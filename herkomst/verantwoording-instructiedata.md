# Verantwoording van de instructiedata

**Walnoot 8B Instruct 1.0. Opgesteld door WAINUT op 24 september 2026.**

**Bijgewerkt op 27 september 2026.**

Dit document beschrijft de data waarmee Walnoot 8B Instruct heeft leren werken met opdrachten: de
instructiemix van de instructietraining (in vakjargon de SFT-mix) en de data van de nabewerking die
daarop volgde. U leest hier wat erin zit, hoe die data is gemaakt en gekozen, onder welke licenties
zij valt, wat wij met persoonsgegevens hebben gedaan en wat wel of niet openligt. Het is geschreven
voor wie wil nagaan wat er in het model zit.

---

## Waar dit document over gaat

Walnoot 8B Instruct is een open-weight Nederlands taalmodel van WAINUT, gebouwd op het basismodel
Apertus-8B-2509. Het is in drie stappen getraind en elke stap heeft zijn eigen data:

1. voortgezette pretraining (continued pretraining) op Nederlandse tekst;
2. instructietraining op **de instructiemix**, 51.875 records;
3. een nabewerking op **de nabewerkingsdata**, 1.157 records.

Dit document gaat over stap 2 en stap 3. De data van stap 1 staat per subset in
`provenance-manifest.json`, met een leesinstructie in `MANIFEST-TOELICHTING.md`. De modelkaart in
`../MODELKAART.md` beschrijft alle drie de stappen in gewone taal.

In dit document staat geen tekst uit de data: geen vragen, geen antwoorden en geen brondocumenten.

`PROVENANCE.md`, naast dit document, legt de generatie-setup vast zoals die bij een proefronde in
juli 2026 is gebruikt. Waar dit document op die proefronde steunt, staat dat erbij.

---

## De data in een oogopslag

| | instructiemix | nabewerkingsdata |
|---|---:|---:|
| gebruikt in | instructietraining | nabewerking |
| records | 51.875 | 1.157 |
| bytes | 149.968.466 | 4.519.892 |
| tokens, tekst van alle beurten | 40.957.043 | 1.177.826 |

De checksums (sha256) van de twee bestanden waarop is getraind:

- instructiemix: `01e27e43dcada008456d04933d414605c35c1d2905630bfd59d43d56a7b7f96e`
- nabewerkingsdata: `0580e65ce528bb20cf7fb3c39bc5d8e34070dde7ca070dcd622155db294b9fc8`

**Hoe de tokens zijn geteld.** Wij hebben ze op 23 september 2026 geteld met de tokenizer van het
uitgegeven model (vocabulaire van 131.072). Veel records hebben dezelfde systeembeurt. Daarom geven
wij drie tellingen, zodat u kunt kiezen welke maat u nodig heeft:

| telling | instructiemix | nabewerkingsdata |
|---|---:|---:|
| tekst van alle beurten, systeembeurt inbegrepen | 40.957.043 | 1.177.826 |
| gerenderd met het chat template, inclusief rolmarkeringen en begintoken | 41.299.228 | 1.185.925 |
| tekst zonder de systeembeurt | 27.592.411 | 689.572 |

De systeembeurt zelf is 13.364.632 tokens in de instructiemix en 488.254 tokens in de
nabewerkingsdata.

**Berichten.** De instructiemix telt 145.155 berichten: 41.233 systeemberichten, 51.961
gebruikersberichten en 51.961 assistentberichten. 10.642 records hebben geen systeembeurt; dat is
20,5147 procent van de mix.

**Taal.** De instructiemix is overwegend Nederlands. Engels zijn de wetenschappelijke tak (2.491
records) en de categorie en-retentie (1.500 records), die bedoeld is om het Engels van het model op
peil te houden.

---

## Wat er in de instructiemix zit

### Twintig categorieën

| categorie | records | waar het over gaat |
|---|---:|---|
| samenvatten | 6.858 | een tekst samenvatten |
| instructie-opvolging | 5.998 | een opdracht precies uitvoeren |
| redeneren-rekenen | 5.600 | redeneren en rekenen |
| overheids-juridische-qa | 5.001 | vragen over overheids- en juridische teksten |
| tekstvereenvoudiging | 3.986 | een tekst eenvoudiger maken |
| nl-classificatie | 3.853 | Nederlandse tekst indelen |
| veiligheid-weigering | 3.438 | weigeren op veiligheidsgronden |
| mc | 3.214 | meerkeuzevragen |
| herschrijven | 2.832 | een tekst herschrijven |
| sciriff | 2.491 | Engelstalige wetenschappelijke annotatietaken |
| classificatie | 2.400 | documenten indelen |
| extractie | 2.017 | gegevens uit een tekst halen |
| en-retentie | 1.500 | Engelstalige opdrachten |
| b1-getrouw | 660 | herschrijven naar eenvoudig Nederlands op niveau B1 |
| briefgeneratie | 547 | een standaardbrief opstellen |
| onthouding | 500 | zich onthouden van een antwoord |
| handelsreken | 400 | zakelijk rekenen |
| identiteit | 250 | vragen over het model zelf |
| gedragslagen | 247 | gedrag van het model |
| anonimiseren | 83 | persoonsgegevens in een aangeleverde tekst vervangen |
| **samen** | **51.875** | |

### Hoe de mix is opgebouwd

