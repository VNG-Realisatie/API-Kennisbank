# Haal Centraal tooling

De Haal Centraal projecten gebruiken tooling voor het beheren van de OpenAPI specificaties:

- [Spectral][1] voor het valideren van OpenAPI specificatie documenten. Hiervoor wordt gebruik gemaakt van de standaard ruleset van Spectral aangevuld met eigen regels
- [Swagger Codegen][2] voor het resolven van OpenAPI specificatie documenten. Tijdens het resolven van een OpenAPI specificatie document worden alle externe referenties (referenties naar definities in externe OpenAPI specificatie documenten) vervangen door een lokale referentie. Dit is nodig omdat er OpenAPI tools zijn, zoals code generatoren die niet met externe referenties om kunnen gaan.  
- [OpenAPI Generator][3] voor het genereren van client code voor een OpenAPI specificatie document
- [OpenAPI 3.0 to Postman Collection Converter][4] voor het genereren van een Postman collection voor een OpenAPI specificatie document
- [mvn-dl][5] voor het automatisch downloaden van JAVA packages uit de Maven Repository. [Swagger Codegen][2] wordt namelijk beheerd in de Maven Repository
- [mkdirp][6] voor het aanmaken van mappen. Indien de output parameter voor de [OpenAPI 3.0 to Postman Collection v2.1.0 Converter][4] mappen bevat die nog niet bestaan, dan faalt de conversie. Met [mkdirp][6] kan de niet-bestaande mappen worden aangemaakt voordat de conversie wordt uitgevoerd
- [husky][7] voor het beheren van git hooks in de packages.json bestand

## Prerequisites

- [Node.js][8]. Dit is nodig voor [Spectral][1], de [OpenAPI 3.0 to Postman Collection Converter][4] en [mkdirp][6]
- JAVA 7 of hoger runtime. Dit is nodig voor [Swagger Codegen][2] en [OpenAPI Generator][3]

## Beheer van de tooling en bijbehorende scripts

Voor het configureren en het beheren van de gebruikte versies van de verschillende tooling wordt gebruik gemaakt van npm, de package manager van Node.js.

### Initialiseren van npm voor een Haal Centraal repository

In de lokale map van de repository moet de volgende statement worden uitgevoerd:

``` bash
npm init -y
```

Na het uitvoeren van de statement is een package.json bestand aangemaakt. In dit bestand wordt bijgehouden welke tooling en welke versie van de tooling wordt gebruikt voor de betreffende Haal Centraal repository. In dit bestand worden ook de scripts, voor het automatiseren van de aanroep van de tooling, beheerd.

### Installeren van de tooling

Voor het installeren van de benodigde tools moet de volgende statements worden uitgevoerd:

``` bash
npm install --save-dev @openapitools/openapi-generator-cli
npm install --save-dev @stoplight/spectral
npm install --save-dev husky
npm install --save-dev mkdirp
npm install --save-dev mvn-dl
npm install --save-dev openapi-to-postmanv2
```

De packages die nodig zijn voor de tools worden geïnstalleerd in de *node_modules* map. Behalve in de *package.json* bestand wordt in een *package-lock.json* bestand gegevens bijgehouden over de geïnstalleerde packages.

### Scripts ten behoeve van aanroep van de tools

Om het gebruiken van de benodigde tools te vergemakkelijken en om de aanroep te kunnen automatiseren zijn de volgende scripts aangemaakt. De scripts zijn te vinden onder de **scripts** node in het *package.json* bestand

#### Valideren van de openapi.yaml en de genereervariant van de openapi.yaml bestand

``` bash
"oas:lint": "spectral lint ./specificatie/openapi.yaml"
```

``` bash
"oas:lint-genereervariant": "spectral lint ./specificatie/genereervariant/openapi.yaml"
```

#### Resolven van de externe referenties in het openapi.yaml bestand

Met het volgende script wordt het resolven van het openapi.yaml bestand uitgevoerd. Er worden twee geresolve-de varianten gegenereerd, een yaml en json variant

``` bash
"oas:resolve": "java -jar swagger-codegen-cli.jar generate -i ./specificatie/openapi.yaml -l openapi-yaml -o ./specificatie/genereervariant && java -jar swagger-codegen-cli.jar generate -i ./specificatie/openapi.yaml -l openapi -o ./specificatie/genereervariant"
```

Voor het resolven wordt gebruik gemaakt van *swagger-codegen-cli.jar*. Er is hier voor gekozen omdat SwaggerHub ook *swagger-codegen-cli.jar* als generator gebruikt.

Om het gebruik van *swagger-codegen-cli.jar* te kunnen automatiseren moet deze worden gedownload. Dit wordt gedaan met behulp van het volgende script:

