# Design Rules VNGRealisatie

## Inleiding

In de onderliggende Design Rules zijn de inzichten vastgelegd die zijn opgedaan bij het ontwerpen en specificeren van API's binnen diverse projecten waar VNG Realisatie bij betrokken is.
Deze Design Rules zijn binnen het team Standaarden besproken en er is consensus bereikt over het feit dat deze Design Rules toegepast worden op API-specificaties die door VNR Realisatie worden gemaakt of in beheer worden genomen.

Dit is een levende set van Design Rules die beïnvloed kan worden door voortschrijdend inzicht en door technologische ontwikkelingen. We houden bij een Design Rule bij wanneer we deze hebben toegevoegd, wanneer die is gewijzigd en indien van toepassing wanneer deze is afgevoerd. Door een opmerking te plaatsen en de datum van afvoeren toe te voegen.

Om die reden kan het zijn dat de specificaties die door VNG Realisatie zijn opgesteld of in beheer zijn genomen niet voldoen aan alle Design Rules.
Op het moment dat een nieuwe versie van een dergelijke  API-specificatie gepland wordt waarmee breaking changes worden doorgevoerd bepaalt de betreffende designer of dat een kans is om correcties door te voeren waardoor de API weer voldoet aan de onderstaande Design Rules.

Een nieuwe versie van een API specificatie met een breaking change houdt dus niet automatisch in dat deze is aangepast aan de Design Rules.

## Landelijke API-strategie