De mix bestaat uit twee delen. De vorige versie van de mix telde 48.478 records. Daaruit zijn eerst
1.605 extractierecords gehaald (zie *Extractie*) en de takken voor anonimiseren, B1, brief,
classificatie en samenvatten, samen 4.847 records. Daarna bleven 42.026 records over. Daar zijn acht
nieuwe families bij gekomen; vijf daarvan vervangen de weggehaalde takken:

| nieuwe familie | records |
|---|---:|
| samenvatten | 2.533 |
| wetenschappelijke tak | 2.491 |
| classificatie | 2.400 |
| extractie met onthouding | 763 |
| herschrijven naar B1 | 660 |
| standaardtekst en brief | 547 |
| extractie, opnieuw gegenereerd | 372 |
| anonimiseren | 83 |
| **samen met de 42.026 uit de vorige versie** | **51.875** |

**Waarom nieuwe families.** Op onze eigen praktijkopdrachten schoot een eerdere versie van het model
tekort bij samenvatten en bij herschrijven naar B1. Classificatie, extractie en standaardtekst horen
bij de taken waarvoor het model bedoeld is, zoals de modelkaart ze noemt. Wat de nieuwe families
hebben opgeleverd, leest u in de modelkaart. Die noemt een samenvatting van dit model een eerste
opzet die u zelf naleest en raadt het model af voor herschrijven naar eenvoudige taal.

**Extractie.** Uit de vorige versie zijn 1.605 extractierecords verwijderd, omdat de vraag de te
vinden gegevens al als lijst meegaf. Er viel dan niets te zoeken. 882 extractierecords uit de vorige
versie bleven staan en 372 zijn opnieuw gegenereerd, zonder zo'n lijst. Het tekort ten opzichte van
wat er uitging is 1.233 records. Na de herbouw is elk van de 2.017 extractierecords in de mix
nagelopen. Daarvan geven er 0 de te vinden gegevens voor.

**Anonimiseren.** Deze familie is klein gebleven, met 83 records over 38 documenten. De
modelkaart raadt het model af voor het verwijderen van persoonsgegevens uit documenten.

**Identiteit.** De 250 records over het model zelf zijn door een mens geschreven. Zij komen uit geen
externe bron en vallen onder een eigen licentie van WAINUT (`proprietary-WAINUT`).

**Gedragslaag.** De 247 records van de gedragslaag zijn geschreven door Apertus-70B en door WAINUT
gecureerd.

**Uitsluitlijst.** 74 records stonden op een uitsluitlijst die bij onze eigen praktijkopdrachten
hoort. Zij zijn onvoorwaardelijk uit de mix gehaald: 51 uit B1, 8 uit extractie, 8 uit samenvatten
en 7 uit standaardtekst.

### Wie de tekst schreef

Bij elk record hoort metadata in een apart bestand, met onder meer de velden `id`, `category`,
`license`, `bron_set`, `blok` en `generator_model`. Dat metabestand publiceren wij niet. De tellingen
hieronder komen eruit.

**Het veld `generator_model`.**

| generator | records |
|---|---:|
| `swiss-ai/Apertus-70B-Instruct-2509` | 47.488 |
| regelgebaseerd opgebouwd | 83 |
| veld leeg | 4.304 |
| **samen** | **51.875** |

Het veld is onder meer leeg bij de identiteitslaag, die door een mens is geschreven. Ook bij de
wetenschappelijke tak is het leeg; die komt uit bestaande annotatiesets.

**Het teachermodel.** De instructiedata is grotendeels synthetisch. Het teachermodel dat de
antwoorden genereerde, is `swiss-ai/Apertus-70B-Instruct-2509`, onder de Apache License 2.0. Het
is een groter model uit dezelfde familie als het basismodel. Zijn licentie beperkt training op zijn
output niet.

In de proefronde van juli, vastgelegd in `PROVENANCE.md`, draaide het teachermodel met temperature
0.8, top_p 0.9, max_tokens 1024, seed 1234 en een contextlengte van 8192, op vLLM 0.24.0. In die
proefronde ging tijdens de generatie geen enkele prompt naar een externe API. Het metaveld per
record uit de proefronde, met generator, seedbron, tijdstip en samplinginstellingen, is niet
meegekomen naar de uitgegeven mix. De metadata van de uitgegeven mix noemt de generator wel, maar
geen samplinginstellingen per record.

**Het veld `source`.** Dit veld is niet in elk record gevuld, dus de tellingen hieronder dekken niet
de hele mix. Bij 8.740 records is het leeg. De records waarin het gevuld is, verdelen
zich zo:

| herkomst | records |
|---|---:|
| Self-Instruct op 51 met de hand geschreven seed-prompts | 26.435 |
| met grounding op een passage uit het GPT-NL Public Corpus | 13.312 |
| SciRIFF, via `swiss-ai/apertus-sft-mixture` | 2.491 |
| Self-Instruct voor zakelijk rekenen, met een door code exact uitgerekend antwoord | 400 |
| door een mens geschreven | 250 |
| door Apertus-70B geschreven, door WAINUT gecureerd | 247 |
| **samen** | **43.135** |

**De anonimiseerrecords.** De 83 anonimiseerrecords zijn regelgebaseerd opgebouwd. Hun vraag is
geschreven door Apertus-70B en daarna door een beoordelaarsmodel gekeurd.

### Brondocumenten

Een deel van de instructiedata steunt op een brondocument. Het model krijgt dan een tekst en
een opdracht over die tekst. Die documenten komen uit twee bronnen.

