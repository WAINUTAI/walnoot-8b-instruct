# Beslisregel held-out-decontam (BINDEND, blind bevroren)

> **Leesaanwijzing.** Dit stuk is de beslisregel zoals WAINUT die op 31 juli 2026 heeft bevroren,
> voordat de uitslag van de diepte-pas bekend was. Zij gaat niet over de testsets van EuroEval. Zij
> gaat over een eigen set van 6.244 records in drie delen (en, en_academic en code) die wij apart
> houden om te meten of het model tijdens de voortgezette pretraining kennis verliest. De vraag was
> of records van die set ook in het trainingscorpus stonden. In dat geval meet de set niet meer
> zuiver wat zij moet meten.
>
> - **De regel van toen.** Paragraaf 1 tot en met 7, zonder 6a en 6b, zijn de regel zoals die bij
>   het bevriezen om 11:12 UTC gold.
>   Waar de tekst zegt wat er moet of wordt gedaan, beschrijft zij de handelwijze die toen was
>   afgesproken. Het zijn geen stappen voor de lezer.
> - **De uitkomst.** Paragraaf 6a is de gedateerde registratie van de uitkomst. Route A faalde op
>   alle vier de poorten, dus gold route C en is route A niet gevolgd. Paragraaf 6b legt
>   aanscherpingen van route C vast die zijn bevroren voordat niveau 16 en de definitieve cijfers
>   waren ingezien.
> - **Het oordeel.** Onder route C heet het oordeel PASS_AMENDED_G2PRIME. De kale uitslag G2-FAIL
>   staat ernaast en is niet herroepen. Hoe dat in het geheel past, staat in `../MODELKAART.md` en
>   `../README.md`.
> - **Werkafspraken.** Een deel van de tekst gaat over de bouw van toen, zoals de poorten A5 en A6
>   op de rekenknoop en de alinea Operationeel in 6b. Die alinea is voor publicatie in de verleden
>   tijd uitgeschreven. Aan de regels zelf is niets veranderd.
> - **Publicatie.** Voor publicatie zijn namen, commits, werknamen en interne
>   bestandsverwijzingen vervangen door een omschrijving of weggelaten.
>
> Enkele werktermen. Een as is een van de drie delen van de eigen set. Een tail-parquet is een
> bronbestand van zo'n deel. Step 0 is het begin van de training, voor de eerste stap. Een node is
> een rekenknoop met GPU's. Een sidecar is een apart evaluatiebestand naast de hoofdset. De
> R3-tripwire is het interne alarmsignaal voor kennisverlies, dat afgaat als de loss op de eigen
> set stijgt terwijl de validatieloss daalt. Axolotl is de trainingssoftware en `classify_hits` een
> functie van het meetgereedschap.
>
> De meting van de eigen set liep in twee richtingen. Richting (a) legt de set naast de
> evaluatiereferentie van EuroEval en richting (b) naast de bestanden van het trainingscorpus.
> "Herdraai richting (a)" en "BEIDE decontam-richtingen" gaan daarover. Het cap-amendement is het
> amendement van 30 juli 2026 op de plafonds in tekens per deel van de eigen set. De runner is het
> script dat de meting op dertien woorden tegen het corpus draaide. Het PASS_WITH_REVIEW-precedent
> gaat over een eerdere toelating van de eigen bron die in het corpus de opmaak van tekst moet
> behouden. PASS_WITH_REVIEW was de uitslag als alle treffers op dertien woorden op twintig
> woorden verdwenen. De meting die voor die bron uiteindelijk gold, staat in `13-gram-bron1.md` en
> `13-gram-bron2.md`. De 477-kandidatenlijst telt 477 records van de eigen set, de strengste
> kandidaten voor een echt lek; 477 is hier een aantal records en geen stappental. U, T en V staan
> voor de geraakte records bij een meting tegen alle 116 bestanden, tegen de 115 trainshards en
> tegen het validatiebestand. H16, H20 en H25 zijn de records met een treffer op 16, 20 of 25
> woorden; H0, H1 en H2 bij het schaduwpaneel zijn drie groepen records die daar zelf worden
> uitgelegd. Het getal achter een letter is het niveau in woorden en n staat voor elk
> niveau. Een machinepoort is een controle die het meetgereedschap zelf uitvoert. Een
> sentinelproef is een proef met een bekend testdocument die laat zien of de meting lange
> documenten op dezelfde plekken in stukken hakt als de training. Vier-ogen betekent dat een
> tweede lezer de regel vooraf heeft nagelezen. Read-only betekent dat die lezer niets kon
> wijzigen.

