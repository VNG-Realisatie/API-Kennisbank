# Design decisions VNGRealisatie
In de onderliggende Design Decisions zijn de inzichten vastgelegd die zijn opgedaan bij het ontwerpen en specificeren van API's binnen diverse projecten waar VNG Realisatie bij betrokken is.
Deze design decisions zijn binnen het team Standaarden besproken en er is consensus bereikt over het feit dat deze design decisions toegepast worden op API-specificaties die door VNR Realisatie worden gemaakt of in beheer worden genomen.

Dit is een levende set van design decissions die beïnvloed kan worden door voortschrijdend inzicht en door technologische ontwikkelingen.

Om die reden kan het zijn dat de specificaties die door VNG Realisatie zijn opgesteld of in beheer zijn genomen niet voldoen aan alle Design Decisions.
Op het moment dat een nieuwe versie van een dergelijke  API-specificatie gepland wordt waarmee breaking changes worden doorgevoerd bepaalt de betreffende designer of dat een kans is om correcties door te voeren waardoor de API weer voldoet aan de onderstaande Design Decisions.

Een nieuwe versie van een API specificatie met een breaking change houdt dus niet automatisch in dat deze is aangepast aan de Design Decisions.

Van de common.yaml specificatie, in de onderliggende repository, wordt zo nodig wel steeds direct een nieuwe versie uitgebracht.
In de releasenotes wordt dan aangegeven of de wijziging breaking is of niet (wat ook gevolgen kan hebben voor het versienummer). Daarmee kunnen nieuwe API's en API's in ontwikkeling optimaal bediend worden. Voor API's die gebruik maken van een "oude" versie van common.yaml geldt dat de API-designer bepaalt of bij een wijziging een nieuwe versie van de common.Yaml wordt gebruikt. De basis voor die beslissing is de impact voor de afnemers (consumers).

## 1. Redundantie in propertynamen wordt verwijderd

Onderstaande Design Decisions zijn een verbijzondering van paragraaf 6.1 van de [API Designrules Extensions](https://docs.geostandaarden.nl/api/API-Strategie-ext/#field-names-in-snake_case-camelcase-uppercamelcase-or-kebab-case).

### DD1.1 Geef een zo duidelijk mogelijke naam
Dit is het geval wanneer in een propertynaam de gegevensgroepnaam of resourcenaam waar deze zich in bevindt wordt herhaald.

Bijvoorbeeld _verblijfstitelIngeschrevenNatuurlijkPersoon_ wordt _verblijfstitel_, _overlijdenIngeschrevenNatuurlijkPersoon_ wordt _overlijden_, _geboorteIngeschrevenNatuurlijkPersoon_ wordt _geboorte_, enz.

_**Ratio**_
* De propertynamen worden erg lang. Dit is niet bevorderlijk voor eenvoud van implementatie.
* Extensie "IngeschrevenNatuurlijkPersoon" is redundant, want het is al duidelijk dat het gaat over eigenschappen van een ingeschreven natuurlijk persoon omdat de property is gedefinieerd in een context binnen de OAS3.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

### DD1.2 URIs eindigen nooit op een trailing slash (“/”)

De URIs die gebruikt worden om collecties van objecten, of individuele objecten op te vragen, eindigen nooit op een trailing slash:

Voorbeelden

Goed

/api/v1/zaken
/api/v1/zaken?identificatie=12345
/api/v1/zaken/67890
Fout

/api/v1/zaken/
/api/v1/zaken/?identificatie=12345
/api/v1/zaken/67890/

_**Ratio**_

De DSO heeft hier geen expliciet standpunt over maar alle voorbeelden zijn zonder trailing slash. Daarnaast zijn veel commerciele APIs die dit voorbeeld volgen zoals Google en Facebook. Verschillende bronnen zijn hier wel over verdeeld, zoals REST API tutorial en Wikipedia maar er is gekozen om te kijken naar de praktijk en DSO.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

## 2. Waarden, Enumeraties en dynamische lijsten

### DD2.1 Voor het uitdrukken van tijdsduur gebruiken we de ISO-8601 standaard
Voor een element van een referentielijst-type, wordt in de response zowel de code als de omschrijving opgenomen. Dit betreft dynamische lijsten (tabellen) met een code en waarde, zoals "Tabel 32 Nationaliteitentabel".

_**Ratio**_

Dit is een veelgebruikte internationale standaard.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

## 3. HAL, embedding en links

Het toepassen van het content-type hal+json is een keuze en geen verplichting. Het is aan te raden bij API's waar discoverability (bv. bij bevraging API's) voor de consumer een belangrijk aspect is.
Onderstaande design rules gelden duas alleen **als** er sprake is van het toepassen van JSON Hal.  

## 4. Historie


## 5. Diversen
