# Haal Centraal GitHub Action workflows

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

Voor de Haal Centraal repositories zijn de volgende GitHub Action workflows gedefinieerd:

- lint-oas
- generate-sdks
- generate-postman-collection
- generate-user-stories-md

Deze workflows maken gebruik van node en JAVA packages. Om het beheren en het gebruiken van de packages te vergemakkelijken is voor elke repository een package.json bestand ingericht. Het inrichten en beheren van zo'n package.json is beschreven in [Haal Centraal npm beheer][9]

## lint-oas

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

## generate-sdks

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

## generate-postman-collection

De generate-sdks workflow genereert m.b.v. de [OpenAPI 3.0 to Postman Collection v2.1.0 Converter][7] om op basis van een OpenAPI specificatie een Postman collection te genereren. Dit bestand kan dan worden gebruikt om met Postman de API aan te roepen.

De workflow wordt getriggered:

- wanneer er yaml bestanden in de specificatie/genereervariant map naar GitHub worden gepushed
- wanneer de generate-postman-collection.yml bestand naar GitHub wordt gepushed
- wanneer de **Run workflow** button wordt geklikt

De workflow voert de volgende stappen uit:

- `actions/checkout@v2`. M.b.v. deze action wordt `git checkout` op de repo uitgevoerd zodat de andere workflow stappen de bestanden in de repo kan benaderen
- `actions/setup-node@v1`. Hiermee wordt v12 van `node.js` van node.js geïnstalleerd. Dit is nodig om dependencies opgenomen in het *package.json* bestand te kunnen installeren
- `npm install`. Script om de dependencies gedefinieerd het package.json bestand te installeren. Dit is nodig de npm scripts gedefinieerd in het package.json bestand uit te kunnen voeren
- `npm run oas:generate-postman-collection`. Deze stap genereert de postman collection bestand
- `push resolved to remote` script. De script valideert of het xxx-postman-collection bestand onder de test map is gewijzigd. Is dat het geval, dan worden deze wijzigingen ge-commit & ge-push-t naar de GitHub repository.  
  Er is voor gekozen om deze script niet op te nemen als npm script omdat er GitHub specifieke variabele ($GITHUB_ACTOR) wordt gebruikt, waardoor het niet mogelijk is om deze script lokaal uit te voeren

## generate-user-stories-md

De generate-user-stories-md workflow selecteert m.b.v. de [Select Matching Issues][8] GitHub Action issues die de volgende labels hebben:

- "User Story"
- "v[major].[minor]"

Hiermee wordt vervolgens twee markdown bestanden: *user-stories-prod.md* en *user-stories-dev.md* gegenereerd. Deze bestanden respectievelijk de user stories die in de productie versie van de API zijn geïmplementeerd en de user stories die in de volgende versie van de API worden geïmplementeerd.

De workflow wordt getriggered:

- om 9, 11, 12, 14, 16, 17 uur. Let op: dit hoeft niet hetzelfde te zijn als de lokale tijd
- wanneer de **Run workflow** button wordt geklikt

De workflow voert de volgende stappen uit:

1. `actions/checkout@v2`. M.b.v. deze action wordt `git checkout` op de repo uitgevoerd zodat de andere workflow stappen de bestanden in de repo kan benaderen
2. `Create User Stories IO` script. Deze script maakt het *user-stories-dev.md* bestand aan. Met de eerste *echo* statement wordt YAML front matter (te gebruiken layout template en titel) en met de tweede *echo* statement wordt de tekst `# User stories` naar het bestand geschreven
3. `lee-dohm/select-matching-issues@v1.2.0`. Met deze action worden issues geselecteerd in de GitHub repository met labels "User Story" en "v[major].[minor]". De gevonden issues worden weggeschreven naar issues-tmp.md. Dit wordt gedaan omdat de action het opgegeven bestand (m.b.v. de *path* parameter) overschrijft indien deze al bestaat
4. `cat issues-tmp.md >> user-stories-dev.md` statement. Hiermee wordt de inhoud van issues-tmp.md toegevoegd aan het *user-stories-dev.md* bestand
5. `Create User Stories Prod` script. Deze script maakt het *user-stories-prod.md* bestand aan. Met de eerste *echo* statement wordt YAML front matter (te gebruiken layout template en titel) en met de tweede *echo* statement wordt de tekst `# User stories` naar het bestand geschreven
6. `lee-dohm/select-matching-issues@v1.2.0`. Met deze action worden issues geselecteerd in de GitHub repository met labels "User Story" en "v[major].[minor]". De gevonden issues worden weggeschreven naar issues-tmp.md. Dit wordt gedaan omdat de action het opgegeven bestand (m.b.v. de *path* parameter) overschrijft indien deze al bestaat
7. `cat issues-tmp.md >> user-stories-prod.md` statement. Hiermee wordt de inhoud van issues-tmp.md toegevoegd aan het *user-stories-prod.md* bestand
8. Stap 6 en 7 worden herhaald voor elke major-minor versie combinatie van issues die al in de productie versie zijn geïmplementeerd
9. `target=_blank toevoegen aan issue link` script. Met behulp van de *sed* command en de regular expression *s/)$/){:target="_blank" rel="noopener"}/* wordt in **user-stories-dev.md** en **user-stories-prod.md** gezocht naar regels die eindigen met een *)*. De *)* wordt vervolgens vervangen met de tekst *){:target="_blank" rel="noopener"}*
10. `move user-stories markdown bestanden naar ./docs` script. Met behulp van deze script worden de **user-stories-dev.md** en **user-stories-prod.md** bestanden verplaatst naar de *docs* map
11. `commit & push user-stories markdown bestanden` script. Deze script controleert of de **user-stories-dev.md** en **user-stories-prod.md** bestanden zijn gewijzigd. Indien dit het geval is, dan worden deze bestanden ge-commit en ge-push-t naar de GitHub repository

[1]: https://docs.github.com/en/free-pro-team@latest/actions
[2]: https://docs.github.com/en/free-pro-team@latest/actions/reference/events-that-trigger-workflows
[3]: https://github.com/marketplace?type=actions
[4]: https://stoplight.io/open-source/spectral/
[5]: https://mvnrepository.com/artifact/io.swagger.codegen.v3/swagger-codegen-cli
[6]: https://openapi-generator.tech/
[7]: https://github.com/postmanlabs/openapi-to-postman
[8]: https://github.com/marketplace/actions/select-matching-issues
[9]: ./haal-centraal-npm-beheer.md

Deze workflow maakt gebruik van de secret USER_TOKEN, een ge-encrypte omgevingsvariabele waarin acces tokens zijn vastgelegd waarmee autorisatie verkregen kan worden voor het aanbrengen van wijzigingen op de repository.
Een beschrijving van het verkrijgen van een access token en de configuratie van deze secret staat beschreven in [Haal Centraal NPM beheer](haal-centraal-npm-beheer.md).