**Letterlijke passages uit het GPT-NL Public Corpus.** 13.312 records hebben in hun metadata de
herkomst `corpus`. Bij die records komt de passage letterlijk uit het corpus en is het antwoord van
Apertus-70B. Ook de nieuwe familie samenvatten werkt op letterlijke corpuspassages.

Het corpus is `GPT-NL/GPT-NL_Public_Corpus`, door het GPT-NL-consortium vrijgegeven onder CC BY 4.0.
De code die de passages ophaalde, legde de revisie niet expliciet vast. De voortgezette pretraining
las het corpus wel gepind op revisie `1e17d21afa6518939523fbdcc1fbb3167b671725` (lastModified
2026-05-04T12:42:07Z). Tot 24 augustus 2026 was dit ook de laatste versie van het corpus.
Na die revisie kreeg het corpus nog twee commits. De commit van 24 augustus 2026 wijzigde alleen de
README. De commit van 7 september 2026 wijzigde de licentiewaarde van de twee archiefsubsets van het
Noord-Hollands Archief en Het Utrechts Archief, in hun twee statistiekbestanden en in vijf
parquetbestanden; volgens de beschrijving van die commit veranderde in die parquetbestanden alleen
de licentiekolom. De andere 26 subsets die de voortgezette pretraining gebruikte, zijn byte-gelijk
op deze revisie en op de HEAD van het corpus zoals die op 27 september 2026 stond.

In de proefronde van juli is de grounding beperkt tot acht subsets met modern Nederlands:
rechtspraak, officiele-bekendmakingen, tweedekamer, european-parliament, pbl, dansknaw, multi-eurlex
en wikidata. Krantenarchieven (kb-open-kranten) zijn uitgesloten vanwege verouderd Nederlands en
OCR-ruis. Een passage moest tussen 400 en 6.000 tekens lang zijn en een taalscore
van minstens 0,80 halen. Voor de 13.312 records met herkomst `corpus` is niet per record vastgelegd
uit welke subset de passage komt.

De nieuwe familie samenvatten gebruikt passages uit een pool van 33.785 passages die de poort (gate)
van 5 september heeft gehaald (zie *Een poort op corpuspassages*). Voor die pool golden eigen
filters: minstens 1.100 tekens, een taalscore van minstens 0,90 en een lengte van 300 tot 1.100
tokens. De pool bevat ook passages uit subsets buiten de acht van de proefronde, zoals dpc, woogle,
openraadsinformatie en auditdienstrijk. Bij deze passages staat de subset per document vast.

**Documenten die het teachermodel schreef.** De nieuwe families anonimiseren, B1 en classificatie
werken op documenten die Apertus-70B heeft geschreven. Dat geldt ook voor de nieuwe
extractierecords, met onthouding en opnieuw gegenereerd. Die documenten vallen onder de licentie van
het teachermodel.

### De wetenschappelijke tak

De tak bestaat uit 2.491 Engelstalige records met wetenschappelijke en biomedische annotatietaken,
zoals vragen bij een artikel en het markeren van begrippen in een tekst. Zij komt uit SciRIFF
(`allenai/SciRIFF`, onder ODC-BY), via `ai2-adapt-dev/tulu_v3.9_sciriff_10k` in
`swiss-ai/apertus-sft-mixture`, revisie `51998bcb2f80bc3ad1779bdfe5ebdc4d4df9f624`. Wij hebben de
tak in september 2026 in één keer ingelezen.

**De licentiepoort.** SciRIFF bundelt taken uit veel oorspronkelijke datasets. Per dataset moest de
licentie blijken uit een primaire bron: het licentiebestand, de datasetkaart of de bijlage van het
eigen artikel. De licentietabel in het SciRIFF-artikel en de algemene licentievlag van de bundel
telden niet als bewijs.

Van de 9.722 kandidaatrecords haalden er 4.421 die poort. Afgevallen zijn 5.301 records:

| reden | records |
|---|---:|
| dataset zonder primaire bron voor de licentie | 4.749 |
| CC BY-NC | 270 |
| DDI, waarvan de meest specifieke bron niet-commercieel zegt | 176 |
| NLM-Gene | 102 |
| AxCell | 3 |
| GPL 3.0 | 1 |

Na de kwaliteitspoorten bleven 2.659 records over. Daarvan kwamen 168 uit AnatEM, dat onder CC BY-SA
3.0 staat. Die 168 zitten niet in de mix. Zo komt de tak op 2.491 records uit dertien
oorspronkelijke datasets:

| licentie | records | datasets |
|---|---:|---|
| CC BY 2.5 | 812 | BioASQ |
| Apache 2.0 | 516 | SciTLDR, COVID-QA |
| MIT | 412 | QASA, PubMedQA, MatSci Text Corpus |
| CC0 1.0 | 281 | MedMentions, NLM-Chem |
| CC BY 4.0 | 279 | Chia, Qasper |
| publiek domein | 171 | NCBI Disease |
| CC BY 3.0 | 16 | JNLPBA |
| BSD | 4 | LINNAEUS |
| **samen** | **2.491** | |

### Systeembeurt, chat template en loss

