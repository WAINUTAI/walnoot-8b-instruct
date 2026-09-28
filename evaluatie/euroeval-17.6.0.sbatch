#!/bin/bash
# Interne werknamen en paden zijn voor publicatie vervangen door algemene woorden en placeholders.
# =============================================================================
#  Walnoot, EuroEval-meting op de rekenomgeving. SLURM-jobtekst.
#  EuroEval 17.6.0, aangeroepen als run_euroeval.sh --full.
#
#  Dit is de jobtekst waarmee de meting in deze map is gedraaid. Voor publicatie zijn de
#  paden, het account en de tijdstempel vervangen door placeholders en zijn enkele
#  meldingen en namen in gewone woorden gezet. ARM draagt de werknaam die het model tijdens
#  de bouw had; ../README.md legt uit waarom die blijft staan. run_euroeval.sh zit in de
#  container-image en staat niet in deze repository.
#
#  WAT DE JOB DOET, in volgorde:
#    P1   de sha van de container-image
#    P2   de sha van de modelmap
#    C0   een eigen kopie van de datasetcache op de lokale NVMe, plus de
#         bestandstelling
#    C2   de sha256-toets van die kopie tegen het gepinde manifest van de vooraf
#         klaargezette bestanden
#    P3   vier GPU's zichtbaar in de container
#    P4   de versiepin van euroeval, torch, vllm, transformers en xgrammar
#    P5   de sha van de evaluatieharness in het image
#    P6a  de acht hulpmappen dragen het runetiket
#    P6   de offline-schakelaars komen door
#    M    de meting zelf
#    U    het uitlezen, met de iteratiepoort
#
#  WAAROM EEN EIGEN CACHEKOPIE PER RUN. `evaluate` schrijft per
#  metriekberekening een arrow-tussenbestand waarvan de naam alleen van
#  experiment_id, procesnummer en rank afhangt. Draaien twee metingen op een
#  gedeelde --cache-dir, dan ruimt het ene proces op wat het andere nog moet
#  lezen. run_euroeval.sh --full is gepind en biedt geen experiment_id, dus de
#  maatregel is een EIGEN CACHEKOPIE per run.
#
#  DAT IS GOEDKOOP EN DAT IS GEMETEN. De datasetcache weegt 59 MB in 1.199
#  bestanden. De hub-cache gaat niet mee: euroeval leest de datasets uit
#  --cache-dir en de tokenizer uit de modelmap. De kopie gaat naar de lokale
#  NVMe van de node (/scratch/tmp, 436 GB, per job leeg), dus zij kost geen
#  quotum op het gedeelde bestandssysteem en geen enkele node deelt hem met een
#  andere.
#
#  DE KOPIE WORDT GETOETST tegen het gepinde manifest van de vooraf klaargezette bestanden,
#  EVAL-KLAARZET-SHA256SUMS, 197 regels: de 68 regels met het voorvoegsel
#  hf-eval/datasets/ dekken de cache, de 129 regels met hf-eval/hub/ niet.
#  Faalt de toets, dan stopt de job voordat hij een GPU aanraakt.
#
#  PLACEHOLDERS. <W> voor de werkmap, <account> voor het Slurm-account en
#  <stempel> voor de tijdstempel van de ronde. Een sed maakte de ingevulde
#  kopie; de drie regels PH_W, PH_STEMPEL en PH_ARM hieronder zijn zo
#  samengesteld dat die sed ze NIET raakt, zodat de job zelf merkt wanneer de
#  sed niet heeft gedraaid. De ingevulde kopie is ingediend in deze vorm
#    sbatch --account <account> <de ingevulde kopie>
# =============================================================================
#SBATCH --job-name=walnoot
#SBATCH --qos=acc_ehpc
#SBATCH --partition=acc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:4
#SBATCH --cpus-per-task=80
#SBATCH --time=01:30:00
#SBATCH --output=<W>/v2d-claimsuite-<stempel>/logs/claim-v2d-C-%j.out
#SBATCH --error=<W>/v2d-claimsuite-<stempel>/logs/claim-v2d-C-%j.err

