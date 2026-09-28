---
license: apache-2.0
language:
- nl
- en
library_name: transformers
pipeline_tag: text-generation
base_model:
- swiss-ai/Apertus-8B-2509
base_model_relation: finetune
datasets:
- GPT-NL/GPT-NL_Public_Corpus
tags:
- dutch
- nederlands
- apertus
- text-generation
- continued-pretraining
---

> De gewichten en de modelbestanden `systeemprompt.txt`, `config.json`, `tokenizer.json`,
> `tokenizer_config.json`, `generation_config.json`, `chat_template.jinja` en `Modelfile` staan op
> <https://huggingface.co/WAINUT/walnoot-8b-instruct> en niet in deze GitHub-repository. Waar de kaart
> hieronder "deze repository" zegt, is de repository op Hugging Face bedoeld.

<p align="center">
  <a href="https://walnoot.ai"><img src="https://walnoot.ai/merk/walnoot-logo-wit.png" alt="Walnoot" width="320"></a>
</p>

# Walnoot 8B Instruct

**Versie 1.0. Nederlands taalmodel van WAINUT.**

---

## Wat dit model is

Walnoot 8B Instruct is een taalmodel voor het Nederlands. WAINUT heeft het gemaakt door een
bestaand open basismodel verder te trainen op Nederlandse instructietaken: vragen beantwoorden
bij een document, gegevens uit een tekst halen, teksten indelen en standaardteksten opstellen.
Samenvatten zit er ook in, maar alleen als eerste opzet die u zelf naleest; zie *Beperkingen en
risico's*.

Het model is bedoeld als hulpmiddel bij werk met Nederlandse zakelijke en juridische teksten.
Het is geen zoekmachine, geen feitenbank en geen vervanging van een vakinhoudelijk oordeel.

| gegeven | waarde |
|---|---|
| naam | Walnoot 8B Instruct |
| versie | 1.0 |
| repository | `WAINUT/walnoot-8b-instruct` |
| basismodel | `swiss-ai/Apertus-8B-2509` |
| parameters | 8,05 miljard (8.053.338.240) |
| licentie | Apache License 2.0 |
| talen | Nederlands en Engels voor zover het basismodel dat draagt |
| denkstap | geen; het model antwoordt direct, zonder aparte denkstap (non-thinking) |
| contextlengte | 32768 tokens als ingestelde limiet; de architectuur laat 65536 toe. Zie *Over de contextlengte* verderop |

Uitgegeven op **28 september 2026**.

De cijfers onder *Resultaten* komen uit de EuroEval-ronde van **11 september 2026**.

## English summary

