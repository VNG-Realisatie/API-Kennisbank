# Haal Centraal GitHub Actions workflows

[GitHub Actions][1] is een feature van GitHub waarmee je workflows kan definieren voor een GitHub repository. Je kan met GitHub Actions bijvoorbeeld een complete Continuous Integration / Continuous Delivery workflow inrichten, maar je kan ook kleinere workflows definieren zoals het automatisch valideren van specifieke commits.

Een GitHub Actions workflow is een file met .yml extensie en moet worden aangemaakt in de `.github/workflows` directory van een repository. Een minimale workflow file ziet er als volgt uit:

``` yaml
name: <workflow naam>

on:
  <event naam>

jobs:
  <job key>
    runs-on: <type machine>
    steps:
      - uses: <action naam>
      - runs: <script>
```

- `name`: de naam van de workflow. Deze naam wordt gebruikt voor het tonen van de logs van de workflow onder de **Actions** tab
- `on`: één of meerdere [events][2] die de workflow moet triggeren
- `jobs`: één of meerdere jobs. Elke job heeft een job key/identifier
- `runs-on`: de type machine (runner) aangegeven waar de job moet worden uitgevoerd
- `steps`: één of meerdere stappen die horen bij een job. Er zijn twee type steps:
   - `uses`: voert een action uit. Een action is code die je in meerdere stappen en andere workflows kan hergebruiken. 3rd party actions zijn te vinden op de [GitHub marketplace][3] maar je kan ook je eigen action implementeren
   - `runs`: voert code uit. Dit is meestal bash code omdat die op de meeste runner types is voorgeïnstalleerd

## Haal Centraal GitHub Actions workflows

Voor de Haal Centraal repositories zijn de volgende GitHub Actions workflows gedefinieerd:

- lint-oas
- generate-sdks
- generate-postman-collection
- generate-user-stories

### lint-oas

De lint-oas workflow valideert en resolve de openapi.yaml bestanden in de GitHub repository. De workflow maakt hiervoor gebruik van de npm scripts gedefinieerd in de package.json bestand. Hier is voor gekozen zodat lokaal en remote valideren en resolven op dezelfde manier en met dezelfde versie van de tools gebeurt, zodat het niet kan voorkomen dat je lokaal en remote verschillende resultaten krijgt.

De workflow wordt getriggered:

- wanneer er yaml bestanden in de specificatie map naar GitHub worden gepushed
- wanneer de lint-oas.yaml bestand naar GitHub wordt gepushed
- wanneer de **Run workflow** button wordt geklikt

De workflow voert de volgende stappen uit:

- Uitvoeren van `git checkout` van de repo zodat de rest van de workflow stappen acties op de bestanden kan uitvoeren
- Installeer v12 van `node.js`
- Installeer de dependencies uit de package.json bestand. Dit is nodig omdat de hierna volgende stappen gebruik maken van de npm scripts gedefinieerd in de package.json bestand
- Valideer de specificatie/openapi.yaml bestand m.b.v. [Spectral][4]
- Resolve de specificatie/openapi.yaml bestand m.b.v. [Swagger Codegen][5]. De geresolve-de variant wordt weggeschreven in de specificatie/genereervariant map
- Valideer de specificatie/genereervariant/openapi.yaml bestand m.b.v. [Spectral][4]
- Commit & push bij wijzigingen de geresolve-de bestanden (openapi.yaml en openapi.json) naar de GitHub repository

[1]: https://docs.github.com/en/free-pro-team@latest/actions
[2]: https://docs.github.com/en/free-pro-team@latest/actions/reference/events-that-trigger-workflows
[3]: https://github.com/marketplace?type=actions
[4]: https://stoplight.io/open-source/spectral/
[5]: https://mvnrepository.com/artifact/io.swagger.codegen.v3/swagger-codegen-cli