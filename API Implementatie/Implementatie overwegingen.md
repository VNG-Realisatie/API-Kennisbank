---
layout: page-with-side-nav
title: API Kennisbank
---

**WAARSCHUWING!**

**Dit document is in ontwikkeling en is daarom nog aan wijzigingen onderhevig.**

# Inleiding

Bij het realiseren van API's op basis van de (mede) door VNG-realisatie vervaardigde API standaarden in Referentie Implementaties, landelijke voorzieningen of andere 
systemen worden besluiten genomen m.b.t. de implementatie. Dit document bevat beschrijvingen van die besluiten met als doel deze aan andere projecten mee te geven ter
overweging.

Bij elke beschrijving worden naast de beschrijving ook de reden voor het besluit en links naar gerelateerde issues uit het gerelateerde GitHub project opgenomen.
Zo kan het hoe en waarom van een te overwegen implementatieregel altijd worden achterhaald.

## Overwegingen

### Ondersteun in een fields parameter ook niet uniek gedefinieerde propertynamen.

T.b.v. gebruikersgemak is het gebruik van verbijzonderende toevoegingen aan property-namen in een fields parameter niet verplicht.
Functionaliteit is daarbij als volgt:

* Als de opgegeven veldnaam of het opgegeven pad exact voorkomt in de resource, Dan wordt dat veld teruggegeven
* Anders: Als de opgegeven veldnaam of het opgegeven pad voorkomt in een groep of sub-groep in de resource, en er is maar één veld in de resource waarvoor dit geldt, Dan wordt dat veld teruggegeven.
* Anders: Als de opgegeven veldnaam of het opgegeven pad meerdere keren voorkomt (in een groep of sub-groep) in de resource, Dan wordt een foutmelding teruggegeven.

Uitgaande van de volgende collectie:

```[{
"id": 1,
"status": "actief",
"overheid": {
  "code": "0000",
  "naam": "Ministerie van BZK"
}
}, {
"id": 2,
"status": "inactief",
"overheid": {
  "code": "9901",
  "naam": "Provincie Gelderland"
}
}]
```

Mag je dus m.b.v. het 'fields' parameter filteren met '/overheid.code=0000' maar ook met '/code=0000'.

_**Ratio**_
* Deze constructie is het meest vriendelijk en duidelijk voor gebruikers.
* Zonder deze functionaliteit is de kans op een url met meer dan 1000 karakter groter. Op basis van dit besluit kan de lengte van een url worden beperkt.

_**Links**_<br/>
[Issue 44 HaalCentraal Common](https://github.com/VNG-Realisatie/Haal-Centraal-common/issues/44)<br/>
[Issue 265 HaalCentraal BAG Bevragen](https://github.com/VNG-Realisatie/Haal-Centraal-BAG-bevragen/issues/265)<br/>
[Issue 74 HaalCentraal Common](https://github.com/VNG-Realisatie/Haal-Centraal-common/pull/74)

**Let op!** In API Designrule API-30 van de NL API Strategie staat dat de waarde van een field parameter altijd moet corresponderen met opzoekbare velden. 
Daarmee wordt bedoelt dat uit de waarde exact opgemaakt kan worden welke property gevraagd wordt. Er bestaan in de opgevraagde resource dus niet meerdere velden die
voldoen aan de veldwaarde. Bovenstaande overweging komt daar niet mee overeen en de genoemde API Designrule moet hier dan ook nog mee in overeenstemming worden 
gebracht.

### Gebruik voor interne links relatieve urls
Maak binnen berichten zo mogelijk gebruik van relatieve urls.
Dus niet: 

```"_links" : {
"adressen" : [
{
"href" : "https://www.voorbeeld.nl/v1.1/adressen/0014200010877405"
},
{
"href" : "https://www.voorbeeld.nl/v1.1/adressen/0014200022197986"
}
],
"panden" : [
{
"href" : "https://www.voorbeeld.nl/v1.1/panden/0014100010921152"
}
],
"self" : {
"href" : "https://www.voorbeeld.nl/v1.1/adresseerbareobjecten/0014010011067299"
```

maar:

```"_links" : {
"adressen" : [
{
"href" : "/adressen/0014200010877405"
},
{
"href" : "/adressen/0014200022197986"
}
],
"panden" : [
{
"href" : "/panden/0014100010921152"
}
],
"self" : {
"href" : "/adresseerbareobjecten/0014010011067299"
```

_**Ratio**_
Het voordeel hierrvan is dat er geen vertaling in de berichten hoeft te worden gedaan wanneer de API wordt gebruikt via een servicebus of API gateway.

_**Links**_<br/>
[Issue 234 HaalCentraal BAG Bevragen](https://github.com/VNG-Realisatie/Haal-Centraal-BAG-bevragen/issues/234)