#  ------------------------------------------------------------------------
#  EEN JOB DEKT ALLE TIEN TAKEN: run_euroeval.sh --full pint de test-split, tien
#  iteraties en de tien NL-datasets in vaste volgorde. Er is dus geen job per
#  taak en geen job per taakgroep; tien taken is wat deze ene job meet en de
#  iteratiepoort in de job eist tien iteraties per record.
#  ------------------------------------------------------------------------
set -u

# DE PLACEHOLDER ALS WAARDE. Zo samengesteld dat de sed die de effectieve
# kopie maakt deze drie regels NIET raakt; zij zijn de poort op zichzelf.
# Zelfde vorm als in de andere jobteksten van dit project.
PH_W="<""W"">"
PH_STEMPEL="<""stempel"">"
PH_ARM="<""ARM"">"

ARM="v2d_C"
W="<W>"
R="$W/v2d-claimsuite-<stempel>"

case "$ARM$W$R" in
  *"$PH_W"*|*"$PH_STEMPEL"*|*"$PH_ARM"*)
    echo "FATAAL: de paden dragen nog een plaatshouder; dit is niet de EFFECTIEVE kopie"
    exit 1 ;;
esac
SIF="$W/images/walnoot-eval.sif"
ENVF="$W/env/offline-eval.env"
BRONCACHE="$W/hf-eval/datasets"
KLAARZETMANIFEST="$W/EVAL-KLAARZET-SHA256SUMS"
# Twee tellingen die de poort zelf meet en tegen deze pinnen legt. Zij
# komen uit een meting op de doelomgeving en niet uit een zin in een checklist.
DATASETREGELS_VERWACHT=68
CACHEBESTANDEN_VERWACHT=1199
MODELPAD="$R/models/$ARM"
STAMP=$(date -u +%Y%m%dT%H%M%SZ)
RUNID="claim-$ARM-$STAMP"
BEWIJS="$R/bewijs/$ARM"
RUNCACHE="/scratch/tmp/eval-cache-$ARM"
mkdir -p "$BEWIJS" "$R/logs" "$R/runs"

T0=$(date +%s)
echo "=== EuroEval-meting, model $ARM ==="
echo "job      ${SLURM_JOB_ID:-onbekend} op ${SLURMD_NODENAME:-onbekend}"
echo "run-id   $RUNID"
echo "model    $MODELPAD"
echo "cache    $RUNCACHE (eigen kopie, niet gedeeld)"
echo "start    $(date -Is)"
echo

module load singularity/4.1.5
echo "singularity: $(singularity --version)"

# --- DE ACHT HULPMAPPEN, MET RUNETIKET --------------------------------------
# De datasetcache kreeg al een runetiket; deze acht niet. Racevrij was het toch,
# want --gres gpu:4 met --cpus-per-task 80 vult een hele ACC-node, dus twee van
# deze jobs kunnen niet op dezelfde node landen. Maar in de header staat geen
# --exclusive terwijl de header van de trainjob die wel draagt en het interne meetplan waarschuwt
# bij naam voor juist de triton-, inductor- en vllm-cache. Een runetiket
# kost niets en maakt de racevrijheid onafhankelijk van hoe SLURM toewijst.
#
# DE ACHT VARIABELENAMEN ZIJN GELEZEN EN NIET GERADEN. Zij zijn op 6 september 2026
# nagelezen op regel 52 tot 57 en 76 tot 77 van env/offline-eval.env op de
# rekenomgeving; dat bestand staat niet in deze repository. De --env-vlaggen staan NA
# --env-file, dus zij winnen.
TMPARM=/scratch/tmp/eval-$ARM
mkdir -p "$TMPARM/triton" "$TMPARM/inductor" "$TMPARM/torch" "$TMPARM/vllm" \
         "$TMPARM/xdg" "$TMPARM/outlines" "$TMPARM/home" "$TMPARM/flashinfer"
