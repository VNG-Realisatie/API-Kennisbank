# Inleiding

Dit document bevat een beschrijving van een aantal design principes. Design principes die zijn toegepast in de huidige API standaardisatie projecten (Zaakgericht Werken en HaalCentraal).
Sommige van deze principes bestonden wellicht al maar anderen zijn gedurende projecten ontwikkeld en/of aangescherpt.

Dit document heeft een tweeledig doel.

1. Ten eerste worden hierin design principes beschreven die toegepast moeten worden bij het ontwerpen van een Open API-specificatie teneinde een gegevenslandschap vorm te geven waarin verschillende API's op dezelfde wijze kunnen worden aangesproken.
2. Ten tweede dient dit document als discussie document aangezien in de huidige API standaardisatie projecten op sommige punten verschillende principes gehanteerd worden.
   Uitgangspunt is dat we uiteindelijk overeenstemming bereiken over het te hanteren principe OF dat we duidelijk gaan beschrijven in welke situatie welk principe gehanteerd gaat worden.
   Zodra overeenstemming is bereikt over de design principes zal dit doel komen te vervallen.

# Design principes

## Relaties tussen 2 domeinen

Bij een relatie tussen 2 domeinen is altijd 1 van de domeinen het dominante domein. 
Soms is heel duidelijk welke dat is en is dat goed te beargumenteren, soms is het een buikgevoel en wat lastiger te beargumenteren en soms is het 
gewoon een keuze omdat er geen natuurlijke dominante in de relatie is. In de relatie tussen het zaken domein en klantinteractiedomein is het zaken 
domein bijv. de dominante.

De relatie tussen objecten uit die domeinen wordt altijd in beide domeinen d.m.v. een aparte relatieclass vastgelegd (beide classes vormen als het ware
tegenhangers). Zo'n relatieclass moet overigens niet verward worden met een associatieclass waarmee properties aan een associatie gekoppeld kunnen worden.
De relatieclasses worden in beide domeinen vastgelegd omdat je immers vanuit beide domeinen de gerelateerde resources op wil kunnen vragen. Beide 
instanties van de relatieclass zijn 'tightly coupled' en bevatten dus ook dezelfde informatie waaronder de uri's van de koppelende resources. 
Daarnaast loopt de relatie ook altijd vanuit het object in het dominante domein naar het object in het recessieve domein. Dat principe beinvloed de 
naamgeving van deze relatieclasses. 
De naamgevingsconventie is nl. als volgt: '[naam van de gerelateerde class in dominant domein][naam van de gerelateerde class in recessief domein]'.
Denk aan 'zaakcontactmoment' en 'verzoekinformatieobject'. In een gegevensmodel kunnen in dit geval 2 classes opgenomen zijn met dezelfde naam maar elk 
opgenomen in een ander domein.

Op het moment dat zo'n relatieclass kan koppelen aan classes in meerdere dominante domeinen dan geldt een aangepaste naamgevingsconventie, nl. 
'object[naam van de gerelateerde class in recessief domein]'. Denk bijv. aan 'objectcontactmoment' en 'objectinformatieobject'. In dit geval is er ook 
geen sprake van 2 relatieclasses met dezelfde naam in het gegevensmodel. Een goed voorbeeld van 2 van deze 'tightly coupled' classes met verschillende
namen is 'zaakcontactmoment' en 'objectcontactmoment'. In dit geval zal in zo'n class die koppelt aan meerdere domeinen ook een attribuut worden opgenomen 
waarmee het type van de te koppelen class aangegeven kan worden. Deze class zal overigens alle attributen bevatten van alle relevante tegenhangers.

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
