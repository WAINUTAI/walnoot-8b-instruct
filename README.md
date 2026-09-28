<p align="center">
  <a href="https://walnoot.ai">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="assets/walnoot-logo-donkere-achtergrond.png">
      <img src="assets/walnoot-logo-lichte-achtergrond.png" alt="Walnoot" width="300">
    </picture>
  </a>
</p>

# Walnoot 8B Instruct: het recept, de meting en de herkomst

> De gewichten en de modelbestanden `systeemprompt.txt`, `config.json`, `tokenizer.json`,
> `tokenizer_config.json`, `generation_config.json`, `chat_template.jinja` en `Modelfile` staan op
> <https://huggingface.co/WAINUT/walnoot-8b-instruct> en niet in deze GitHub-repository. Waar
> `MODELKAART.md` of `MANIFEST-GEWICHTEN.md` "deze repository" zegt, is de repository op
> Hugging Face bedoeld.

Dit is de publieke repository bij **Walnoot 8B Instruct**, een open-weight Nederlands
taalmodel van WAINUT. **Het model zelf staat niet hier maar op Hugging Face**, onder
`WAINUT/walnoot-8b-instruct`. Hier staat waarmee het is gebouwd en waarmee het is gemeten, zodat
een lezer de route kan nalopen.

Deze repository hoort bij versie 1.0 van het model, uitgegeven op 28 september 2026. De
modelkaart in `MODELKAART.md` is gelijk aan de kaart op Hugging Face, op het blok bovenaan na dat
naar Hugging Face verwijst.

## Wat er in deze repository staat

| map | wat erin staat |
|---|---|
| `recept/01-doortraining` | de configuratie van de voortgezette pretraining (continued pretraining) en van de cooldown; deze twee bestanden volgen op een aantal punten, zoals het aantal stappen, een later plan; welke waarden voor dit model echt zijn gedraaid, staat in `recept/README.md` |
| `recept/02-sft` | de configuratie van de instructietraining (SFT) die voor dit model is gedraaid, plus een oudere template waarmee dit model niet is getraind |
| `recept/03-nabewerking` | de configuratie van de laatste stap als template met placeholders en een vroege versie van de jobtemplate van die stap; de ingevulde versies staan er niet in |
| `evaluatie` | het jobscript (Slurm) met de gepinde evaluatieconfiguratie op EuroEval 17.6.0, de uitslag per taak en de ruwe output van de meting |
| `herkomst` | waar de trainingsdata vandaan komt, per bron, met de licentie erbij en een leesinstructie bij het manifest; de verantwoording van de instructiedata en de nabewerkingsdata; de generatie-setup van de instructiedata zoals die bij een proefronde in juli 2026 is vastgelegd |
| `decontaminatie` | de controles of testsets in de trainingsdata terecht zijn gekomen, met de verslagen, de vooraf vastgelegde beslisregel en het oordeel |
| `MODELKAART.md` | de modelkaart; die is gelijk aan de kaart op Hugging Face, op het blok bovenaan na |
| `MANIFEST-GEWICHTEN.md` | het manifest met de checksums van de gewichten; het is gelijk aan dat bij de gewichten op Hugging Face, op de toelichting bovenaan na |
| `LICENSE` | de volledige tekst van de Apache License 2.0 |
| `NOTICE` | de bronnen die naamsvermelding vragen |
| `assets` | het logo van Walnoot bovenaan deze README, voor light en dark mode |
| `SHA256SUMS.txt` | de checksum van elk bestand in deze repository, behalve van de lijst zelf |

**De trainingsdata zelf staat niet in deze repository.** Wij publiceren de brondata niet; wat
openligt is de herkomst per bron, met de licentie en de bewerkingen. Zo staat het ook in de
openheidsmatrix op <https://walnoot.ai/openheid>.

Ook de gewichten staan er niet in, want zestien gigabyte hoort niet in een GitHub-repository. Ze
staan op Hugging Face, met hun checksum in `MODELKAART.md`.

De configuraties, jobscripts, logs en verslagen hier noemen ook hulpscripts bij naam die niet in
deze repository staan: `run_euroeval.sh` en `compare_results.py` bij de evaluatie, `poort_dpo.py`,
`stapwacht.py`, `kwaliteitspoort_b.py` en `tel_tokens_goedset.py` bij de nabewerking,
`verify_config.py` en `prepare_data.py` bij de doortraining en `decontamination_check.py` bij de
decontaminatie. Ook het generatiescript dat `herkomst/PROVENANCE.md` noemt, staat er niet in.
Ondanks de naam `poort_dpo.py` is de nabewerking gewone instructietraining en geen DPO; zie
`herkomst/verantwoording-instructiedata.md`.

