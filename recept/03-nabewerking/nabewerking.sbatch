#!/bin/bash
# Interne werknamen en paden zijn voor publicatie vervangen door algemene woorden en placeholders.
# =============================================================================
#  Jobtemplate voor de nabewerking van Walnoot op de rekenomgeving (SLURM).
#  ZELFDISTILLATIE MET VERWERPING en dat is GEWONE SFT en geen DPO.
#  Vastgesteld door WAINUT, 9 september 2026.
#
#  WAT DIT BESTAND IS. Een vroege versie van de jobtemplate van deze stap. De jobtekst
#  waarmee de nabewerking van het uitgegeven model is ingediend, is een latere versie ervan
#  met meer controles; die staat niet in deze repository. Deze versie draait niet zonder
#  aanvulling. Zie recept/README.md.
#
#  AFGELEID UIT de jobtekst van de paarsgewijze variant (DPO). Bij de afleiding waren er vijf
#  verschillen en verder geen. Daarna kwamen de stapwacht en het schrijven zonder pipe erbij
#  (zie hieronder) en versie D voegde nog vier dingen toe (D1 tot en met D4).
#
#    C1  de invoer heet RECORDS en geen PAREN en de vormpoort toetst `messages`
#        in plaats van prompt, chosen en rejected
#    C2  er is GEEN referentiemodel, dus de lading telt EEN keer en niet twee en
#        er is geen forward pass voor de referentiekansen
#    C3  de effectieve batch is 8 GEPAKTE REEKSEN; een stap draagt 8 maal 4.096 is
#        32.768 tokens en het stappental volgt uit de TOKENS en niet uit het
#        aantal records, want packing staat AAN
#    C4  het plafond staat op EEN uur in plaats van drie; de duurste variant kost
#        ruim duizend seconden en drie uur zou een leeg gebaar zijn
#    C5  de config heet nabewerking.yaml
#
#  WAT HETZELFDE BLIJFT: de containerruntime en haar toets, de aanroepvorm met
#  --cleanenv --no-home --no-mount cwd, de torchrun-wrapper die SLURM_PROCID als
#  GETAL in de regel zet, het wandtijd-vangnet en de bewijsbundel. Poort 6 en 7 zijn
#  woordelijk gelijk aan die van de DPO-jobtekst, poort 1 en 4 op de namen van de invoer
#  na. Bij de afleiding gold dat ook voor poort 2; versie D heeft poort 2 uitgebreid en
#  poort 0 toegevoegd.
#
#  DE BEDOELDE WERKWIJZE. Een hulpscript (poort_dpo.py, niet meegeleverd) vulde de
#  placeholders in, toetste elke placeholdervorm op de ingevulde kopie en schreef pas
#  dan een indienbaar bestand. De indiening was een aparte handeling.
#
#  PLACEHOLDERS IN DIT BESTAND
#
#      __ARMNAAM__     de naam van de run
#      __BASIS_PAD__   de modelmap van het startmodel; er is geen referentiemodel (C2)
#
#  De invoerpaden komen sinds versie D uit de omgeving, met --export (zie D1 hieronder).
#  Poort 1 leest daarnaast DATA_SHA, de sha256 van het recordbestand. Deze versie wijst
#  die naam nergens toe, dus ook DATA_SHA moet uit de omgeving komen. Hetzelfde geldt voor
#  W, want de standaardwaarden van KWALITEITSPOORT en TELSTAP gebruiken W voordat het
#  script W een waarde geeft.
#
#  WAT DIT SCRIPT UIT DE INSTRUCTIETRAININGSJOB OVERNEEMT en waar het van afwijkt.
#
#  OVERGENOMEN, woordelijk van vorm: de containerruntime en haar toets, de
#  `--cleanenv --no-home --no-mount cwd` aanroepvorm, de torchrun-wrapper die
#  BUITEN de container per SLURM-taak wordt gegenereerd en `SLURM_PROCID` als
#  GETAL in de regel zet (de reparatie van 3 september), het wandtijd-vangnet met
#  `--signal B:USR1@600` en de bewijsbundel per run.
#
#  AFWIJKEND: er is geen stopvaardigheidstoets en geen gguf-conversie in deze job. Die
#  toets was voorzien als eigen job NA deze run, want een nabewerkingsrun kan de
#  stopvaardigheid slopen die de SFT net heeft opgebouwd en dat wil je als aparte
#  meting zien. De gguf-nafase hing aan de uitkomst daarvan.
#
#  NIET OVERGENOMEN en dat is met opzet: de 3.666 regels van de volledige
#  trainingspipeline van de instructietrainingsjob. Wat hier staat is de header, de
#  poorten en de trainstap. Die jobtekst staat niet in deze repository.
#
#
#  DE STAPWACHT. Een training die VALT wordt gevangen door de
#  exitcode; een training die HANGT werd tot dan toe door niets gevangen, want het
#  vangnet `--signal B:USR1@600` slaat 600 seconden voor het EINDE van de wandtijd
#  aan en niet vroeg. `gereedschap/stapwacht.py` leest het trainlog en breekt af
#  zodra er te lang geen stapregel meer verschijnt.
#
#      tot de eerste stapregel   de lading maal het aantal modellen, plus 300 s
#      daarna                    4 maal de mediane tussentijd van de vorige vijf
#                                stapregels, met een ondergrens van 300 s
#
#  DRIE ONTWERPKEUZES UIT EERDERE FOUTEN ZITTEN IN DE VORM. De wacht start met `setsid`
#  en zonder pipe, met haar input op /dev/null en haar output naar een bestand, dus zij
#  erft geen schrijfkant die iemand laat wachten. Zij schrijft haar meldingen
#  rechtstreeks naar een bestand. En zij geeft een echte booleaanse uitkomst, die
#  hier uit het statusbestand wordt gelezen en niet uit haar output.
#
#  EN DE PIPE IS WEG. De training schreef eerst door `tee` naar het bewijs, wat
#  `PIPESTATUS` nodig maakte om de exitcode van torchrun te lezen in plaats van
#  die van `tee`. Nu schrijft `srun` rechtstreeks naar het bestand en geeft `wait`
#  de echte code. Dat haalt die hele klasse fouten weg in plaats van
#  haar te omzeilen.
#
#  VERSIE D. Vier dingen erbij en verder niets.
#
#    D1  DE INVOERPADEN KOMEN UIT DE OMGEVING en niet meer uit een placeholder
#        in het bestand. Zij worden getoetst op BESTAAN en op SHA256 tegen de
#        bijbehorende sha-lijst, VOOR de modellading. Een pad dat de
#        indiener vergeet, laat de job hier stoppen en niet na 305 seconden.
#    D2  DE KWALITEITSPOORT IS POORT 0. `kwaliteitspoort_b.py --eis-goud`
#        draait op het invoerbestand voordat er iets anders gebeurt; exitcode 2
#        blokkeert de job. De poort die de data keurt hoort voor de poort die de
#        paden keurt, want een compleet pad naar een afgekeurd bestand is erger
#        dan een ontbrekend pad.
#    D3  DE STAPREKENING IS GECONCENTREERD in EEN blok, met de gemeten lading van
#        305 seconden en marge 2. Er staat geen tweede rekensom elders.
#    D4  HET VERBRUIK REKENT MET DE BOEKINGSEENHEDEN EN NIET MET DE KLOK. Poort 5 zet
#        de benodigde tijd om in de boekingseenheden van de rekenomgeving (billing);
#        vier kaarten boeken een hele node, een kaart een kwart. Erratum van
#        9 september, gemeten met sacct.
#  DE CONTROLES HIERIN GAAN ELK TERUG OP EEN EERDERE FOUT. De lesnummers in de
#  markeringen van poort 1 tot en met 4 verwijzen naar een interne lijst met die lessen.
#    elke naam die dit sbatch declareert wordt gemeten en elk
#        invoerbestand bestaat aantoonbaar VOOR de modellading. Poort 2 en 3.
#    een templatevariabele wordt geevalueerd, nooit als tekst gelezen; de
#        plekpoort meet waar de job werkelijk leest. Poort 4.
#    de placeholderscan kent elke vorm, dummywaarden inbegrepen. Poort 1.
#    elk getal dat naar een ander programma gaat, gaat met een punt.
#        Poort 5 rekent met `awk` en niet met de locale van de shell.
#    het plafond dekt eerst de lading, dan de reserve, dan het werk.
#        Poort 5.
#  Een poort (gate) is hier een controle in de job die bij een afwijking stopt (ROOD) of
#  doorgaat (groen).
# =============================================================================

