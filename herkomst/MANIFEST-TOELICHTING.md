# Leesinstructie bij provenance-manifest.json

`provenance-manifest.json` legt vast waar de data van de doortraining vandaan komt: per subset
de bucket, het aantal documenten, het aantal tekens, de geschatte tokens, de licenties, de naam
en het adres van de bron. **Het bestand is byte-gelijk aan het manifest dat de bouw van het corpus
op 31 juli 2026 heeft weggeschreven.** Wij hebben er niets in veranderd, ook niet waar een waarde
niet klopt of niet vanzelf spreekt. De uitleg daarvan staat hieronder. Paragraaf 1 en 2 gaan over
de twee punten die het meest uitmaken, met de getallen erbij. Paragraaf 3 legt de overige velden
uit.

**Eerst wat het manifest telt.** Het manifest telt het corpus zoals het voor de doortraining is
gebouwd en niet wat het model daarvan heeft gezien. Het budget van die bouw was 8 miljard tokens,
het veld `token_budget`. De doortraining is ook zo ver doorgelopen, tot stap 7.632 van elk
1.048.576 tokens, ongeveer 8,0 miljard tokens. De beste uitkomst lag bij ongeveer 4 miljard. Dit
model rust daarom op het bewaarpunt (checkpoint) bij stap 3.816, gevolgd door een cooldown van 64
stappen, samen ongeveer 4,07 miljard tokens. Welke stappen voor dit model echt zijn gedraaid,
staat in `../recept/README.md`.

## 1. De optelling van de subsets sluit niet aan op de totalen

Het manifest bevat 28 subsets. De som over hun veld `docs` is 3.142.638 documenten, door ons
nagerekend uit dit bestand. De totalen bovenin hetzelfde bestand staan op `train_docs` 3.448.292
plus `val_docs` 5.451, samen 3.453.743 documenten. Het verschil is 311.105 documenten.

Dat verschil is geen gat in de boekhouding. Het is een eigen bron van WAINUT, bedoeld om het model
de opmaak van tekst te laten behouden. Het zijn synthetische chatparen, gemaakt met hetzelfde
teachermodel als de instructiedata. Die bron staat per definitie niet in het `subsets`-blok, want
dat blok telt uitsluitend de gelezen bronsubsets, terwijl de totalen bovenin alles tellen wat bij
de bouw is weggeschreven. De interne correctienota van 31 juli 2026 meet die bron op 311.105
records met 585.781.778 tekens. Daarmee sluit de optelling zonder rest, want 3.142.638 plus
311.105 is 3.453.743. Die correctienota is een intern stuk dat niet in deze repository staat; ze
is op verzoek beschikbaar via support@walnoot.ai. Voor de tekens sluit de optelling op dezelfde
manier, maar alleen als de validatieset wordt meegeteld. De som over de 28 subsets is
28.703.274.866 tekens, eveneens door ons nagerekend uit dit bestand. Met de 585.781.778 tekens van
de eigen bron erbij komt dat op 29.289.056.644. Het manifest bevat bovenin alleen `train_chars`
29.240.230.710 en geen veld voor de tekens van de validatieset, dus die laatste som is niet uit dit bestand
alleen na te rekenen.

**Waarom 311.105 records.** De eigen bron bestaat uit twee bronbestanden met 41.406 en 31.290
records, samen 72.696. Dat zijn de twee bestanden die in `../decontaminatie/13-gram-bron1.md` en
`13-gram-bron2.md` zijn gemeten. Om op het vooraf ingestelde aandeel van 2 procent van de tekens
te komen, is dat materiaal bij de bouw herhaald. Gemeten in tekens is het ongeveer 4,36 keer
opgenomen, in vier volledige doorgangen en een deel van een vijfde. Zo komt de bron in het corpus
op 311.105 records. Deze getallen komen uit het bouwrapport van 31 juli 2026, dat net als de
correctienota intern is.

Gemeten in tekens is die eigen bron 2,0 procent van het corpus; gemeten in documenten is ze
9,0 procent. Beide percentages zijn door ons nagerekend uit dit bestand. Dezelfde correctienota
noemt 0,02 als de vooraf ingestelde doelfractie en meldt die bron als volledig geteld, gehasht en
op overlap met de testsets gecontroleerd; dit bestand heeft daar geen veld voor.

