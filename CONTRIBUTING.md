# Hoe bij te dragen
We zijn heel blij dat je dit leest, want de kwaliteit van onze standaarden wordt gemaakt door de vrijwillige bijdragen aan de standaarden. Bijdragen kan in verschillende vormen, zoals het melden van issues (bugs, fouten), wensen en suggesties, of correcties en aanpassingen in de deelproducten van de standaarden.

In dit document staat beschreven hoe je kunt bijdragen en welke eisen we daaraan stellen.

Wanneer je nog niet goed weet hoe Git en GitHub werkt, kun je hier iets meer over lezen in onze [tutorial](GitHub%20tutorial/github_tutorial.md). Hierin staat ook de workflow beschreven voor het voorstellen van wijzigingen (pull request).

Heel belangrijk zijn de omgangsvormen die we hier hanteren. Het moet voor iedereen prettig zijn om een bijdrage te leveren, dus moeten we op een vriendelijke en respectvolle manier met elkaar omgaan. Daarover hebben we een [code of conduct](CODE_OF_CONDUCT.md).

We kennen drie vormen om bij te dragen aan een standaard:
1. Issues indienen voor bugs, fouten, wensen en suggesties.
2. Bijdragen van anderen beoordelen, door te reageren op een issue of pull request.
3. Wijzigingen of toevoegingen doen deelproducten via een pull request.

Voordat je gaat werken aan een wijziging die je wilt indienen via een pull request is het verstandig eerst een issue in te dienen om te polsen of anderen in de community je voorgestelde wijziging ondersteunen. Dat voorkomt (verkleind de kans) dat je tijd besteedt aan het maken van een wijziging, die vervolgens kan worden afgewezen.

Wanneer je een wijziging of toevoeging volledig doorvoert, dus bijvoorbeeld in zowel documentatie, technische specificaties (o.a. xsd en/of open api specificatie), referentie-implementatie(s) (incl. tests daarop) en voorbeeldberichten, kan een pull request sneller worden doorgevoerd naar de standaard. Je bent dan immers niet meer afhankelijk van anderen om de andere deelproducten aan te passen.
Maar het is niet verplicht om alle relevante deelproducten zelf aan te passen. Het is handig dit eerst af te stemmen (in het issue over de gewenste wijziging of toevoeging). Sommige deelproducten kunnen door de beheerder worden gegenereerd, dus soms is het niet nodig alle aanpassingen zelf te doen.

## Taal
We gebruiken **Nederlands** als voertaal. 

Voor technische documenten (bijvoorbeeld software code voor referentie-implementaties), in issues en in opmerkingen is ook Engels toegestaan.

## Soorten documenten en bestanden
Elk deelproduct van een standaard (document of bestand), moet geschikt zijn voor het versiebeheerproces, zodat anderen (incl. de beheerders) de aangebrachte (en toekomstige) verschillen kunnen beoordelen, en verschillende wijzigingen op hetzelfde bestand kunnen worden samengevoegd. Hiervoor moet elk bestand tekstgebaseerd zijn, zoals markdown, xml, yaml, xmi, json, sql, en softwarecode. Het document moet te lezen en bewerken zijn met vrij beschikbare tooling. Als het met notepad te lezen en bewerken is, is het geschikt. We gebruiken dus bijvoorbeeld geen MS Office documenten.

Probeer te voorkomen dat bestanden heel groot zijn.

Maak documenten (bestanden van elke gebruikte soort) zo duidelijk mogelijk leesbaar te maken voor anderen. Hierbij helpt:
* Een duidelijke structuur
* Consequente vormgeving (indents, code conventies)
* Voeg zinvol commentaar/toelichting toe (in technische code)
* Betekenisvolle namen van bestanden en elementen

## Pull requests
Houd pull requests zo klein mogelijk. Combineer dus niet verschillende functionele toevoegingen in één pull requests.

In een pull request moet in de beschrijving duidelijk worden aangegeven:
* Wat het doel is van de Wijzigingen
* Wat is gewijzigd in welke bestanden