#SBATCH --job-name        walnoot
#SBATCH --account         <account>
#SBATCH --qos             acc_ehpc
#SBATCH --partition       acc
#SBATCH --nodes           1
#SBATCH --ntasks-per-node 1
#SBATCH --gres            gpu:4
#SBATCH --cpus-per-task   80
#SBATCH --time            0-01:00:00
#SBATCH --hint            nomultithread
#SBATCH --exclusive
#SBATCH --chdir           <W>
#SBATCH --output          runs/slurmlogs/R-%x.%j.out
#SBATCH --error           runs/slurmlogs/R-%x.%j.err
#SBATCH --open-mode       append
#SBATCH --no-requeue
#SBATCH --signal          B:USR1@600

# DE TWEE GPU-CONFIGURATIES. De header hierboven vraagt er VIER, zoals de trainjob. De
# tweekaartsvariant staat hier zodat zij met twee vlaggen op de indienregel te
# kiezen is en niet met een tweede bestand:
#
#   vier kaarten (STANDAARD)   --gres gpu:4   GPUS_PER_NODE=4  accum 2
#   twee kaarten               --gres gpu:2   GPUS_PER_NODE=2  accum 4
#
#   rekensom vier  4 maal micro 1 maal accum 2 is 8 gepakte reeksen
#   rekensom twee  2 maal micro 1 maal accum 4 is 8 gepakte reeksen
#
# De effectieve batch blijft in beide gevallen 8 gepakte reeksen, dus de uitkomst
# is vergelijkbaar en alleen de wandtijd verschilt. Deze run heeft geen
# referentiemodel, dus het geheugen is hier de ruime kant en niet de krappe.
#
#   sbatch --gres=gpu:2 --export=ALL,GPUS_PER_NODE=2,GA_STEPS=4 <dit bestand>

