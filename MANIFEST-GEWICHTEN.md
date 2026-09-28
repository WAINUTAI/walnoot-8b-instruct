# Manifest van de gewichten

> De gewichten en de modelbestanden `systeemprompt.txt`, `config.json`, `tokenizer.json`,
> `tokenizer_config.json`, `generation_config.json`, `chat_template.jinja` en `Modelfile` staan op
> <https://huggingface.co/WAINUT/walnoot-8b-instruct> en niet in deze GitHub-repository. Waar het
> manifest hieronder "deze repository" zegt, is de repository op Hugging Face bedoeld. Waar dit
> manifest `README.md` noemt, gaat het om de modelkaart; in deze GitHub-repository is dat
> `MODELKAART.md`.
>
> Onder deze toelichting staat het manifest zoals het bij de gewichten op Hugging Face staat.

**De gewichten staan in deze repository zelf.** Dit manifest staat ernaast. Het noemt uit welke
bestanden de gewichten bestaan, hoe groot die zijn en welke sha256 ze hebben, zodat u kunt
narekenen dat u precies dit model heeft.

## Het bestand voor transformers

| gegeven | waarde |
|---|---|
| bestand | `model.safetensors` |
| bytes | 16.106.727.320 |
| sha256 | `db131554ffb1fb9e0885855008b8ad4078077d4168e4c931e1024c2f9c586494` |

**Dit is het bestand waarop de release rust.** De sha is gemeten over dat bestand en niet over
een map, een archief of een samenvatting van een map. De opgeslagen kopie waarop deze release
rust en het laatste checkpoint van de training hebben dezelfde sha. Dat is met twee metingen
vastgesteld en niet aangenomen.

## De variant voor lokaal draaien

| gegeven | waarde |
|---|---|
| bestand | `walnoot-8b-instruct-bf16.gguf` (GGUF, bf16) |
| bytes | 16.115.108.576 |
| sha256 | `028306621d0013270d8b2bd3e1927dbf75166722792ff0fbb9a6dc055355a839` |

Het meegeleverde `Modelfile` en de LM Studio-aanwijzingen in `README.md` gaan over deze variant.
Het `Modelfile` verwacht de bestandsnaam precies zoals die hier staat; wie het bestand hernoemt,
moet ook het `Modelfile` aanpassen. **De header van dit bestand is op 22 september 2026
opgeschoond.** De modelnaam, de herkomstvelden en het chat template zijn opnieuw gezet. De
tensorbytes zijn gelijk aan die van het bestand van voor het opschonen; dat is per tensor gemeten,
over alle 324 tensors.

## De modelbestanden

Vijf modelbestanden komen uit het laatste checkpoint van de training en staan in deze
repository:

| bestand | wat het is |
|---|---|
| `config.json` | de architectuur van het model |
| `generation_config.json` | de instellingen voor het genereren |
| `tokenizer.json` | de tokenizer |
| `tokenizer_config.json` | de configuratie van de tokenizer |
| `chat_template.jinja` | het chat template |

**`special_tokens_map.json` ontbreekt. Dat is geen verzuim.** Het bestand zit niet in het laatste
checkpoint van de training. **Wij leiden het niet af**, want dan zou er een bestand ontstaan dat
de training nooit heeft opgeleverd. De special tokens volgen uit `tokenizer_config.json`, waarin
`bos_token`, `eos_token`, `pad_token` en `unk_token` bij naam staan.

**`training_args.bin` zit er bewust niet bij.** Dat bestand hoort bij het trainen en niet bij het
gebruiken; het bevat sporen van onze eigen opzet.

## Vijf keuzes in deze release, uitdrukkelijk benoemd

**Op deze vijf punten wijken de bestanden af van wat er letterlijk in het laatste checkpoint van
de training stond. De originelen zijn bewaard.**

1. **In `config.json` staat `use_cache` op `true`.** In het laatste checkpoint van de training
   stond `false`, want bij het trainen wordt de KV-cache uitgezet. **Bij het genereren hoort de
   sleutel op `true`.** Anders rekent het model bij elk nieuw token de hele voorafgaande reeks
   opnieuw door. Dat wordt trager naarmate het gesprek langer duurt. De antwoorden veranderen er
   niet door. **Op die sleutel na is het bestand gelijk aan de versie uit het laatste checkpoint
   van de training.** Het aantal sleutels is zesentwintig tegen zesentwintig, het aantal regels
   achtendertig tegen achtendertig. De grootte is 900 bytes tegen 901, omdat `true` een teken
   korter is.
2. **In `tokenizer_config.json` staat `model_max_length` op 32768.** In het laatste checkpoint van
   de training stond daar de standaardwaarde van de bibliotheek; die betekent "niet gezet". 32768
   is de limiet die wij bewust hebben ingesteld. De EuroEval-runs registreerden 65536; onze eigen
   meting op praktijkopdrachten draaide op 32768. **Het is niet de bovengrens van de
   architectuur**, want in `config.json` staat `max_position_embeddings` op 65536. **32768 is dus
   een bewuste behoudende keuze** en geen grens van het model. `README.md` noemt dezelfde drie
   getallen.
3. **Uit `tokenizer_config.json` zijn twee sleutels verwijderd**, `is_local` en `local_files_only`.
   Beide zijn een spoor van trainen vanaf een lokaal pad. De tweede kan tooling ervan weerhouden
   iets van de hub te halen, in een repository die juist van de hub wordt gehaald.
4. **In `generation_config.json` staat `do_sample` op false** en er staan geen samplingwaarden in.
   Alles in `README.md` is op temperature 0 gemeten; wie niets instelt, hoort hetzelfde gedrag te
   krijgen. Zelf samplen kan gewoon.

5. **Het chat template `chat_template.jinja` had achttien regels intern commentaar.** Die
   zijn vervangen door acht neutrale regels. **De renderende regels zijn ongewijzigd**,
   vierenveertig tegen vierenveertig; dat hebben wij gemeten en niet aangenomen. Het gedrag van
   het template is dus gelijk gebleven. Die telling vergelijkt dit bestand met het template uit
   het laatste checkpoint van de training, over de regels die niet leeg zijn en geen commentaar
   zijn; de lege slotregel telt niet mee. `README.md` meldt dat het template in het
   GGUF-bestand byte-gelijk is aan dit template.

## Waar de bestanden staan

1. **Deze repository op Hugging Face.** Daar haalt u de gewichten op. De waarden hierboven gelden
   voor de bestanden daar.
2. **De object storage van WAINUT**, als back-up.

WAINUT heeft maar tijdelijk toegang tot de rekenomgeving waarop de instructietraining, de
nabewerking en de metingen zijn uitgevoerd. Die omgeving telt daarom niet als plek waar de bestanden
blijven staan.

## Hoe u dit narekent

Haal `model.safetensors` op en draai daarna dit commando.

```
sha256sum model.safetensors
```

Vergelijk de uitkomst **op alle vierenzestig tekens** met de waarde hierboven. Een sha die op de
eerste acht tekens klopt, zegt niets.
