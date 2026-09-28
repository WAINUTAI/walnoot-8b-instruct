# Decontaminatie-controle: Walnoot trainingsdata vs. EuroEval-testsplits

> **Leeswijzer.** Dit is het verslag van de meting van 30 juli 2026 op het tweede bronbestand van
> de eigen bron die in het corpus van de voortgezette pretraining de opmaak van tekst moet
> behouden. Het meetgereedschap heeft het zo geschreven. Gemeten is dat bronbestand na het
> schrappen van de records met onzichtbare tekens op 30 juli; het telt dan 31.290 records. Met
> "trainingsmix" bedoelt het gereedschap hier dat ene bronbestand en met "gate" de poort. De
> referentie telt 35 bestanden uit EuroEval 17.6.0 met test-, train- en validatiesplits. Waar de
> titel en de conclusie van testsplits spreken, gaat het dus om alle drie de splits. In het
> corpus is de eigen bron herhaald om op 2 procent van de tekens te komen; zie
> `../herkomst/MANIFEST-TOELICHTING.md`. Voor publicatie is het begin van de paden vervangen door
> `<bouwomgeving>` en is de interpunctie van de titel aangepast. `<bouwomgeving>` staat voor de map
> op de machine waarop het corpus is gebouwd. Waar deze meting in het geheel staat, legt
> `../README.md` uit.

*Gegenereerd:* 2026-07-30 14:21 UTC  
*Tool:* decontamination_check.py v1.1.0

## Methode (voor de publicatie)

- **N-gram:** 13 woorden (schuifvenster).
- **Normalisatie:** NFKC + lowercase + interpunctie->spatie + witruimte-collapse + splitsen op spaties (woord-tokens).
- **Fingerprint:** md5, eerste 8 bytes little-endian -> 64-bit int (deterministisch).
- **Steekproefcaps:** max_train_records = geen; max_eval_records_per_dataset = geen.
- **Faaldrempel:** een dataset boven 0.0000% besmette records laat de tool falen (exit 1); de gate toetst per dataset (de zwaarst besmette), niet het totaalgemiddelde.
- **Train-globs:** `<bouwomgeving>/format/onzichtbaar-schrap-20260730/walnoot_format_bron_gen.onzichtbaar-geschrapt.jsonl`
- **Eval-map:** `<bouwomgeving>/format/onzichtbaar-schrap-20260730/poort-bron2_gen/clean_eval`

## Verwerkt

- Train: 1 bestand(en), 31,290 documenten, 9,215,242 n-grams gestreamd (0 zonder text/messages overgeslagen).
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
| hellaswag-nl.train | 1024 | 0 | 0 | 0.0000% |
| hellaswag-nl.val | 256 | 0 | 0 | 0.0000% |
| mbbq-nl.test | 2044 | 0 | 0 | 0.0000% |
| mbbq-nl.val | 255 | 0 | 0 | 0.0000% |
| mmlu-nl.test | 2048 | 1 | 0 | 0.0000% |
| mmlu-nl.train | 1024 | 0 | 0 | 0.0000% |
| mmlu-nl.val | 256 | 0 | 0 | 0.0000% |
| onofficieel-copa-nl.test | 500 | 0 | 0 | 0.0000% |
| onofficieel-copa-nl.train | 400 | 0 | 0 | 0.0000% |
| onofficieel-copa-nl.val | 100 | 0 | 0 | 0.0000% |
| onofficieel-dutch-cola.test | 2048 | 2003 | 0 | 0.0000% |
| onofficieel-dutch-cola.train | 1024 | 1001 | 0 | 0.0000% |
| onofficieel-dutch-cola.val | 256 | 247 | 0 | 0.0000% |
| onofficieel-dutch-proverbs.test | 98 | 0 | 0 | 0.0000% |
| onofficieel-dutch-proverbs.train | 32 | 0 | 0 | 0.0000% |
| scala-nl.test | 2048 | 925 | 0 | 0.0000% |
| scala-nl.train | 1024 | 506 | 0 | 0.0000% |
| scala-nl.val | 256 | 121 | 0 | 0.0000% |
| squad-nl.test | 2048 | 0 | 0 | 0.0000% |
| squad-nl.train | 1024 | 0 | 0 | 0.0000% |
| squad-nl.val | 256 | 0 | 0 | 0.0000% |
| valeu-nl.test | 53 | 1 | 0 | 0.0000% |
| wiki-lingua-nl.test | 2048 | 0 | 0 | 0.0000% |
| wiki-lingua-nl.train | 1024 | 0 | 0 | 0.0000% |
| wiki-lingua-nl.val | 256 | 0 | 0 | 0.0000% |
| **totaal** | **29273** | **6179** | **0** | **0.0000%** |

## Conclusie

> GEEN overlap gevonden: 0 van de 29273 eval-records deelt een 13-woord-n-gram met de trainingsmix. De testsplits zijn volgens deze methode niet besmet.