**De systeembeurt.** De records uit de vorige versie van de mix hielden hun systeembeurt. De nieuwe
families, op de wetenschappelijke tak na, kregen er een via een loting met een vaste seed over vijf
standen, waaronder een stand zonder systeembeurt, in de verhouding 0,20, 0,15, 0,25, 0,20 en 0,20.
Ook de identiteitslaag en de gedragslaag doen niet mee aan de loting. Zij brengen elk een eigen
stand mee, zodat over de hele mix zeven standen voorkomen. De systeemteksten zijn byte voor byte
overgenomen uit een eerdere versie van de mix. De wetenschappelijke tak doet evenmin mee aan de
loting. Van die tak hebben 619 records geen systeembeurt en 1.872 records de systeemprompt van het
model met een vast aanvullend blok erachter. Die systeembeurt is dus niet gelijk aan
`systeemprompt.txt`.

**Loss alleen op de antwoorden.** De training telt alleen de assistentbeurten mee. Systeem- en
gebruikersbeurten zijn gemaskeerd. Het eindtoken `<|assistant_end|>` wordt meegetraind, zodat het
model leert zijn beurt af te sluiten.

**Een vast chat template.** De records zijn gerenderd met een eigen, vastgezet chat template (jinja,
3.530 bytes, sha256 `ae225a7276a912e27d5fbef291d634a20a00f87ce9a69f2fd9a977f59bf7d282`). Het
standaardtemplate van de tokenizer zou elk record zonder systeembeurt stilletjes een
identiteitsprompt meegeven. Met het vaste template gebeurt dat niet.

### Poorten op de mix

De mix moest deze poorten halen voordat erop werd getraind:

- 0 dubbele id's en 0 records zonder verplichte velden;
- 0 van de 2.017 extractierecords met een voorgezegde lijst;
- de mix is twee keer vanaf nul gebouwd en beide resultaten waren byte voor byte gelijk;
- tegen onze eigen afgeschermde praktijkopdrachten: 0 harde treffers en 0 treffers op de
  afgeschermde sets. 12 records gaven een melding. Een melding is een lichtere overlap die wordt
  gerapporteerd maar niet blokkeert.

---

## De nabewerkingsdata

### Wat de nabewerking is

De nabewerking is gewone instructietraining op antwoorden die het model zelf heeft gegeven en die
daarna zijn goedgekeurd. In vakjargon is dat rejection fine-tuning (RFT), ook wel self-distillation
met rejection sampling genoemd. Er is geen DPO gebruikt, geen referentiemodel en geen voorkeurspaar.

De run start op het model uit de instructietraining. De vragen zijn aan dat model voorgelegd; de
antwoorden heeft het zelf gegenereerd. Elk record bestaat uit precies een systeembeurt, een
gebruikersbeurt en een assistentbeurt. De systeembeurt is de tekst van `systeemprompt.txt` in de
modelrepository op Hugging Face. Dat bestand is 1.527 bytes, sha256
`81994b38115fd3296b53c3238c2ecc60ff57fb020b2ea79f67eb1d44d88825a7`. In de records staat de tekst
zonder de newline aan het eind, dus 1.526 bytes, sha256
`5ed46c740a4ddc4f6a2b415cd61d5c472520459317b18583967ff7c324578e6d`.

### Waar de vragen vandaan komen

De vragen van 1.016 records komen uit een pool van 6.000: 3.000 brede opdrachten, 2.000 uit de
taakfamilies en 1.000 met een eis aan de vorm van het antwoord. Naar herkomst zijn dat 2.000 vragen
uit een familietemplate, 1.500 uit een indeling van opdrachtsoorten, 1.500 uit de instructiemix en
1.000 uit een template met een vormeis. De vragen in de pool verwijzen naar 3.088 verschillende
documenten; 228 daarvan staan ook in de instructiemix. De vragen van de overige 141 records komen
uit een aanvullende laag van 2.200 vragen.

Van de 1.157 gekozen records is de vraag bij 858 overgenomen: 594 uit de instructiemix en 264 op een
document uit het corpus. Bij 158 is de vraag gesteld op een document dat het teachermodel schreef.
Bij 141, de records uit de aanvullende laag, is niet positief vast te stellen of het document
synthetisch is. Die 141 tellen wij als niet-synthetisch, dus aan de strenge kant.

### Hoe de antwoorden zijn gekozen

Per vraag zijn meerdere antwoorden gegenereerd, in drie generatierondes van 24.000, 12.000 en 15.400
antwoorden. Uit die rondes komen respectievelijk 871, 145 en 141 records van de nabewerkingsdata.

Een beoordelingsstap besliste welke antwoorden goed waren:

- In de drie families met een controleerbaar antwoord (classificatie, extractie en anonimiseren)
  besliste een regelgebaseerde controle. Die controle noemt een antwoord goed of onbruikbaar. Zij
  meet niet of er iets is verzonnen.
- Buiten die drie families beoordeelden twee modellen van derden elk antwoord. Een antwoord telde
  als goed wanneer beide het goed noemden. Waren zij het oneens, dan oordeelde een derde model van
  een derde partij en besliste de meerderheid van twee van de drie.

Daarna golden drie regels:

- per vraag bleef hoogstens één antwoord over;
- een antwoord dat langer was dan 1,8 keer de mediaan van de goede antwoorden in dezelfde laag van
  de pool, viel af. De grenzen kwamen uit op 439,2, 302,4 en 1.333,8 tekens;
- vielen daarmee alle goede antwoorden van een vraag af, dan leverde die vraag geen record.

De drie beoordelaarsmodellen draaiden elk bij een eigen aanbieder, zonder fallback naar een andere
aanbieder. Vragen met hun documenten zijn voor de beoordeling dus naar externe aanbieders gegaan. De
rubric van de beoordeling en de prompts van de beoordelaarsmodellen zijn niet gepubliceerd. De namen
van die modellen zijn op verzoek beschikbaar.

