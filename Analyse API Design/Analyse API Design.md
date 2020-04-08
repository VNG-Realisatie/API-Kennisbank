**WAARSCHUWING!**

**Dit document is in ontwikkeling en is daarom nog aan wijzigingen onderhevig.**

# Inleiding

Dit document bevat een beschrijving van een aantal design principes. Design principes die zijn toegepast in de huidige API standaardisatie projecten (Zaakgericht Werken en HaalCentraal).

Deze handreiking is een aanvulling danwel aanscherping op de [API strategie voor de Nederlandse overheid](https://docs.geostandaarden.nl/api/API-Strategie/).  Alle API-stratgie design rules zoals beschreven in de API strategie voor de Nederlandse overheid worden geadopteerd tenzij dat in dit document anders is beschreven of aangescherpt.

Dit document heeft een tweeledig doel:

1. de design-rules en werkwijze vastleggen zodat API-design binnen het gemeentelijk gegevenslandschap eenduidig wordt uitgevoerd op basis van gezamenlijk vastgestelde design rules.
2. de gebruiker van de API's (de ontwikkelaars) inzicht geven in waarom een bepaalde constructie of werkwijze in de API's gebruikt wordt.

# Design principes

## Relaties tussen 2 domeinen

**Motivatie**

Bij relaties tussen twee domeinen wil je vanuit beide domeinen de gerelateerde
gegevens uit het andere domein kunnen opvragen/inkijken. Daarvoor wordt in elk domein een relatie-entiteit gedefinieerd dat in feite een record van een koppeltabel is. In zo'n relatie-entiteit worden de identifiers van de te koppelen entiteiten vastgelegd. 

In het voorbeeld hieronder zie je dat in het 'Zaken API' domein de relatie entiteit 'zaakverzoek' is gecreëerd waarmee een koppeling wordt gedefinieerd tussen de entiteit 'zaak' in hetzelfde domein en de entiteit 'verzoek' in het 'Klantinteracties API' domein. In het 'Klantinteracties API' domein is met hetzelfde doel juist de relatie-entiteit 'objectverzoek' gecreëerd.

![Voorbeeld relatie-entiteiten](https://github.com/VNG-Realisatie/API-Kennisbank/blob/master/Analyse%20API%20Design/Relatie-entiteiten.jpg)

**Relaties tussen domeinen**

Bij relaties tussen domeinen wordt altijd één van de domeinen als eigenaar beschouwt. Soms is heel duidelijk welk domein die rol heeft en is dat goed te beargumenteren, andere keren is het een buikgevoel en lastiger te beargumenteren, of het is gewoon een keuze omdat er geen natuurlijke eigenaar aangewezen kan worden. Voorbeelden hiervan zijn:

(eigenaar domein in vet)

* **Zaken** en Informatieobjecten
* **Zaken** en Klantinteracties
* **Besluiten** en Documenten

**Relatieklassen**

Zoals hierboven al wordt aangegeven wordt het feit dat een relatie bestaat tussen objecten in twee verschillende domeinen
altijd in beide domeinen vastgelegd met een specifieke resource voor de
relatieklasse (de relatie-entiteit). In ieder domein zijn de relatieklassen als het ware tegenhangers
van elkaar. Indien er extra relatie-informatie op de relatieklasse bijgehouden
wordt, dan wordt deze _enkel_ in het domein van de eigenaar van de relatie bijgehouden.
Dat is ook de klasse die benaderbaar is voor comsumers van deze API. De koppetabel in het andere domein moet worden bijgehouden door registratie die "eigenaar" is van de relatieklasse. Daarmee wordt de consumer dus niet belast.

Zo'n relatieklasse moet overigens niet verward worden met een associatieklasse
waarmee properties aan een associatie gekoppeld kunnen worden.

Beide relatieklassen zijn _tightly coupled_ - een instantie van de ene kan niet
bestaan zonder een instantie van de andere. In de relatieklassen zijn op z'n
minst de URLs van de koppelende resources opgenomen. Dit laat toe om vanuit
beide kanten op te lijsten welke externe objecten gerelateerd zijn.

Daarnaast loopt de relatie ook altijd vanuit het object in het domein van de eigenaar
naar het object in het andere domein. Dat principe beinvloed de naamgeving
van deze relatieklasses.

De naamgevingsconventie is nl. als volgt:
`[naam van de gerelateerde class in dominant domein][naam van de gerelateerde class in recessief domein]`.

Voorbeelden hiervan zijn:

* `zaakverzoek`
* `zaakcontactmoment`
* `zaakbesluit`

In een gegevensmodel kunnen om bepaalde redenen 2 klasses opgenomen zijn met dezelfde naam maar elk opgenomen in een ander domein. Dit is echter geen ideale situatie die als het even kan voorkomen moet worden. Over het algemeen zal dan ook dat wat beschreven staat in de volgende sectie (Relatieklassen met meerdere objecttypen) gelden.

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

Tussen een entiteit en een relatie-entiteit, al dan niet in een ander domein, is altijd een 1 op 1 koppeling van toepassing. De kardinaliteit aan entiteit zijde (A, D, E en H in de onderstaande illustratie) van deze relatie is dus altijd 1. 
Aangezien een entiteit in een ander domein niet per definitie hoeft te leiden tot een relatie-entiteit is de relatie tussen de relatie-entiteit en de entiteit, al dan niet in een ander domein, aan de relatie-entiteit zijde (B, C, G en F in de onderstaande illustratie) altijd optioneel.
De maximale kardinaliteit van die relatie kan echter verschillen, daarvoor zijn geen generieke regels te benoemen. Dat moet dus per geval worden bepaald. Wel geldt dat kardinaliteiten van de tegenhanger van een relatie-entiteit een overeenkomst hebben. Zo zal de kardinaliteit van B en G aan de ene kant en C en F aan de andere kant (zie onderstaande illustraties) altijd gelijk aan elkaar zijn.

![Relatie-entiteiten-en-kardinaliteiten](https://github.com/VNG-Realisatie/API-Kennisbank/blob/master/Analyse%20API%20Design/Relatie-entiteiten-en-kardinaliteiten.jpg)

**Relaties met entiteiten uit API-loze domeinen**

Soms moet er in een domein een relatie gelegd worden met een object in een domein waarvoor nog geen API standaard is.
In dat geval wordt de entiteit (tijdelijk) binnen het onder handen zijnde domein getrokken. Dat betekent dat er een object wordt gecreeerd met een
relevante naam en alleen de meest elementaire attributen. Relaties vanuit zo'n object naar andere objecten binnen het eigen domein worden niet gemodelleerd en die andere objecten blijven dan ook in het onder handen zijnde domein buiten beschouwing. Zodra er voor het domein waar het object eigenlijk thuis hoort een eigen API standaard is
ontwikkeld wordt het object in oude domein deprecated verklaard en in de eerstvolgende nieuwe versie verwijderd.

Indien zo'n object een n-op-m relatie heeft met andere objecten binnen het in bewerking zijnde domein dan moet tussen die relatie een koppelentiteit worden geplaatst zoals beschreven is in het voorgaande deel van deze paragraaf.

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
