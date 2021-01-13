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

[1]: https://docs.github.com/en/free-pro-team@latest/actions
[2]: https://docs.github.com/en/free-pro-team@latest/actions/reference/events-that-trigger-workflows
[3]: https://github.com/marketplace?type=actions