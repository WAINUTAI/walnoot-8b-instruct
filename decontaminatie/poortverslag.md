# Fase-C decontaminatie-poort

> **Leeswijzer.** Dit is het poortverslag van de eerste pas van 22 juli 2026. Het meetgereedschap
> heeft het zo geschreven. De pas ging over een eerdere en kleinere bouw van het corpus met de
> instructiedata van dat moment en niet over de bouw waarop dit model is doorgetraind. Fase C is
> de interne naam van die stap in de bouw. Het oordeel FAIL is de uitslag op dertien woorden tegen
> een faaldrempel van nul. De diepte-pas op 16, 20 en 25 woorden liet één echte treffer over,
> testvraag 1941 van `wiki-lingua-nl` (in de tabel `real_leak`). De andere vijftien zijn vaste
> frases (`fixed_phrase_false_positive`). Hoe met die ene treffer is omgegaan, lag vooraf vast en
> lag aan de scorekant, dus bij het scoren en niet bij de data; zie `../MODELKAART.md`. De audit op
> acht woorden onderaan telt niet mee voor de uitslag. Voor publicatie is het begin van de paden
> vervangen door `<bouwomgeving>`, de map op de machine waarop het corpus is gebouwd. Verder staan
> de overlappende fragmenten er niet in en is de korte werkaanwijzing achter de heuristiek
> uitgeschreven als beschrijving van wat het gereedschap toen voorschreef.

*Gegenereerd:* 2026-07-22 20:12:00 UTC

## VERDICT: **FAIL**

- Eval-map: `<bouwomgeving>/data/qg_eval_clean` (35 datasets, 29,273 records)
- 13-gram (primair): drempel-OVERSCHREDEN, besmet=16, zwaarst=`valeu-nl.test` (7.5472%)
- Diepte-pass (ladder [13, 16, 20, 25], deep 20-gram): 16 treffers -> 1 echt lek, 15 vaste-frase-vals-positief

> Heuristiek: een 13-gram-treffer die op deep_level (20-gram) naar 0 gaat, is een vaste-frase-vals-positief; overleeft hij, dan is het een echt lek. Bij een echt lek schreef het gereedschap toen voor het shardbestand met de treffer uit de bouw te halen en de meting te herhalen.

## Per-hit-verantwoording

| Dataset | Eval-record | Classificatie | Overleeft deep | 13-gram | Train-bestand |
|---|---|---|---|---|---|
| hellaswag-nl.train | 538 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 70 tekens] | `walnoot_sft.jsonl` |
| mmlu-nl.train | 82 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 59 tekens] | `shard-00001.jsonl` |
| mmlu-nl.train | 901 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 73 tekens] | `shard-00004.jsonl` |
| onofficieel-dutch-cola.test | 799 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 71 tekens] | `shard-00000.jsonl` |
| onofficieel-dutch-proverbs.test | 15 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 60 tekens] | `shard-00003.jsonl` |
| squad-nl.test | 924 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 79 tekens] | `shard-00000.jsonl` |
| squad-nl.test | 975 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 79 tekens] | `shard-00000.jsonl` |
| squad-nl.test | 987 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 54 tekens] | `shard-00004.jsonl` |
| squad-nl.val | 249 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 73 tekens] | `shard-00001.jsonl` |
| valeu-nl.test | 5 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 25 tekens] | `shard-00004.jsonl` |
| valeu-nl.test | 8 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 25 tekens] | `shard-00004.jsonl` |
| valeu-nl.test | 37 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 25 tekens] | `shard-00004.jsonl` |
| valeu-nl.test | 44 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 25 tekens] | `shard-00004.jsonl` |
| wiki-lingua-nl.test | 181 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 80 tekens] | `shard-00000.jsonl` |
| wiki-lingua-nl.test | 1941 | real_leak | ja | [fragment weggelaten: 13 woorden, 71 tekens] | `shard-00000.jsonl` |
| wiki-lingua-nl.val | 13 | fixed_phrase_false_positive | nee | [fragment weggelaten: 13 woorden, 59 tekens] | `walnoot_sft.jsonl` |

## 8-gram audit (informational, GEEN pass/fail)

- besmet=1409 / 29273 (4.8133%). audit-referentie (Apertus-vergelijkbaarheid); NOOIT de pass/fail-poort - 8-gram overspoelt met vals-positieven.