**Status** BINDEND. Vastgelegd 31 juli 2026, met gemeten vastlegtijd
11:12:48Z, door WAINUT, na vier-ogen met een externe tegenlezer, read-only, antwoord
ontvangen 31 juli kort voor het bevriezen. Dit document is bevroren VOORDAT de uitslag
van de ladder-niveaus 16/20/25 en de classificatie
(`classify_hits`) is ingezien. Wijziging na die inzage kan alleen met een nieuwe
tegenleesronde en een gedateerde correctieparagraaf, nooit stil.

**Wat op het moment van bevriezing WEL bekend was** en dus geen blindheid claimt: de drie
kale 13-gram-uitslagen (37,03 / 37,40 / 36,29 procent, gate FAIL op drempel 0), het
unie-getal 2.754 van 6.244 records (44,11 procent), de per-as-uitsplitsing (en 467 van 813,
en_academic 184 van 217, code 2.103 van 5.214), de lokaliteitsverdeling over de drie
corpusdelen (68,9 procent in alle drie de delen), de frequentietop (licentiekoppen en
open-access-frasen), de aard-steekproef (10 boilerplate, 8 code-idioom, 2 substantieel,
0 aantoonbare duplicaten), de 477-kandidatenlijst en de vaststelling dat strikte
unie-snoei de en_academic-as op 33 records brengt tegen een harde ondergrens van 100.
**Niet bekend** was elke uitkomst van de niveaus 16/20/25, elke deep_set, elke
classificatieverdeling en elke coverage-meting.

**G2 en G3 zijn de interne namen van twee poorten op de corpusbouw.** G2 eist in zijn vierde
conditie nul overlap op dertien woorden; G3 kent daarnaast een vrijstelling voor vaste frases.
Die twee namen blijven hieronder staan, want het oordeel PASS_AMENDED_G2PRIME draagt ze.

---

## 1. De uitspraak over de poort

1. De kale 13-gram-run met drempel 0 tegen de volledige 116-bestandsshardset is de
   letterlijke G2-conditie 4 en die is **FAIL**. Dat verdict wordt niet met
   terugwerkende kracht herroepen, geherinterpreteerd of overgeschreven. Het blijft als
   FAIL zichtbaar in de verslaglegging van de corpusbouw en in elk afgeleid dossier.
2. **Optie B is verworpen**: de vaste-frase-vrijstelling van G3 mag niet worden
   gepresenteerd als de altijd al bedoelde lezing van G2. G2 en G3 verschillen tekstueel,
   het cap-amendement herhaalt de G2-eis ongewijzigd en de runner implementeert de
   strikte lezing bewust. Een externe tegenlezer mag dat verschil als bewust behandelen.
3. Het PASS_WITH_REVIEW-precedent van de eerdere formataanvulling wordt expliciet
   onderscheiden en niet genegeerd: daar ging het om toelating van trainmateriaal onder
   een bindende nul-eis zonder meetkundige selectiebias; hier verandert snoei de
   evalpopulatie en daarmee het te meten estimand. Dat rechtvaardigt een ander besluit
   over de MEETSET, maar wist de oorspronkelijke poort-FAIL niet uit.

## 2. De beslisboom (de voorkeursroute van de tegenlezer, overgenomen)

Stap 1. Na afronding van de metingen wordt EERST de strikte A-set berekend: de held-out
minus de unie van alle ruwe 13-gram-treffer-records tegen het trainuniversum van
paragraaf 4.