### Wat er overbleef

Onderweg viel dit af:

- 3.671 vragen kregen geen enkel goed antwoord;
- 74 antwoorden waren een kopie van de vraag;
- 23 vragen hielden na het weglaten van kopieën geen goed antwoord over;
- 452 vragen verloren al hun goede antwoorden aan de lengteregel.

534 vraag-id's staan op vijf uitsluitlijsten, waaronder 300 afgeschermde evaluatievragen. Daardoor
zijn 4.407 gegenereerde antwoorden geweerd.

Het resultaat is 1.157 records:

| familie | records |
|---|---:|
| brede opdrachten | 664 |
| opdrachten met een vormeis | 167 |
| classificatie | 118 |
| extractie | 111 |
| vragen bij een document | 63 |
| samenvatten | 24 |
| herschrijven naar B1 | 6 |
| anonimiseren | 4 |
| **samen** | **1.157** |

De antwoorden zijn kort, met een mediaan van 175 tekens en een bereik van 6 tot 1.314. Per record,
systeembeurt inbegrepen, is de mediaan 983 tokens en het gemiddelde 1.018,0, met een minimum van 460
en een maximum van 2.791. De systeembeurt alleen heeft een mediaan van 422 tokens. Die telling is
gedaan zonder chat template en is dus een ondergrens.

De nabewerkingsdata heeft geen licentieveld. Zij voegt geen nieuwe externe bron toe en de
wetenschappelijke tak zit er niet in.

### De run

| instelling | waarde |
|---|---|
| epochs | 1 |
| learning rate | 1e-5, cosine schedule |
| warmupstappen | 5 |
| batch | 8 packed sequences van 4.096 tokens |
| stappen | 37 |
| eval_loss | van 0,2141 naar 0,1997 |

Voordat de training begint, keurt een eerste poort het invoerbestand. Bij afkeur start de training
niet.

Het uitgegeven model is het checkpoint na stap 37. Dat is `model.safetensors` in de modelrepository,
sha256 `db131554ffb1fb9e0885855008b8ad4078077d4168e4c931e1024c2f9c586494`; zie ook
`../MANIFEST-GEWICHTEN.md`.

---

## Licenties

Het veld `license` in de metadata van de instructiemix kent tien waarden:

| licentie | records | waar het voor staat |
|---|---:|---|
| `Apache-2.0-clean` | 49.134 | een afgeleid label van WAINUT voor materiaal uit onze eigen generatieketen, met Apertus-70B (Apache 2.0) als teachermodel; geen licentie van een externe bron |
| CC BY 2.5 | 812 | wetenschappelijke tak |
| Apache 2.0 | 516 | wetenschappelijke tak |
| MIT | 412 | wetenschappelijke tak |
| CC0 1.0 | 281 | wetenschappelijke tak |
| CC BY 4.0 | 279 | wetenschappelijke tak |
| `proprietary-WAINUT` | 250 | de identiteitslaag, door een mens geschreven |
| publiek domein | 171 | wetenschappelijke tak |
| CC BY 3.0 | 16 | wetenschappelijke tak |
| BSD | 4 | wetenschappelijke tak |
| **samen** | **51.875** | |

**Corpuspassages vallen onder de licentie van het corpus.** De records die op een letterlijke
passage uit het GPT-NL Public Corpus steunen, staan in het licentieveld onder `Apache-2.0-clean`.
Dat label gaat over het gegenereerde deel. De passage zelf valt onder de licentie van het corpus,
CC BY 4.0. De naamsvermelding daarvoor staat in `../NOTICE`.

**Wat er niet in zit.** Geen enkele bron in de mix staat onder een niet-commerciële licentie, onder
share-alike, onder de GPL of onder een onderzoeksbeperking. Geen van de bronnen in het licentieveld
van de instructiemix sluit gebruik in een commercieel model uit.
Een onderzoeksgebonden dataset voor naamherkenning uit een eerdere versie van onze data zit niet in
de mix; 0 records hebben die herkomst.

**Naamsvermelding.** De naamsvermelding voor het GPT-NL Public Corpus en de CC BY-sets van de
wetenschappelijke tak staat met rechthebbende, vindplaats en licentie in `../NOTICE`. SciRIFF zelf
(`allenai/SciRIFF`; Wadden et al., 2024) staat onder ODC-BY. Ook die licentie vraagt
naamsvermelding.

**Licentie en persoonsgegevens zijn twee verschillende vragen.** Een open licentie regelt het
auteursrecht en niet de AVG. Daarover gaat het volgende hoofdstuk.

---

## Persoonsgegevens

**Er is geen filter op persoonsgegevens over de trainingsdata als geheel gedraaid.** De modellen tot
en met deze uitgave zijn getraind op data die als geheel niet op persoonsgegevens is gefilterd.
Hieronder staat wat er wel is gedaan en gemeten.

### Waar persoonsgegevens in de instructiemix zitten

De corpuspassages in de instructiemix zijn echte overheids- en archiefteksten die WAINUT niet heeft
bewerkt. Daarin staan echte persoonsgegevens, zoals geboortedata en e-mailadressen op bestaande
domeinen. Er zit ook interviewmateriaal tussen waarin een geboortedatum en een geboorteplaats samen
voorkomen, soms met een naam.