# Keuze van 6 september 2026, waarmee deze meting is gedraaid. ZEVEN van de acht gaan via
# --env; HOME gaat via de vlag --home hieronder. Singularity 4.1.5 weigert HOME
# via --env, met "Overriding HOME environment variable with SINGULARITYENV_HOME
# is not permitted" en negeert de vlag daarna stil. Een eerdere job strandde
# daardoor op P6a: HOME wees naar de echte home directory. De env-file zet HOME ook,
# op /scratch/tmp/eval-home en een dry run op de login node van 6 september
# toonde dat ook die weg NIET doorkomt. De ronde van 4 september draaide dus in
# werkelijkheid met de echte, onder --no-home niet schrijfbare home directory en de
# suite werkte toch; flashinfer werd gered door FLASHINFER_WORKSPACE_BASE en
# niet door HOME. Alleen --home werkt en hij werkt naast --no-home: HOME is dan
# de runmap en die is schrijfbaar. Dry run, varianten A tot E.
CACHE_ENV=(--env TRITON_CACHE_DIR="$TMPARM/triton"
           --env TORCHINDUCTOR_CACHE_DIR="$TMPARM/inductor"
           --env TORCH_HOME="$TMPARM/torch"
           --env VLLM_CACHE_ROOT="$TMPARM/vllm"
           --env XDG_CACHE_HOME="$TMPARM/xdg"
           --env OUTLINES_CACHE_DIR="$TMPARM/outlines"
           --env FLASHINFER_WORKSPACE_BASE="$TMPARM/flashinfer")

# --- POORT P1, image-sha ------------------------------------------------------
echo "P1. image-sha"
( cd "$W/images" && sha256sum -c walnoot-eval.sif.sha256 ) || { echo "AFGEBROKEN: image-sha"; exit 1; }

# --- POORT P2, modelmap-sha ---------------------------------------------------
echo "P2. modelmap-sha"
( cd "$MODELPAD" && sha256sum -c SHA256SUMS ) || { echo "AFGEBROKEN: modelmap-sha"; exit 1; }

# --- STAP C, de eigen cachekopie, VOOR de container ---------------------------
# Sinds een keuze van 6 september 2026 is er geen stap C1 meer. De
# du -sb-vergelijking over twee bestandssystemen is vervallen; C0 telt de bestanden,
# C2 toetst de inhoud.
echo
echo "C0. cachekopie naar de lokale NVMe, plus de bestandstelling"
rm -rf "$RUNCACHE"
mkdir -p "$RUNCACHE/hf-eval"
cp -a "$BRONCACHE" "$RUNCACHE/hf-eval/datasets" || { echo "AFGEBROKEN: cp faalt"; exit 1; }
BRON_N=$(find "$BRONCACHE" -type f | wc -l)
KOPIE_N=$(find "$RUNCACHE/hf-eval/datasets" -type f | wc -l)
echo "   bron  $BRON_N bestanden"
echo "   kopie $KOPIE_N bestanden"
echo "   gepind: $CACHEBESTANDEN_VERWACHT bestanden (op 6 september 1.199)"
[ "$KOPIE_N" = "$CACHEBESTANDEN_VERWACHT" ] \
  || { echo "AFGEBROKEN: $KOPIE_N bestanden tegen de gepinde $CACHEBESTANDEN_VERWACHT"; exit 1; }
[ "$BRON_N" = "$KOPIE_N" ] || { echo "AFGEBROKEN: bestandstelling wijkt af"; exit 1; }
echo "   GROEN, $KOPIE_N van $BRON_N bestanden"

echo "C2. sha256-toets van de kopie tegen het gepinde manifest van de klaarzet"
grep '  hf-eval/datasets/' "$KLAARZETMANIFEST" > "$RUNCACHE/DATASETS-SHA256SUMS" \
  || { echo "AFGEBROKEN: geen datasetregels in het manifest van de klaarzet"; exit 1; }
