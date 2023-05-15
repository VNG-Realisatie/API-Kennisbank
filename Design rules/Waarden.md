---
layout: page-with-side-nav
title: API Kennisbank
---


# 2. Waarden, enumeraties en dynamische lijsten

### DR2.1 Voor het uitdrukken van tijdsduur gebruiken we de ISO-8601 standaard
Een toelichting is [hier](https://nl.wikipedia.org/wiki/ISO_8601) te vinden.

_**Ratio:**_

Dit is een veelgebruikte internationale standaard.

Datum opname : 17-02-2021
Datum wijziging : 29-04-2022 (Toelichting van ISO-8601 standaard toegevoegd)

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

## DR2.6 Beperk de lengte van enumeratiewaarden

De lengte van enumeratiewaarden wordt beperkt. Bijvoorbeeld "Opstalhouder Nutsvoorzieningen op gedeelte van perceel" krijgt als waarde "nutsvoorzieningen_gedeelte". Het is aan de API-designer en de betreffende community om de toe te passen waarden te bepalen. Gebruik alleen enumeraties als de waarde kort, zelfbeschrijvend en stabiel is.

Als er behoefte is aan lange enumeratiewaarde is een referentielijst mogelijk een beter alternatief. Ook als de waarden van de betreffende lijst mutabel is is een referentielijst een betere keuze.

Mocht het toch van belang zijn de lange omschrijving te delen met de comsumer-developer, dan kan deze lange omschrijving opgenomen worden in de description van de enumeratie. Indien gewenst zou deze lange omschrijving dan additioneel aangeboden kunnen worden als property.

'''
taal:
  type: string
  description: |-
    De taal afkorting volgens ISO 639-2:
    * dut - Dutch
    * eng - English
  enum:
  - dut
  - eng
taalWeergave:
  type: string
  description: De volledige naam van de taal
'''

_**Ratio:**_
Vanuit developer-perspectief zijn lange enumeratiewaarde onprettig om mee te werken. Ook het tonen van enumeratiewaarden in de User Interface wordt complex als de enumartiewaarden te onnodig lang zijn.

Datum opname : 29-04-2022
Datum wijziging : 29-04-2022

## DR2.7 Gebruik betekenisvolle enumeratiewaarden

Gebruik enumeratiewaarden die betekenisvol en begrijpelijk zijn. Dus niet M en V, maar man en vrouw. Hierbij moet een afweging gemaakt worden met het toepassen van Design Rule DR2.6

_**Ratio:**_
Een developer moet bij het coderen begrijpen wat de code betekent, om fouten in de implementatie te voorkomen.

## DR2.8 Overweeg een enumeratiewaarde weer te geven als string in een bevraging-API

Het toepassen van een enumratie brengt het risico van tight coupling en breaking changes met zich mee.

Indien een attribuut in het informatiemodel voorkomt als enumeratie, maar de corresponderende property komt alleen voor in de response op een bevraging om aan gebruikers te worden getoond dan is het niet nodig het ook in de API specificaties als een enumeratie te definiëren.

Wanneer de enumeratiewaarde gebruikt wordt in code (algoritmes), definieer dan betekenisvolle maar bondige enumeratiewaarden.

_**Ratio:**_

Het opnemen van een enumeratie in de API-definitie betekent dat voor het kunnen tonen van een nieuwe of gewijzigde waarde in de enumeratie een nieuwe versie van de API moet worden uitgebracht. Voor bevraging-API's is dat een ongewenste vorm van tight coupling.

Als het gegeven echter wordt gebruikt in code (algoritme) dan is het van belang dat er niet afgeweken kan worden van de bekende waarden en is een definitie als enumeratie op zijn plaats.

## DR2.9 Neem een indicator op om de betekenis "magic strings" expliciet te maken.

Wanneer het gevuld zijn van een datum functionele betekenis heeft, ook wanneer deze volledig onbekend is, wordt een indicator opgenomen om dit aan te geven. Als bv een datum veld de waarde "00000000" bevat en dat betekenis heeft wordt niet deze ongeldige waarde opgenomen in een date-veld, maar wordt een indicator toegevoegd.

Indien in het onderstaande voorbeeld er helemaal niets bekend is van de overlijdensdatum, maar er is wel bekend dat de persoon overleden is, dan kan dat nergens uit worden afgeleid. Uit de reponse kan je niet opmaken of de overlijdensdatum leeg is omdat iemand  niet is overleden of omdat de overlijdensdatum niet bekend is.

```
    Persoon:
      type: object
      description: "Natuurlijkpersoon of NietNatuurlijkPersoon"
      properties:
        identificatie:
          type: string
        datumOverleden:  
          $ref: "#/components/schemas/TypePersoonEnum"type: string
        voorletters:
          type: string
```

Door voor een dergelijke situatie een boolean op te nemen waar de betreffende informatie wordt gerepresenteerd wordt duidelijk wat de situatie is zonder dat er invalide waardes hoeven te worden opgenomen in de datum-velden.

```
    Persoon:
      type: object
      description: "Natuurlijkpersoon of NietNatuurlijkPersoon"
      properties:
        identificatie:
          type: string
        datumOverleden:  
          $ref: "#/components/schemas/TypePersoonEnum"type: string
        indicatieOverleden:
          type: boolean
        voorletters:
          type: string
```

_**Ratio:**_
Bijvoorbeeld of een persoon overleden is kan niet worden afgeleid uit het bestaan van een overlijdensdatum wanneer die datum onbekend is. Daarvoor kan een boolean "indicatieOverleden" worden gedefinieerd.