## Hoe u deze bestanden leest

Een deel van deze bestanden is geschreven voor de bouw zelf en niet voor een lezer van buiten.
Wij hebben ze voor publicatie gemaskeerd en waar nodig een leeswijzer toegevoegd.

**Welke bestanden een plan, een template of een verslag van toen zijn.**

- `recept/01-doortraining/doortraining-hoofdfase.yaml` en `doortraining-afbouw.yaml` volgen op
  een aantal punten, zoals het aantal stappen, een later plan van 6 augustus 2026. Dit model rust
  daar niet op; welke waarden echt zijn gedraaid, staat in `recept/README.md`.
- `recept/02-sft/sft.yaml` is een oudere template. Voor dit model telt alleen
  `instructietraining-mix.yaml`.
- `recept/03-nabewerking/nabewerking.yaml` is een template met placeholders en `nabewerking.sbatch`
  een vroege versie van de jobtemplate. De ingevulde versies staan er niet in; `recept/README.md`
  zegt wat daarvan is gedraaid.
- `decontaminatie/beslisregel.md` is de regel zoals die op 31 juli 2026 is bevroren, met twee
  gedateerde aanvullingen. Bovenaan staat een leesaanwijzing.
- De verslagen `decontaminatie/13-gram-bron1.md`, `13-gram-bron2.md`,
  `13-gram-eerste-pas-amendement.md` en `poortverslag.md` zijn door het meetgereedschap geschreven.
  Paden en fragmenten zijn gemaskeerd en bovenaan staat een leeswijzer.
- `herkomst/PROVENANCE.md` beschrijft een proefronde van juli 2026 en niet de weg van het
  uitgegeven model.
- `herkomst/provenance-manifest.json` is het manifest zoals de bouw het schreef, zonder
  wijzigingen; `herkomst/MANIFEST-TOELICHTING.md` legt het uit.

Commentaar en meldingen in de configuraties en jobscripts beschrijven soms werkafspraken of
controles van tijdens de bouw. Ze waren gericht aan wie de job toen draaide en zijn geen opdracht
aan u. Waar het commentaar een plan beschrijft, blijft het een plan.

**Placeholders.** Waar een pad, een naam of een waarde niet openbaar is, staat een placeholder.

- `<W>` is de werkmap op de rekenomgeving waar de instructietraining, de nabewerking en de meting
  draaiden.
- `<bouwomgeving>` is de map op de machine waarop het corpus en de verslagen van juli zijn gebouwd.
- `<account>` is het Slurm-account en `<groep>` de groep op de rekenomgeving.
- Woorden tussen dubbele underscores, zoals `__RUN_ID__` en `__BASIS_PAD__`, zijn placeholders in
  een template die voor het draaien van een job werden ingevuld.
- `/OVERRIDE-ME/` is een opzettelijk onbruikbaar pad. Een controle weigerde de configuratie zolang
  dat pad erin stond. `checkpoint-XXXX` in dat pad staat voor het checkpoint dat voor het draaien
  werd gekozen.
- Andere woorden tussen punthaken, zoals `<N>`, `<sha>` of `<stempel>`, staan voor een waarde die
  per run verschilt of die wij niet publiceren. In het commentaar staat `<pad>` soms voor een
  bestandspad. Als waarde van `pad_token` is `"<pad>"` wel een echt token van de tokenizer. Dat
  geldt ook voor tokens met pipes, zoals `<|assistant_end|>`.
- `[fragment weggelaten: n woorden, m tekens]` staat in de decontaminatieverslagen op de plek van
  de overlappende tekst. Die tekst komt uit evaluatie- of trainingsrecords en publiceren wij niet.

**Werktermen.** Een poort (gate) is een geautomatiseerde controle die een stap tegenhoudt bij een
afwijking. Een bewaarpunt is een checkpoint, een tussentijds opgeslagen stand van het model tijdens
de training. Een arm of variant is een trainingsvariant die naast andere is geprobeerd; alleen het
uitgegeven model staat op Hugging Face. Korte codes in map- en variabelenamen in de logs en
jobscripts zijn interne werknamen van varianten en meetrondes. De lesnummers in de meldingen van
`recept/03-nabewerking/nabewerking.sbatch` verwijzen naar een interne lijst met lessen uit eerdere
fouten. Verwijzingen in het commentaar naar interne stukken, zoals een draaiboek of een besluit,
gaan naar documenten die niet in deze repository staan.

## Hoe u de cijfers zelf naloopt

