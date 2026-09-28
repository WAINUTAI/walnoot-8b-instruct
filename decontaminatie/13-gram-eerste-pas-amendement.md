# Decontaminatie-controle: Walnoot trainingsdata vs. EuroEval-testsplits

> **Leeswijzer.** Dit is het verslag van de eerste pas van 22 juli 2026 op dertien woorden. Het
> meetgereedschap heeft het zo geschreven. De pas ging over een eerdere en kleinere bouw van het
> corpus van de voortgezette pretraining met de instructiedata van dat moment, in vijf
> corpusbestanden en een bestand met instructiedata, samen 238.971 documenten. Zij raakte 16 van
> de 29.273 records en is tegen de faaldrempel van nul afgekeurd. De diepte-pas liet daar één
> echte treffer van over, testvraag 1941 van `wiki-lingua-nl`; zie `poortverslag.md`. Hoe daarmee
> is omgegaan, lag vooraf vast en lag aan de scorekant, dus bij het scoren en niet bij de data.
> Die omgang is het amendement in de naam van dit bestand. Het oordeel PASS_AMENDED_G2PRIME hoort
> niet bij deze pas maar bij de controle van een eigen set; zie `beslisregel.md`. **Deze pas is
> niet opnieuw gedraaid op de bouw van het corpus waarop dit model is doorgetraind.** De referentie
> telt 35 bestanden uit EuroEval 17.6.0 met test-, train- en validatiesplits. Waar de titel van
> testsplits spreekt, gaat het dus om alle drie de splits. Voor publicatie is het begin van de
> paden vervangen door `<bouwomgeving>`. Dat staat voor de map op de machine waarop het corpus is
> gebouwd. Verder zijn interne mapnamen in die paden vervangen door gewone woorden, staan de
> overlappende fragmenten er niet in en is de interpunctie van de titel aangepast. Waar deze pas in
> het geheel staat, legt `../README.md` uit.

*Gegenereerd:* 2026-07-22 19:35 UTC  
*Tool:* decontamination_check.py v1.0.0

## Methode (voor de publicatie)

- **N-gram:** 13 woorden (schuifvenster).
- **Normalisatie:** NFKC + lowercase + interpunctie->spatie + witruimte-collapse + splitsen op spaties (woord-tokens).
- **Fingerprint:** md5, eerste 8 bytes little-endian -> 64-bit int (deterministisch).
- **Steekproefcaps:** max_train_records = geen; max_eval_records_per_dataset = geen.
- **Faaldrempel:** een dataset boven 0.0000% besmette records laat de tool falen (exit 1); de gate toetst per dataset (de zwaarst besmette), niet het totaalgemiddelde.
- **Train-globs:** `<bouwomgeving>/data/corpus/doortraining/shard-*.jsonl`, `<bouwomgeving>/data/instructiedata/output/walnoot_sft.jsonl`
- **Eval-map:** `<bouwomgeving>/data/qg_eval_clean`

## Verwerkt

- Train: 6 bestand(en), 238,971 documenten, 189,435,284 n-grams gestreamd (0 zonder text/messages overgeslagen).
- Eval: 35 dataset(s), 29,273 records, 2,980,615 unieke n-gram-fingerprints geïndexeerd.

## Overlap per eval-dataset