Walnoot 8B Instruct is a Dutch language model that WAINUT built on top of
`swiss-ai/Apertus-8B-2509`. WAINUT trained it further on Dutch instruction tasks: document
question answering, information extraction, classification, summarisation and drafting of
standard texts. It answers directly, without a separate thinking step. Summarisation is
included, but only as a first draft you check yourself; see the Dutch section on limitations
(*Beperkingen en risico's*). The model is released under the Apache License 2.0. By its own
measurement WAINUT is not a provider of a general-purpose AI model within the meaning of
Regulation (EU) 2024/1689. Even so, it publishes three documents at
<https://walnoot.ai/en/transparantie>: the public summary of the training content, the
copyright policy with the point of contact for rightsholders and the model documentation for
downstream providers. The remainder of this card is in Dutch. The results table below reports
ten Dutch EuroEval tasks with 95 percent confidence intervals. GPT-NL published figures for
seven Dutch tasks. Six of those are comparable; on wiki-lingua-nl the metric differs between
the two measurements. The original goal was to match GPT-NL on all six comparable benchmarks.
That goal has been met. Walnoot is above GPT-NL on five of them and level on dbrd, measured
against GPT-NL's published values under the decision rule in the Dutch section on the GPT-NL
comparison. Before use, see the Dutch section on limitations (*Beperkingen en risico's*).

---

## Basismodel en trainingsweg, in gewone taal

Het vertrekpunt is **Apertus-8B-2509**, een open Europees basismodel. WAINUT heeft dat model in
drie stappen verder getraind.

1. **Voortgezette pretraining op Nederlandstalig materiaal.** Het basismodel is eerst verder
   voorgetraind op Nederlandse tekst, met een cooldown aan het eind. Dat leverde een eigen
   Nederlandse basis op. Die basis is het vertrekpunt van stap 2 en wordt niet apart
   gepubliceerd.
2. **Instructietraining (SFT).** Op die eigen basis heeft het model geleerd om opdrachten in het
   Nederlands op te volgen. Daarvoor is een samengestelde verzameling taken uit de praktijk
   gebruikt: een vraag beantwoorden aan de hand van een meegeleverd document, gegevens uit een
   tekst halen, een tekst indelen, samenvatten en een standaardtekst opstellen.
3. **Nabewerking met terugkoppeling.** Daarna is het model bijgestuurd op antwoorden die een
   beoordelingsstap had goedgekeurd, zodat het vaker de vorm en de volledigheid levert die bij de
   taak past. De vakterm daarvoor is rejection fine-tuning (RFT).

**Over het veld `base_model` in de metadata van deze kaart.** Dat veld noemt het upstream-model,
zoals de hub het veld bedoelt. Onze eigen Nederlandse tussenbasis heeft geen repository op de hub.

Het model heeft geen nieuwe taal van nul af aan geleerd. WAINUT heeft drie dingen aan het
basismodel toegevoegd: een Nederlandse voortzetting van de pretraining, een eigen instructielaag
in het Nederlands en een laatste nabewerkingsstap met terugkoppeling op goedgekeurde antwoorden.

---

## Resultaten

De tabel geeft de tien Nederlandse taken van EuroEval, met het 95-procentinterval van de
meting. **Hogere waarden zijn beter**, behalve waar de taak dat anders definieert.

| taak | metriek | score | ondergrens | bovengrens |
|---|---|---|---|---|
| dbrd | MCC | 90,5578 | 89,7617 | 91,3540 |
| scala-nl | MCC | 34,4078 | 31,0021 | 37,8135 |
| conll-nl | micro-F1 (no-MISC) | 46,5178 | 44,4888 | 48,5469 |
| squad-nl | F1 (EM 62,08) | 77,3490 | 76,8556 | 77,8423 |
| wiki-lingua-nl | ChrF3++ | 34,1821 | 32,7437 | 35,6205 |
| mmlu-nl | MCC | 37,1621 | 36,1912 | 38,1330 |
| hellaswag-nl | MCC | 22,4580 | 20,7278 | 24,1881 |
| duidelijke-taal | METEOR | 52,9465 | 51,1116 | 54,7814 |
| valeu-nl | EuropeanValues | 2,0235 | 1,4062 | 2,6408 |
| mbbq-nl | bias-gecorrigeerde accuratesse | 27,7202 | 26,1695 | 29,2708 |

**Zo leest u deze tabel.**

- `squad-nl` is gerekend op `f1` en niet op `em`; dat is de primaire metriek van die taak.
- `dbrd` is een sentimenttaak en wordt apart gelezen.
- **De intervallen horen bij de getallen.** Een verschil dat binnen twee intervallen valt, is
  met deze meting niet aangetoond.
- **Kennisvragen en zinsafronding zijn zwak.** `mmlu-nl` komt op 37,16 MCC en `hellaswag-nl` op
  22,46 MCC, op een schaal waarop nul voor gokken staat; **gebruik dit model niet als feitenbank**.
- `mbbq-nl` gaat over bias en is geen veiligheidskeuring; een gestructureerde red-teamronde is er
  niet geweest.

### De vergelijking met GPT-NL

GPT-NL publiceerde in december 2025 interim-scores van zijn eigen basismodel. Op de taken die
zich daarmee laten vergelijken, is dit de stand.

| taak | metriek | Walnoot 8B | interval | GPT-NL | uitslag |
|---|---|---|---|---|---|
| dbrd | MCC | 90,56 | 89,76 tot 91,35 | 90 | gelijkspel |
| squad-nl | EM | 62,08 | 61,42 tot 62,73 | 51 | gewonnen |
| conll-nl | micro-F1 zonder MISC | 46,52 | 44,49 tot 48,55 | 36 | gewonnen |
| scala-nl | MCC | 34,41 | 31,00 tot 37,81 | 19 | gewonnen |
| mmlu-nl | MCC | 37,16 | 36,19 tot 38,13 | 2 | gewonnen |
| hellaswag-nl | MCC | 22,46 | 20,73 tot 24,19 | -2 | gewonnen |

**Het oorspronkelijke doel was GPT-NL op alle zes gepubliceerde benchmarks minimaal te evenaren,
van de zeven die GPT-NL in het Nederlands publiceerde. Dat doel is gehaald.** Op vijf taken ligt
Walnoot erboven, op dbrd staat het gelijk. Walnoot 8B telt 8,05 miljard parameters tegen
26,03 miljard van GPT-NL.

**De beslisregel, vooraf vastgelegd en symmetrisch.** Winst heet pas winst als ons hele
betrouwbaarheidsinterval boven hun cijfer ligt. Verlies heet pas verlies als het interval er
volledig onder ligt. Valt hun cijfer binnen ons interval, dan staat er gelijkspel. Dat geldt ook
op een taak waar wij op punten voorstaan, zoals dbrd.

**Wat u bij deze vergelijking moet weten.** Onze kolom komt uit EuroEval 17.6.0, op de testsplit,
met tien iteraties en bf16-gewichten. De kolom van GPT-NL komt uit hun eigen publicatie op
EuroEval 15.16.0 en bevat interim-scores van het basismodel van GPT-NL, als puntscores zonder
interval. Dat is een verschil van twee hoofdversies in de evaluatieharness. Over versies heen is
de datasetinhoud niet gegarandeerd identiek. Die ruis kan naar beide kanten uitvallen. GPT-NL
publiceert geen gewichten, dus wij hebben dat model nooit zelf kunnen meten.

**Vier taken vallen buiten de vergelijking, om twee verschillende redenen.** Op
`wiki-lingua-nl` publiceerde GPT-NL wel een cijfer, 61 op BERTScore, maar de metriek wisselde
tussen beide metingen; wij meten daar 34,18 op ChrF3++ en die twee schalen lopen anders. Op
`duidelijke-taal`, `valeu-nl` en `mbbq-nl` publiceerde GPT-NL geen cijfer.

**`squad-nl` staat hier op EM en in de tabel hierboven op f1.** Dat komt doordat het
gepubliceerde cijfer van GPT-NL op EM staat; vergelijken kan alleen op dezelfde maat.

**Bron van de kolom GPT-NL.** TNO, GPTNL-DEL-4002, december 2025, pagina 44 tot 49, gemeten op
EuroEval 15.16.0 en gepind in paragraaf 3.6.3 op pagina 96.
<https://publications.tno.nl/publication/34645564/ZpYAY8XF/oliveira-filho-2025-gptnl-training-pipeline.pdf>

**Wat hier niet staat.** In geen van beide tabellen hierboven staat het model waarop Walnoot
voortbouwt. Deze kaart gaat over dit model.

### Hoe er verder is beoordeeld

Naast EuroEval gebruikt WAINUT een tweede meetlat. Dat is een vaste verzameling
praktijkopdrachten in het Nederlands. Een panel van drie van elkaar onafhankelijke
beoordelaarsmodellen legt de antwoorden op die opdrachten langs een vooraf vastgelegde rubric.
Elke opdracht wordt drie keer gegenereerd, met een vaste en twee variabele instellingen, zodat de
spreiding van het model zelf zichtbaar wordt.
**De cijfers daarvan zijn intern en staan niet in deze kaart**, omdat zij niet met een publieke
meetlat te reproduceren zijn. De grenzen die zij aanwijzen staan er wel in, verderop onder
*Beperkingen en risico's*.

---

## Waar het model sterk in is

Het model is gebouwd voor Nederlandse zakelijke en juridische teksten. Onze cijfers hieronder
staan met hun intervallen in de tabellen hierboven. Zij zijn afgezet tegen GPT-NL onder de
beslisregel die daar staat, niet tegen een absolute norm.

- **Sentiment.** `dbrd` komt op 90,56 MCC, het hoogste cijfer in de resultatentabel; die tabel
  zet metrieken van verschillende schalen naast elkaar. Tegen de 90 van GPT-NL staat gelijkspel.
- **Vragen bij een document.** `squad-nl` komt op 77,35 F1 en 62,08 EM, tegen 51 EM bij GPT-NL.
- **Gegevens uit een tekst halen.** `conll-nl` komt op 46,52 micro-F1 zonder MISC, tegen 36 bij
  GPT-NL.

---

## Beperkingen en risico's

**Lees dit voordat u het model in een werkproces zet.**

1. **Samenvatten en herschrijven naar eenvoudige taal.** Een samenvatting van dit model is een
   eerste opzet die u zelf naleest en geen eindproduct; het model haalt op samenvattaken maar een
   klein deel van de opdrachten op een bruikbaar niveau. Herschrijven naar eenvoudige taal gaat
   niet goed. Op onze eigen praktijkverzameling leverde het model op die taak geen enkel bruikbaar
   antwoord. **Gebruik het model daar niet voor.**
2. **Anonimiseren is geen doel van dit model.** Anonimiseren is een kopieertaak waarbij het model
   verhoudingsgewijs vaak tekst toevoegt die niet in de bron staat. **Gebruik dit model niet om
   persoonsgegevens uit documenten te verwijderen.**
3. **Het model verzint.** Zoals elk taalmodel voegt het soms elementen toe die niet in de bron
   staan. Het doet dat vaker naarmate de opdracht meer vrijheid geeft. Controleer elk
   feitelijk gegeven aan de bron.
4. **Het model kan gegevens bevatten of voortbrengen die naar een persoon herleidbaar zijn.**
   Dat geldt voor het basismodel en daarmee ook voor dit model. Wie het model inzet, is daarvoor
   zelfstandig verwerkingsverantwoordelijke.

**Waarom hier geen cijfers bij het eerste punt staan.** Dat punt rust op onze eigen
praktijkverzameling en die meetlat is buiten WAINUT niet te draaien. Een getal uit een meting
die u niet kunt herhalen, hoort niet in een modelkaart; de richting en de strekking wel. Wat er
publiek naast te leggen valt, staat in de tabel hierboven.

**Meer op de site.** De scoretabel met per taak de metriek en het interval staat op
<https://walnoot.ai/scorebord>, in het Engels op <https://walnoot.ai/en/scorebord>. De
modelkaart op de site noemt daarnaast drie dingen die bij het eerste gebruik opvallen en die
hier niet staan. Die kaart staat op <https://walnoot.ai/model> en <https://walnoot.ai/en/model>.

---

## Aanbevolen systeemprompt en instellingen

Het model is met een vaste systeemprompt getraind. **Die prompt hoort erbij.** Zonder die prompt
gedraagt het model zich anders dan waarop het is afgestemd. De EuroEval-metingen in de tabel
hierboven zijn zonder systeemprompt gedraaid, want die harness stuurt er geen mee; onze eigen
meting op praktijkopdrachten draaide er wel mee.

De prompt staat in deze repository als `systeemprompt.txt`, 1.527 bytes,
`81994b38115fd3296b53c3238c2ecc60ff57fb020b2ea79f67eb1d44d88825a7`.

**Wat die prompt met de naam van het basismodel doet.** Met die prompt noemt het model als eigen
herkomst een open Europees basismodel. De naam geeft het pas als iemand er uitdrukkelijk naar
doorvraagt. Dat is een keuze in het gedrag van het model. Deze kaart en het `NOTICE` naast deze
kaart noemen die naam wel voluit.

De prompt laat het model ook geen webadressen noemen, omdat het in onze identiteitstoetsen
adressen verzon die niet bestaan.

**De neutrale instellingen waarmee alles is gemeten.**

| instelling | waarde |
|---|---|
| temperature | 0.0 |
| top_p | 1.0 |
| top_k | 0 |
| min_p | 0.0 |
| repeat_penalty | 1.0 |
| contextlengte | 8192 in onze gebruiksinstructies, 32768 als ingestelde limiet; de EuroEval-runs registreerden 65536 |

**Temperature 0 is met opzet.** Zo is een run herhaalbaar en meet u het model en niet de ruis.
Voor vrijer schrijven kunt u `temperature` op 0.7 en `top_p` op 0.9 zetten. **Meet dan niet het
een en rapporteer het ander.**

**Stoptokens.** Het model gebruikt `<|assistant_end|>` als eindtoken. Voeg `<|user_start|>` en
`<|system_start|>` als extra stoptokens toe; dat is een vangnet tegen doorlopen in een nieuwe
beurt.

**Over de contextlengte, want er zijn drie getallen in omloop.** De tokenizerconfiguratie in deze
repository zet `model_max_length` op **32768**; dat is de limiet die wij bewust hebben ingesteld
en geen bovengrens van het model. **De architectuur laat meer toe, want in `config.json` staat
`max_position_embeddings` op 65536.** Wie `config.json` opent en 65536 ziet staan, kijkt dus niet
naar een fout. **In onze eigen gebruiksinstructies staat daarnaast 8192 als aanbevolen
waarde.** Dat is een advies over geheugengebruik.

**Er is verschil tussen wat is gezet en wat er is gedraaid.** De 32768 is pas voor deze uitgave
in de tokenizerconfiguratie gezet; in het laatste checkpoint van de training stond die waarde er
niet in. Alle tien EuroEval-runs van dit model registreren daarom `max_sequence_length` 65536.
Onze eigen meting op praktijkopdrachten draaide wel op 32768. Kort gezegd is 8192 het advies en
32768 de ingestelde limiet; 65536 is wat de architectuur toelaat en wat de EuroEval-runs
gebruikten.

**Over de KV-cache.** `config.json` in deze repository zet `use_cache` op **true**. In het laatste
checkpoint van de training stond die sleutel op false, want bij het trainen wordt de cache
uitgezet. **Bij het genereren hoort hij op true.** Anders rekent het model bij elk nieuw token de
hele voorafgaande reeks opnieuw door. Dat wordt trager naarmate het gesprek langer duurt. De
antwoorden veranderen er niet door, de snelheid wel.

**Over de meegeleverde generatieconfiguratie.** `generation_config.json` in deze repository zet
`do_sample` op **false**. Dat is met opzet, want alles in deze kaart is op temperature 0 gemeten.
Wie het model ophaalt en niets instelt, hoort hetzelfde gedrag te krijgen als wij. **U kunt
gewoon zelf samplen**, met `do_sample=True` en uw eigen `temperature` en `top_p`. Er staan
met opzet geen samplingwaarden in dat bestand, zodat uw keuze niet stilletjes met die van ons
wordt vermengd.

---

## Het chat template

Bij dit model hoort een eigen chat template, `chat_template.jinja`. **Het wijkt bewust af van het
template van het basismodel** en voldoet aan vier eisen. Die staan hier omdat zij bepalen hoe het
model zich gedraagt.

1. **Het injecteert nooit een standaardsysteemprompt.** Een systeemblok wordt alleen gerenderd
   als het in de berichten staat en niet leeg is. Het template van het basismodel voegt bij een
   gesprek zonder systeemblok stilletjes een eigen systeemtekst toe; **dit template doet dat
   niet**. Daarom is de aanbevolen systeemprompt hierboven ook echt nodig.
2. **Het rendert geen developer- of toolblok.** Alleen system, user en assistant.
3. **Het gebruikt de controltokens van het basismodel exact**, in hun oorspronkelijke vorm en
   met hun oorspronkelijke ids.
4. **Elke assistentbeurt sluit af op het eindtoken** `<|assistant_end|>`. Er is één uitzondering.
   Laat u met `continue_final_message` een begonnen antwoord voortzetten, dan blijft het
   eindtoken bewust weg.

**Wie het template vervangt, verandert het gedrag van het model**, ook als de tekst er hetzelfde
uitziet.

**Let op als u zelf tokeniseert, want het template zet het begintoken er zelf in.** Gebruikt u
`apply_chat_template` met `tokenize=True`, dan klopt het en hoeft u niets te doen. Rendert u eerst
naar tekst en tokeniseert u die daarna zelf, geef dan `add_special_tokens=False` mee. **Anders
staat het begintoken er twee keer** en krijgt het model een reeks die het zo nooit heeft gezien.

**Let ook op het verschil tussen Ollama en transformers zonder systeembericht.** Via Ollama krijgt
u de systeemprompt uit het meegeleverde `Modelfile`, ook wanneer u zelf geen systeembericht
meestuurt. Via transformers krijgt u er geen, want **dit template injecteert niets.** Wilt u in
beide gevallen hetzelfde gedrag, stuur de systeemprompt dan altijd zelf mee.

---

## Gebruik

### transformers

**Welke versie u nodig heeft.** De modelcode voor deze architectuur zit in transformers vanaf
`v4.56.0`; op een oudere versie herkent de bibliotheek het modeltype niet en krijgt u geen nette
melding. Installeer naast transformers en torch ook accelerate, anders stopt `device_map="auto"`
met een foutmelding. Dat kan in één keer met `pip install "transformers>=4.56" torch accelerate`.
Wij hebben het fragment hieronder gedraaid op transformers 5.14.1 met accelerate 1.15.0.
Gebruikt u een versie ouder dan 5.0, schrijf dan `torch_dtype=` waar hier `dtype=` staat.

```python
from huggingface_hub import hf_hub_download
from transformers import AutoModelForCausalLM, AutoTokenizer

naam = "WAINUT/walnoot-8b-instruct"
tok = AutoTokenizer.from_pretrained(naam)
model = AutoModelForCausalLM.from_pretrained(naam, dtype="bfloat16", device_map="auto")

systeem = open(hf_hub_download(naam, "systeemprompt.txt"), encoding="utf-8").read()
berichten = [
    {"role": "system", "content": systeem},
    {"role": "user", "content": "Vat de volgende brief samen in drie zinnen: ..."},
]
invoer = tok.apply_chat_template(berichten, add_generation_prompt=True, return_tensors="pt", return_dict=True).to(model.device)
uit = model.generate(**invoer, do_sample=False, max_new_tokens=512)
print(tok.decode(uit[0][invoer["input_ids"].shape[-1]:], skip_special_tokens=True))
```

**`do_sample=False` is de neutrale stand.** Wilt u samplen, zet dan `do_sample=True` met
`temperature=0.7` en `top_p=0.9`.

### De twee gewichtsbestanden, bij naam

| bestand | bytes | sha256 |
|---|---|---|
| `model.safetensors` | 16.106.727.320 | `db131554ffb1fb9e0885855008b8ad4078077d4168e4c931e1024c2f9c586494` |
| `walnoot-8b-instruct-bf16.gguf` | 16.115.108.576 | `028306621d0013270d8b2bd3e1927dbf75166722792ff0fbb9a6dc055355a839` |

Het safetensors-bestand is voor transformers, het GGUF-bestand is de variant voor lokaal draaien.
Het meegeleverde `Modelfile` verwacht de naam van het GGUF-bestand precies zoals hij hier staat;
wie dat bestand hernoemt, moet ook het `Modelfile` aanpassen. Dezelfde waarden staan in
`MANIFEST-GEWICHTEN.md` naast deze kaart.

### LM Studio

1. Laad het GGUF-bestand in LM Studio.
2. Zet de systeemprompt op de inhoud van `systeemprompt.txt`.
3. Zet `temperature` op 0.0, `top_p` op 1.0, `top_k` op 0, `min_p` op 0.0 en `repeat_penalty` op 1.0.
4. Zet de contextlengte op 8192.
5. Controleer dat `<|assistant_end|>`, `<|user_start|>` en `<|system_start|>` bij de stoptokens
   staan.
6. Het template in het GGUF-bestand is byte-gelijk aan `chat_template.jinja` in deze repository;
   dat hebben wij gemeten en niet aangenomen. U hoeft het chat template dus niet te vervangen.

### Ollama

Zet het meegeleverde `Modelfile` in dezelfde map als het GGUF-bestand. Bouw en start het model
daarna zo.

```
ollama create walnoot-8b-instruct -f Modelfile
ollama run walnoot-8b-instruct
```

**LET OP. Dit kost anders een halve avond zoeken.** Het OpenAI-compatibele endpoint van Ollama
(`/v1/chat/completions`) negeert `top_k`, `min_p` en `repeat_penalty`. Het zet `temperature` en
`top_p` hard op 1,0 als de client ze niet meestuurt. Gebruik het eigen endpoint `/api/chat`, of
stuur `temperature` en `top_p` altijd expliciet mee.

---

## Herkomst van de trainingsdata

Dit model is op drie lagen data gebouwd: het corpus van de voortgezette pretraining, de
instructiedata en de nabewerkingsdata. Hieronder staat per laag waar die data vandaan komt en
onder welke voorwaarden zij is gebruikt.

**De voortgezette pretraining.** De mix is 70 procent Nederlands, 20 procent Engels en 10 procent
code. Alle drie komen uit het GPT-NL Public Corpus, dat het GPT-NL-consortium zelf onder CC BY 4.0
heeft vrijgegeven. Wij gebruikten er 28 subsets uit, op een gepinde revisie en met een lengte- en
taalfilter per document: 24 met Nederlandse tekst, drie met Engelse tekst (`cc_english-pd`,
`cc_loc-pd-books` en `cc_openalex`) en één met code (`cc_github_open_source`). Het Engels en de
code zitten er bewust in, als replay tegen kennisverlies. **Krantenarchieven zijn uitgesloten. De
grond is kwaliteit en geen recht.** Het gaat om historisch materiaal met een verouderde spelling
en veel OCR-ruis.
Naast het corpus zit in de doortraining een kleine eigen bron van WAINUT, ongeveer 2 procent van
de tekens. Die bestaat uit synthetische chatparen, gemaakt met hetzelfde teachermodel als de
instructiedata, om het model de opmaak van tekst te laten behouden.

**Op de gepinde revisie droegen twee van die 28 subsets in de metadata per document de
licentiewaarde "unknown".** De andere zesentwintig droegen een expliciete waarde; de twee zijn
archiefsubsets. Samen zijn dat 81.169 documenten en ongeveer 37 miljoen geschatte tokens. Dat is
0,43 procent van de geschatte tokens van het corpus en 2,58 procent van de documenten. De uitgever
van het corpus rekent beide subsets in zijn eigen collectiemetadata tot het publieke domein.
Op 22 september 2026 heeft WAINUT die collectiemetadata en de pagina's met de open data van
beide archieven nagelopen; beide archieven geven hun open data vrij onder CC0. Die verklaring
gaat over de open data van de archieven, dus over hun archieftoegangen; zij gaat niet met zoveel
woorden over de tekst van de documenten zelf. De waarde "unknown" stond op die revisie in de
statistiekbestanden per subset van de uitgever en is van daaruit in ons herkomstmanifest
overgenomen. **Op 7 september 2026 om 11:34 UTC heeft de uitgever beide subsets op public-domain
gezet**, met de commit "Set license of Noord-Hollands and Utrechts Archief to public-domain". De
voortgezette pretraining liep op de gepinde revisie, van voor die wijziging. **Beide delen
blijven in de trainingsdata**, want ons auteursrechtbeleid werkt op bronniveau en op dat niveau
staat het corpus als bron onder CC BY 4.0.

**De instructiedata.** Die is samengesteld en grotendeels synthetisch. De antwoorden zijn
gegenereerd met `swiss-ai/Apertus-70B-Instruct-2509` als teachermodel, op basis van 51 met de
hand geschreven seeds en van passages uit het corpus hierboven. Daarnaast bevat de mix een
wetenschappelijke tak uit bestaande, openbare annotatiedatasets. **Per externe bron is de
licentie herleid uit een primaire bron**, dus uit het licentiebestand of de datasetkaart van die
bron zelf. Naast die externe bronnen bevat de mix onze eigen identiteitslaag. Die is door een mens
geschreven en komt dus uit geen enkele externe bron.

Onze triage telt tien licentierijen; de tiende is die eigen identiteitslaag. Acht rijen komen uit
externe bronnen en staan alle acht commercieel gebruik toe. De negende, `Apache-2.0-clean`, is
geen licentie van een externe bron maar een afgeleid label van WAINUT voor het gegenereerde
materiaal van de mix. Records die op een letterlijke passage uit het corpus steunen, dragen dat
label ook; die passage valt onder CC BY 4.0, de licentie van het corpus. **Geen enkele bron in de
gebruikte mix staat onder een niet-commerciële licentie, onder share-alike, onder de GPL of onder
een onderzoeksbeperking.** De bronnen die naamsvermelding vragen, staan bij naam in het bestand
`NOTICE` naast deze kaart.

**De nabewerkingsdata.** De laatste stap is getraind op antwoorden die het model zelf had
gegenereerd en die een beoordelingsstap had goedgekeurd. Daar komt dus geen nieuwe externe bron
bij. De vragen komen uit dezelfde verzameling als hierboven en de antwoorden komen van het model
zelf. **De tegenleesrondes en de beoordelingsketen zijn hier naar rol beschreven**, dus als
tegenlezer, beoordelaar en panel.

**Er wordt geen trainingsdata gepubliceerd.** Wij publiceren de brondata niet. Wat openligt is de
herkomst per bron; die kunnen wij wel geven. Wie de keten wil narekenen, vindt de bronnen, de
licenties en de bewerkingen beschreven; de records zelf zitten er niet bij.

**Wat WAINUT vrijwillig publiceert.** Onder de Europese AI-verordening, Verordening (EU)
2024/1689, publiceert WAINUT vrijwillig drie stukken op <https://walnoot.ai/transparantie>, in
het Engels op <https://walnoot.ai/en/transparantie>: de publieke samenvatting van de
trainingsinhoud, het auteursrechtbeleid met het contactpunt voor rechthebbenden
(`support@walnoot.ai`) en de modeldocumentatie voor afnemers. Naar eigen meting is
WAINUT geen aanbieder van een AI-model voor algemene doeleinden in de zin van die verordening. Wij
publiceren de drie stukken toch, want openheid over de data is de inzet van dit project. De
praktijkcode voor AI-modellen voor algemene doeleinden heeft WAINUT niet getekend; wij volgen haar
wel als leidraad. **Deze stukken zijn nog niet door een juridisch adviseur beoordeeld.**

**Waar de keten staat.** De configuratie van de training, de ruwe meetlogs van EuroEval en het
herkomstmanifest per subset staan in de publieke repository
<https://github.com/WAINUTAI/walnoot-8b-instruct>, in de mappen `recept`, `evaluatie` en
`herkomst`.

**Decontaminatie.** Wij hebben op drie momenten en over verschillend materiaal gemeten of items
uit de testsets van EuroEval in de trainingsdata terecht zijn gekomen. De bouw van het corpus
waarop dit model is doorgetraind, is als geheel niet opnieuw tegen de testsets gemeten. De
referentie van de twee metingen in juli ligt vast in een manifest van 35 bestanden uit
EuroEval 17.6.0, samen 29.273 records, elk met een eigen checksum. Daarvan komen er 18.145 uit de
testsplit, 8.674 uit de trainsplit en 2.454 uit de validatiesplit. Er is dus tegen alle drie de
splits gemeten en niet alleen tegen de testsplit; dat is strenger dan nodig. De splitbestanden
zelf zijn niet bewaard; wat vastligt is het manifest.

**Er zijn drie metingen en zij gaan niet over hetzelfde materiaal.** De eerste pas, op 22 juli,
ging over een eerdere en kleinere bouw van het corpus van de voortgezette pretraining en over de
instructiedata van dat moment, samen 238.971 documenten. Zij raakte op dertien woorden achter
elkaar 16 van de 29.273 records, 0,0547 procent. Tegen een faaldrempel van nul is dat een
afgekeurde uitslag. De diepte-pas op zestien, twintig en vijfentwintig woorden hield daar **één
echte treffer** van over. Dat was het Onzevader, in testvraag 1941 van `wiki-lingua-nl`. Hoe wij
daarmee omgingen, lag vooraf vast en zat aan de scorekant, dus bij het scoren en niet bij de data.
Naast die pas liep een audit op acht woorden over datzelfde materiaal; die telt niet mee voor de
uitslag en raakte 1.409 van de 29.273 records, 4,81 procent.

**De tweede meting, op 30 juli, ging over de twee bronbestanden van onze eigen bron die in het
corpus van de voortgezette pretraining de opmaak van tekst moet behouden.** Op dertien woorden
komt zij voor beide bronnen uit op nul, per bron gemeten. De audit op acht woorden raakte daar
per bron 723 en 591 van de 29.273 records. **De pas van 22 juli is niet opnieuw gedraaid op de
bouw van het corpus waarop dit model is doorgetraind.**

**De derde meting, op 12 september, ging over de instructiedata en de nabewerkingsdata, de
bestanden waarop dit model werkelijk is getraind.** Zij liep na de training, tegen de tien
Nederlandse taken van EuroEval waarop dit model is gemeten. Dat zijn 28 splits met samen
42.925 items, elk een keer op de vraag en een keer op het gouden antwoord gemeten. De poort ligt
daar op twintig woorden. In de instructiedata raakten op dertien woorden **twee items** uit de
testsplit van `squad-nl`, aan de kant van de vraag. Het gedeelde stuk beslaat hoogstens
1,27 procent van zo'n item en is op zestien woorden weg, dus het is een vaste frase. Op twintig
woorden en meer raakte niets. In de nabewerkingsdata raakte op dertien woorden en meer niets. Het
oordeel is schoon. De audit op acht woorden raakte 659 items in de instructiedata en 33 in de
nabewerkingsdata. De samenvatting staat in `decontaminatie/getrainde-data-12-september.md` in de
publieke repository op GitHub.

**De controle van het corpus tegen onze eigen set voor het meten van kennisverlies is geslaagd met
een amendement.** Dat amendement staat in de naam van de uitslag, PASS_AMENDED_G2PRIME. Daarnaast
staat een uitslag die in diezelfde naamgeving G2-FAIL heet, dus gezakt op die poort. Die uitslag
halen wij er niet af. Zij gaat niet over de testsets. Naast de testsets houden wij een eigen set
apart om te meten of het model kennis verliest tijdens het doortrainen; op die set raakte dezelfde
meting 2.754 van de 6.244 records, 44,11 procent. Dat is een gezakte uitslag en die is niet
herroepen. Wij hebben die set daarna gesnoeid, onder een regel die is vastgelegd voordat de
uitslag van de diepte-pas op die set bekend was.

**Persoonsgegevens.** De trainingsdata is als geheel niet door een PII-filter gegaan. De modellen
tot en met deze uitgave zijn op data getraind die als geheel niet is gefilterd. Dat is een feit
over de bouw en geen voorbehoud bij de uitkomst.

Achteraf is de nabewerkingsdata van dit model met een gepinde detectorset doorgemeten. Die vond
daarin geen burgerservicenummers, geen creditcardnummers, geen geboortedata in context en geen
rekeningnummers die de rekenkundige controle doorstaan. Adressen, postcodes, kentekens,
telefoonnummers en e-mailadressen komen wel voor. Op deze data zelf is daarvan alleen gemeten dat
geen enkel e-mailadres een persoonlijk ogend deel voor de @ combineert met een bestaand domein.
Het oordeel dat de andere soorten overwegend synthetisch zijn of naar een gereserveerd domein
wijzen, rust op een handmatige controle van vergelijkbare data uit een eerdere ronde en niet op
een handmatige controle van deze data.

Twee delen van de data werken per ontwerp met persoonsgegevens, omdat zij het model leren die te
markeren of eruit te halen. Dat hun waarden uit gereserveerde reeksen komen, is een aanwijzing en
geen toets. De rekenkundige controle op rekeningnummers slaat in beide delen nul keer aan, terwijl
er wel waarden in staan die op rekeningnummers lijken. Een handmatige controle van juist deze
twee delen is niet gedaan.

Materiaal uit openbare rechtspraak hebben wij niet zelf bewerkt, omdat de bron de herleidbare
gegevens er zelf al uit haalt. Persoonsnamen in een professionele context zijn behouden. De
gevoelige deelverzameling is niet bewerkt maar afgekeurd en verwijderd.

Van een deel van de nabewerkingsdata is de herkomst niet positief vast te stellen. Dat deel telt
in deze verantwoording als niet-synthetisch, dus aan de strenge kant.

WAINUT beroept zich voor de verwerking op gerechtvaardigd belang onder artikel 6 lid 1 sub f AVG. De
belangenafweging daarvoor is intern vastgelegd volgens de cumulatieve driestappentoets uit EDPB
Opinion 28/2024. De openbaarheid van een bron is daarbij een factor in de belangenafweging en geen
zelfstandige grond.

**Hoeveel de detectie mist, is alleen in een steekproef gemeten.** In 300 records uit onze eigen
databestanden, waarvan 90 uit de instructiedata van dit model, vond dezelfde detectorset geen van
de negen echte gevallen van persoonsgegevens. Op de nabewerkingsdata zelf en per soort is het niet
gemeten. Wie dit model in een omgeving met persoonsgegevens inzet, blijft zelf
verwerkingsverantwoordelijke en kan zich niet op deze meting beroepen.

**Er staat in deze kaart geen record-, prompt- of documenttekst**. Die komt er ook niet in.

**De licentie van het basismodel is de gewone Apache License 2.0**, zonder aanhangsel en zonder
extra voorwaarde. Daarnaast hanteert de uitgever van het basismodel een afzonderlijke
gebruiksvoorwaarde, de *Apertus LLM Acceptable Use Policy*, versie 1.0 van 1 september 2025. Die
staat in de repository van het basismodel als `USAGE_POLICY.md`. Zij regelt onder meer dat wie
het model gebruikt ETH Zurich en EPFL vrijwaart tegen claims van derden die uit dat gebruik
voortkomen, dat de gebruiker zelfstandig verwerkingsverantwoordelijke is voor persoonsgegevens en
dat de uitgever toezegt periodiek een bestand met hashwaarden beschikbaar te stellen dat u als
outputfilter kunt toepassen, met het dringende advies dat elk half jaar te halen en toe te
passen. **Die voorwaarde kan wijzigen zonder dat de licentie wijzigt.**

**Over dat outputfilter.** De gebruiksvoorwaarde adviseert een bestand met hashwaarden als
outputfilter toe te passen. **De uitgever schrijft op de kaart van het basismodel zelf dat er op
dit moment geen outputfilter wordt aangeboden.** Er staat woordelijk
"Currently no output filter is provided." Onze eigen zoekactie onder de organisatie van de
uitgever leverde dat bestand ook niet op. Wij vragen er bij de uitgever naar. Zodra het er is,
past u het toe op de output van dit model.

---

## Vermelding van de rekenfaciliteit

De instructietraining, de nabewerking en de metingen zijn uitgevoerd op een Europese
rekenfaciliteit. De verplichte vermelding luidt woordelijk als volgt.

> "We acknowledge EuroHPC JU for awarding the project ID EHPC-AIF-2026PG01-984 access to
> MareNostrum5 ACC hosted by BSC, Spain"

---

## Contact

WAINUT is te bereiken op **`support@walnoot.ai`**. Gebruik dat adres voor vragen over dit model,
over de herkomst van de trainingsdata of over gebruik in een werkproces.

Hetzelfde adres geldt in drie bijzondere gevallen: **als u rechthebbende bent** en iets wilt
melden over materiaal in de trainingsdata, **als uw melding over persoonsgegevens gaat** of **als
u een fout in deze kaart vindt**. Schrijf dan naar `support@walnoot.ai`.

**Eén uitzondering geldt voor materiaal dat uit het basismodel komt.** Gaat uw verwijderverzoek of
uw melding over persoonsgegevens of over auteursrechtelijk beschermd materiaal dat uit het
basismodel afkomstig is, dan is de uitgever van het basismodel het loket. Diens modelkaart noemt
daarvoor twee eigen adressen: `llm-privacy-requests@swiss-ai.org` en
`llm-copyright-requests@swiss-ai.org`. Voor onze eigen laag blijft `support@walnoot.ai` het
adres.

## Licentie

Dit model staat onder de **Apache License 2.0**. De volledige tekst staat in deze repository als
`LICENSE`. De bronnen die naamsvermelding vragen, staan bij naam in `NOTICE`. De bytes en de
sha256 van de twee gewichtsbestanden staan in `MANIFEST-GEWICHTEN.md`, zodat u kunt narekenen
dat u precies dit model heeft.

**Gebruik dat inbreuk maakt op auteursrecht of op andere rechten van derden is niet toegestaan.**
Het auteursrechtbeleid op <https://walnoot.ai/transparantie> beschrijft hoe rechthebbenden WAINUT
bereiken.

## Citeren / Citation

Wilt u dit model in onderzoek vermelden, citeer dan dit model. Gebruikt u het in werk dat
voortbouwt op het corpus of op het basismodel, citeer die dan ook, want de datasetkaart van het
corpus vraagt daar uitdrukkelijk om.

```bibtex
@misc{wainut2026walnoot8binstruct,
  title        = {{Walnoot 8B Instruct}},
  author       = {{WAINUT}},
  year         = {2026},
  month        = sep,
  howpublished = {Hugging Face model repository},
  url          = {https://huggingface.co/WAINUT/walnoot-8b-instruct},
  note         = {Version 1.0. Dutch continued pretraining and instruction tuning by WAINUT
                  on top of swiss-ai/Apertus-8B-2509. Licensed under Apache-2.0.}
}
```

Het corpus van de voortgezette pretraining citeert u zo.

```bibtex
@inproceedings{van-oort-etal-2026-gpt,
  title     = "{GPT}-{NL} Public Corpus: A Permissively Licensed, {D}utch-First Dataset for {LLM} Pre-training",
  author    = "Van Oort, Jesse J. and Brinkkemper, Frank and de Graaf, Erik and Vanroy, Bram and Lensink, Saskia",
  booktitle = "Proceedings of the Fifteenth Language Resources and Evaluation Conference",
  month     = may,
  year      = "2026",
  address   = "Palma de Mallorca, Spain",
  publisher = "ELRA Language Resource Association",
  url       = "https://aclanthology.org/2026.lrec-1.548/",
  doi       = "10.63317/5fbtc336wwx2",
  pages     = "6893--6903"
}
```

Het basismodel citeert u zo.

```bibtex
@misc{swissai2025apertus,
  title        = {{Apertus: Democratizing Open and Compliant LLMs for Global Language Environments}},
  author       = {Hernández-Cano, Alejandro and others},
  year         = {2025},
  howpublished = {\url{https://arxiv.org/abs/2509.14233}}
}
```

De volledige auteurslijst staat in de kaart van het basismodel.

Het `NOTICE` naast deze kaart noemt onder BASISMODEL een andere naam, namelijk die uit de
copyrightregel in het `LICENSE.txt` van de uitgever. Die regel staat op naam van The Swiss AI
team. Dat is de rechthebbende; het blok hierboven volgt de auteurslijst die de uitgever zelf bij
dit stuk publiceert, ingekort tot de eerste auteur volgens de gebruikelijke citeervorm.
