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
- wanneer de lint-oas.yml bestand naar GitHub wordt gepushed
- wanneer de **Run workflow** button wordt geklikt

De workflow voert de volgende stappen uit:

- `actions/checkout@v2`. M.b.v. deze action wordt `git checkout` op de repo uitgevoerd zodat de andere workflow stappen de bestanden in de repo kan benaderen
- `actions/setup-node@v1`. Hiermee wordt v12 van `node.js` van node.js geïnstalleerd. Dit is nodig om dependencies opgenomen in het *package.json* bestand te kunnen installeren
- `npm install`. Script om de dependencies gedefinieerd het package.json bestand te installeren. Dit is nodig de npm scripts gedefinieerd in het package.json bestand uit te kunnen voeren
- `npm run oas:lint`. Uitvoeren van de oas:lint script gedefinieerd in het package.json bestand. De script valideert de specificatie/openapi.yaml bestand m.b.v. [Spectral][4]. De gebruikte OAS rules staan gedefinieerd in het .spectral.yml bestand
- `npm run oas:resolve`. Uitvoeren van de oas:resolve script. De script resolve de specificatie/openapi.yaml bestand m.b.v. [Swagger Codegen][5]. De geresolve-de variant wordt weggeschreven in de specificatie/genereervariant map
- `npm run oas:lint-genereervariant`. De oas:lint-genereervariant valideert de specificatie/genereervariant/openapi.yaml bestand m.b.v. [Spectral][4]
- `push resolved to remote` script. De script valideert of de specificatie/genereervariant/openapi.yaml is gewijzigd door de resolve stap. Is dat het geval, dan worden deze wijzigingen ge-commit & ge-push-t naar de GitHub repository.  
  Er is voor gekozen om deze script niet op te nemen als npm script omdat er GitHub specifieke variabele ($GITHUB_ACTOR) wordt gebruikt, waardoor het niet mogelijk is om deze script lokaal uit te voeren

### generate-sdks

De generate-sdks workflow genereert m.b.v. de [OpenAPI Generator][6] client code voor het aanroepen van een Web API voor de volgende programmeer talen:

- JAVA
- .NET Core
- .NET Full Framework
- Python

De workflow wordt getriggered:

- wanneer er yaml bestanden in de specificatie/genereervariant map naar GitHub worden gepushed
- wanneer de generate-sdks.yml bestand naar GitHub wordt gepushed
- wanneer de **Run workflow** button wordt geklikt

De workflow voert de volgende stappen uit:

- `actions/checkout@v2`. M.b.v. deze action wordt `git checkout` op de repo uitgevoerd zodat de andere workflow stappen de bestanden in de repo kan benaderen
- `actions/setup-node@v1`. Hiermee wordt v12 van `node.js` van node.js geïnstalleerd. Dit is nodig om dependencies opgenomen in het *package.json* bestand te kunnen installeren
- `npm install`. Script om de dependencies gedefinieerd het package.json bestand te installeren. Dit is nodig de npm scripts gedefinieerd in het package.json bestand uit te kunnen voeren
- `npm run oas:generate-java-client`. Deze stap genereert client code voor JAVA
- `npm run oas:generate-netcore-client`. Deze stap genereert client code voor .NET Core
- `npm run oas:generate-net-client`. Deze stap genereert client code voor .NET Full Framework
- `npm run oas:generate-python-client`. Deze stap genereert client code voor Python
- `push resolved to remote` script. De script valideert of er bestanden onder de code map zijn gewijzigd. Is dat het geval, dan worden deze wijzigingen ge-commit & ge-push-t naar de GitHub repository.  
  Er is voor gekozen om deze script niet op te nemen als npm script omdat er GitHub specifieke variabele ($GITHUB_ACTOR) wordt gebruikt, waardoor het niet mogelijk is om deze script lokaal uit te voeren

[1]: https://docs.github.com/en/free-pro-team@latest/actions
[2]: https://docs.github.com/en/free-pro-team@latest/actions/reference/events-that-trigger-workflows
[3]: https://github.com/marketplace?type=actions
[4]: https://stoplight.io/open-source/spectral/
[5]: https://mvnrepository.com/artifact/io.swagger.codegen.v3/swagger-codegen-cli
[6]: https://openapi-generator.tech/