Stap 2. **Route A geldt als de A-set alle poorten van paragraaf 3 haalt.** De route is
dan: snoei, herbevries (nieuwe sha, chmod 444), verse kale 13-gram-nulrun met drempel 0
tegen de volle 116 bestanden die per constructie 0 treffers moet geven, herdraai
richting (a), voorbereiding. G2-conditie 4 wordt dan alsnog regulier groen.

Stap 3. **Route C geldt alleen als route A op een poort van paragraaf 3 faalt** en is een
zichtbaar post-failure-amendement (G2-prime) met de regels van paragraaf 5. Het verdict
heet dan **PASS_AMENDED_G2PRIME**, nooit kaal PASS en staat altijd naast de
oorspronkelijke FAIL.

Stap 4. Route B bestaat niet.

## 3. De poorten voor route A

Meetbaar voor de voorbereiding, alle vier verplicht:

- A1. Minstens 100 records per as na de snoei (amendement-ondergrens, hard). Op de
  bevriezingsdata faalt en_academic hier al (33), maar de poort wordt pas definitief
  gemeten op de exacte A-set tegen het trainuniversum van paragraaf 4.
- A2. Alle vijf tail-parquets per as blijven met minstens 1 record vertegenwoordigd.
- A3. Balans voor en na de snoei op de waarneembare covariaten bronbestand en
  log-recordlengte: SMD hoogstens 0,1 en total-variation-afstand op de
  bronbestandsverdeling hoogstens 0,1 per as.
- A4. Leave-one-tail-file-out-gevoeligheid: geen enkele as waar het weglaten van een tail-
  parquet de per-as recordtelling onder 100 duwt.

Node-poorten (pas meetbaar met GPU, bij step 0 van de curve; blokkeren de voorbereiding niet
maar zijn bindend voor de INTERPRETATIE van de forgetting-meting):

- A5. De gesnoeide records gaan mee als NIET-BINDEND schaduwpaneel en worden op step 0
  en op de beslissende checkpoints geevalueerd. Een afwijkende lossdelta tussen
  schoon-kern en schaduwpaneel is bewijs van selectiebias en wordt gerapporteerd.
- A6. Bij step 0 wordt de per-record-lossvariantie gemeten en daaruit de power bepaald;
  onder 80 procent power voor een relatieve lossstijging van 5 procent per as wordt de
  as als indicatief en niet als bindend gelabeld.

Onder route A wordt de claim beperkt tot de zero-overlap-subpopulatie en wordt dat in de
rapportage met zoveel woorden gezegd.

## 4. Twee corpusuniversa, plus de val-audit

- De historische G2-run is en blijft de 116-bestandsrun. Die uitslag is het bewijsstuk
  bij de FAIL van paragraaf 1.
- Het **beslissende trainingslek-universum is de 115 trainshards** (shard-00000 tot en
  met shard-00114). `shard-00115` wordt op de node uitsluitend `val.jsonl` en traint
  niet mee. Vereiste sluiting bij elke meting op dit universum: 115 bestanden en
  3.448.292 documenten.
- `shard-00115` wordt APART gemeten (held-out tegen alleen dit bestand), zodat val-only-
  treffers zichtbaar zijn en de A-set-berekening ze niet als trainingslek meetelt.
- **Verplicht voor de voorbereiding**: een 13-gram-audit van `val.jsonl` (de bytes van
  shard-00115) tegen de 115 trainshards, met rapport. Overlap daar drukt de R3-tripwire
  (dalende val-loss om de verkeerde reden) en moet minstens gekend en gerapporteerd
  zijn; een snoei-eis aan de val volgt er niet automatisch uit, een weging wel.

## 5. De regels voor route C (nu vastgelegd, voor inzage van de diepte-uitslag)

Een record blijft alleen staan als het aan ALLE onderstaande voorwaarden aantoonbaar
voldoet; elke treffer waarvoor een voorwaarde niet meetbaar is wordt gesnoeid
(fail-closed):

- C1. Elk record dat een 16-, 20- of 25-gram-treffer tegen het trainuniversum overleeft
  wordt gesnoeid.
- C2. Elk geraakt record korter dan het diepte-niveau wordt gesnoeid (korte-recordsregel;
  op de bevriezingsdata is deze klasse naar verwachting leeg, de regel blijft).
