# De acht-woordsaudit, per dataset

**Dit is een AUDIT en geen poort.** De bindende meting van 30 juli loopt op dertien woorden en staat
in `13-gram-bron1.md` en `13-gram-bron2.md`; die komen op nul uit. De meting hieronder loopt op acht
woorden en telt niet mee voor de uitslag. Zij staat er omdat een lezer die deze getallen zelf
vindt, zich anders afvraagt waarom zij ontbraken.

**Waarom acht woorden overspoelt.** Op zo'n kort fragment loopt gewoon taalgebruik mee:
verdragstitels, licentiekoppen, vaste formules. Een treffer op acht woorden is daarom geen
aanwijzing voor besmetting; een treffer op dertien woorden die ook op twintig woorden overleeft,
is dat wel.

**Er staat hier geen n-gramtekst.** Alleen tellingen. De gevonden fragmenten zelf blijven intern,
want zij zijn stukken tekst uit evaluatierecords.

## De twee bronnen

De meting van 30 juli ging over de twee bronbestanden van de eigen bron die in het corpus van de
voortgezette pretraining de opmaak van tekst moet behouden. Elke bron is apart tegen dezelfde
bevroren evaluatiereferentie gelegd: 35 bestanden met samen 29273 records. De meting over de
instructiedata en de nabewerkingsdata staat in `getrainde-data-12-september.md`.

| dataset | records | besmet, bron 1 | besmet, bron 2 |
|---|---:|---:|---:|
| `conll-nl.test` | 1024 | 0 | 0 |
| `conll-nl.train` | 1024 | 1 | 0 |
| `conll-nl.val` | 256 | 0 | 0 |
| `dbrd.test` | 2048 | 15 | 8 |
| `dbrd.train` | 1024 | 11 | 4 |
| `dbrd.val` | 256 | 1 | 1 |
| `duidelijke-taal.test` | 90 | 0 | 0 |
| `duidelijke-taal.train` | 50 | 0 | 0 |
| `duidelijke-taal.val` | 51 | 0 | 0 |
| `hellaswag-nl.test` | 2048 | 106 | 85 |
| `hellaswag-nl.train` | 1024 | 58 | 49 |
| `hellaswag-nl.val` | 256 | 18 | 14 |
| `mbbq-nl.test` | 2044 | 4 | 0 |
| `mbbq-nl.val` | 255 | 0 | 0 |
| `mmlu-nl.test` | 2048 | 23 | 13 |
| `mmlu-nl.train` | 1024 | 12 | 5 |
| `mmlu-nl.val` | 256 | 0 | 0 |
| `onofficieel-copa-nl.test` | 500 | 0 | 0 |
| `onofficieel-copa-nl.train` | 400 | 0 | 0 |
| `onofficieel-copa-nl.val` | 100 | 0 | 0 |
| `onofficieel-dutch-cola.test` | 2048 | 1 | 1 |
| `onofficieel-dutch-cola.train` | 1024 | 0 | 0 |
| `onofficieel-dutch-cola.val` | 256 | 0 | 0 |
| `onofficieel-dutch-proverbs.test` | 98 | 0 | 2 |
| `onofficieel-dutch-proverbs.train` | 32 | 0 | 0 |
| `scala-nl.test` | 2048 | 2 | 2 |
| `scala-nl.train` | 1024 | 0 | 0 |
| `scala-nl.val` | 256 | 0 | 0 |
| `squad-nl.test` | 2048 | 36 | 31 |
| `squad-nl.train` | 1024 | 8 | 4 |
| `squad-nl.val` | 256 | 12 | 10 |
| `valeu-nl.test` | 53 | 0 | 0 |
| `wiki-lingua-nl.test` | 2048 | 244 | 197 |
| `wiki-lingua-nl.train` | 1024 | 139 | 129 |
| `wiki-lingua-nl.val` | 256 | 32 | 36 |
| **totaal** | **29273** | **723** | **591** |

## De uitslag

    dertien woorden, bindend      0 van 29273, beide bronnen
    acht woorden, audit           723 en 591 van 29273
    diepte-pas                    16, 20 en 25 woorden, achter elke treffer op dertien
    oordeel                       PASS, met het corpusoordeel PASS_AMENDED_G2PRIME ernaast

**G2 is de interne naam van de poort op de corpusbouw en PASS_AMENDED_G2PRIME het zichtbare
amendement daarop; `beslisregel.md` legt beide uit.** Dat corpusoordeel gaat niet over de
testsets van EuroEval maar over een eigen set die wij apart houden om kennisverlies te meten. Het
amendement in die naam laten wij nergens weg en de kale uitslag G2-FAIL blijft er publiek naast
staan. Op die eigen set raakte de meting op dertien woorden 2.754 van de 6.244 records. De
afgekeurde eerste pas van 22 juli, over een eerdere bouw van het corpus, staat in
`13-gram-eerste-pas-amendement.md` en `poortverslag.md`.
