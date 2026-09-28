# De generatie-setup van de instructiedata

Dit stuk beschrijft de generatie-setup zoals die bij een proefronde op 18 en 19 juli 2026 is
vastgelegd: het teachermodel, de sampling, de nalevingsregel, het grounding-corpus met zijn
subsets en filterdrempels plus het herkomstveld per record. Interne werknamen zijn vervangen door
gewone woorden. Die proefronde kende twee mixen. De mix waarvan de categorieen hieronder staan,
heet de generieke mix. Een eigen meting in het metabestand naast de uitgegeven instructiemix van
51.875 records wees uit dat het teachermodel hetzelfde is. Bij 47.488 records staat het als
generator genoemd. Uit deze proefronde komt ook de vaste identiteitsset terug, 125 dialogen die
door een mens zijn geschreven. In de proefronde stond elke dialoog er vijf keer in, samen 625
paren (zie onder). In de uitgegeven mix staat elke dialoog er twee keer in, samen 250 records.
Verder bevat geen enkel record een datum uit juli 2026, een samplinginstelling of het
herkomstveld dat hieronder staat.

`../MODELKAART.md` noemt bij de instructiedata van het uitgegeven model ook een wetenschappelijke
tak uit bestaande, openbare annotatiedatasets. Die tak komt in de categorieen van deze proefronde
niet voor.

## Teachermodel (generator)
- Model: swiss-ai/Apertus-70B-Instruct-2509 (Apache 2.0), tensor_parallel_size=8, max_model_len=8192.
- Sampling: temperature 0.8, top_p 0.9, max_tokens 1024, seed 1234 (Apertus-aanbeveling).
- Script: het generatiescript, in een Python-omgeving met vllm==0.24.0 (+ ninja).
- Naleving in deze proefronde: de generator was uitsluitend Apertus. Geen enkele prompt ging van de
  compute node naar een externe API.

## Grounding-corpus (bron voor de categorieen met grounding)
- Repo: GPT-NL/GPT-NL_Public_Corpus (CC-BY 4.0).
- Revisie: **1e17d21afa6518939523fbdcc1fbb3167b671725** (lastModified 2026-05-04T12:42:07Z).
  Dit is dezelfde revisie als de gepinde corpusrevisie van de doortraining.
- Subsets (tier 1, modern Nederlands, gekozen om weg te blijven van het oudere Nederlands van
  kb-open-kranten): rechtspraak, officiele-bekendmakingen, tweedekamer, european-parliament, pbl,
  dansknaw, multi-eurlex, wikidata. **kb-open-kranten is uitdrukkelijk uitgesloten** (verouderd
  Nederlands en OCR-ruis).
- Lengte- en taalfilters: corpus-min-chars 400, corpus-max-chars 6000, corpus-min-lang-score 0.80.
- Beperking voor de reproduceerbaarheid: het generatiescript las het corpus met
  load_dataset(..., streaming=True) zonder expliciete `revision=`-pin. Op het moment van lezen was
  de HEAD van het corpus 1e17d21 (hierboven vastgelegd). De gelezen revisie volgt dus uit het
  tijdstip, maar het script legde die niet zelf vast. Wie deze grounding wil reproduceren, moet die
  revisie zelf pinnen met `revision="1e17d21afa6518939523fbdcc1fbb3167b671725"`. De HEAD is na
  2026-05-04 twee keer verschoven. Op 2026-08-24 wijzigde alleen de README en op 2026-09-07 de
  licentiewaarde van de archiefsubsets noordhollandsarchief en utrechts-archief. De acht subsets
  hierboven zijn op 1e17d21 en op de HEAD van 2026-09-27 byte-gelijk. Deze beperking gaat over de
  grounding van deze proefronde. De doortraining staat daar los van. Die liep op een gepinde
  corpusrevisie, zoals `../MODELKAART.md` beschrijft.

## Self-Instruct (categorieen zonder grounding)
- Seed-prompts: 51 met de hand geschreven startopdrachten (seed_prompts_nl.jsonl).

## Categorieen (basis van de generieke mix, met een doel van 55.000 te genereren paren)
- instructie-opvolging, samenvatten, tekstvereenvoudiging, overheids-juridische-qa,
  redeneren-rekenen, herschrijven, veiligheid-weigering, mc.
- Uitgesloten: de twee automatisch gegenereerde identiteitscategorieen. Die zijn vervangen door
  een vaste identiteitsset van 125x5=625 paren, gelijk in beide mixen. Dat is op 18 juli 2026
  besloten.

## Herkomst per record in de proefopstelling
- Elk record van die proefronde had een `meta`-veld met de generator, de seedbron, het tijdstip
  en de samplinginstellingen.

## De weg van het uitgegeven model

Hierboven staat hoe de data van die proefronde is gemaakt en niet welke weg het uitgegeven model
heeft afgelegd. Die weg staat in `../recept/`: de doortraining in
`01-doortraining/doortraining-hoofdfase.yaml` met `doortraining-afbouw.yaml`, de instructietraining
in `02-sft/instructietraining-mix.yaml` en de nabewerking in `03-nabewerking/nabewerking.yaml`, elk
met eigen pins en poorten (gates). De twee bestanden van de doortraining volgen op een aantal
punten, zoals het aantal stappen, een later plan; welke waarden voor dit model echt zijn gedraaid,
staat in `../recept/README.md`.
`../MODELKAART.md` beschrijft die weg in gewone taal en noemt daarbij de samenstelling van de
instructiedata, de licentietriage per bron en de meting per taak.