Materiaal uit openbare rechtspraak hebben wij niet zelf bewerkt. De bron haalt de herleidbare
gegevens er zelf uit; de namen van rechter en griffier blijven staan. Namen van personen in een
professionele context hebben wij behouden.

### Een poort op corpuspassages

Op 5 september 2026 is een poort gedraaid op letterlijke corpuspassages die voor documenttaken zijn
klaargezet. Die poort keurde 16.776 kandidaatpassages af omdat er persoonsgegevens in stonden:

| soort | passages |
|---|---:|
| telefoonnummer | 1.431 |
| e-mailadres | 1.066 |
| BSN | 76 |
| geboortedatum | 89 |
| IBAN | 41 |
| naam | 11.592 |
| initialen | 1.445 |
| adres | 1.036 |

De eerste vijf soorten golden als hard, de laatste drie als zacht. Na die stap en een filter op
lengte bleef een pool van 33.785 passages over. Daaruit zijn 1.600 passages gekozen, die bij een
hercontrole 0 treffers gaven. Het afgekeurde deel is niet bewerkt maar weggelaten.

Deze poort ging alleen over de passages voor die documenttaken. Zij heeft twee grenzen. Het
GPT-NL-corpus is zelf al deels gepseudonimiseerd; hoe volledig dat is, is niet gemeten. Namen van
ambtsdragers in hun ambtsrol blijven staan.

### Een meting achteraf op de nabewerkingsdata

Achteraf is de nabewerkingsdata doorgemeten met een vastgezette set van 18 detectoren. Zelftoetsen
op 38 en 17 gevallen gaven 0 fouten en de set was voor en na de scan byte voor byte dezelfde.

11 van de 18 detectoren slaan aan, met samen 702 treffers over de 1.157 records: 528 in de vragen
en 174 in de antwoorden.

| soort | in de vraag | in het antwoord |
|---|---:|---:|
| kenteken | 144 | 45 |
| medisch gegeven | 89 | 19 |
| adres | 81 | 36 |
| postcode | 81 | 42 |
| postcode met huisnummer | 37 | 32 |
| e-mailadres | 36 | 0 |
| telefoonnummer in context | 27 | 0 |
| vast telefoonnummer | 20 | 0 |
| mobiel telefoonnummer | 7 | 0 |
| paspoortnummer in context | 4 | 0 |
| IPv4-adres | 2 | 0 |
| **samen** | **528** | **174** |

Er is geen enkele treffer voor een geboortedatum in context, een BSN (kaal of in context), een IBAN,
een creditcardnummer, een KvK-nummer of een btw-nummer. Dat die detectoren werken, is getoetst op
een synthetisch geval.

E-mailadressen, telefoonnummers en paspoortcontext staan alleen in de vragen. Het model heeft ze
niet zelf gegenereerd. Geen enkel e-mailadres in deze data combineert een persoonlijk ogend deel
voor de @ met een bestaand domein. Het oordeel dat de overige treffers overwegend synthetisch zijn,
rust op een handmatige controle van vergelijkbare data uit een eerdere ronde en niet op een
handmatige controle van deze data.

Twee families, extractie en anonimiseren, werken per ontwerp met persoonsgegevens. Zij leren het
model die te vinden of te vervangen. Dat hun waarden uit gereserveerde reeksen komen, is een
aanwijzing en geen toets. De rekenkundige controle op rekeningnummers slaat er 0 keer op aan,
terwijl er wel waarden in staan die op rekeningnummers lijken. Een handmatige controle van juist
die twee families is niet gedaan.

De kwaliteitspoort van de nabewerking had een onderdeel voor persoonsgegevens, maar dat oordeelde bij
1.153 van de 1.157 records niet over dit punt. De selectie op kwaliteit liet 96 procent van de
treffers uit de generatierondes weg. Dat was geen filter op persoonsgegevens.

In de nabewerkingsdata is langs twee wegen geen geboortedatum gevonden. In de instructiemix eronder
staan wel enkele tientallen records met een geboortedatum in context. Het uitgegeven model
heeft dat materiaal dus in zijn voorgeschiedenis.

### Wat de detectoren niet zien

De detectoren zoeken naar patronen, zoals nummers en adressen. Een steekproef liet zien wat ze
missen. In een gestratificeerde steekproef van 300 records uit onze kandidaatdata, waarvan 90 uit de
instructiemix van het uitgegeven model, bevatten 9 records echte persoonsgegevens. Alle 9 zijn
interview- of profielmateriaal zonder gegevens met een vast patroon. Twee daarvan gaan vermoedelijk
over levende personen. De detectoren vonden er 0 van de 9. Daarnaast bevatten 52 van de 300 records
synthetische persoonsgegevens.

Een tweede detectielaag, die persoonsnamen herkent, heeft nooit gedraaid. Hoeveel de detectie per
soort mist, is niet gemeten. De nabewerkingsdata zelf zat niet in de steekproef.

### Grondslag

WAINUT beroept zich voor de verwerking op gerechtvaardigd belang onder artikel 6 lid 1 sub f AVG. De
belangenafweging daarvoor is intern vastgelegd volgens de cumulatieve driestappentoets uit EDPB
Opinion 28/2024. De openbaarheid van een bron is daarbij een factor in de belangenafweging en geen
zelfstandige grond.

### Wat dit voor u betekent