- C3. Een resterende 13- tot 15-gram-frase geeft alleen vrijstelling als zij aan
  trainzijde voorkomt in minstens 10 onafhankelijke trainrecords verdeeld over minstens
  2 trainshards (gemeten, niet aangenomen).
- C4. Coverage-grens: de unie van gedeelde spans binnen het door axolotl werkelijk
  geevalueerde 4096-tokenvenster blijft kleiner dan 1 procent van het venster per record
  EN de som over de as blijft kleiner dan 0,1 procent van de modeltokens van die as.
- C5. Rapportage per as en per tail-parquet: records, chars en modeltokens voor en na;
  13/16/20/25-overleving; unie en intersecties van de deelruns; coverage;
  trainfrequentie; elke gesnoeide record-id met reden; de nieuwe sha256. Daarna worden
  BEIDE decontam-richtingen opnieuw gedraaid op de gesnoeide set.
- C6. `classify_hits` met deep_level 20 alleen is onvoldoende bewijs voor een
  vaste-frase-vrijstelling; C3 en C4 vergen per-treffer-metingen van trainfrequentie en
  overlapcomponenten. Ontbreekt dat instrument, dan wordt het gebouwd of wordt de
  betreffende treffer gesnoeid.

## 6. Meetlat-lessen die los van de route gelden

- De bindende in-run eval levert een tokengewogen totaal-loss waarin de drie assen
  onzichtbaar zijn; codeverbetering kan academische forgetting maskeren. De per-as-
  meting wordt op de beslispunten apart gedraaid (sidecar-bestanden per as).
- De relevante besmettingsmaat voor R3 is het aandeel lossdragende modeltokens, niet het
  percentage geraakte records; licentiekoppen in korte coderecords wegen zwaarder dan
  een frase in een lang artikel. De coverage-rapportage van C5 geldt daarom ook onder
  route A voor de VERWIJDERDE populatie.
- De decontam scant volledige records, axolotl evalueert hoogstens 4096 tokens; een
  treffer uitsluitend in de nooit-geevalueerde staart beinvloedt de tripwire niet. Dit
  wordt in de coverage-meting expliciet gescheiden.
- Acht curvepunten zijn acht gecorreleerde blikken op dezelfde set; zodra stoppen of
  verlengen erop reageert is de held-out een validatieset en geen onaangeroerde
  eindtest. De rapportage benoemt dat.

## 6a. Uitkomst (gedateerde registratie, 31 juli 2026 ~12:15Z, geen regelwijziging)

De metingen zijn na het bevriezen uitgevoerd; het beslismoment-rapport
is de bron. **Route A is als eerste berekend en faalt op alle vier de poorten**: A1
en_academic 33 tegen een harde 100 (en 346 en code 3.111 slagen); A2 en_academic 4 van 5
tails (`cc_openalex_0694.parquet` telde 1 record en dat is besmet); A3 en_academic TV
0,1293 en SMD 0,8373 en ook code faalt met SMD 0,2927 op log-recordlengte (de snoei
verwijdert systematisch langere coderecords, mediaan 2.948 chars gesnoeid tegen 1.157
behouden); A4 en_academic 19 zonder `cc_openalex_0691`. De wissel naar het
115-trainuniversum verandert niets: alle 970 records die shard-00115 raakt worden ook
door minstens een trainshard geraakt, val-only-aftrek is exact nul, A-set sha256
`60d2b279cd7c42f713aafc3d1719c2eb9168f828473d88e177a06ec0eccd3d87` (3.490 records).
Daarmee geldt **route C** conform paragraaf 2 stap 3. De A3-uitslag op code is
inhoudelijk de kern: de strikte snoei holt de meetfunctie aantoonbaar uit, precies het
geval waarvoor de tegenlezer route C reserveerde.

## 6b. As-statuscriteria en C-aanscherpingen (vastgelegd 31 juli, met gemeten
vastlegtijd 12:11:44Z, VOOR inzage van niveau 16 en de definitieve
C-set-cijfers; bron: de tegenlezing van het beslismoment, zelfde ronde)