set -u
set -o pipefail

# VERPLICHT: ARMNAAM
# VERPLICHT: DATA_PAD
# VERPLICHT: BASIS_PAD
ARMNAAM="__ARMNAAM__"
BASIS_PAD="__BASIS_PAD__"

# ---------------------------------------------------------------------------- #
# D1. DE INVOERPADEN UIT DE OMGEVING. Geen placeholder meer in dit bestand.
# VERPLICHT: GOEDSET
# VERPLICHT: GOEDSETLIJST
GOEDSET="${GOEDSET:?geef de goed-set mee met --export}"
GOEDSETLIJST="${GOEDSETLIJST:?geef de sha-lijst van die set mee met --export}"
KWALITEITSPOORT="${KWALITEITSPOORT:-$W/gereedschap/kwaliteitspoort/kwaliteitspoort_b.py}"
TELSTAP="${TELSTAP:-$W/gereedschap/tel_tokens_goedset.py}"
W4_RENDER="${W4_RENDER:?geef het renderblok van W4 mee met --export}"
TOKENIZER="${TOKENIZER:-swiss-ai/Apertus-8B-Instruct-2509}"

W="<W>"
GPUS_PER_NODE="${GPUS_PER_NODE:-4}"
GA_STEPS="${GA_STEPS:-2}"
EFFECTIEVE_BATCH="${EFFECTIEVE_BATCH:-8}"
DOORVOER_TRAIN="${DOORVOER_TRAIN:-12483}"   # tokens per s, 524.288 in 42 s, gemeten in de instructietraining
SEQ_LEN="${SEQ_LEN:-4096}"              # gelijk aan sequence_len in de config
DOORVOER_VOORWAARTS="${DOORVOER_VOORWAARTS:-34193}"   # tokens per s, gemeten in de instructietraining
TRAINSPLIT_AANDEEL="${TRAINSPLIT_AANDEEL:-0.98032}"   # val_set_size 0,02, gemeten op de instructiemix
RESERVE_S="${RESERVE_S:-120}"
LADING_S="${LADING_S:-305}"          # GEMETEN, erratum 9 september
MODELLEN="${MODELLEN:-1}"
MARGE="${MARGE:-2}"                  # vastgelegd in het recept
BILLING="${BILLING:-160}"            # gres/gpu=4 boekt 160 van 160
WANDTIJD_AANVRAAG_S="${WANDTIJD_AANVRAAG_S:-3600}"
RUN_ID="${SLURM_JOB_ID:-geenjob}-$ARMNAAM"
RUN="$W/runs/$RUN_ID"
BEWIJS="$RUN/bewijs"
CFG="$W/configs/sft_${ARMNAAM}.EFFECTIEF.yaml"

