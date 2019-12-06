# Inleiding

Dit document bevat een beschrijving van een aantal design principes. Design principes die zijn toegepast in de huidige API standaardisatie projecten (Zaakgericht Werken en HaalCentraal).
Sommige van deze principes bestonden wellicht al maar anderen zijn gedurende projecten ontwikkeld en/of aangescherpt.

Dit document heeft een tweeledig doel.
1. Ten eerste worden hierin design principes beschreven die toegepast moeten worden bij het ontwerpen van een API standaard.
2. Ten tweede dient dit document als discussie document aangezien in de huidige API standaardisatie projecten op sommige punten verschillende principes gehanteerd worden.
   Uitgangspunt is dat we uiteindelijk overeenstemming bereiken over het te hanteren principe OF dat we duidelijk gaan beschrijven in welke situatie welk principe gehanteerd gaat worden.
   Zodra overeenstemming is bereikt over de design principes zal dit doel komen te vervallen.

# Design principes

## Relaties tussen 2 domeinen

**Motivatie en dominante domeinen**

Bij relaties tussen twee domeinen wil je vanuit elk domein de gerelateerde
gegevens uit het andere domein kunnen opvragen/inkijken. Eén van de domeinen
wordt als dominant/primair domein beschouwt. Soms is heel duidelijk welke dat
is en is dat goed te beargumenteren, andere keren is het een buikgevoel en
lastiger te beargumenteren, of het is gewoon een keuze omdat er geen
natuurlijke dominantie kan aangewezen worden. Voorbeelden hiervan zijn:

(dominante domein in vet)

* **Zaken** en informatieobjecten
* **Zaken** en klaninteracties
* **Besluiten** en informatieobjecten

**Relatieklassen**

Het feit dat een relatie bestaat tussen objecten in twee verschillende domeinen
wordt altijd in beide domeinen vastgelegd, met een specifieke resource voor de
relatieklasse. In ieder domein zijn de relatieklassen als het ware tegenhangers
van elkaar. Indien er extra relatie-informatie op de relatieklasse bijgehouden
wordt, dan wordt deze _enkel_ in het dominante domein bijgehouden.

Zo'n relatieklasse moet overigens niet verward worden met een associatieklasse
waarmee properties aan een associatie gekoppeld kunnen worden.

Beide relatieklassen zijn _tightly coupled_ - een instantie van de ene kan niet
bestaan zonder een instantie van de andere. In de relatieklassen zijn op z'n
minst de URLs van de koppelende resources opgenomen. Dit laat toe om vanuit
beide kanten op te lijsten welke externe objecten gerelateerd zijn.

Daarnaast loopt de relatie ook altijd vanuit het object in het dominante domein
naar het object in het recessieve domein. Dat principe beinvloed de naamgeving
van deze relatieklasses.

De naamgevingsconventie is nl. als volgt:
`[naam van de gerelateerde class in dominant domein][naam van de gerelateerde class in recessief domein]`.

Voorbeelden hiervan zijn:

* `ZaakContactmoment`
* `VerzoekInformatieobject`
* `ZaakBesluit`
* `BesluitInformatieobject`

In een gegevensmodel kunnen in dit geval 2 klasses opgenomen zijn met dezelfde
naam maar elk opgenomen in een ander domein.

**Relatieklassen met meerdere objecttypen**

Er bestaan relatieklassen waarbij meerdere dominante domeinen een relatie hebben
met resources uit een recessief domein. In deze situatie geldt een andere
naamgevingsconventie voor de relatieklasse in het recessieve domein:
`Object[naam van de gerelateerde class in recessief domein]`.

Voorbeelden hiervan zijn:

* `ObjectContactmoment`
* `ObjectInformatieobject`

In dit geval is er ook geen sprake van twee relatieklasses met dezelfde naam in
het gegevensmodel. Een goed voorbeeld van 2 van deze _tightly coupled_ klasses
met verschillende namen is `ZaakContactmoment` en `ObjectContactmoment`. In dit
geval zal in zo'n klasse die koppelt aan meerdere domeinen ook een attribuut
worden opgenomen waarmee het type van de te koppelen klassse aangegeven kan
worden.

**Kardinaliteit van deze classes**

...

**Relaties met entiteiten uit API-loze domeinen**

Soms moet er in een domein een relatie gelegd worden met een object in een domein waarvoor nog geen API standaard is.
In dat geval wordt de entiteit (tijdelijk) binnen het onder handen zijnde domein getrokken. Dat betekent dat er een object wordt gecreeerd met een
relevante naam en alleen de meest elementaire attributen. Zodra er voor het domein waar het object eigenlijk thuis hoort een eigen API standaard is
ontwikkeld wordt het object in oude domein deprecated verklaard en in de eerstvolgende nieuwe versie verwijderd.

## Polymorphisme
M.b.t. Polymorphisme bestaat er een verschil in aanpak tussen de projecten.

| Project | Beargumentatie |
|:------- |:-------------- |
| ZGW | Binnen de ZGW API's wordt polymorphisme vermeden wat wordt doorgetrokken naar het gegevensmodel. De attributen in een superclass worden opgenomen in de subclasses en de superclass wordt in het gegevensmodel verwijderd. De beargumentatie voor deze keuze is dat polymorphisme de complexiteit verhoogt. |
| HaalCentraal | Binnen HaalCentraal is het gebruikt van superclasses een common practice o.a. omdat daarmee de werkelijkheid beter weergegeven kan worden. |