REGELS=$(wc -l < "$RUNCACHE/DATASETS-SHA256SUMS")
echo "   $REGELS regels te toetsen, gepind op $DATASETREGELS_VERWACHT"
# Het manifest telt 197 regels, waarvan 68
# met het voorvoegsel hf-eval/datasets/ en 129 met hf-eval/hub/. Alleen die 68
# gaan mee in de kopie per run; de 129 hub-regels blijven waar zij staan.
[ "$REGELS" = "$DATASETREGELS_VERWACHT" ] \
  || { echo "AFGEBROKEN: $REGELS datasetregels tegen de gepinde $DATASETREGELS_VERWACHT"; exit 1; }
( cd "$RUNCACHE" && sha256sum -c DATASETS-SHA256SUMS ) > "$BEWIJS/cachetoets-$ARM.txt" 2>&1
CRC=$?
tail -3 "$BEWIJS/cachetoets-$ARM.txt"
[ $CRC -eq 0 ] || { echo "AFGEBROKEN: cachekopie faalt de sha-toets"; exit 1; }
OK_N=$(grep -c ': OK$' "$BEWIJS/cachetoets-$ARM.txt" || true)
echo "   GROEN, sha256sum -c gaf rc 0; $OK_N OK-regels van $REGELS getoetste regels"
CACHE="$RUNCACHE/hf-eval/datasets"

# --- De container. --env NA --env-file, zodat HF_DATASETS_CACHE de eigen kopie
# --- wijst en geen enkele euroeval-run nog op de gedeelde cache schrijft.
SEXEC=(singularity exec --nv --cleanenv --no-home --no-mount cwd
       --home "$TMPARM/home"
       --env-file "$ENVF"
       --env HF_DATASETS_CACHE="$CACHE"
       "${CACHE_ENV[@]}"
       --bind "$W" --bind /scratch/tmp)

echo
echo "P3. vier GPU's"
"${SEXEC[@]}" "$SIF" nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv \
  || { echo "AFGEBROKEN: nvidia-smi"; exit 1; }

echo "P4. versiepin in het image"
"${SEXEC[@]}" "$SIF" python -c "
import sys, importlib.metadata as m
wil={'euroeval':'17.6.0','torch':'2.11.0+cu129','vllm':'0.24.0+cu129','transformers':'5.14.1','xgrammar':'0.2.3'}
slecht=[k+'='+m.version(k) for k,v in wil.items() if m.version(k)!=v]
[print('%-14s %s' % (k, m.version(k))) for k in wil]
sys.exit('VERSIEPOORT GEFAALD: '+', '.join(slecht) if slecht else 0)" \
  || { echo "AFGEBROKEN: versiepin"; exit 1; }

echo "P5. harnas-sha in het image"
"${SEXEC[@]}" "$SIF" bash -lc "cd /opt/eval/scripts && sha256sum -c SHA256SUMS" \
  || { echo "AFGEBROKEN: harnas-sha"; exit 1; }

echo "P6a. de acht hulpmappen dragen het runetiket"
"${SEXEC[@]}" "$SIF" bash -lc 'for v in TRITON_CACHE_DIR TORCHINDUCTOR_CACHE_DIR TORCH_HOME \
    VLLM_CACHE_ROOT XDG_CACHE_HOME OUTLINES_CACHE_DIR HOME FLASHINFER_WORKSPACE_BASE; do
      printf "%-28s %s\n" "$v" "$(eval echo \$$v)"; done' | tee "$BEWIJS/hulpmappen-$ARM.txt"
MIS=$(grep -c -v -- "/scratch/tmp/eval-$ARM/" "$BEWIJS/hulpmappen-$ARM.txt" || true)
[ "$MIS" = "0" ] || { echo "AFGEBROKEN: $MIS van de acht hulpmappen dragen het runetiket niet"; exit 1; }
echo "   GROEN, acht van acht onder /scratch/tmp/eval-$ARM/"

echo "P6. offline-schakelaars komen door"
"${SEXEC[@]}" "$SIF" bash -lc 'echo "HF_EVALUATE_OFFLINE=$HF_EVALUATE_OFFLINE"; echo "HF_DATASETS_CACHE=$HF_DATASETS_CACHE"' \
  | tee "$BEWIJS/omgeving-$ARM.txt"
