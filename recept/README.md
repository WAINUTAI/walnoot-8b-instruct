# Wat er voor dit model echt is gedraaid

In deze map staat de configuratie van de drie stappen waarmee Walnoot 8B Instruct is getraind.
**Twee bestanden in `01-doortraining` zijn niet ingesteld op het aantal stappen waarop dit model rust.**
Hieronder staat per stap welke waarden echt zijn gedraaid en waar dat vandaan komt.

## Zo leest u de bestanden in deze map

De configuraties en jobscripts zijn werkbestanden uit de bouw. Hun commentaar is voor publicatie
herschreven voor een externe lezer. Waar het een plan beschrijft, blijft het een plan. Ook een
regel die toen gold, staat er nog als regel van toen. In de waarden en de code zijn interne
werknamen en paden vervangen door gewone woorden en placeholders, ook in enkele meldingen en
namen van de jobscripts. Verder is er niets aan de waarden en de code veranderd.

- `<W>` staat voor de werkmap op de rekenomgeving en `<account>` voor het Slurm-account.
- `__RUN_ID__`, `__BASIS_PAD__`, `__DATA_PAD__` en `__ARMNAAM__` zijn placeholders in een
  template. Een hulpscript of het jobscript vulde ze in voordat er werd getraind. Een effectieve
  kopie is zo'n ingevulde kopie.
- `/OVERRIDE-ME/` is een opzettelijk onbruikbaar pad, zodat een vergeten invulling de job laat
  stoppen.
- `/data` en `/wsout` zijn de mappen voor de data en de output in de container.
- Een poort (gate) is een geautomatiseerde controle die de job stopt bij een afwijking. ROOD
  betekent dat de controle faalt en groen dat die slaagt. De lesnummers in de markeringen van
  `03-nabewerking/nabewerking.sbatch` verwijzen naar een interne lijst met lessen uit eerdere
  fouten.
- Een arm of variant is een trainingsvariant die naast andere is geprobeerd. De controlevariant
  startte ter vergelijking op het kale basismodel. Alleen het uitgegeven model staat op Hugging
  Face.
- Namen als `v2`, `v2a`, `v2_slice`, `v2d_C` en `W4` zijn interne werknamen van varianten,
  datasets of bouwstappen.
- CPT is de voortgezette pretraining (continued pretraining) en SFT de instructietraining. RFT is
  de nabewerking op eigen antwoorden die een beoordelingsstap had goedgekeurd. De DPO-varianten
  zijn varianten met paarsgewijze voorkeurstraining; geen daarvan is uitgegeven.
- Waar het commentaar een intern plan, besluit, draaiboek of verslag noemt, gaat het om een stuk
  dat niet in deze repository staat. Waar een coderegel in `nabewerking.sbatch` "het recept"
  noemt, is het interne trainingsplan bedoeld en niet deze map. Ook de hulpscripts die de
  bestanden noemen, staan er niet in; `../README.md` somt ze op.
- In het commentaar heet een jobscript, het Slurm-script van een job, ook jobtekst.
- `# scanner-uitzondering` aan het eind van een regel in `nabewerking.sbatch` markeert een regel
  die zelf de zoekpatronen van een interne controle bevat en daarom voor die controle een
  uitzondering is. De omrekening naar de boekingseenheid van de rekenomgeving in poort 5 van dat
  bestand is een rekensom die de job pas bij het draaien uitvoert; in het bestand staat geen
  uitkomst.

## 01, de voortgezette pretraining

**Wat er is gedraaid.** De productierun van de voortgezette pretraining begon op 31 juli 2026.
Dit model rust op het bewaarpunt (checkpoint) bij stap 3.816 van die run. Vanaf dat bewaarpunt is
een aparte cooldown van 64 stappen gedraaid. Een stap is 1.048.576 tokens, het product van micro
batch 8, gradient accumulation 4, 8 ranks en sequence length 4.096.

| grootheid | gedraaid voor dit model | in de bestanden van deze map |
|---|---|---|
| stappen in de hoofdfase | 3.816 | 3.339, in `doortraining-hoofdfase.yaml` |
| tokens in de hoofdfase | 4.001.366.016, ongeveer 4,0 miljard | 3.501.195.264 |
| stappen in de cooldown | 64 | 477, in `doortraining-afbouw.yaml` |
| tokens in de cooldown | 67.108.864 | 500.170.752 |
| data van de cooldown | hetzelfde corpus als de hoofdfase | een aparte afbouwslice |
| startpunt van de cooldown | het bewaarpunt bij stap 3.816 | een placeholder |

**Alle andere waarden zijn gelijk.** Wij hebben de configuratie van de hoofdfase zoals die draaide
sleutel voor sleutel naast `doortraining-hoofdfase.yaml` gelegd. Van de 51 waarden verschillen
alleen `max_steps` en de twee paden `dataset_prepared_path` en `output_dir`. Gelijk zijn onder meer
de learning rate van 2,0e-5 met `constant_with_warmup`, `warmup_ratio` 0,02, weight decay 0,1,
gradient clipping op 1,0 en seed 42. De configuratie van de cooldown zoals die draaide, is op
dezelfde manier naast `doortraining-afbouw.yaml` gelegd. Van de 50 waarden verschillen `max_steps`,
`eval_steps` en `save_steps` (64 in plaats van 477), de data, het startpunt en de paden. Gelijk
zijn de learning rate die zonder warmup lineair van 2,0e-5 naar 0 loopt, weight decay 0,1 en seed
4242.