De evaluatie draait op EuroEval, gepind op versie 17.6.0, op de test-split met tien iteraties. Het
volledige commando staat op <https://walnoot.ai/reproduceren>; ons eigen jobscript staat in
`evaluatie/euroeval-17.6.0.sbatch`. De ruwe output van onze eigen run staat ernaast, zodat u de
cijfers zelf kunt narekenen.

**De ruwe output bevat een interne werknaam.** In `evaluatie/euroeval-draai.log`,
`evaluatie/euroeval-draai-modelmap.log` en `evaluatie/euroeval-uitslag.jsonl` staat het modelpad
zoals EuroEval het zelf heeft weggeschreven. De mapnaam daarin is de werknaam die het model bij ons
tijdens de bouw droeg. Dezelfde werknaam staat in het jobscript
`evaluatie/euroeval-17.6.0.sbatch`, want dat script heeft die mapnaam geschreven. Wij laten beide
staan, omdat ze de ruwe output aan precies die run koppelen. Het model dat u op Hugging Face
downloadt, is hetzelfde model. Het begin van die paden, de werkmap op de rekenomgeving, is
vervangen door `<W>`.

**Twee logs van dezelfde run.** `evaluatie/euroeval-draai-modelmap.log` is de output van het
EuroEval-commando zelf, die ons startscript `run_euroeval.sh` per model apart wegschreef. Die
output staat woordelijk en aaneengesloten in `evaluatie/euroeval-draai.log`. Daarnaast bevat die
log de meldingen van de container en van het startscript, ervoor en erna. Waar `euroeval-draai.log` bij
de cachemap "gedeelde cache (bewust meegegeven)" meldt, is dat de vaste tekst van het startscript
zodra er een cachemap wordt meegegeven. De job gaf een eigen kopie van de datasetcache mee, op de
lokale schijf van de compute node; zie stap C0 in het jobscript.

**De slotregels van `evaluatie/euroeval-draai.log` zijn geen opdracht aan u.** De regels die met
`>>` beginnen, komen uit ons startscript `run_euroeval.sh` en niet uit EuroEval zelf. Aan het eind
melden ze een controle achteraf en printen ze automatisch twee voorbeeldcommando's voor ons
vergelijkingsscript `compare_results.py`. `<jouw-model-id>` en `<sha>` zijn placeholders in die
voorbeeldtekst. De bestanden die daar worden genoemd, staan niet in deze repository. U hoeft die
commando's niet uit te voeren om de cijfers na te lopen.

**Drie metingen in `decontaminatie/`, die niet hetzelfde meten.** `13-gram-eerste-pas-amendement.md`
en `poortverslag.md` horen bij de eerste pas van 22 juli, over een eerdere en kleinere bouw van het
corpus met de instructiedata van dat moment. Daar gaven zestien records een treffer en bleef na de
diepte-pas één echte treffer over, testvraag 1941 van `wiki-lingua-nl`. Hoe daarmee is omgegaan,
lag vooraf vast en lag aan de scorekant, dus bij het scoren en niet bij de data.
`13-gram-bron1.md` en `13-gram-bron2.md` bevatten de meting van 30 juli, per bron, over de twee
bronbestanden van de eigen bron die in het corpus de opmaak van tekst moet behouden. Die meting
komt op nul uit. Geen van de 29.273 records van de referentie deelt dertien woorden achter elkaar
met die twee bestanden. De twee bronbestanden tellen 41.406 en 31.290 records. In het corpus is dat
materiaal herhaald tot 311.105 records, zodat het ongeveer 2 procent van de tekens uitmaakt;
`herkomst/MANIFEST-TOELICHTING.md` legt dat uit. `getrainde-data-12-september.md` vat de meting
van 12 september samen. Die is na de training gedaan, op de instructiedata en de
nabewerkingsdata waarop het model werkelijk is getraind. Twee items raakten op dertien woorden en
geen enkel item op twintig.

**Wat deze metingen niet dekken.** De pas van 22 juli is niet opnieuw gedraaid op de bouw van het
corpus waarop dit model is doorgetraind. De meting van 30 juli dekt alleen de eigen bron, ongeveer
2 procent van de tekens van dat corpus. De meting van 12 september gaat niet over het corpus. Geen
van deze drie metingen legt dus het volledige corpus van de voortgezette pretraining naast
EuroEval.