Het model kan gegevens bevatten of voortbrengen die naar een persoon herleidbaar zijn. Wie het model
inzet, is daarvoor zelfstandig verwerkingsverantwoordelijke en kan zich niet op de metingen hierboven
beroepen. Meldingen over persoonsgegevens gaan naar `support@walnoot.ai`.

---

## Decontaminatie tegen de evaluatiesets

Wij rapporteren onze cijfers op EuroEval, een publieke meetlat. Daarom hebben wij gemeten of
testitems van EuroEval in de instructiedata terecht zijn gekomen. Dat is op verschillende momenten
gebeurd, over verschillend materiaal.

**Juli 2026, materiaal van toen.** De metingen van juli staan in `../decontaminatie/`. Zij gaan over
de voorbereide trainingsdata (22 juli) en over de twee bronbestanden van de eigen bron die in het
corpus van de voortgezette pretraining de opmaak van tekst moet behouden (30 juli). De referentie
was 35 bestanden uit EuroEval 17.6.0 met 29.273 records. Er is gemeten op 13 woorden achter elkaar,
na NFKC-normalisatie en omzetting naar kleine letters. Op de twee bronbestanden kwam die meting op 0
uit. De audit op 8 woorden raakte daar 723 en 591 records.
De pas van 22 juli en zijn amendement staan beschreven in de modelkaart en in
`../decontaminatie/13-gram-eerste-pas-amendement.md`. De instructiemix van het uitgegeven model is
later gebouwd. Voor die mix gelden de metingen hieronder.

**6 september 2026, voor de training.** Een deel van de mix is gemeten tegen de Nederlandse sets van
EuroEval 17.6.0, samen 27 splitbestanden met 24.815 rijen. Geen enkel testitem kwam er exact in
voor. Op 13 woorden raakten 2 van de 2.048 items van squad-nl (test), met een vaste frase die op 20
woorden verdwijnt. De wetenschappelijke tak was schoon. Op 8 woorden raakten 624 van de 24.815
rijen, 2,5146 procent. De families die daarna nog zijn toegevoegd, vielen buiten deze meting.

**Voor de training, tegen onze eigen praktijkopdrachten.** De volledige mix is getoetst tegen onze
eigen afgeschermde praktijkopdrachten; zie *Poorten op de mix*.

**12 september 2026, de bestanden waarop is getraind.** Deze meting ging over precies de twee
bestanden van dit document. Van beide is eerst de sha256 opnieuw gemeten en die was gelijk aan de
vastgelegde waarde. De referentie waren de tien Nederlandse taken van EuroEval, met 28 splits en samen
42.925 testitems. Elk item is aan de vraagzijde en aan de antwoordzijde apart gemeten, samen 85.850
itemzijden. 41.531 daarvan zijn korter dan 8 woorden en kunnen op die maat niet raken. Gemeten zijn
de gebruikers- en assistentbeurten, niet de systeembeurt.

Aantal testitems met minstens één treffer:

| bestand | 8 woorden | 13 woorden | 20 woorden |
|---|---:|---:|---:|
| instructiemix | 659 | 2 | 0 |
| nabewerkingsdata | 33 | 0 | 0 |

De 2 items op 13 woorden zijn testvragen van squad-nl (squad-nl-v2-mini, split test), aan de
vraagzijde. Zij delen ongeveer 1,27 procent van hun reeksen van 13 woorden met de mix. Het gaat om een
vaste instructiefrase die op 16 woorden verdwijnt. De poort ligt op 20 woorden achter elkaar en daar
is het oordeel schoon.

Het verslag van deze meting staat in `../decontaminatie/getrainde-data-12-september.md`.

---

## Wat openligt en wat niet

| wat | open | waar, of waarom niet |
|---|---|---|
| herkomst per bron, met licentie | ja | dit document, `PROVENANCE.md`, `provenance-manifest.json`, `../NOTICE` |
| omvang, sha256 en tokentellingen van beide bestanden | ja | dit document |
| recept van de instructietraining | ja | `../recept/02-sft/instructietraining-mix.yaml` |
| recept van de nabewerking | als template | `../recept/03-nabewerking/`; de ingevulde versie staat er niet in |
| decontaminatie | tellingen | `../decontaminatie/` voor juli en 12 september, dit document ook voor 6 september; de audit op 8 woorden alleen als tellingen per dataset |
| de records zelf: vragen, antwoorden en documenten | nee | persoonsgegevens, zie hieronder |
| het metabestand per record | nee | het hoort bij de records |
| de uitsluitlijsten | nee | zij verwijzen naar records |
| rubric en prompts van de beoordelaarsmodellen | nee | niet gepubliceerd |
| namen van modellen van derden bij keuring en beoordeling | op verzoek | wij beschrijven ze naar rol |
| onze eigen praktijkopdrachten en hun cijfers | nee | buiten WAINUT niet te draaien, dus niet na te rekenen |

**Waarom wij de records niet publiceren.** Een licentie verbiedt het niet, want de licentietriage vond
geen bron die dat uitsluit. Wel bevat de data persoonsgegevens; zie *Persoonsgegevens*.

Voor latere versies hebben wij uitsluitlijsten gemaakt voor verhalend persoonsmateriaal, zoals
interviews en profielen. Die lijsten zijn ook bindend voor elke publicatie van de data. Op het
uitgegeven model zijn ze niet toegepast, want dat was er al op getraind.

---

## Bekende beperkingen en open punten

- **Herkomst niet in elk record.** Het veld `source` is niet in elk record gevuld. Voor een deel van
  de mix is de herkomst alleen per familie bekend.