**Waar 3.339 en 477 vandaan komen.** Die twee getallen horen bij een later plan voor een nieuwe
voortgezette pretraining van vier miljard tokens met een vooraf geplande cooldown. Dat plan is
op 6 augustus 2026 opgesteld. Dit model rust er niet op. Het commentaar van beide bestanden
beschrijft grotendeels de opzet die wel is gedraaid. Dat van `doortraining-hoofdfase.yaml` rekent
met 3.816 stappen en een verlenging tot 7.632. Dat van `doortraining-afbouw.yaml` beschrijft op
meer plekken de cooldown van 64 stappen. De waarden in beide bestanden volgen op de genoemde
punten het plan; beide bestanden zeggen dat ook bovenaan in hun commentaar. In beide bestanden zijn voor
publicatie interne werknamen vervangen door gewone woorden, in het commentaar en in een of twee
paden. Verder zijn de waarden niet aangepast. Het commentaar is herschreven voor een externe
lezer; waar het een plan beschrijft, blijft het een plan. De gedraaide waarden staan in deze
README.

**De productierun liep door tot acht miljard tokens.** De run is voortgezet tot stap 7.632,
ongeveer 8,0 miljard tokens, het budget van de bouw. De beste uitkomst lag bij stap 3.816,
ongeveer 4,0 miljard tokens. Daarom rust dit model op dat bewaarpunt en niet op het eindpunt.

**De bron.** De configuratie van de hoofdfase zoals die draaide, is 29.307 bytes met sha256
`b1e76e5ef1da741313b18fa158a264289f93d7a63fe8c2b0a3938fdac1af8070`. De configuratie van de
cooldown zoals die draaide, is 7.276 bytes met sha256
`3308b3003aba86e93b53453c5bc1e8fd2fdae2034bb665fc2876411258cb9e29`; het interne uitslagbestand
van dat bewaarpunt, dat niet in deze repository staat, noemt diezelfde sha en 64 stappen. De
gewichten na de cooldown zijn 16.106.727.320 bytes met sha256
`e5b473c16fcb5e44ab6bcfaf5b4b63e3d23996a19a4202b296a49750d2be20d7`. Dat is de basis die
`02-sft/instructietraining-mix.yaml` in zijn commentaar noemt. Die stukken zijn intern en staan
niet in deze repository; ze zijn op verzoek beschikbaar via support@walnoot.ai.

## 02, de instructietraining

`02-sft/instructietraining-mix.yaml` is de configuratie die voor dit model is gedraaid. Wij
hebben dat bestand sleutel voor sleutel naast de configuratie gelegd waarmee de training liep;
alleen vijf paden verschillen. De mix telt 51.875 records. Daarop is twee epochs getraind, met een
learning rate van 2,0e-5. `02-sft/sft.yaml` is een oudere template met drie epochs en een
learning rate van 1,0e-5. Met die template is dit model niet getraind.

## 03, de nabewerking

`03-nabewerking/nabewerking.yaml` bevat de waarden van de laatste stap van dit model. Naast de
configuratie gelegd waarmee die stap liep, verschilt het bestand alleen in de paden waarin een
placeholder staat. De placeholders staan voor de werkmap, de modelmap, het recordbestand en het
run-ID (het jobnummer plus de naam van de run).

`03-nabewerking/nabewerking.sbatch` is een vroege versie van de jobtemplate van deze stap. Het
jobscript waarmee de nabewerking van dit model is ingediend, is een latere versie van dezelfde
template met meer controles; dat jobscript staat niet in deze repository. De gepubliceerde
template draait niet zonder aanvulling. Het bestand gebruikt `W` in twee standaardwaarden voordat
het `W` een waarde geeft en het leest `DATA_SHA` zonder die naam ergens toe te wijzen. Onder
`set -u` stopt het script daarop, tenzij die namen al uit de omgeving komen. In het bestand staan twee
placeholders, `__ARMNAAM__` voor de naam van de run en `__BASIS_PAD__` voor de modelmap van het
instructiegetrainde model. De invoerpaden komen uit de omgeving. Een hulpscript vulde de template
in, toetste de ingevulde kopie en schreef pas dan een indienbaar bestand; dat hulpscript staat
niet in deze repository.

## English summary

This folder holds the configuration of the three training stages of Walnoot 8B Instruct. Two files
in `01-doortraining` do not carry the step counts this model rests on. The model rests on step
3,816 of the continued pretraining run, which is 4,001,366,016 tokens. A separate cooldown of 64
steps followed from that point, 67,108,864 tokens on the same corpus with a learning rate falling
linearly from 2.0e-5 to 0. The values 3,339 and 477 in the two files belong to a later plan for a
new run. This model does not rest on that plan. Of the 51 values in the main phase file, only
`max_steps` and the two paths `dataset_prepared_path` and `output_dir` differ from what ran. In
the cooldown file, `max_steps`, `eval_steps`, `save_steps`, the data, the starting point and the
paths differ; the other values match. The run itself went on to step 7,632, about 8 billion
tokens, the budget of the build. The best result lay at step 3,816, which is why this model rests
there and not on the endpoint. In `02-sft` the file `instructietraining-mix.yaml` is the
configuration that ran; `sft.yaml` is an older template. In `03-nabewerking` the file
`nabewerking.yaml` carries the values of the final stage as a template with placeholders.
`nabewerking.sbatch` is an early version of the job template of that stage. The job that was
submitted for this model was a later version with more checks; it is not included here. The
comments in all these files were rewritten for publication. Internal working names were replaced
by plain words, in the comments and in a few paths. The values are otherwise unchanged. The
section on how to read the files explains the placeholders and the internal terms that remain.
