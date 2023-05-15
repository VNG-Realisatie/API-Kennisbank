---
layout: page-with-side-nav
title: API Kennisbank
---

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

## DR4.4 Als meerdere componenten dezelfde properties bevatten (generalisatie) gebruik dan de 'allOf' om deze samenhang vorm te geven.

Wanneer er meerdere componenten zijn met meerdere dezelfde properties, moet er hergebruik worden gemaakt via een 'allOf' constructie. Dit sluit aan op object oriëntatie in de verschillende programmeeromgevingen.

Bijvoorbeeld een woonadres en een postadres zijn identiek, behalve dat postadres ook een postbusnummer kent. Dan is postadres een extensie op woonadres.
Bijvoorbeeld een natuurlijk persoon en een niet-natuurlijk persoon hebben beide een naam en een adres, maar beide hebben ook eigen gegevens (natuurlijk persoon heeft geboortedatum, niet-natuurlijk persoon heeft eigenaar), dan zijn beide een extensie op een bovenliggende component "Persoon".
Bijvoorbeeld bij een zakelijkGerechtigde worden alleen minimale identificerende gegevens van een persoon opgenomen (alleen naam en identificatie), maar bij de persoon (resource) worden meer eigenschappen van de persoon opgenomen (zoals adres). Dan gebruikt zakelijkGerechtigde het component "persoonBeperkt" en is de uitgebreide persoon een extensie hierop.

Voorbeeld:

```
     Adres:
      type: "object"
      properties:
        straat:
          type: "string"
          example: "Nassaulaan"
        huisnummer:
          type: "integer"
          example: 12
        postcode:
          type: "string"
          example: "2514JS"
        woonplaats:
          type: "string"
          example: "Den Haag"

      PostAdres:
       allOf:
         - $ref: "#/components/schemas/Adres"
         - properties:
             postbusnummer:
               type: "integer"
               example: 300
```

## DR4.5 Plaats bij het gebruik van 'allOf' het hergebruikte component als eerste.

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

## DR4.6 Bij het gebruik van 'allOf' is er slechts 1 component waarnaar gerefereerd wordt

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

















Wanneer er meerdere componenten zijn met meerdere dezelfde properties, moet er hergebruik worden gemaakt via een 'allOf' constructie. Dit sluit aan op object oriëntatie in de verschillende programmeeromgevingen.

Bijvoorbeeld een woonadres en een postadres zijn identiek, behalve dat postadres ook een postbusnummer kent. Dan is postadres een extensie op woonadres.
Bijvoorbeeld een natuurlijk persoon en een niet-natuurlijk persoon hebben beide een naam en een adres, maar beide hebben ook eigen gegevens (natuurlijk persoon heeft geboortedatum, niet-natuurlijk persoon heeft eigenaar), dan zijn beide een extensie op een bovenliggende component "Persoon".
Bijvoorbeeld bij een zakelijkGerechtigde worden alleen minimale identificerende gegevens van een persoon opgenomen (alleen naam en identificatie), maar bij de persoon (resource) worden meer eigenschappen van de persoon opgenomen (zoals adres). Dan gebruikt zakelijkGerechtigde het component "persoonBeperkt" en is de uitgebreide persoon een extensie hierop.
