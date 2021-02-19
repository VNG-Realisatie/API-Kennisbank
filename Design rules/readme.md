# Design Rules VNGRealisatie
In de onderliggende Design Rules zijn de inzichten vastgelegd die zijn opgedaan bij het ontwerpen en specificeren van API's binnen diverse projecten waar VNG Realisatie bij betrokken is.
Deze Design Rules zijn binnen het team Standaarden besproken en er is consensus bereikt over het feit dat deze Design Rules toegepast worden op API-specificaties die door VNR Realisatie worden gemaakt of in beheer worden genomen.

Dit is een levende set van Design Rules die beïnvloed kan worden door voortschrijdend inzicht en door technologische ontwikkelingen.

Om die reden kan het zijn dat de specificaties die door VNG Realisatie zijn opgesteld of in beheer zijn genomen niet voldoen aan alle Design Rules.
Op het moment dat een nieuwe versie van een dergelijke  API-specificatie gepland wordt waarmee breaking changes worden doorgevoerd bepaalt de betreffende designer of dat een kans is om correcties door te voeren waardoor de API weer voldoet aan de onderstaande Design Rules.

Een nieuwe versie van een API specificatie met een breaking change houdt dus niet automatisch in dat deze is aangepast aan de Design Rules.

VNG conformeert zich aan de [Design Rules en de Rest-principes van de landelijke API-strategie](https://docs.geostandaarden.nl/api/API-Designrules/). Daar komen de onderstaande punten aan bod.

_2.2 RESTful principles_

_API principle: operations are Safe and/or Idempotent_

_API principle: do not maintain state information at the server_

_API principle: Only apply default HTTP operations_

_API principle: Leave off trailing slashes from API endpoints_

_API principle: Define interfaces in Dutch unless there is an official English glossary_

API principle: Use plural nouns to indicate resources
API principle: Create relations of nested resources within the endpoint
API principle: Implement custom representation if supported
API principle: Implement operations that do not fit the CRUD model as sub-resources
API principle: Documentation conforms to OAS v3.0 or newer
API principle: Publish documentation in Dutch unless there is existing documentation in English or there is an official English glossary available
API principle: Include a deprecation schedule when publishing API changes

2.3.1 Best practice(s)
API principle: Publish OAS at a base-URI in JSON-format
API principle: Allow for a (maximum) 1 year deprecation period to a new API version
API principle: Include only the major version number in the URI


3. Normative API Principles

3.1 API-01: Operations are Safe and/or Idempotent
3.2 API-02: Do not maintain state information at the server
3.3 API-03: Only apply default HTTP operations
3.4 API-04: Define interfaces in Dutch unless there is an official English glossary
3.5 API-05: Use plural nouns to indicate resources
3.6 API-06: Create relations of nested resources within the endpoint
3.7 API-09: Implement custom representation if supported
3.8 API-10: Implement operations that do not fit the CRUD model as sub-resources
3.9 API-16: Use OAS 3.0 for documentation
3.10 API-17: Publish documentation in Dutch unless there is existing documentation in English or there is an official English glossary available
3.11 API-18: Include a deprecation schedule when publishing API changes
3.12 API-19: Allow for a maximum 1 year transition period to a new API version
3.13 API-20: Include the major version number only in ihe URI
3.14 API-48: Leave off trailing slashes from API endpoints
3.15 API-51: Publish OAS at the base-URI in JSON-format_


## 1. Redundantie in propertynamen wordt verwijderd

Onderstaande Design Rules zijn een verbijzondering van paragraaf 6.1 van de [API DesignRules Extensions](https://docs.geostandaarden.nl/api/API-Strategie-ext/#field-names-in-snake_case-camelcase-uppercamelcase-or-kebab-case).

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
Onderstaande Design Rules gelden duas alleen **als** er sprake is van het toepassen van JSON Hal.  

## 4. Historie


## 5. Diversen
x
