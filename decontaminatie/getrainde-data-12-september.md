# De meting van 12 september, over de instructiedata en de nabewerkingsdata

**Dit is de meting over de instructiedata en de nabewerkingsdata waarop het uitgegeven model
werkelijk is getraind.** Dat zijn de data van de laatste twee stappen van de training. De meting
liep op 12 september 2026, na de training. De twee
metingen van juli in deze map gingen over ander materiaal. `13-gram-eerste-pas-amendement.md` en
`poortverslag.md` horen bij de pas van 22 juli, over een eerdere en kleinere bouw van het corpus
met de instructiedata van dat moment. `13-gram-bron1.md` en `13-gram-bron2.md` horen bij de meting
van 30 juli, over de twee bronbestanden van de eigen bron die in het corpus van de voortgezette
pretraining de opmaak van tekst moet behouden.

**Er staat hier geen n-gramtekst en geen tekst uit een testitem of een trainingsrecord.** Alleen
tellingen.

## Wat is gemeten

| trainingsbestand | records | bytes |
|---|---:|---:|
| de instructiedata | 51.875 | 149.968.466 |
| de nabewerkingsdata | 1.157 | 4.519.892 |

Van beide bestanden is voor de meting de sha256 gemeten; die was gelijk aan de vastgelegde waarde.
Van elk record doen de gebruikersbeurt en de assistentbeurt mee, de systeembeurt niet. In dezelfde
meting liepen nog twee andere mixen mee waarop het uitgegeven model niet is getraind; die staan
hier niet.

De referentie is de tien Nederlandse taken van EuroEval waarop het model is gemeten, zoals
EuroEval ze laadt. Dat zijn 28 splits met samen 42.925 items. Elk item is twee keer gemeten,
een keer op de vraag en een keer op het gouden antwoord: samen 85.850 zijden. Daarvan waren er
41.531 korter dan acht woorden. Die zijn apart geteld en niet als nul geboekt; het zijn vooral de
gouden antwoorden van de classificatietaken, waar het antwoord een label van een of twee woorden
is.

| dataset in EuroEval | splits |
|---|---:|
| `conll-nl-mini` | 3 |
| `dbrd-mini` | 3 |
| `duidelijke-taal` | 3 |
| `european-values-nl` | 1 |
| `hellaswag-nl-mini` | 3 |
| `mbbq-nl` | 2 |
| `mmlu-nl-mini` | 3 |
| `scala-nl` | 4 |
| `squad-nl-v2-mini` | 3 |
| `wiki-lingua-nl-mini` | 3 |
| **samen** | **28** |

## Methode

De normalisatie is dezelfde als bij de meting van 30 juli, uit hetzelfde meetgereedschap in versie
1.1.0: NFKC, kleine letters, interpunctie naar spatie, witruimte samengevouwen en splitsen op
spaties. Gemeten is op een ladder van 8, 13, 16, 20, 25, 40, 60, 100 en 200 woorden achter elkaar.
**De poort ligt op twintig woorden.** Overleeft geen item twintig woorden, dan is het oordeel
schoon. Overleven items twintig maar geen tweehonderd woorden, dan zijn het vaste frases en krijgt
elk getal een voetnoot. Overleven items tweehonderd woorden, dan is er tekst gedeeld en blokkeert
de uitslag. Een treffer op dertien woorden die voor twintig woorden verdwijnt, is een vaste frase.
Acht woorden is een audit en beslist niets.

## De uitslag

Per trainingsbestand het aantal items met minstens een treffer op dat niveau:

| trainingsbestand | 8 woorden, audit | 13 woorden | 16 woorden | 20 woorden en meer |
|---|---:|---:|---:|---:|
| de instructiedata | 659 | 2 | 0 | 0 |
| de nabewerkingsdata | 33 | 0 | 0 | 0 |

**De twee items op dertien woorden.** Beide staan in de testsplit van `squad-nl-v2-mini`, aan de
kant van de vraag. Het gedeelde stuk beslaat hoogstens 1,27 procent van de reeksen van dertien
woorden in zo'n item en op zestien woorden is het weg. Het is dus een vaste frase en geen gedeeld
testitem.

    trainingsbestanden        2, sha gelijk aan de vastgelegde waarde voor beide
    referentie                10 van 10 taken, 28 splits, 42.925 items
    dertien woorden           2 items in de instructiedata, 0 in de nabewerkingsdata
    twintig woorden, poort    0 items
    oordeel                   schoon

**Deze meting zegt niets over het corpus van de voortgezette pretraining.** Dat is hier niet
gemeten. Wat daarover in juli is gemeten, staat in `13-gram-eerste-pas-amendement.md`,
`poortverslag.md`, `13-gram-bron1.md` en `13-gram-bron2.md`. Die metingen leggen het corpus waarop
dit model is doorgetraind niet in zijn geheel naast EuroEval; `../README.md` zegt wat zij wel
dekken.