``` bash
"preoas:resolve": "mvn-dl io.swagger.codegen.v3:swagger-codegen-cli:3.0.19 -f swagger-codegen-cli.jar"
```

Door het script dezelfde naam te geven als de resolve script (oas:resolve) en `pre` aan het begin toe te voegen (preoas:resolve), zorgt npm ervoor dat als het oas:resolve script wordt aangeroepen dat het preoas:resolve script eerst wordt uitgevoerd.

Voor het downloaden van het *swagger-codegen-cli.jar* bestand uit de maven repository wordt gebruik gemaakt van de *mvn-dl* npm package

Het opschonen (verwijderen van het *swagger-codegen-cli.jar* bestand) wordt uitgevoerd met het volgende script

``` bash
"postoas:resolve": "rm swagger-codegen-cli.jar"
```

Door het script dezelfde naam te geven als de resolve script en `post` aan het begin toe te voegen, wordt dit script uitgevoerd nadat het *oas:resolve* script is uitgevoerd.

#### Genereren van postman collection

Voor het genereren van de postman collection wordt gebruik gemaakt van het volgende script:

``` bash
"oas:generate-postman-collection": "openapi2postmanv2 -s ./specificatie/genereervariant/openapi.yaml -o ./test/BRK-Bevragen-postman-collection.json --pretty"
```

Omdat de *openapi2postmanv2* package geen mappen aanmaakt, wordt dit gedaan met behulp van het volgende script:

``` bash
"preoas:generate-postman-collection": "mkdirp ./test"
```

Dit script wordt bij aanroep van het *oas:generate-postman-collection* script eerst uitgevoerd door het script dezelfde naam (oas:generate-postman-collection) te geven en `pre` aan het begin van de naam toe te voegen.

#### Genereren van client code

Voor het genereren van client code in .NET (Core en Full Framework versie), JAVA en Python wordt de volgende scripts gebruikt:

``` bash
"oas:generate-client": "openapi-generator-cli generate -i ./specificatie/genereervariant/openapi.yaml --global-property=modelTests=false,apiTests=false,modelDocs=false,apiDocs=false",
"oas:generate-java-client": "npm run oas:generate-client -- -o ./code/java -g java --additional-properties=dateLibrary=java8,java8=true,optionalProjectFile=false,optionalAssemblyInfo=false",
"oas:generate-netcore-client": "npm run oas:generate-client -- -o ./code/netcore -g csharp-netcore --additional-properties=optionalProjectFile=false,optionalAssemblyInfo=false",
"oas:generate-net-client": "npm run oas:generate-client -- -o ./code/net -g csharp --additional-properties=optionalProjectFile=false,optionalAssemblyInfo=false",
"oas:generate-python-client": "npm run oas:generate-client -- -o ./code/python -g python --additional-properties=optionalProjectFile=false,optionalAssemblyInfo=false",
```

Om het herhalen van de aanroep van *openapi-generator-cli* voor elke taal te minimaliseren, is het volgende script gemaakt:

``` bash
"oas:generate-client": "openapi-generator-cli generate -i ./specificatie/genereervariant/openapi.yaml --global-property=modelTests=false,apiTests=false,modelDocs=false,apiDocs=false"
```

Dit script bevat de aanroep van *openapi-generator-cli* en alle opties die voor elke programmeertaal gelijk zijn.

Dit script wordt voor elke programmeer taal aangeroepen door `npm run oas:generate-client --` gevolgd door alle parameters die specifiek zijn voor het betreffende programeertaal.

#### Automatisch valideren van het openapi.yam bestand en de genereervariant bij een commit

Om ervoor te zorgen dat het openapi.yaml bestand alleen kan worden ge-commit als het geen fouten bevat en dat het voldoet aan de ruleset van Spectral en eigen rules, wordt er gebruik gemaakt git hooks. Met behulp van Husky kunnen de hooks in het *package.json* bestand worden gedefinieerd en worden gecommit, zodat de hooks automatisch worden gedeeld met iedereen die de repository clone.

Met behulp van de volgende regels wordt in Husky een pre-commit hook gedefinieerd:

``` bash
"husky": {
  "hooks": {
    "pre-commit": "npm run oas:lint && npm run oas:resolve && npm run oas:lint-genereervariant && git checkout ./specificatie/genereervariant/openapi.*"
  }
}
```

De *husky* node moet als een root node worden toegevoegd aan het package.json bestand.

De *pre-commit* hook voert de volgende scripts bij een commit uit:

- oas:lint
- oas:resolve
- oas:lint-genereervariant
- `git checkout ./specificatie/generereervariant/openapi.*`. Hiermee worden de gewijzigde openapi bestanden in de genereervariant map terug gedraaid

### Updaten van de npm packages in package.json bestand