fataal () { echo "FATAAL: $*" >&2; exit 1; }
marker () { echo; echo "== $* =="; }

mkdir -p "$BEWIJS" "$W/runs/slurmlogs" || fataal "kan de runmap niet maken"

# ---------------------------------------------------------------------------- #
marker "POORT 0, DE KWALITEITSPOORT"
# D2. De DATA wordt gekeurd voordat er een pad wordt uitgevouwen of een model
# geladen. Een compleet pad naar een afgekeurd bestand is erger dan een ontbrekend
# pad, dus deze poort staat voor alle andere. Exitcode 2 blokkeert; elke andere
# waarde ongelijk nul ook.
[ -f "$KWALITEITSPOORT" ] || fataal "de kwaliteitspoort staat niet op $KWALITEITSPOORT"
[ -f "$GOEDSET" ] || fataal "het invoerbestand staat niet op $GOEDSET"
[ -f "$W4_RENDER" ] || fataal "het renderblok van W4 staat niet op $W4_RENDER"
python3 "$KWALITEITSPOORT" --goed "$GOEDSET" \
        --w4-render "$W4_RENDER" --eis-goud \
        --uit "$BEWIJS/kwaliteitspoort" > "$BEWIJS/kwaliteitspoort.txt" 2>&1
KP_RC=$?
echo "kwaliteitspoort exitcode $KP_RC; uitvoer in $BEWIJS/kwaliteitspoort.txt"
if [ "$KP_RC" = "2" ]; then
  fataal "de kwaliteitspoort keurt de invoer AF (exitcode 2). Er wordt niets geladen."
fi
[ "$KP_RC" = "0" ] || fataal "de kwaliteitspoort gaf exitcode $KP_RC en dat is geen groen"
echo "poort 0 groen: de invoer is gekeurd met --eis-goud"