## 2. Een subsetlabel komt uit de bron en klopt niet

De subset `cc_openalex` heeft `dataset_name: "CC-German-PD"`, terwijl het om
OpenAlex-materiaal gaat. Diezelfde correctienota van 31 juli 2026 telde de volledige leescache
van die subset. Daarin hebben 588.860 van de 588.860 rijen het veld `source` met de waarde
`OpenAlex`, dus 100 procent. Dat getal is het regeltal van die leescache. Het is dus niet het
aantal documenten dat dit manifest voor de subset boekt (`docs` 9.585) en ook niet het aantal
gelezen rijen dat het zelf telt (`reads_per_subset` 391.057). Het label is metadata die de bron
zelf meelevert en die ongewijzigd is doorgegeven. Het is dus geen fout in de data zelf. Lees bij
deze subset het veld `source` en niet `dataset_name`.

## 3. De overige velden

**`gegenereerd` en `modus`.** Het moment waarop de bouw dit manifest schreef en de soort bouw.
`volledig` is de volledige bouw en geen proefbouw.

**`repo_id`.** Alle 28 subsets komen uit het GPT-NL Public Corpus op Hugging Face. De revisie
staat niet in dit bestand. De bouw las het corpus gepind op revisie
`1e17d21afa6518939523fbdcc1fbb3167b671725`; zie `verantwoording-instructiedata.md`.

**`mix_fracties`.** Het beoogde aandeel van de drie buckets in het tokenbudget: 70 procent
Nederlands, 20 procent Engels en 10 procent code. De lange staart van decimalen is afrondingsruis
van de berekening.

**`out_dir` en `totaal_shards`.** `out_dir` is de map op de bouwomgeving waarin de bouw het corpus
en dit manifest wegschreef. Het corpus staat daar in 116 bestanden. Volgens paragraaf 4 van
`../decontaminatie/beslisregel.md` bevatten 115 daarvan de 3.448.292 documenten van `train_docs`
en was het laatste bestand bedoeld als validatieset.

**`tier`.** Een kwaliteitsindeling uit de bouw. Tier 1 zijn de acht subsets met gecureerd, modern
Nederlands: `dansknaw`, `european-parliament`, `multi-eurlex`, `officiele-bekendmakingen`, `pbl`,
`rechtspraak`, `tweedekamer` en `wikidata`. De andere twintig subsets staan op tier 2. In deze
bouw wogen alle tiers even zwaar, dus het veld heeft de samenstelling van het corpus niet
veranderd.

**`geschatte_tokens`.** Het aantal tekens gedeeld door een vaste verhouding van tekens per token
per bucket: 3,166 voor Nederlands, 3,761 voor Engels en 3,599 voor code. Het is dus een schatting
en geen telling met de tokenizer. Dat die deling klopt, hebben wij voor alle 28 subsets
nagerekend uit dit bestand.

**`reads_per_subset`.** Per subset het aantal rijen dat de bouw uit de bron heeft gelezen, geteld
voordat filters, ontdubbeling en de plafonds per subset hun werk deden. Daarom is dat getal bij
elke subset groter dan `docs`.

**`licenties`.** De licentiewaarden staan zoals de bron ze meelevert. Daardoor staan
schrijfwijzen als `public-domain`, `Public domain` en `Public Domain` naast elkaar. Bij
`noordhollandsarchief` en `utrechts-archief` staat `unknown`, samen 81.169 documenten. Dat is de
waarde op de revisie waarop de bouw las. Op 7 september 2026 zette de uitgever van het corpus
beide op public-domain; het manifest houdt de waarde van de gelezen revisie. Wat wij over die twee
subsets weten, staat in `../MODELKAART.md`.

**`dataset_name` en `dataset_url`.** De naam en het adres komen uit de metadata van de bron. Bij
`kb` staat als adres `to_be.determined`. Dat is de placeholder die de bron voor die subset
meelevert en geen werkend adres; wij hebben er geen adres voor in de plaats gezet. Bij
`noordhollandsarchief` is het adres leeg.
