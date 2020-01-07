# Inleiding

Dit document bevat een beschrijving van een aantal design principes. Design principes die zijn toegepast in de huidige API standaardisatie projecten (Zaakgericht Werken en HaalCentraal).
Sommige van deze principes bestonden al maar andere zijn gedurende projecten ontwikkeld en/of aangescherpt.

Deze handreiking bouwt voort op de [API strategie voor de Nederlandse overheid](https://aandeslagmetdeomgevingswet.nl/digitaal-stelsel/documenten/documenten/api-uri-strategie/).

Dit document heeft een tweeledig doel.

1. Ten eerste worden hierin design principes beschreven die toegepast moeten worden bij het ontwerpen van een Open API-specificatie teneinde een gegevenslandschap vorm te geven waarin verschillende API's op dezelfde wijze kunnen worden aangesproken.
2. Ten tweede dient dit document als discussie document aangezien in de huidige API standaardisatie projecten op sommige punten verschillende principes gehanteerd worden.
   Uitgangspunt is dat we uiteindelijk overeenstemming bereiken over het te hanteren principe OF dat we duidelijk gaan beschrijven in welke situatie welk principe gehanteerd gaat worden.
   Zodra overeenstemming is bereikt over de design principes zal dit doel komen te vervallen.

# Design principes

## Relaties tussen 2 domeinen

**Motivatie en dominante domeinen**

Bij relaties tussen twee domeinen wil je vanuit beide domeinen de gerelateerde
gegevens uit het andere domein kunnen opvragen/inkijken. Daarvoor wordt in elk domein een relatie-entiteit gedefinieerd die in feite de representatie van een entiteit in een ander domein is. Zo'n relatie-entiteit kan vervolgens gebruikt worden om aan andere entiteiten binnen het domein te koppelen. Dit is noodzakelijk omdat de relatie tussen de entiteit in het ene domein en de entiteit in het andere domein slechts op logisch niveau kan worden gelegd. Zo'n relatie wordt nooit op technisch niveau gecreëerd. 

In het voorbeeld hieronder zie je dat in het 'Zaken API' domein de relatie entiteit 'zaakverzoek' is gecreëerd wat in feite een representatie is van de entiteit 'verzoek' uit het 'Klantinteracties API' domein. In het 'Klantinteracties API' domein is juist de relatie-entiteit 'objectverzoek' gecreëerd wat een representatie is van de entiteit 'zaak' uit het 'Zaken API' domein.
De relatie tussen 'zaakverzoek' en 'verzoek' bestaat alleen op logisch niveau en wordt op technisch niveau niet gerealiseerd. Hetzelfde geldt voor de relatie tussen 'objectverzoek' en 'zaak'.

![Voorbeeld relatie-entiteiten](https://github.com/VNG-Realisatie/API-Kennisbank/blob/master/Handreiking%20API%20Design/Relatie-entiteiten.jpg)

Binnen een relatie tussen domeinen wordt altijd één van de domeinen
als dominant/primair beschouwt. Soms is heel duidelijk welke dat
is en is dat goed te beargumenteren, andere keren is het een buikgevoel en
lastiger te beargumenteren, of het is gewoon een keuze omdat er geen
natuurlijke dominantie aangewezen kan worden. Voorbeelden hiervan zijn:

(dominante domein in vet)

* **Zaken** en Documenten
* **Zaken** en Klantinteracties
* **Besluiten** en Documenten

**Relatieklassen**

Zoals hierboven al aangegeven wordt het feit dat een relatie bestaat tussen objecten in twee verschillende domeinen
altijd in beide domeinen vastgelegd met een specifieke resource voor de
relatieklasse (de relatie-entiteit). In ieder domein zijn de relatieklassen als het ware tegenhangers
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

* `zaakverzoek`
* `zaakcontactmoment`
* `verzoekinformatieobject`
* `zaakbesluit`
* `besluitinformatieobject`

In een gegevensmodel kunnen in dit geval 2 klasses opgenomen zijn met dezelfde
naam maar elk opgenomen in een ander domein.

>Deze naamgevingsconventie is nog aan discussie onderhevig. Tijdens de webinar voor de ZGW API's van 16 december 2019 heeft Henri Korver een ander voorstel gedaan waarbij de naamgeving de volgende conventie volgt:
>
>`[naam van de gerelateerde class in het source domein][naam van de gerelateerde class in het target domein]`.
>
>Indien besloten wordt deze conventie te gaan volgen is er natuurlijk geen sprake meer van dat in een gegevensmodel 2 klasses opgenomen zijn met dezelfde naam.

**Relatieklassen met meerdere objecttypen**

Er bestaan relatieklassen waarbij meerdere dominante domeinen een relatie hebben
met resources uit een recessief domein. In deze situatie geldt een andere
naamgevingsconventie voor de relatieklasse in het recessieve domein:
`Object[naam van de gerelateerde class in recessief domein]`.

Voorbeelden hiervan zijn:

* `objectverzoek`
* `objectcontactmoment`
* `objectinformatieobject`

In dit geval is er ook geen sprake van twee relatieklasses met dezelfde naam in
het gegevensmodel. Een goed voorbeeld van 2 van deze _tightly coupled_ klasses
met verschillende namen is `zaakcontactmoment` en `objectcontactmoment`. In dit
geval zal in zo'n klasse die koppelt aan meerdere domeinen ook een attribuut
worden opgenomen waarmee het type van de te koppelen klassse aangegeven kan
worden.

**Kardinaliteit van deze classes**

Tussen een entiteit en de relatie-entiteit in een andere domein die de entiteit daar representeert is altijd een 1 op 1 koppeling van toepassing. De kardinaliteit aan beide zijde van deze relatie is dus maximaal 1. Aangezien een entiteit in een ander domein niet per definitie hoeft te leiden tot een relatie-entiteit moet de kardinaliteit van de relatie tussen de relatie-entiteit en de entiteit in het andere domein aan de relatie-entiteit zijde (C en G in de onderstaande illustratie) altijd 0..1 zijn. Aan de entiteit zijde (D en H  in de onderstaande illustratie) is deze niet optioneel en dus exact 1.

![Relatie-entiteiten-en-kardinaliteiten](https://github.com/VNG-Realisatie/API-Kennisbank/blob/master/Handreiking%20API%20Design/Relatie-entiteiten-en-kardinaliteiten.jpg)

Door de kardinaliteit van deze relaties op maximaal 1 te stellen wordt voorkomen dat een meervoudige relatie tussen een entiteit in het ene domein en een entiteit in een ander domein technisch niet gerelaiseerd kan worden. De relatie tussen een relatie-entiteit en de entiteit die deze representeert is immers, zoals al eerder aangegeven, slechts op logisch niveau gelegd. Hoe een meervoudige relatie dan wel gerealiseerd kan worden wordt hieronder beschreven.

Aangezien een entiteit in een ander domein niet per definitie hoeft te leiden tot een relatie-entiteit is de relatie tussen een entiteit en een relatie-entiteit binnen hetzelfde domein (B en F in de bovenstaande illustratie) altijd optioneel aan de relatie-entiteit zijde. 
* Op het moment dat een entiteit meerdere keren aan een entiteit in een ander domein gekoppeld moet kunnen worden wordt de kardinaliteit van die relatie aan de relatie-entiteit zijde dus 0..*.
* Op het moment dat een entiteit slechts één keer aan een entiteit in een ander domein gekoppeld mag kunnen worden wordt de kardinaliteit van die relatie aan de relatie-entiteit zijde dus 0..1.

Een relatie-entiteit bestaat altijd bij de gratie van een andere entiteit in hetzelfde domein wat betekent dat in de relatie tussen een relatie-entiteit en die andere entiteit aan de zijde van de andere entiteit (A en E in de bovenstaande illustratie) de kardinaliteit altijd minimaal 1 is.
* Op het moment dat een entiteit in een ander domein meerdere keren aan een entiteit gekoppeld moet kunnen worden wordt de kardinaliteit van die relatie aan de relatie-entiteit zijde dus 1..*.
* Op het moment dat een entiteit in een ander domein slechts één keer aan een entiteit gekoppeld mag kunnen worden wordt de kardinaliteit van die relatie aan de relatie-entiteit zijde dus 1.

**Relaties met entiteiten uit API-loze domeinen**

Soms moet er in een domein een relatie gelegd worden met een object in een domein waarvoor nog geen API standaard is.
In dat geval wordt de entiteit (tijdelijk) binnen het onder handen zijnde domein getrokken. Dat betekent dat er een object wordt gecreeerd met een
relevante naam en alleen de meest elementaire attributen. Zodra er voor het domein waar het object eigenlijk thuis hoort een eigen API standaard is
ontwikkeld wordt het object in oude domein deprecated verklaard en in de eerstvolgende nieuwe versie verwijderd.

## Supertypes / Abstracte klassen

Soms zijn er objecten (ook wel *objecttype* of *concrete klasses* genoemd) die overerven van een ander object omdat ze een gemeenschappelijke basis hebben (ook wel *supertype* of *abstracte klasse* genoemd).

Zo'n abstracte klasse kan op verschillende manieren worden vertaald naar een API-specificatie in termen van resources. Neem als voorbeeld `Persoon` als abstracte klasse en `Docent` en `Student` als concrete klasses die overerven van `Persoon` (het zijn immers beide personen maar gedeelde en specifieke attributen). Er zijn 3 mogelijkheden voor de vertaling naar een API-specificatie:

1. Niets doen. De abstracte klasse opnemen als concrete resource. Op basis van het voorbeeld krijg je nu 3 resources: `Persoon`, `Docent` en `Student`. Je kan nooit een `Persoon` alleen aanmaken, maar als je een `Student` aanmaakt, moet je ook een `Persoon` aanmaken (en deze koppelen).
2. Platslaan. Je neemt de resources `Student` en `Docent` op als concrete resources. Deze resources bevatten beide de attributen uit `Persoon`.
3. Polymorphisme. Je neemt alleen `Persoon` op als resource, en op basis van een `type`-attribuut (discriminator met de keuzes `student` en `docent`) wordt bepaald wat de specifieke attributen er in deze resource zitten.

| Project | Beargumentatie |
|:------- |:-------------- |
| ZGW | Binnen de ZGW API's wordt polymorphisme vermeden wat wordt doorgetrokken naar het gegevensmodel. De attributen in een superclass worden opgenomen in de subclasses en de superclass wordt in het gegevensmodel verwijderd. De beargumentatie voor deze keuze is dat polymorphisme de complexiteit verhoogt. |
| HaalCentraal | Binnen HaalCentraal is het gebruikt van superclasses een common practice o.a. omdat daarmee de werkelijkheid beter weergegeven kan worden. |

## Berichtontwerp

In de regel worden er voor alle entiteiten in een domein berichten ontworpen (_Klopt dit of zijn er situaties te benoemen waarbij er voor een entiteit geen berichten zijn?_). Normaliter zijn dat de volgende berichten:

* Get (zowel in de vorm van een collectie entiteiten als in de vorm van een specifieke entiteit)
* Post
* Patch
* Put
* Delete

Er zijn echter een aantal situaties aan te wijzen waarop niet in alle berichtypes wordt voorzien.

In het geval van een relatie-entiteit wordt niet voorzien in een Patch en Put bericht als alle attributen immutable zijn. In dat geval mag zo'n entiteit niet aangepast worden. Het vervangen van een relatie-entiteit door een andere gaat dus altijd gepaard met het verwijderen van een relatie-entiteit en het opvoeren van een nieuwe.
Indien er meta informatie op een relatie entiteit staat is aanpassing wel toegestaan en kan wel voorzien worden in een Patch en Put bericht.

_Zijn er andere situaties denkbaar waarbij een of meer berichten niet van toepassing zijn?_