# ---------------------------------------------------------------------------- #
marker "POORT 1, DE PLAATSHOUDERS IN DIT BESTAND ZELF (les 57)"
# Een template die per ongeluk wordt ingediend hoort hier te stoppen. De scan kent
# elke vorm die een template in dit project draagt, dummywaarden inbegrepen: een
# rij nullen als sha en een verwijzing naar een proefrun zijn de twee vormen die op
# 8 september drie jobs hebben gekost.
PH_ROOD=0
for waarde in "$ARMNAAM" "$GOEDSET" "$BASIS_PAD" "$W4_RENDER"; do
  case "$waarde" in
    __*__|*'<groep>'*|*'<account>'*|*OPEN_*|*TE-VULLEN*|*PLAATSHOUDER*|/PROEF/*|*PROEFGROEP*|*proefaccount*|*proefrun*)   # scanner-uitzondering: deze regel DRAAGT de patronen
      echo "POORT 1 ROOD: een plaatshouder is niet gevuld: $waarde"
      PH_ROOD=1 ;;
  esac
done
case "$DATA_SHA" in
  0000000000000000*|ffffffffffffffff*|e3b0c44298fc1c14*)   # scanner-uitzondering: deze regel DRAAGT de patronen
    echo "POORT 1 ROOD: DATA_SHA is een dummywaarde: $DATA_SHA"
    PH_ROOD=1 ;;
esac
[ "${#DATA_SHA}" = "64" ] || { echo "POORT 1 ROOD: DATA_SHA is geen 64 tekens"; PH_ROOD=1; }
[ "$PH_ROOD" = "0" ] || fataal "poort 1 rood; dit is nog een sjabloon en geen indiening"
echo "poort 1 groen: vier plaatshouders gevuld, sha is 64 tekens en geen dummy"

# ---------------------------------------------------------------------------- #
marker "POORT 2, DE BESTAANSTOETS, VOOR DE MODELLADING (les 54)"
# De hergeneratie-herstelbaan van 8 september laadde 582 seconden en viel daarna op
# een ontbrekend bestand. Een bestaanstoets kost niets.
POORT2_ROOD=0
toets_uit_lijst () {   # toets_uit_lijst <naam> <pad> <sha-lijst>
  # D1. De verwachte sha komt uit de LIJST die bij het bestand hoort en niet uit een
  # placeholder in dit sbatch. Staat het bestand niet in die lijst, dan is dat rood:
  # een invoer zonder sha-regel is een invoer die niemand heeft gemeten.
  local naam="$1" pad="$2" lijst="$3" verwacht gemeten grond
  if [ ! -f "$pad" ]; then
    echo "POORT 2 ROOD: $naam ontbreekt op $pad"; POORT2_ROOD=1; return
  fi
  if [ ! -f "$lijst" ]; then
    echo "POORT 2 ROOD: de sha-lijst van $naam ontbreekt op $lijst"; POORT2_ROOD=1; return
  fi
  grond="$(basename "$pad")"
  verwacht="$(awk -v g="$grond" '$2 ~ g || $2 == g {print $1; exit}' "$lijst")"
  if [ -z "$verwacht" ]; then
    echo "POORT 2 ROOD: $grond staat niet in $lijst"; POORT2_ROOD=1; return
  fi
  gemeten="$(sha256sum "$pad" | cut -d' ' -f1)"
  if [ "$gemeten" != "$verwacht" ]; then
    echo "POORT 2 ROOD: $naam wijkt af van de lijst"
    echo "   lijst   $verwacht"
    echo "   gemeten $gemeten"
    POORT2_ROOD=1; return
  fi
  echo "groen $naam  $pad  sha uit $(basename "$lijst")"
}

toets_bestand () {   # toets_bestand <naam> <pad> <verwachte sha of leeg>
  local naam="$1" pad="$2" verwacht="${3:-}" gemeten
  if [ ! -f "$pad" ]; then
    echo "POORT 2 ROOD: $naam ontbreekt op $pad"; POORT2_ROOD=1; return
  fi
  if [ -n "$verwacht" ]; then
    gemeten="$(sha256sum "$pad" | cut -d' ' -f1)"
    if [ "$gemeten" != "$verwacht" ]; then
      echo "POORT 2 ROOD: $naam wijkt af"
      echo "   verwacht $verwacht"
      echo "   gemeten  $gemeten"
      POORT2_ROOD=1; return
    fi
  fi
  echo "groen $naam  $pad"
}
toets_uit_lijst "goed-set" "$GOEDSET" "$GOEDSETLIJST"
toets_bestand "dpo-config"   "$CFG"       ""
toets_bestand "jinja"        "$W/configs/walnoot_sft_template.jinja" ""
[ -d "$BASIS_PAD" ] || { echo "POORT 2 ROOD: de modelmap ontbreekt op $BASIS_PAD"; POORT2_ROOD=1; }
N_GEW="$(ls -1 "$BASIS_PAD"/*.safetensors 2>/dev/null | wc -l | tr -d ' ')"
[ "$N_GEW" -ge 1 ] || { echo "POORT 2 ROOD: de modelmap draagt geen safetensors"; POORT2_ROOD=1; }
echo "gewichtbestanden in de modelmap: $N_GEW"
[ "$POORT2_ROOD" = "0" ] || fataal "poort 2 rood; er wordt geen model geladen"

# ---------------------------------------------------------------------------- #
marker "POORT 3, DE VORM VAN DE RECORDS (les 54, invoer bestaat en deugt)"
# C1. Deze run leest de chat-vorm van de instructiemix en geen paren.
N_REC="$(wc -l < "$GOEDSET" | tr -d ' ')"
echo "records in het bestand: $N_REC"
[ "$N_REC" -ge 100 ] || fataal "minder dan honderd records; dat is geen trainingsronde"
N_VORMPROEF="$(grep -c '"vormproef"' "$GOEDSET" || true)"
[ "$N_VORMPROEF" = "0" ] \
  || fataal "$N_VORMPROEF regel(s) markeren zichzelf als vormproef; dat bestand mag niet getraind worden"
N_ZONDER="$(grep -c -v '"messages"' "$GOEDSET" || true)"
[ "$N_ZONDER" = "0" ] \
  || fataal "$N_ZONDER regel(s) dragen geen messages; dat is de chat-vorm van de instructiemix niet"
echo "poort 3 groen: geen vormproefregel en elk record draagt messages"

# ---------------------------------------------------------------------------- #
marker "POORT 4, DE UITVOUWPOORT EN DE PLEKPOORT (les 56)"
# De variabele wordt door de SHELL uitgevouwen en daarna gemeten. Een pad dat na
# uitvouwen nog een dollarteken draagt, is een naam en geen waarde.
for naam in GOEDSET BASIS_PAD CFG W; do
  eval "waarde=\${$naam}"
  case "$waarde" in
    *'$'*) fataal "poort 4 rood: $naam draagt na uitvouwen nog een dollarteken: $waarde" ;;
    /*)    : ;;
    *)     fataal "poort 4 rood: $naam is geen absoluut pad: $waarde" ;;
  esac
  echo "groen $naam vouwt uit tot $waarde"
done
# de plekpoort: schrijf een merkbestand en lees het terug op het pad waar de job
# straks WERKELIJK leest, niet op het pad waar dit script denkt te schrijven
echo "plekpoort-$RUN_ID" > "$RUN/plekpoort.txt"
[ "$(cat "$RUN/plekpoort.txt")" = "plekpoort-$RUN_ID" ] \
  || fataal "poort 4 rood: de plekpoort leest niet terug wat zij schreef"
echo "groen plekpoort op $RUN"

# ---------------------------------------------------------------------------- #
marker "DE TELSTAP, DE TOKENS VAN DE GOED-SET ZELF"
# Geen aanname 757 en geen aanname 854: de goed-set komt uit kortere generaties dan
# de instructiemix waarop die getallen zijn gemeten en een begroting op 854 zou het
# stappental met een factor drie overschatten.
TELLING="$BEWIJS/tokentelling-goedset.json"
python3 "$TELSTAP" --data "$GOEDSET" --tokenizer "$TOKENIZER" \
        --uit "$TELLING" --veld messages > "$BEWIJS/telstap.txt" 2>&1
TEL_RC=$?
cat "$BEWIJS/telstap.txt"
[ "$TEL_RC" = "0" ] || fataal "de telstap gaf exitcode $TEL_RC; zonder telling is er geen rekening"
TOKENS_SOM="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["tokens_som"])' "$TELLING")"
TOKENS_MED="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["tokens_mediaan"])' "$TELLING")"
N_REC="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["records"])' "$TELLING")"

# ---------------------------------------------------------------------------- #
marker "POORT 5, DE STAPREKENING EN HET PLAFOND"
export LC_ALL=C
N_TRAIN="$(awk -v n="$N_REC" -v a="$TRAINSPLIT_AANDEEL" 'BEGIN{printf "%d", int(n*a)}')"
TOKENS_TRAIN="$(awk -v s="$TOKENS_SOM" -v a="$TRAINSPLIT_AANDEEL" 'BEGIN{printf "%d", s*a}')"
TOKENS_PER_STAP="$(awk -v b="$EFFECTIEVE_BATCH" -v L="$SEQ_LEN" 'BEGIN{printf "%d", b*L}')"
STAPPEN="$(awk -v t="$TOKENS_TRAIN" -v p="$TOKENS_PER_STAP" 'BEGIN{printf "%d", int((t+p-1)/p)}')"
TRAINING_S="$(awk -v t="$TOKENS_TRAIN" -v d="$DOORVOER_TRAIN" 'BEGIN{printf "%d", t/d}')"
LADING_TOTAAL="$(awk -v l="$LADING_S" -v m="$MODELLEN" 'BEGIN{printf "%d", l*m}')"
NODIG_S="$(awk -v a="$LADING_TOTAAL" -v b="$RESERVE_S" -v c="$TRAINING_S" 'BEGIN{printf "%d", a+b+c}')"
PLAFOND_S="$(awk -v n="$NODIG_S" -v m="$MARGE" 'BEGIN{printf "%d", n*m}')"
NODE_UUR="$(awk -v s="$NODIG_S" -v b="$BILLING" 'BEGIN{printf "%.4f", s/3600*b/160}')"
echo "records          $N_REC"
echo "trainsplit       $N_TRAIN  bij aandeel $TRAINSPLIT_AANDEEL"
echo "tokens som       $TOKENS_SOM  GEMETEN op deze set, mediaan $TOKENS_MED"
echo "tokens train     $TOKENS_TRAIN"
echo "tokens per stap  $TOKENS_PER_STAP  ($EFFECTIEVE_BATCH gepakte reeksen van $SEQ_LEN)"
echo "stappen          $STAPPEN  (een epoch)"
echo "lading           $LADING_TOTAAL s  ($MODELLEN maal $LADING_S, GEMETEN)"
echo "reserve          $RESERVE_S s"
echo "training         $TRAINING_S s  bij $DOORVOER_TRAIN tokens per s"
echo "nodig            $NODIG_S s"
echo "plafond          $PLAFOND_S s  (marge $MARGE)"
echo "node-uur         $NODE_UUR  (billing $BILLING van 160)"
if [ "$PLAFOND_S" -gt "$WANDTIJD_AANVRAAG_S" ]; then
  fataal "de rekening vraagt $PLAFOND_S s en de kop vraagt $WANDTIJD_AANVRAAG_S s aan"
fi
echo "poort 5 groen: het plafond past binnen de aangevraagde wandtijd"

# ----------------------------------------------------------------------------
marker "POORT 6, DE CONTAINERRUNTIME"
SING_MODULE="${SING_MODULE:-singularity/4.1.5}"
module load "$SING_MODULE" 2>/dev/null \
  || fataal "module load $SING_MODULE faalt; draai 'module avail singularity'"
APP="$(command -v singularity || true)"
[ -n "$APP" ] || fataal "geen singularity op PATH na 'module load $SING_MODULE'"
"$APP" exec --help 2>&1 | grep -q -- '--nv' \
  || fataal "singularity exec kent --nv niet; zonder die vlag is er geen GPU in de container"
SIF="$W/images/walnoot-sft.sif"
[ -f "$SIF" ] || fataal "de image ontbreekt op $SIF"
echo "containerruntime $APP, image $SIF"
APPRUN="$APP exec --nv --cleanenv --no-home --no-mount cwd --bind $W:$W"

# ---------------------------------------------------------------------------- #
marker "POORT 7, DE CONFIGVALIDATIE ZONDER GPU"
# axolotl leest de config en de dataset en stopt voor de training. Dit is dezelfde
# stap die de dry run op de login node draait; hier staat zij nog een keer,
# want een config die op de login node deugde kan op de compute node een ander pad
# missen.
$APPRUN "$SIF" bash -c "python -m axolotl.cli.preprocess $CFG" 2>&1 \
  | tee "$BEWIJS/preprocess.txt" \
  || fataal "de configvalidatie van axolotl is rood; zie $BEWIJS/preprocess.txt"
echo "poort 7 groen: axolotl leest de config en de paren"

# ---------------------------------------------------------------------------- #
marker "TRAIN"
# DE TRAINTAAK-WRAPPER, van vorm woordelijk uit de instructietrainingsjob. Hij draait BUITEN de
# container, EEN keer per SLURM-taak, leest daar SLURM_PROCID, zet die waarde als
# GETAL in de torchrun-regel en duwt hem met --env de container in. Dat is
# de reparatie van 3 september en zij hoort hier onveranderd.
MASTER_ADDR="$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n1)"
MASTER_PORT="${MASTER_PORT:-29500}"
cat > "$RUN/traintaak.sh" <<WRAPPER
#!/bin/bash
NODE_RANK="\${SLURM_PROCID:-0}"
case "\$NODE_RANK" in ''|*[!0-9]*) echo "TRAINTAAK ROOD: node_rank '\$NODE_RANK' is geen getal"; exit 1 ;; esac
echo "TRAINTAAK host=\$(hostname -s) node_rank=\$NODE_RANK nnodes=$SLURM_NNODES nproc_per_node=$GPUS_PER_NODE"
exec $APPRUN --env SLURM_PROCID="\$NODE_RANK" "$SIF" bash -c "torchrun --nproc_per_node $GPUS_PER_NODE --nnodes $SLURM_NNODES --node_rank \$NODE_RANK --rdzv_endpoint $MASTER_ADDR:$MASTER_PORT --rdzv_backend c10d --max_restarts 0 --tee 3 -m axolotl.cli.train $CFG"
WRAPPER
chmod +x "$RUN/traintaak.sh"

# DE PLACEHOLDERPOORT OP DE WRAPPER, want hij is net uit variabelen gegenereerd.
grep -q '__' "$RUN/traintaak.sh" \
  && fataal "de gegenereerde wrapper draagt nog een plaatshouder; zie $RUN/traintaak.sh"
grep -q 'node_rank \$NODE_RANK' "$RUN/traintaak.sh" \
  || fataal "de wrapper draagt geen node_rank; de torchrun-regel is niet compleet"
cp "$RUN/traintaak.sh" "$BEWIJS/traintaak.sh"

# ---- DE STAPWACHT, LOSGEKOPPELD EN ZONDER PIPE ---- #
TRAINLOG="$BEWIJS/train.txt"
STAPWACHT_STATUS="$BEWIJS/stapwacht-status.json"
: > "$TRAINLOG"
setsid python3 "$W/gereedschap/stapwacht.py" \
    --log "$TRAINLOG" \
    --meldingen "$BEWIJS/stapwacht.txt" \
    --status "$STAPWACHT_STATUS" \
    --pid-bestand "$RUN/srun.pid" \
    --jobid "${SLURM_JOB_ID:-0}" \
    --lading "$LADING_S" --modellen "$MODELLEN" \
    < /dev/null > /dev/null 2>&1 &
WACHT_PID=$!
echo "stapwacht gestart als pid $WACHT_PID, meldingen in $BEWIJS/stapwacht.txt"

# GEEN PIPE. srun schrijft rechtstreeks naar het bewijsbestand en `wait` geeft de
# echte exitcode; PIPESTATUS is daarmee niet meer nodig.
srun --cpus-per-task "${SLURM_CPUS_PER_TASK}" \
     --ntasks="$SLURM_NNODES" --ntasks-per-node=1 \
     bash "$RUN/traintaak.sh" >> "$TRAINLOG" 2>&1 &
SRUN_PID=$!
echo "$SRUN_PID" > "$RUN/srun.pid"
wait "$SRUN_PID"
RC=$?
echo "TRAIN exitcode $RC" >> "$TRAINLOG"
echo "TRAIN exitcode $RC"

# ---- DE UITKOMST VAN DE WACHT, ALS BOOLEAAN EN NIET ALS TEKST ------------- #
# De regel hierboven staat ook in het trainlog en dat is het eindpatroon waarop de
# wacht zichzelf netjes afsluit. Twintig tikken van drie seconden is ruim.
for _ in $(seq 1 20); do
  [ -f "$STAPWACHT_STATUS" ] && break
  sleep 3
done
if [ -f "$STAPWACHT_STATUS" ]; then
  WACHT_GEZOND="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["gezond"])' "$STAPWACHT_STATUS")"
  echo "stapwacht: gezond=$WACHT_GEZOND"
  cat "$BEWIJS/stapwacht.txt" 2>/dev/null || true
  if [ "$WACHT_GEZOND" != "True" ]; then
    echo "DE STAPWACHT HEEFT EEN HANG VASTGESTELD. De job krijgt exitcode 4, zodat"
    echo "de evaluatieketen aan afterok NIET start."
    RC=4
  fi
else
  echo "WAARSCHUWING: de stapwacht heeft geen status geschreven. Zij telt dan NIET"
  echo "als groen; beoordeel $BEWIJS/stapwacht.txt met de hand."
fi
kill "$WACHT_PID" 2>/dev/null || true

marker "UITSLAG"
echo "run            $ARMNAAM"
echo "records        $N_REC"
echo "stappen begroot $STAPPEN"
echo "bewijsbundel   $BEWIJS"
echo "WAT HIERNA MOET: de stopvaardigheidstoets met cap 1024 als EIGEN job, en daarnaast"
echo "de lengteverdeling van de uitvoer naast die van het startmodel, want"
echo "zelfdistillatie kan de lengte verschuiven en de weerregel snijdt alleen de"
echo "uitschieters weg. 5 van 5 blijft de eis."
exit $RC
