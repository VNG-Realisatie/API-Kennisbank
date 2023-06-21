---
layout: page-with-side-nav
title: API Design rules - Naamgeving
---


# 1. Naamgeving

Onderstaande Design Rules zijn een verbijzondering van paragraaf 6.1 van de [API DesignRules Extensions](https://docs.geostandaarden.nl/api/API-Strategie-ext/#field-names-in-snake_case-camelcase-uppercamelcase-or-kebab-case).

## DR1.1 Redundantie in propertynamen wordt verwijderd.
Dit is het geval wanneer in een propertynaam de gegevensgroepnaam of resourcenaam waar deze zich in bevindt wordt herhaald.

Bijvoorbeeld _verblijfstitelIngeschrevenNatuurlijkPersoon_ wordt _verblijfstitel_, _overlijdenIngeschrevenNatuurlijkPersoon_ wordt _overlijden_, _geboorteIngeschrevenNatuurlijkPersoon_ wordt _geboorte_, enz.

_**Ratio**_
* De propertynamen worden erg lang. Dit is niet bevorderlijk voor eenvoud van implementatie.
* Extensie "IngeschrevenNatuurlijkPersoon" is redundant, want het is al duidelijk dat het gaat over eigenschappen van een ingeschreven natuurlijk persoon omdat de property is gedefinieerd in een context binnen de OAS3.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

## DR1.2 Gebruik zelfverklarende propertynamen.

We benoemen altijd zo duidelijk mogelijk wat iets is.
Hoofdregel is altijd: propertynamen moeten zoveel mogelijk zelfverklarend zijn (lezen van de description om de betekenis te begrijpen is liefst niet nodig).
Propertynamen zijn zo kort als mogelijk om toch voldoende duidelijk en onderscheidend te zijn en niet langer dan daarvoor nodig.

_**Ratio:**_ Het is voor developers van consumer-software van belang om zo snel mogelijk te begrijpen waar de content van het bericht over gaat.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

## DR1.3 Namen van properties zijn in lowerCamelCase

Dit is een verbijzondering van [API-26](https://geonovum.github.io/KP-APIs/API-strategie-extensies/#api-26) uit de landelijke API-strategie Design Rule Extensions.

_**Ratio:**_ Consistentie in Casing van namen is voor zowel developers als designers prettiger werken.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

## DR1.4 Namen van schemacomponenten zijn in UpperCamelCase

Voor de namen van componenten in het schema wordt UpperCamelCase toegepast en bevatten geen underscores.

_**Ratio:**_ Consistentie in Casing van namen is voor zowel developers als designers prettiger werken.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

## DR1.5 Namen van endpoints en url's bevatten alleen kleine letters

Voor de namen van endpoints, url's worden alleen kleine letters gebruikt.

_**Ratio:**_ Domein namen zijn case insensitive volgens [RFC 4343](https://tools.ietf.org/html/rfc4343). Om duidelijkheid te creëren over de aanroep van de endpoints wordt de url lower case gedefinieerd.

Datum opname : 29-04-2021
Datum wijziging : 29-04-2021

## DR1.6 Neem 'tot' of 'totEnMet' op in de naam van een einddatum

Als voor een einddatum geen functioneel duidende naam is (bv. datumOntbindingHuwelijk) neem dan voor einddatums altijd expliciet in de naam de string "tot" of "totEnMet" op.

_**Ratio:**_ Het is niet eenduidig of een einddatum een "tot"-datum is of een "totEnMet"-datum is. Dat is afhankelijk van de functionele context. Door deze postfix te gebruiken maak je het expliciet.

Datum opname : 29-04-2021
Datum wijziging : 29-04-2021
