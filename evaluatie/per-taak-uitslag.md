# De uitslag per taak van het uitgegeven model naast de voorganger

Stand van 11 september 2026. Dit verslag legt de EuroEval-uitslag van het uitgegeven model per
taak naast die van zijn voorganger. De voorganger is het model na de instructietraining, het
startpunt van de nabewerking (zie `../recept/README.md`). De vraag was of de nabewerking het model
op een taak aantoonbaar had laten zakken. De uitslag hieronder is uit het scorebestand van de
meting berekend en niet overgenomen. Dezelfde cijfers staan machineleesbaar in
`uitslag-per-taak.json`.

## 1. De bron, gemeten en niet overgenomen

    scorebestand   de uitgelezen scores van deze meetronde, uit stap U van
                   euroeval-17.6.0.sbatch
    sha256         2f213429275fce440207aa92cafd2209d9367afaeed695dcc232561e9dea5870
    bytes          8.320
    records        10, tien taaknamen, elk met tien iteraties volgens de controle in stap U
    referentie     het scorebestand van de voorganger,
                   sha 361272c5f4add9b23b82cc7492d3c07e7145c8c98a95ce74be158f1b38b48d38

Het scorebestand zelf gaat niet mee met deze repository; dat van de voorganger evenmin. Hun
sha256 staat hierboven, zodat wie ze van ons krijgt kan narekenen dat het dezelfde bestanden zijn.
De waarden van het uitgegeven model in de tabellen hieronder staan ook in de ruwe uitslag
`euroeval-uitslag.jsonl` in deze map.

## 2. Regel B, de acht taken

Regel B legt het model op acht taken naast de ondergrens van het 95-procentinterval van de
voorganger. Komen twee of meer taken onder die ondergrens uit, dan is de uitslag rood.

    taak             metriek             model  referentie    verschil   ondergrens  onder?
    dbrd             mcc                  90.558      90.585     -0.028      89.890   nee
    scala-nl         mcc                  34.408      34.215     +0.193      30.637   nee
    conll-nl         micro_f1_no_misc     46.518      47.218     -0.700      45.395   nee
    squad-nl         em                   62.077      61.883     +0.193      61.140   nee
    wiki-lingua-nl   chr_f3pp             34.182      34.173     +0.009      32.708   nee
    mmlu-nl          mcc                  37.162      37.033     +0.129      36.070   nee
    hellaswag-nl     mcc                  22.458      21.137     +1.321      19.661   nee
    duidelijke-taal  meteor               52.947      53.340     -0.394      51.677   nee

    taken onder de ondergrens, door het telscript          0
    taken onder de ondergrens, door een tweede telling     0
    som model min referentie over de acht taken     +0,724, band -12,407 tot +12,407, RAPPORTAGE

De som over de acht taken staat er als rapportage en telt niet mee voor het oordeel. De band loopt
van -12,407 tot +12,407, bijna 25 punten breed, terwijl de som van de verschillen 0,724 is. Zo'n
band onderscheidt niets.

De ondergrenzen komen uit de vooraf vastgelegde beslisregel van deze meetronde. Dat is een intern
stuk dat niet in deze repository staat; het is niet de beslisregel in `../decontaminatie/`. Het
telscript leest de ondergrenzen zelf uit het scorebestand van de voorganger. Die twee bronnen zijn
tegen elkaar gelegd en geven op alle acht taken dezelfde ondergrens.

**De krapste marge staat op `dbrd`, 0,667 boven de ondergrens.** Op die taak ligt dit model het
dichtst bij de grens van regel B. Het haalt hem; bij een volgende meting is dit de taak waar het
model het eerst onder de grens kan uitkomen.

## 3. De vergelijking met GPT-NL op zes taken

De kolom GPT-NL is de gepubliceerde waarde van GPT-NL. WIN betekent dat het hele interval boven
die waarde ligt, GELIJK dat de waarde binnen het interval valt. `../MODELKAART.md` geeft de bron, de
beslisregel en de kanttekeningen bij deze vergelijking.

    taak             metriek           GPT-NL    waarde  interval               uitslag
    dbrd             mcc                  90.00    90.558  [  89.762 ;   91.354]  GELIJK
    scala-nl         mcc                  19.00    34.408  [  31.002 ;   37.813]  WIN
    conll-nl         micro_f1_no_misc     36.00    46.518  [  44.489 ;   48.547]  WIN
    squad-nl         em                   51.00    62.077  [  61.424 ;   62.729]  WIN
    mmlu-nl          mcc                   2.00    37.162  [  36.191 ;   38.133]  WIN
    hellaswag-nl     mcc                  -2.00    22.458  [  20.728 ;   24.188]  WIN

**Het model staat op dbrd GELIJK.** De ondergrens is 89,762 en ligt daarmee 0,238 onder de
publicatiewaarde 90,00; het interval loopt over de 90,00 heen.

## 4. De twee regels van het oordeel

Regel A is de eerste winvoorwaarde die vooraf is vastgelegd, in de json `wc1` en `WC#1` genoemd. Zij vraagt
minstens vijf winsten tegen GPT-NL op de zes taken van paragraaf 3. Regel B staat in paragraaf 2.

    REGEL A   5 winsten tegen GPT-NL, minstens 5 vereist                         GEHAALD
    REGEL B   0 taken onder de 95-procent-ondergrens, rood vanaf 2               GEHAALD

    OORDEEL   GROEN

GROEN betekent dat regel A en regel B allebei zijn gehaald. Bij deze meting lag geen van de acht
taken van regel B onder de ondergrens van het 95-procentinterval van de voorganger. Het oordeel
staat hier en in het veld `harde_poort.oordeel` van de json.

## 5. Wat bij dit model apart is nagekeken

**Dit model is met RFT nabewerkt.** RFT slaat op de data, een set eigen antwoorden die met
verwerping is samengesteld; de training zelf is gewone SFT. Het scorebestand is gemaakt met dezelfde
uitleesstap als dat van de andere varianten uit dezelfde meetronde en heeft dezelfde tien records,
taaknamen en metrieken. Dat is nagemeten en niet aangenomen.

## 6. Wat dit oordeel NIET zegt

Dit oordeel zegt alleen dat dit model op deze taken niet aantoonbaar wegzakt ten opzichte van de
voorganger. Het zegt niets over valeu-nl en mbbq-nl. Die twee vallen buiten regel B en staan
alleen in de json, onder `som_tien`, met hun waarden en die van de voorganger.