VNG conformeert zich aan de [Design Rules en de Rest-principes van de landelijke API-strategie](https://docs.geostandaarden.nl/api/API-Designrules/). Daar komen de onderstaande punten aan bod.

_RESTful principles_

- _API principle: operations are Safe and/or Idempotent_
- _API principle: do not maintain state information at the server_
- _API principle: Only apply default HTTP operations_
- _API principle: Leave off trailing slashes from API endpoints_
- _API principle: Define interfaces in Dutch unless there is an official English glossary_
- _API principle: Use plural nouns to indicate resources_
- _API principle: Create relations of nested resources within the endpoint_
- _API principle: Implement custom representation if supported_
- _API principle: Implement operations that do not fit the CRUD model as sub-resources_
- _API principle: Documentation conforms to OAS v3.0 or newer_
- _API principle: Publish documentation in Dutch unless there is existing documentation in English or there is an official English glossary available_
- _API principle: Include a deprecation schedule when publishing API changes_

_Best practice(s)_
- _API principle: Publish OAS at a base-URI in JSON-format_
- _API principle: Allow for a (maximum) 1 year deprecation period to a new API version_
- _API principle: Include only the major version number in the URI_


_Normative API Principles_

- _3.1 API-01: Operations are Safe and/or Idempotent_
- _3.2 API-02: Do not maintain state information at the server_
- _3.3 API-03: Only apply default HTTP operations_
- _3.4 API-04: Define interfaces in Dutch unless there is an official English glossary_
- _3.5 API-05: Use plural nouns to indicate resources_
- _3.6 API-06: Create relations of nested resources within the endpoint_
- _3.7 API-09: Implement custom representation if supported_
- _3.8 API-10: Implement operations that do not fit the CRUD model as sub-resources_
- _3.9 API-16: Use OAS 3.0 for documentation_
- _3.10 API-17: Publish documentation in Dutch unless there is existing documentation in English or there is an official English glossary available_
- _3.11 API-18: Include a deprecation schedule when publishing API changes_
- _3.12 API-19: Allow for a maximum 1 year transition period to a new API version_
- _3.13 API-20: Include the major version number only in ihe URI_
- _3.14 API-48: Leave off trailing slashes from API endpoints_
- _3.15 API-51: Publish OAS at the base-URI in JSON-format_

De [niet-normatieve extensions van de landelijke API-strategie](https://docs.geostandaarden.nl/api/API-Designrules/) worden behandeld als richtlijnen bij het opstellen van API-specificaties. Als er binnen VNG Realisatie een aanscherping is gedaan is deze in het volgende hoofdstuk opgenomen als VNG Design Rule. Daarbij wordt ook een verwijzing opgenomen naar de betreffende extension.

## VNG Design DesignRules

## 1. Naamgeving

Onderstaande Design Rules zijn een verbijzondering van paragraaf 6.1 van de [API DesignRules Extensions](https://docs.geostandaarden.nl/api/API-Strategie-ext/#field-names-in-snake_case-camelcase-uppercamelcase-or-kebab-case).

### DR1.1 Redundantie in propertynamen wordt verwijderd.
Dit is het geval wanneer in een propertynaam de gegevensgroepnaam of resourcenaam waar deze zich in bevindt wordt herhaald.

Bijvoorbeeld _verblijfstitelIngeschrevenNatuurlijkPersoon_ wordt _verblijfstitel_, _overlijdenIngeschrevenNatuurlijkPersoon_ wordt _overlijden_, _geboorteIngeschrevenNatuurlijkPersoon_ wordt _geboorte_, enz.

_**Ratio**_
* De propertynamen worden erg lang. Dit is niet bevorderlijk voor eenvoud van implementatie.
* Extensie "IngeschrevenNatuurlijkPersoon" is redundant, want het is al duidelijk dat het gaat over eigenschappen van een ingeschreven natuurlijk persoon omdat de property is gedefinieerd in een context binnen de OAS3.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

### DR1.2 Gebruik zelfverklarende propertynamen.

We benoemen altijd zo duidelijk mogelijk wat iets is.
Hoofdregel is altijd: propertynamen moeten zoveel mogelijk zelfverklarend zijn (lezen van de description om de betekenis te begrijpen is liefst niet nodig).
Propertynamen zijn zo kort als mogelijk om toch voldoende duidelijk en onderscheidend te zijn en niet langer dan daarvoor nodig.

_**Ratio:**_ Het is voor developers van consumer-software van belang om zo snel mogelijk te begrijpen waar de content van het bericht over gaat.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

### DR1.3 Namen van properties zijn in lowerCamelCase

Dit is een verbijzondering van [API-26](https://geonovum.github.io/KP-APIs/API-strategie-extensies/#api-26) uit de landelijke API-strategie Design Rule Extensions.

_**Ratio:**_ Consistentie in Casing van namen is voor zowel developers als designers prettiger werken.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

### DR1.4 Namen van schemacomponenten zijn in UpperCamelCase

Voor de namen van componenten in het schema wordt UpperCamelCase toegepast en bevatten geen underscores.

_**Ratio:**_ Consistentie in Casing van namen is voor zowel developers als designers prettiger werken.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

### DR1.5 Namen van endpoints en url's bevatten alleen kleine letters

Voor de namen van endpoints, url's worden alleen kleine letters gebruikt.

_**Ratio:**_ Domein namen zijn case insensitive volgens [RFC 4343](https://tools.ietf.org/html/rfc4343). Om duidelijkheid te creëren over de aanroep van de endpoints wordt de url lower case gedefinieerd.

Datum opname : 29-04-2021
Datum wijziging : 29-04-2021

### DR1.6 Neem 'tot' of 'totEnMet' op in de naam van een einddatum

Als voor een einddatum geen functioneel duidende naam is (bv. datumOntbindingHuwelijk) neem dan voor einddatums altijd expliciet in de naam de string "tot" of "totEnMet" op.

_**Ratio:**_ Het is niet eenduidig of een einddatum een "tot"-datum is of een "totEnMet"-datum is. Dat is afhankelijk van de functionele context. Door deze postfix te gebruiken maak je het expliciet.

Datum opname : 29-04-2021
Datum wijziging : 29-04-2021

## 2. Waarden, Enumeraties en dynamische lijsten

### DR2.1 Voor het uitdrukken van tijdsduur gebruiken we de ISO-8601 standaard
Voor een element van een referentielijst-type, wordt in de response zowel de code als de omschrijving opgenomen. Dit betreft dynamische lijsten (tabellen) met een code en waarde, zoals "Tabel 32 Nationaliteitentabel".

_**Ratio:**_

Dit is een veelgebruikte internationale standaard.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

### DR2.2 Gebruik een boolean voor Ja/Nee of waar/onwaar

Eigenschappen die functioneel alleen de waarde Ja/aan/waar of Nee/uit/onwaar kunnen hebben, worden gedefinieerd als boolean. We gebruiken dus geen enumeratie zoals [J,N] voor dit soort situaties.

_**Ratio:**_ Een boolean is technisch eenduidiger en beter verwerkbaar voor developers.

Datum opname : 29-04-2021
Datum wijziging : 29-04-2021

### DR2.3 Dynamische domeinwaarden worden in de query-parameters met de code opgenomen

Voor een query-parameter waarin een entry uit een waardelijst of een landelijke tabel als selectie-criterium wordt gebruikt wordt de code van de entry gebruikt.

_**Ratio:**_ De omschrijving is human readable tekst. Daar kunnen verschillen in staan, bijvoorbeeld hoofd- of kleine letters. Voor een computer een verschil, voor een mens niet. Daarnaast levert het gebruik van codes ook kortere URL's op.

Datum opname : 29-04-2021
Datum wijziging : 29-04-2021

### DR2.4 Enumeratie-waarden zijn in snake_case

Voor de waarden van enumeraties wordt snake_case toegepast. Deze bevatten dus alleen kleine letters, cijfers en underscores. Geen spaties, geen speciale tekens en geen hoofdletters.

_**Ratio:**_ In sommige development-omgevingen leveren hoofdletters, spaties of speciale tekens in enumeratie-waarden een probleem op met code-genereren.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

### DR2.5 Schema componentnamen voor domeinwaarden en enumeraties krijgen een vaste extensie

Schema componenten voor dynamische domeinwaarden (referentielijsten zoals "Tabel 32 Nationaliteitentabel") en enumeraties krijgen respectievelijk extensie "Tabel" en "Enum" zonder de toevoeging van underscores.

_**Ratio:**_ Vaak heeft de property dezelfde naam als de enumeratie die aangemaakt wordt. Onderscheid is dan prettig en soms zelfs nodig i.r.t. codegenratie. Hetzelfde argument geldt voor referentielijsten.

Datum opname : 29-04-2021
Datum wijziging : 29-04-2021

## 3. HAL, embedding en links

Het toepassen van het content-type hal+json is een keuze en geen verplichting. Het is aan te raden bij API's waar discoverability (bv. bij bevraging API's) voor de consumer een belangrijk aspect is.
Onderstaande Design Rules gelden duas alleen **als** er sprake is van het toepassen van JSON Hal.  

## 4. Diversen

### DR4.1 Identificatie van een resource zit altijd op het hoogste niveau van de resource

De identificatie van een resource zit  altijd op het hoogste niveau van de resource. Als de identificatie als parameter wordt gebruikt is dat in de vorm en inhoud zoals de identificatie is opgenomen in de resource.

Datum opname : 29-04-2021
Datum wijziging : 29-04-2021

### DR4.2 Neem voor properties geen waarden op met een speciale betekenis

We nemen geen waarden op met een speciale betekenis die afwijkt van de normale betekenis van het gegeven.

bijvoorbeeld datum "0000-00-00" om aan te geven dat een datum onbekend is
bijvoorbeeld landcode "0000" om aan te geven dat het land onbekend is

Ratio: Als er informatie beschikbaar is moet die als zondanig onderkend en gemodelleerd worden.

Datum opname : 29-04-2021
Datum wijziging : 29-04-2021

### DR4.3 De description van een property moet semantisch overeenkomen met de betekenis van het gegeven in een gegevenswoordenboek (infromatiemodel)

We nemen bij een property een description op die semantisch overeenkomt met de beschrijving in het gegevenswoordenboek. Deze kan ingekort, vereenvoudigd, of uitgebreid zijn, maar mag de betekenis van het gegeven niet laten afwijken van de betekenis van het corresponderende gegeven in het gegevenswoordenboek.

De description kan worden weggelaten wanneer evident is dat de gebruikers van de API uit de propertynaam weten wat bedoeld wordt (bijvoorbeeld huisnummer).

_**Ratio:**_ Om de description leesbaar te houden voor developers kan ervoor gekozen worden deze in te korten of
binnen de context te vereenvoudigen.

Datum opname : 29-04-2021
Datum wijziging : 29-04-2021

### DR4.4 Plaats bij het gebruik van 'allOf' het hergebruikte component als eerste.

Bij het gebruik van 'allOf' staat de component die hergebruikt wordt altijd eerst, en staan de toegevoegde properties als tweede.

Voorbeeld van het correct gebruik van 'allOf':

```NaamPersoon:
       allOf:
         - $ref: "#/components/schemas/Naam"
         - description: "Gegevens over de naam van de persoon"
           properties:
             aanhef:
               type: "string"  
```

Voorbeeld van _**foutief**_ gebruik van 'allOf':
```
 	NaamPersoon:
 	      allOf:
 	        - description: "Gegevens over de naam van de persoon"
 	          properties:
 	            aanhef:
 	              type: "string"
 	        - $ref: "#/components/schemas/Naam"
```

_**Ratio:**_ Afwijken van deze regel leidt tot problemen bij het genereren van code uit de API specificaties.

Datum opname : 29-04-2021
Datum wijziging : 29-04-2021

### DR4.5 Bij het gebruik van 'allOf' is er slechts 1 component waarnaar gerefereerd wordt

Bij gebruik van allOf is er altijd exact één component waarnaar gerefereerd wordt en één gedefinieerd object met ten minste één property.

Voorbeeld van het foutief gebruik van allOf:

```
     NaamPersoon:
       allOf:
         - $ref: "#/components/schemas/Naam"
         - $ref: "#/components/schemas/Aanschrijfwijze"
         - description: "Gegevens over de naam van de persoon"
           properties:
             aanhef:
               type: "string"
```

Er wordt hier uit twee componenten overgeërfd wat niet correct is.

Voorbeeld van het foutief gebruik van allOf:
```
     NaamPersoon:
       allOf:
         - $ref: "#/components/schemas/Naam"
         - description: "Gegevens over de naam van de persoon"
```

NaamPersoon heeft geen eigen properties wat niet correct is.

Voorbeeld van correct gebruik van allOf:

```
     Naam:
      type: "object"
      properties:
        geslachtsnaam:
          type: "string"
          description: |
                        De achternaam van een persoon.
          example: "Vries"
        voorletters:
          type: "string"
          description: |
                        De voorletters van de persoon, afgeleid van de voornamen.
          example: "P.J."

      NaamPersoon:
       allOf:
         - $ref: "#/components/schemas/Naam"
         - description: "Gegevens over de naam van de persoon"
           properties:
             aanhef:
               type: "string"
             aanschrijfwijze:
               type: "string"
```

_**Ratio:**_

Afwijken van deze regel leidt tot problemen bij het genereren van code uit de API-specificaties.

Datum opname: 15-04-2021
Datum wijziging: 15-04-2021


## 5. Historie

x