grep -q "HF_EVALUATE_OFFLINE=1" "$BEWIJS/omgeving-$ARM.txt" \
  || { echo "AFGEBROKEN: HF_EVALUATE_OFFLINE is niet 1"; exit 1; }

# --- De meting. --full pint test-split, 10 iteraties, de tien NL-datasets in
# --- vaste volgorde en GEEN --num-few-shot. --gpu-mem 0.90 moet er expliciet bij,
# --- want de default van de harness is 0,8.
echo
echo "M. run_euroeval.sh --full"
"${SEXEC[@]}" "$SIF" bash -lc "
  cd /opt/eval/scripts &&
  bash run_euroeval.sh --full \
      --run-id '$RUNID' \
      --model '$MODELPAD' \
      --results-dir '$R/runs' \
      --cache-dir '$CACHE' \
      --gpu-mem 0.90" 2>&1 | tee "$R/logs/claim-$ARM-$STAMP.log"
SUITE_RC=${PIPESTATUS[0]}
T1=$(date +%s)
echo "suite rc=$SUITE_RC, wandtijd $(( (T1-T0)/60 )) minuten"

RUNDIR="$R/runs/$RUNID"
cp -f "$RUNDIR/euroeval_benchmark_results.jsonl" "$BEWIJS/" 2>/dev/null
cp -f "$RUNDIR/environment.log" "$BEWIJS/" 2>/dev/null
cp -f "$RUNDIR"/*.log "$BEWIJS/" 2>/dev/null
cp -f "$R/logs/claim-$ARM-$STAMP.log" "$BEWIJS/suite-$ARM.log" 2>/dev/null

# --- Uitlezen, plus de iteratiepoort die de cacherace zou vangen.
echo
echo "U. de records"
"${SEXEC[@]}" "$SIF" python -c "
import json, sys
p = '$RUNDIR/euroeval_benchmark_results.jsonl'
recs = [json.loads(l) for l in open(p, encoding='utf-8') if l.strip()]
print('records:', len(recs))
mager = []
def _sc(ev):
    if isinstance(ev.get('score'), (int, float)): return ev['score']
    return (ev.get('score_details') or {}).get('score')
def _bi(ev):
    sd = ev.get('score_details') or {}
    for k in ('confidence_interval','ci','interval'):
        if k in sd: return sd[k]
    return {k: v for k, v in sd.items() if k != 'score'}
for r in recs:
    det = r['eval_library']['additional_details']
    ns = det.get('num_samples')
    if isinstance(ns, int) and ns < 10: mager.append((det.get('dataset'), ns))
    print()
    print('== %s | few_shot=%s | iters=%s | num_samples=%s' % (
        det.get('dataset'), det.get('few_shot'),
        det.get('num_iterations', det.get('iterations')), ns))
    print('   euroeval %s | torch %s | vllm %s | transformers %s | xgrammar %s' % (
        r['eval_library']['version'], det.get('torch_version'), det.get('vllm_version'),
        det.get('transformers_version'), det.get('xgrammar_version')))
    print('   generative_type %s' % det.get('generative_type'))
    for ev in r['evaluation_results']:
        print('   %-32s %s   %s' % (ev['evaluation_name'], _sc(ev), _bi(ev)))
print()
if mager:
    print('ITERATIEPOORT ROOD, records met minder dan tien iteraties:', mager)
    sys.exit(3)
print('ITERATIEPOORT GROEN, elk record tien iteraties')
" 2>&1 | tee "$BEWIJS/scores-$ARM.txt"
ITER_RC=${PIPESTATUS[0]}

echo
sha256sum "$BEWIJS"/* > "$BEWIJS/SHA256SUMS-bewijs.txt" 2>/dev/null
cat "$BEWIJS/SHA256SUMS-bewijs.txt"
rm -rf "$RUNCACHE" "$TMPARM"
echo "klaar $(date -Is), wandtijd $(( ($(date +%s)-T0)/60 )) minuten"
echo "suite_rc=$SUITE_RC iteratiepoort_rc=$ITER_RC"
[ $SUITE_RC -ne 0 ] && exit $SUITE_RC
exit $ITER_RC