Het updaten van de npm packages in het package.json bestand kunnen op de volgende manier worden gedaan:

- `npm update`. Deze statement zorgt er voor dat alle gerefereerde npm packages worden geupdate naar de meest recente patch versie
- `npm install \<package-id>`. Deze statement zorgt er voor dat de meest recente versie van het betreffende package wordt geïnstalleerd

Wil je met één statement alle packages updaten naar de meest recente versie, dan moet de volgende statements worden uitgevoerd:

- `npm install -g npm-check-updates`. Hiermee wordt de npm-check-updates npm package globaal geïnstalleerd. Met deze npm package wordt alle npm package referenties in een package.json bestand ge-update naar de meest recente versie
- `ncu -u`. Met deze statement worden de npm package referenties in een package.json bestand ge-update naar de meest recente versie
- `npm install`. Met deze statement worden de packages in de node_modules bestand geupdate aan de hand van het package.json bestand

[1]: https://stoplight.io/open-source/spectral/
[2]: https://mvnrepository.com/artifact/io.swagger.codegen.v3/swagger-codegen-cli
[3]: https://openapi-generator.tech/
[4]: https://github.com/postmanlabs/openapi-to-postman
[5]: https://github.com/laat/mvn-dl
[6]: https://github.com/isaacs/node-mkdirp
[7]: https://typicode.github.io/husky
[8]: https://nodejs.org/en/download/

## Configuratie van de secret USER_TOKEN

Een secret is een ge-encrypte omgevingsvariabele. De secret USER_TOKEN is een secret waarin een acces tokens van een gebruiker zijn vastgelegd. 
Een gebruiker die de benodigde rechten heeft om bewerkingen uit te voeren die de workflow waarin deze secret wordt gebruikt uit moet voeren.
Om deze secret in te richten moet dus eerst een acces token verworven worden waarna de secret daarmee geconfigureerd kan worden.

### Verwerven acces token

Log in GitHub in met het account waarvan je het acces token wil genereren.

Of dit een persoonlijk account moet zijn of juist een organisatie beheer account is afhankelijk van wie de workflow moet kunnen gebruiken.
Over het algemeen maken wij in onze repositories geen scripts die voor persoonlijk gebruik zijn maar in een persoonlijke fork zou dit kunnen. 
De workflows die we in de VNG-Realsatie repositories gebruiken moeten account onafhankelijk gebruikt kunnen worden daarom heeft het de voorkeur om in te loggen met een organisatie beheer account.

Ga daarna naar de account settings. Klik daarvoor op de account avatar en selecteer 'Settings', vervolgens op 'Developer settings' en 'Personal access tokens'.
Klik vervolgens op 'Generate new token' en geef in het 'Note' veld een korte beschrijving van de functie van het access token. Vervolgens moet je de scope van het access token configureren.
Voor de secret 'USER_TOKEN' hoeft alleen de checkbox 'repo' aangeklikt te worden. Klik tenslotte onderaan op 'Generate token'.

Er wordt vervolgens een hexadecimale personal access token code gegenereerd die je dient te kopiëren. 

**Let op!** als je het scherm verlaat en je hebt de code niet gekopieerd of tijdelijk ergens bewaard dan kun je deze niet meer ophalen. 

Gelukkig kun je op dezelfde personal access token wel weer een nieuwe code genereren. Dat kan echter een vervelend effect hebben als je de code in meerdere secrets hebt geplaatst.
Je zult de nieuwe code dan aan al die secrets apart bekend moeten maken.

### Secret configuratie

Een secret kan als domein een repository of een organisatie hebben. 
In het eerste geval is de omgevings variabele alleen binnen de betreffende repository te gebruiken in het tweede geval in alle repositories van de betreffende organisatie.
Een repository secret hoeft niet uniek te zijn binnen de verzameling van repositories van die organisatie. Elke repository kan bijv. dus een secret hebben met de naam 'SECRET_KEY'.
Een repository secret kan zelfs dezelfde naam hebben als een organisation secret. In dat geval overruled het de organization secret.

Het aanmaken van een repository secret en organization secret gaat ongeveer op dezelfde wijze. Bij de eerste klik je binnen de repository of de 'Settings' tab en ga je in het linker menu naar 'Secrets'.
Bij de tweede doe je hetzelfde alleen binnen de organization.

Klik nu op 'New repository secret' resp. 'New organization secret'
Geef de secret een naam waarbij het (vermoedelijk) een goed gebruik is om snakecase met alleen hoofdletters te gebruiken.
Kopieer de eerder verkregen personal access token code in het 'value' veld. Geef bij een organization nog even aan voor welke repositories de secret van toepassing is (repository access).
Klik tenslotte op 'Add secret'.

Het secret kan nu gebruikt worden in de workflows.