- **Subset per passage onbekend.** Voor de 13.312 records met herkomst `corpus` is niet per record
  vastgelegd uit welke subset van het GPT-NL Public Corpus de passage komt. Twee archiefsubsets van
  dat corpus, het Noord-Hollands Archief en Het Utrechts Archief, droegen op de revisie van 4 mei de
  licentiewaarde "unknown". Samen zijn dat 81.169 documenten. Op 7 september 2026 zette de
  uitgever beide op public-domain. In de proefronde van juli vielen ze buiten de grounding en de 1.600
  passages van de poort van 5 september droegen die waarde niet. Dat archiefmateriaal in de
  instructiemix zit, is daarmee niet uitgesloten. De modelkaart beschrijft wat wij over die twee
  subsets weten.
- **Geen revisiepin in de code.** De code die de corpuspassages ophaalde, legde de revisie niet
  expliciet vast. Na 4 mei 2026 wijzigde de uitgever alleen de README (24 augustus) en de
  licentiewaarde van de twee archiefsubsets (7 september). De andere 26 subsets die de voortgezette
  pretraining gebruikte, waren op 27 september 2026 nog byte-gelijk aan de revisie van 4 mei.
- **Persoonsgegevens.** Er is geen filter over de data als geheel gedraaid. De detectielaag voor
  persoonsnamen heeft nooit gedraaid, de recall per soort is niet gemeten en de treffers in de
  nabewerkingsdata zijn niet met de hand nagelezen.
- **Het ingevulde recept van de nabewerking** staat niet in deze repository. De template wel.
- **Het effect van de nieuwe families** is niet met een publieke meetlat vastgesteld. Onze eigen
  praktijkopdrachten zijn buiten WAINUT niet te draaien; hun cijfers staan daarom niet in dit
  document.

---

## Zelf nalopen

Zonder de records kunt u de training niet overdoen. Wel kunt u nalopen hoe zij is ingericht en met
de checksums vaststellen of een bestand precies het getrainde bestand is.

### De instructietraining

Het recept is `../recept/02-sft/instructietraining-mix.yaml`. Het wisselt ten opzichte van het
vorige recept alleen de data, zodat een verschil in uitkomst aan de data is toe te schrijven.

| instelling | waarde |
|---|---|
| startpunt | onze eigen Nederlandse basis uit de voortgezette pretraining |
| tokenizer | `swiss-ai/Apertus-8B-Instruct-2509`, revisie `2256fb4a51e59fc115305da71c420b3b0a278e07` |
| chat template | vastgezet, jinja, 3.530 bytes, sha256 `ae225a7276a912e27d5fbef291d634a20a00f87ce9a69f2fd9a977f59bf7d282` |
| sequence length | 4.096 tokens, met packing |
| batch | 128 packed sequences, 524.288 tokens per stap |
| epochs | 2 |
| learning rate | 2e-5, cosine schedule, warmup 0,03 |
| precisie en verdeling | bf16, FSDP2 |
| seed | 42 |
| split | 0,02: 50.837 records om te trainen, 1.038 om te evalueren |
| stappen | 154, 77 per epoch |
| loss | alleen op de assistentbeurten; `<|assistant_end|>` wordt getraind |

**Waarom twee epochs.** Het aantal epochs komt uit een eerdere ronde met hetzelfde recept op een
eerdere mix. Daar sloot het model na twee epochs zijn beurt netjes af. Drie epochs lieten het model
te veel vergeten en één epoch gaf vormcollaps. Deze instelling is voor deze mix ongewijzigd
overgenomen.

**Het startpunt.** De instructietraining start op onze eigen Nederlandse basis uit de
voortgezette pretraining en niet op het kale basismodel.

**De trainsplit in tokens.** De trainjob meldde 40.462.812 ruwe tokens in de trainsplit. Dat getal
gaat alleen over de trainsplit en is daarom kleiner dan de tellingen over het hele bestand onder
*De data in een oogopslag*.

**Het aandeel systeemtokens.** Bij het opstellen van `instructietraining-mix.yaml` is uitgegaan
van een aandeel systeemtokens van 37,5 procent. Dat aandeel is gemeten op een eerdere mix. In de
uitgegeven mix is de systeembeurt 13.364.632 van de 40.957.043 tokens.

**Let op dat `../recept/02-sft/sft.yaml` niet het recept van dit model is.** Het is een algemene
template met andere waarden, zoals 3 epochs en een learning rate van 1e-5. Voor dit model telt alleen
`instructietraining-mix.yaml`.

### De nabewerking

Het recept is `../recept/03-nabewerking/nabewerking.yaml`. Het yaml-bestand is een template met
placeholders voor de naam van de run, het databestand en het startmodel. De waarden staan onder
*De run* hierboven. Het databestand is de nabewerkingsdata met sha256
`0580e65ce528bb20cf7fb3c39bc5d8e34070dde7ca070dcd622155db294b9fc8`.

De template is opgesteld met een begroting van gemiddeld 757 tokens per record en 68 tot 102
stappen. Gemeten zijn gemiddeld 1.018 tokens per record en 37 stappen.

---

## Contact

Vragen over deze data, meldingen van rechthebbenden en meldingen over persoonsgegevens gaan naar
`support@walnoot.ai`. Gaat uw melding over materiaal dat uit het basismodel komt, dan gaat die naar de
uitgever van het basismodel; `../MODELKAART.md` noemt daarvoor twee adressen.
