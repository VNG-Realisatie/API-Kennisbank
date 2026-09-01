# Handleiding GitHub Pages linkcontrole VNG-Realisatie

## Doel

Het script inventariseert de GitHub Pages-sites van `VNG-Realisatie`, crawlt de inhoud van die sites en controleert de gevonden hyperlinks.

Alleen repositories die **openbaar én niet-gearchiveerd** zijn, worden verder verwerkt.
De volgende repositories worden overgeslagen:
- **gearchiveerd** zijn (`archived = true` in GitHub);
- **private** zijn (`private = true` in GitHub).

Het script staat [inventariseer-github-pages-v2.5.ps1](ook in deze repository).

## Hoe de filtering werkt

### Stap 1 – alle repositories ophalen

Het script vraagt eerst de repositories van de organisatie op via GitHub. Daarna worden drie groepen bepaald:

1. alle gevonden repositories;
2. gearchiveerde repositories;
3. private repositories.

Vervolgens wordt één werklijst gemaakt met alleen repositories waarvoor geldt:

```powershell
(-not $repo.archived) -and (-not $repo.private)
```

Alle vervolgstappen gebruiken deze gefilterde werklijst.

In PowerShell zie je bijvoorbeeld:

```text
Gevonden repositories: 148
  Openbaar en actief: 113
  Overgeslagen (uniek): 35
    Gearchiveerd: 30
    Private:      8
```

Let op: een repository kan zowel private als gearchiveerd zijn. Daarom kunnen de aantallen `Gearchiveerd` en `Private` samen hoger zijn dan `Overgeslagen (uniek)`.

## Welke onderdelen worden overgeslagen?

Voor een private of gearchiveerde repository gebeurt niets meer met de repository:

- GitHub Pages wordt niet geïnventariseerd;
- de README wordt niet gelezen voor `Eigenaar` en `Ingevuld door`;
- de homepage-URL wordt niet meegenomen;
- de GitHub Pages-site wordt niet gecrawld;
- hyperlinks van die site worden niet getest;
- resultaten uit GitHub Code Search voor zo'n repository worden genegeerd;
- de repository komt daardoor niet in de uiteindelijke linkrapportage terecht.

Dit maakt de inventarisatie gericht op de repositories die nog daadwerkelijk in gebruik en publiek toegankelijk zijn.

## Een beperkte test uitvoeren

Om dit te kunnen uitvoeren heb je rechten nodig tot de repository en dien je GitHub CLI (gh) geïnstalleerd te hebben.

Open PowerShell en ga naar de map waar het script is opgeslagen:

```powershell
cd ...\GitHublinkchecker
```

Deblokkeer het nieuwe bestand eenmalig:

```powershell
Unblock-File .\inventariseer-github-pages-v2.5.ps1
```

Voer daarna eerst een beperkte test uit:

```powershell
.\inventariseer-github-pages-v2.5.ps1 -MaxPagesPerSite 25 -SkipCodeSearch
```

`MaxPagesPerSite 25` betekent dat per GitHub Pages-site maximaal 25 pagina's worden gecrawld. `SkipCodeSearch` slaat de aanvullende zoektocht naar oude Pages-links in repositorycode over en maakt een test sneller.

## Volledige controle

Als de beperkte test goed verloopt:

```powershell
.\inventariseer-github-pages-v2.5.ps1 -MaxConcurrentLinkChecks 16 -SkipCodeSearch
```

Wil je ook de aanvullende GitHub Code Search uitvoeren, laat `-SkipCodeSearch` weg:

```powershell
.\inventariseer-github-pages-v2.5.ps1 -MaxConcurrentLinkChecks 16
```

## README-metadata

Voor iedere openbare, actieve repository met GitHub Pages probeert het script de README te lezen.

Als daarin bijvoorbeeld staat:

```markdown
| Eigenaar | Ingevuld door |
| --- | --- |
| Kennis Centrum Architectuur | John Smit|
```

worden deze waarden toegevoegd aan alle gevonden linkregels voor die repository.

Als deze tabel ontbreekt, blijven `Eigenaar` en `Ingevuld door` leeg.

## Belangrijkste rapport

Het belangrijkste beheerbestand is:

```text
VNG-Realisatie-linkcontrole-alle-voorkomens.csv
```

De kolommen staan in deze volgorde:

1. `Repository`
2. `Eigenaar`
3. `Ingevuld door`
4. `Bronpagina`
5. `Gevonden URL`
6. `HttpStatus`
7. `Gecontroleerd op`

`Bronpagina` is de URL van de pagina waarop de hyperlink is aangetroffen. Daardoor kun je bij een defecte link direct zien op welke pagina deze aangepast moet worden.

## Overige rapporten

De resultaten komen standaard in:

```text
...\GitHublinkchecker\github-pages-rapport
```

Daarin staan onder andere:

- `VNG-Realisatie-github-pages-overzicht.csv` – overzicht van meegenomen GitHub Pages-sites;
- `VNG-Realisatie-paginas.csv` – alle gecrawlde pagina's;
- `VNG-Realisatie-linkcontrole-alle-voorkomens.csv` – compacte beheerinventarisatie;
- `VNG-Realisatie-linkcontrole-samenvatting.csv` – unieke links met technische status en classificatie;
- `VNG-Realisatie-github-pages-verwijzingen.csv` – aanvullende Pages-verwijzingen uit GitHub Code Search.

## Periodiek opnieuw uitvoeren

Voor een volgende controle hoef je alleen PowerShell te openen en uit te voeren:

```powershell
cd ...\GitHublinkchecker
.\inventariseer-github-pages-v2.5.ps1 -MaxConcurrentLinkChecks 16 -SkipCodeSearch
```

Omdat de repositorylijst iedere run opnieuw bij GitHub wordt opgehaald, worden repositories die later worden gearchiveerd of private worden bij de volgende run automatisch overgeslagen.