| Dataset | Records | Te kort (<n) | Besmet | Fractie |
|---|---|---|---|---|
| conll-nl.test | 1024 | 601 | 0 | 0.0000% |
| conll-nl.train | 1024 | 592 | 0 | 0.0000% |
| conll-nl.val | 256 | 147 | 0 | 0.0000% |
| dbrd.test | 2048 | 13 | 0 | 0.0000% |
| dbrd.train | 1024 | 4 | 0 | 0.0000% |
| dbrd.val | 256 | 3 | 0 | 0.0000% |
| duidelijke-taal.test | 90 | 9 | 0 | 0.0000% |
| duidelijke-taal.train | 50 | 4 | 0 | 0.0000% |
| duidelijke-taal.val | 51 | 1 | 0 | 0.0000% |
| hellaswag-nl.test | 2048 | 0 | 0 | 0.0000% |
| hellaswag-nl.train | 1024 | 0 | 1 | 0.0977% |
| hellaswag-nl.val | 256 | 0 | 0 | 0.0000% |
| mbbq-nl.test | 2044 | 0 | 0 | 0.0000% |
| mbbq-nl.val | 255 | 0 | 0 | 0.0000% |
| mmlu-nl.test | 2048 | 1 | 0 | 0.0000% |
| mmlu-nl.train | 1024 | 0 | 2 | 0.1953% |
| mmlu-nl.val | 256 | 0 | 0 | 0.0000% |
| onofficieel-copa-nl.test | 500 | 0 | 0 | 0.0000% |
| onofficieel-copa-nl.train | 400 | 0 | 0 | 0.0000% |
| onofficieel-copa-nl.val | 100 | 0 | 0 | 0.0000% |
| onofficieel-dutch-cola.test | 2048 | 2003 | 1 | 0.0488% |
| onofficieel-dutch-cola.train | 1024 | 1001 | 0 | 0.0000% |
| onofficieel-dutch-cola.val | 256 | 247 | 0 | 0.0000% |
| onofficieel-dutch-proverbs.test | 98 | 0 | 1 | 1.0204% |
| onofficieel-dutch-proverbs.train | 32 | 0 | 0 | 0.0000% |
| scala-nl.test | 2048 | 925 | 0 | 0.0000% |
| scala-nl.train | 1024 | 506 | 0 | 0.0000% |
| scala-nl.val | 256 | 121 | 0 | 0.0000% |
| squad-nl.test | 2048 | 0 | 3 | 0.1465% |
| squad-nl.train | 1024 | 0 | 0 | 0.0000% |
| squad-nl.val | 256 | 0 | 1 | 0.3906% |
| valeu-nl.test | 53 | 1 | 4 | 7.5472% |
| wiki-lingua-nl.test | 2048 | 0 | 2 | 0.0977% |
| wiki-lingua-nl.train | 1024 | 0 | 0 | 0.0000% |
| wiki-lingua-nl.val | 256 | 0 | 1 | 0.3906% |
| **totaal** | **29273** | **6179** | **16** | **0.0547%** |

## Voorbeelden van overlappende n-grams

Per besmet eval-record het n-gram dat het als eerste markeerde en het train-bestand waarin dat n-gram voorkwam.

### hellaswag-nl.train

| Eval-record | Overlappend n-gram | Train-bestand |
|---|---|---|
| 538 | [fragment weggelaten: 13 woorden, 70 tekens] | `walnoot_sft.jsonl` |

### mmlu-nl.train

| Eval-record | Overlappend n-gram | Train-bestand |
|---|---|---|
| 82 | [fragment weggelaten: 13 woorden, 59 tekens] | `shard-00001.jsonl` |
| 901 | [fragment weggelaten: 13 woorden, 73 tekens] | `shard-00004.jsonl` |

### onofficieel-dutch-cola.test

| Eval-record | Overlappend n-gram | Train-bestand |
|---|---|---|
| 799 | [fragment weggelaten: 13 woorden, 71 tekens] | `shard-00000.jsonl` |

### onofficieel-dutch-proverbs.test

| Eval-record | Overlappend n-gram | Train-bestand |
|---|---|---|
| 15 | [fragment weggelaten: 13 woorden, 60 tekens] | `shard-00003.jsonl` |

### squad-nl.test

| Eval-record | Overlappend n-gram | Train-bestand |
|---|---|---|
| 924 | [fragment weggelaten: 13 woorden, 79 tekens] | `shard-00000.jsonl` |
| 975 | [fragment weggelaten: 13 woorden, 79 tekens] | `shard-00000.jsonl` |
| 987 | [fragment weggelaten: 13 woorden, 54 tekens] | `shard-00004.jsonl` |

### squad-nl.val

| Eval-record | Overlappend n-gram | Train-bestand |
|---|---|---|
| 249 | [fragment weggelaten: 13 woorden, 73 tekens] | `shard-00001.jsonl` |

### valeu-nl.test

| Eval-record | Overlappend n-gram | Train-bestand |
|---|---|---|
| 5 | [fragment weggelaten: 13 woorden, 25 tekens] | `shard-00004.jsonl` |
| 8 | [fragment weggelaten: 13 woorden, 25 tekens] | `shard-00004.jsonl` |
| 37 | [fragment weggelaten: 13 woorden, 25 tekens] | `shard-00004.jsonl` |
| 44 | [fragment weggelaten: 13 woorden, 25 tekens] | `shard-00004.jsonl` |

### wiki-lingua-nl.test

| Eval-record | Overlappend n-gram | Train-bestand |
|---|---|---|
| 181 | [fragment weggelaten: 13 woorden, 80 tekens] | `shard-00000.jsonl` |
| 1941 | [fragment weggelaten: 13 woorden, 71 tekens] | `shard-00000.jsonl` |

### wiki-lingua-nl.val

| Eval-record | Overlappend n-gram | Train-bestand |
|---|---|---|
| 13 | [fragment weggelaten: 13 woorden, 59 tekens] | `walnoot_sft.jsonl` |

## Conclusie

> 16 van de 29273 eval-records (0.0547% totaal) deelt >=1 13-woord-n-gram met de trainingsmix. Zwaarst besmet: valeu-nl.test (7.5472%). Drempel 0.0000% -> OVERSCHREDEN.