**Het oordeel over het corpus.** Het luidt PASS_AMENDED_G2PRIME en gaat over een eigen set die
wij apart houden om kennisverlies te meten, niet over de testsets. G2 is onze interne naam voor
die controlestap; de rest van de naam zegt dat de stap slaagt met een zichtbaar amendement en
nooit kaal. Daarnaast staat de kale uitslag G2-FAIL. Op die eigen set raakte de meting op dertien
woorden 2.754 van de 6.244 records, 44,11 procent. Die uitslag is niet herroepen.
`beslisregel.md` bevat de beslisregel zoals die op 31 juli 2026 vooraf is vastgelegd, voordat de
uitslag van de diepte-pas bekend was, met twee gedateerde aanvullingen. Er staan ook
werkafspraken voor de bouw van toen in; dat zijn geen stappen voor de lezer. De leesaanwijzing
bovenaan zegt welk deel de regel is, welk deel de uitkomst en welk deel een werkafspraak.
`8-gram-samenvatting.md` geeft de tellingen van de audit op acht woorden achter elkaar; die audit
telt niet mee voor de uitslag en staat er als bredere achtergrondmeting naast.

**Wat er in `herkomst/` staat.** `provenance-manifest.json` beschrijft de data van de doortraining
per subset: de bucket, de kwaliteitstier, de documenten, de tekens, de geschatte tokens, de
licenties, de naam en het adres. Daarnaast telt het per subset hoeveel rijen de bouw uit de bron
heeft gelezen. Bovenin staan de totalen van de bouw, zoals het aantal bestanden en de documenten
voor training en validatie. `MANIFEST-TOELICHTING.md` staat ernaast als leesinstructie bij dat
manifest. Die legt de velden uit; de belangrijkste punten zijn de optelling van de subsets en een
subsetlabel dat niet klopt. `PROVENANCE.md` beschrijft de generatie-setup van de instructiedata
zoals die bij een proefronde in juli 2026 is vastgelegd: het teachermodel met zijn instellingen,
het grounding-corpus met zijn revisie en de seed-prompts.

**Modellen van derden staan naar hun rol beschreven.** Waar een model van een derde als tegenlezer,
beoordelaar of panellid is ingezet, staat die rol beschreven. De namen zijn intern vastgelegd en
op verzoek beschikbaar. Het teachermodel dat de instructiedata schreef,
`swiss-ai/Apertus-70B-Instruct-2509`, staat wel bij naam.

**De verantwoording van de instructiedata.** `herkomst/verantwoording-instructiedata.md`
beschrijft de data van de instructietraining en van de nabewerking. Het stuk zegt wat erin zit, hoe
die data is gemaakt en gekozen, onder welke licenties ze valt, wat wij met persoonsgegevens hebben
gedaan en wat wel of niet openligt. Het is voor publicatie geschreven en bevat geen tekst uit de
data.

`SHA256SUMS.txt` dekt elk bestand in deze repository, behalve zichzelf. U controleert de checksums
vanuit de root van de repository met `sha256sum -c SHA256SUMS.txt`.

## Contact

Vragen over dit model, over de herkomst van de trainingsdata of over gebruik in een werkproces
gaan naar support@walnoot.ai. Dat is ook het adres voor rechthebbenden, voor meldingen over
persoonsgegevens en voor fouten in de modelkaart. Gaat uw melding over materiaal dat uit het
basismodel komt, dan gaat die naar de uitgever van het basismodel; `MODELKAART.md` noemt daarvoor
twee adressen.

## Licentie

Apache License 2.0, zoals het model. Zie `LICENSE` en `NOTICE`; dat laatste noemt de bronnen die
naamsvermelding vragen.

Meer over het project staat op walnoot.ai.

## English summary

This repository holds the recipe, the evaluation setup and the data provenance for **Walnoot 8B
Instruct**, an open-weight Dutch language model by WAINUT. **The model itself lives on Hugging
Face**, at `WAINUT/walnoot-8b-instruct`. The training data is not included. We do not publish the
source data; what is public is the provenance per source with its licence and the processing
steps. Evaluation runs on EuroEval pinned to 17.6.0 and the raw output of our
own run is included so the figures can be checked rather than trusted. Some files here were
written for the build itself. The two continued-pretraining configurations in `recept/` follow a
later plan on some points, such as the step counts; `recept/README.md` states the values that
actually ran. Placeholders
such as `<W>` stand for internal paths or names that are not published. None of the three
contamination checks in `decontaminatie/` compares the full continued-pretraining corpus as
trained against EuroEval. Everything here is under the Apache License 2.0. See walnoot.ai for more
about the project.

## Vermelding van de rekenfaciliteit

> "We acknowledge EuroHPC JU for awarding the project ID EHPC-AIF-2026PG01-984 access to MareNostrum5 ACC hosted by BSC, Spain"