**As-status, driedeling met vooraf bevroren criteria.** Per as geldt na de C-snoei:

| Status | Voorwaarden |
|---|---|
| BINDEND | C1-C4 groen; minstens 100 records; de vier A-balanspoorten opnieuw groen op de definitieve C-set; later step-0-power minstens 80 procent voor +5 procent |
| INDICATIEF | C1-C4 groen; minstens 30 records; minstens 3 niet-lege tails; minstens 100.000 werkelijk lossdragende tokens; uitsluitend sidecar, geen poort en geen claim; bij lengtedrift eerlijk benoemd als geselecteerde subpopulatie |
| VERVALLEN | onder een van de INDICATIEF-vloeren, of C1-C4 niet aantoonbaar groen |

Een INDICATIEVE as gaat UIT de bindende hoofd-held-out en wordt uitsluitend als apart
sidecar-bestand geevalueerd; de bindende in-run eval_loss bevat alleen bindende assen.
De balansmeting op de C-set is GEEN C1-C4-poort maar WEL de formele poort voor deze
statuskeuze; die dubbele rol staat hier expliciet zodat hij niet achteraf informeel wordt.

**C1 wordt bepaald door T16**, de treffers uit een directe meting tegen de 115
trainshards; de aftrek U16 minus V16 is verboden (verliest records die train en val
beide raken). Sluiting Un == Tn verenigd met Vn is een machinepoort, net als de
inclusies H25 binnen H20 binnen H16; elke schending is een meetfout en nooit ruis.

**C3/C4 zijn pas besluitdragend na twee reparaties** (blokkers van de tegenlezer): (1) de doelset
wordt de volledige enumeratie van alle gedeelde n-grams uit de held-out zelf, niet de
een-per-record-per-run-rapportvoorbeelden; maximale gedeelde spans van 13 tot 15
woorden worden zelf als frase getoetst; (2) C4 mag niet op afkappen bij 4096 rekenen,
want axolotl-completion hakt lange documenten in opeenvolgende lossdragende chunks;
de per-record-grens geldt per chunk op de slechtste chunk en de as-som wordt op de
strengste van twee noemers gerekend (alle tokens en alleen volle chunks) totdat de
gepinde chunking op de node met een sentinelproef is bevestigd.

**C4-noemer na krimp**: de 0,1-procent-grens wordt herberekend op de definitieve as na
alle snoei; bij een aggregaat-FAIL geen top-k-optimalisatie maar alle resterende
hitdragende records als een deterministisch blok snoeien en de asstatus hermeten.

**Schaduwpaneel in drie disjuncte strata**: H0 nooit geraakt, H1 door C vrijgesteld,
H2 door C gesnoeid. C-set = H0 met H1; A-verwijderden = H1 met H2. Per as evalueren op
step 0 en de beslissende checkpoints.

**Operationeel** (voor publicatie in de verleden tijd uitgeschreven). Voor de bouw van toen werd
daarnaast afgesproken dat de controle na afloop van het snoeiscript rekening hield met de gekozen
route, want onder route C was een kale 13-gram-nulrun met nul treffers niet de verwachting. Een
markering voor een as onder de 100 records moest verwijzen naar een vastgelegd as-statusbesluit met
zijn sha. Het machinale rapport van het beslismoment moest zijn vastgelegd voordat de snoei
draaide. De opbouw van de voorbereide set veranderde (hoofdset, sidecar en schaduwstrata). Daarom
werd het vaste aantal van 124 bestanden in de overdracht naar de rekenomgeving een parameter en
moest die overdracht de definitieve bestandslijst volgen.

## 7. Traceerbaarheid

Het volledige antwoord van de tegenlezer is de bron van de poorten en regels hierboven; de beslisboom is
zijn voorkeursroute, integraal overgenomen. Afwijkingen van zijn advies: geen, met een
operationalisering: de power- en step-0-poorten (A5, A6) zijn als node-poorten geplaatst
omdat er in de voorbereiding geen GPU is; de schaduwpaneel-constructie van de tegenlezer maakt die verplaatsing
toetsbaar in plaats van vrijblijvend.
