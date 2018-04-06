# Inleiding
Dit document is niet gericht op algemeen gebruik van GitHub, maar toegespitst op gebruik voor het ontwikkelen en beheren van open standaarden van VNG Realisatie.

Eerst wordt een aantal belangrijke concepten uit Git en GitHub kort uitgelegd. Vervolgens wordt de workflow voor het voorstellen en doorvoeren van wijzigingen besproken en de workflow voor releases van standaarden. Daarna wordt voor een aantal veel voorkomende situaties ("use cases") uitgelegd hoe dit moet worden gedaan, zowel vanuit GitHub (via de browser) als vanuit je eigen laptop of pc.

# Belangrijke concepten in github
**git**
Versiebeheersysteem. Een versiebeheersysteem ondersteunt het beheerst en gecontroleerd doorvoeren van wijzigingen aan een product. Hieruit komen concepten als branches, forks, commits, tags en releases.

**GitHub**
Online voorziening (www.github.com) gericht op het samen ontwikkelen. Het gebruikt versiebeheertool git, maar biedt daarnaast workflows voor het open ontwikkelen (in ons geval van open standaarden), en tools vooor samenwerking (issues).

**repository**
Verzamelbak voor zaken die onder versiebeheer vallen en/of gezamenlijk ontwikkeld worden.
Een repository betreft één "product" die als zodanig beheerd en gereleased wordt. Voor een repository wordt één of enkele personen als beheerder aangewezen, die verantwoordelijk is voor het beheren van de repository (o.a. beslissen over pull requests, mergen van branches, sluiten van issues).
Elke standaard zal een eigen repository krijgen. Bijvoorbeeld een repository voor RSGB, een repository voor UGM RSGB, een repository voor RSGB-bevragingen, een repository voor Zaak- Documentservices, enz.

**branch**
Om beheerst wijzigingen te kunnen doorvoeren, worden deze op een aparte "aftakking" ontwikkeld en beoordeeld. Pas wanneer er geoordeeld is dat de wijziging gewenst, klaar en goed is, wordt deze feitelijk doorgevoerd op de standaard.
Er kunnen tegelijkertijd veel verschillende branches actief zijn, zodat verschillende wijzigingen los van elkaar kunnen worden ontwikkeld, beoordeeld en doorgevoerd (toegepast).
Voor een standaard die releasematig wordt beheerd en gepubliceerd, zal er voor elke versie (incl. patchversies) een branch worden gemaakt, waarin de wijzigingen voor die versie worden toegepast.
Voor iemand die een wijziging of toevoeging wil doorvoeren, is het verstandig voor elke wijziging/toevoeging een eigen branch te maken, zodat ook pull requests elk slechts één wijziging/toevoeging bevat.

**master**
Er is één speciale branch, "master". Dit is de basis, de actueel geldende versie van de repository. Wijzigingen voeg je niet direct toe op de "master"-branch, maar op een aparte branch voor deze wijziging.
Pas wanneer de wijziging klaar is en kan worden gepubliceerd, voeg je de branch met de wijziging samen met de master-branch (dit heet `merge`), zodat de wijzigingen worden doorgevoerd op de master.

**fork**
Afsplitsing van een repository die apart wordt ontwikkeld. Bijvoorbeeld standaard Regie- Zaakservices 1.0 is gemaakt als fork van Zaak- Documentservices 1.1.
Wanneer je in GitHub wil bijdragen een repository, maar je een "fork" van die repository. Je hebt dan de vrijheid je eigen "fork" van de repository aan te passen en uit te breiden. Wanneer je daarmee klaar bent kan je de betreffende wijziging aanbieden aan de oorspronkelijke repository via een "pull request".

**staging**
Wanneer je wijzigingen doorvoert op een document op je eigen laptop of pc, zijn daarmee de wijzigingen nog niet doorgevoerd in git(hub). Voor je wijzigingen kan doorvoeren in het git versiebeheer, moet je aan git vertellen welke gewijzigde of toegevoegde bestanden moeten worden meegenomen. Dit doe je door deze bestanden toe te voegen aan "staging".

**commit**
Wanneer je wijzigingen doorvoert op een document op je eigen laptop of pc, zijn daarmee de wijzigingen nog niet doorgevoerd in git(hub). Om de wijzigingen door te voeren in het git versiebeheer, geef je de opdracht `commit`.

**pull**
Wanneer je op je eigen laptop werkt aan bestanden van een GitHub repository, is het verstandig regelmatig je lokale kopie van de repository bij te werken met alle wijzigingen die misschien door iemand anders zijn doorgevoerd. Je hebt dan de meest actuele toestand van de repository op je laptop/pc staan. Dit doe je door de git opdracht `pull`, waarmee je de laatste wijzigingen "naar binnnen trekt".

**push**
Wanneer je op je eigen laptop/pc werkt aan bestanden van een GitHub repository, en je wilt deze doorgeven aan de repository op GitHub, dan stuur je deze via een git opdracht `push` (duwen).

**Pull request**
Wanneer je wijzigingen hebt doorgevoerd op je eigen "fork" van een repository, maar deze wilt doorgeven aan de repository van VNG Realisatie, dan doe je een "pull request". Je verzoekt dan aan de beheerder van de repository om je voorgestelde wijzigingen/toevoegingen te accepteren en "naar binnen te trekken".

**origin**
Wanneer je op je eigen laptop/pc werkt aan bestanden, is "origin" de alias voor je eigen GitHub (remote) repository waarop je wijzigingen op kunt doorvoeren (via een `git push -u origin branchnaam`).

**upstream**
Wanneer je op je eigen laptop/pc werkt aan bestanden, is "upstream" de alias voor de GitHub (remote) repository van VNG-Realisatie. Dit gebruik je wanneer je de lokale kopie van de repository wilt actualiseren met alle door anderen doorgevoerde wijzigingen (via een `git pull upstream master`).

# GitHub workflow voor open Standaarden
De workflow voor open co-creatie aan standaarden werkt met via "pull requests". Dit betekent dat je wijzigingen nooit direct maakt op de VNG Realisatie repository, zelfs niet direct op een branch in de VNG Realisatie repository.
Je doet wijzigingen in je persoonlijke "fork" van de VNG Realisatie repository. Vervolgens biedt je deze wijzigingen aan door een "pull request" te doen, een verzoek aan de beheerder om de wijziging toe te voegen aan de VNG Realisatie repository.

De algemene workflow is:
1. Maak een issue aan voor de gewenste wijziging of toevoeging.
2. Anderen kunnen op het issue reageren.
3. Wanneer uit het issue blijkt dat men positief reageert op de voorgestelde wijziging, en je wilt deze gaan realiseren, geef je dat aan in het issue. Wijs het issue toe aan jezelf (hiervoor moet je lid zijn van de community van de repository, je kan verzoeken je toe te laten voegen via de beheerder van de repository).
4. Maak (wanneer je dat nog niet hebt) een fork van de repository.
5. Maak in je fork van de repository een branch aan voor de wijziging. Geef deze branch een naam waaran de wijziging te herkennen is.
6. Voor de wijzigingen en/of toevoegingen door op deze branch in je fork van de repository.
7. Controleer op basis van criteria (kwaliteitseisen) op de standaard of de bijdrage goed en compleet is.
8. Maak een pull request.
9. De beheerder kan ervoor kiezen specifieke leden van de community aan te wijzen om een review te doen op de pull request.
10. Leden van de community (iedereen die zich belanghebbende vindt of voelt) beoordelen de pull request.
10. Wanneer in het commentaar op de pull request (noodzakelijke) verbeteringen worden gevraagd, voer je die door in de betreffende branch op je repository.
11. Wanneer uit de reacties en reviews blijkt dat de pull request goed is, merged te beheerder van de repository het pull request met release-branch de VNG Realisatie repository. (wanneer gewerkt wordt aan de eerste versie van een standaard kan er ook voor worden gekozen direct op de master te mergen).

# Release workflow voor Standaarden
Standaarden volgen criteria voor versiebeheer en versienummering die voor de (soort) standaard is bepaald.
Voor het ontwikkelen van een eerste versie (v1.0) van een standaard kan direct op de master worden ontwikkeld. Zodra er een eerste gepubliceerde versie is van de standaard, worden nieuwe versies of patches ontwikkeld vanuit branches voor de versie.

1. Maak de branch aan voor de versie. De naam van de branch = het versienummer.
2. Merge pull requests voor deze versie met deze branch.
3. Wanneer de versie klaar is:
	1. Merge je de branch met de master.
	2. Publiceer je de release op GitHub

# Use cases
## Werken op je browser in GitHub.com
1. Ik wil een document toevoegen
	* In GitHub onder tab "Code" klik op "Create new file"
	* Vul de bestandsnaam. Vergeet niet de extensie. Voor een tekstdocument met opmaak (mark down) is dat .md
	* Vul de inhoud van het document. Voor uitleg over gebruik van markdown: https://guides.github.com/features/mastering-markdown/
	* Vul bij "Propose new file" een korte titel voor de bijdrage en een uitgebreide toelichting
	* Klik op "Propose new file"

2. Ik wil een (tekst)document wijzigen
	* Op en het document vanuit tab "Code" door te klikken op de bestandsnaam
	* Klik op het pen-icoon
	* Voor de toevoegingen of wijzigingen door in de inhoud van het document
	* Vul bij "Propose new file" een korte titel voor de toevoegingen of wijzigingen en een uitgebreide toelichting hiervan
	* Klik op "Propose file change"

3. Ik wil een opmerking maken over een bijdrage van iemand anders
	* Ga naar de bijdrage vanuit tab "Pull requests" door op de titel van de bijdrage (≠ titel van document) te klikken
	* Vul onderaan de pagina bij "Write" het commentaar
	* Wees altijd opbouwend, correct en vriendelijk. Iemand heeft immers de moeite genomen een bijdrage te leveren.
	* Klik op de knop "Comment"

4. Ik wil reageren op een opmerking van iemand anders op een pull request
	* Ga naar de bijdrage vanuit tab "Pull requests" door op de titel van de bijdrage (≠ titel van document) te klikken
	* Klik op het invulveld (Reply…) onder de betreffende opmerking
	* Vul bij "Write" je reactie op de opmerking
	* Klik op de knop "Add a single comment" (wat is het verschil met "Start a review"?)

5. Ik wil een opmerking maken over een specifieke wijziging (gewijzigd deel van het document)
	* Ga naar de bijdrage vanuit tab "Pull requests" door op de titel van de bijdrage (≠ titel van document) te klikken
	* Ga naar tab "Files changed" (en selecteer zo nodig het gewijzigd bestand?)
	* Wijs met de muis over de betreffende gewijzigde regel (groen of rood gemarkeerd) tot er een blauw icoon met wit + erin links van de regel verschijnt. Klik op het + icoon
	* Vul bij "Write" je reactie op de opmerking
	* Wees altijd opbouwend, correct en vriendelijk. Iemand heeft immers de moeite genomen een bijdrage te leveren.
	* Klik op de knop "Add a single comment" (wat is het verschil met "Start a review"?)

6. Ik wel een correctie doorgeven (doen?) op een bijdrage (pull request) van iemand anders
	* Alleen de indiener van een pull request kan haar/zijn bijdrage aanpassen.
	* Zie verder bij "Ik wil een opmerking maken over een bijdrage van iemand anders"

7. Ik wil een correctie doen op een bijdrage (pull request) van mijzelf
	* Ga naar de bijdrage vanuit tab "Pull requests" door op de titel van de bijdrage (≠ titel van document) te klikken
	* Ga naar tab "Files changed" (en selecteer zo nodig het gewijzigd bestand?)
	* Klik op het pen-icoon
	* Voor de toevoegingen of wijzigingen door in de inhoud van het document
	* Vul bij "Commit changes" een korte titel voor de correctie en een uitgebreide toelichting hiervan
	* Klik op "Commit changes"

8. Ik wil een pull request intrekken
    * Ga naar de bijdrage vanuit tab "Pull requests" door op de titel van de pull request te klikken
    * Vul onderaan de pagina de reden in en klik op "Close pull request"

9. Ik wil anderen uitnodigen mijn bijdrage te beoordelen
	* Kan nu alleen met write access. Volgens https://help.github.com/articles/requesting-a-pull-request-review/ moet iedereen dit kunnen

10. Ik wil een bijdrage van een ander beoordelen dat deze (wat mij betreft) is goedgekeurd
11. Ik wil een bijdrage van een ander beoordelen dat er gewenste aanpassingen zijn

12. Ik wil een document in mark down schrijven
	* Zie https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf voor opmaakcodes.
	* Zie https://guides.github.com/features/mastering-markdown/

13. Ik (beheerder van een repository) wil een pull request goedkeuren en toevoegen aan de repository
14. Ik (beheerder van een repository) wil een pull request afkeuren

15. Ik (beheerder van een repository) wil een wijziging doorvoeren aan een document
    * Wanneer je iets wilt toevoegen of wijzigen volg je exact dezelfde procedure als ieder ander die iets wil wijzigen of toevoegen.
    * Ook al ben je beheerder, toch dien je wijzigingen in via een pull request, zodat anderen erop kunnen reageren.
    * Dus ook een beheerder commmit nooit direct op de VNG-Realisatie repository.

16. Ik (beheerder van een repository) wil een release maken
	* Maak een branch om alle wijzigingen en toevoegingen van de release in te verzamelen
	* Als de release af is merge je de branch met de master
	* Vervolgens publiceer je de release op GitHub:
		* Onder tab "Code" klik op "releases"
		* Klik op "Create a new release"
		* Vul de release versie (gebruik semantic versioning, begin de versie met "v", bijvoorbeeld "v1.0")
		* Vul de release titel en omschrijving en klik op "Publish release".

17. Ik wil een repository toevoegingen
	* Alleen de "owner" van de GitHub organisatie VNG-Realisatie kan dit werkelijk uitvoeren: Michiel Verhoef (michiel.verhoef@vng.nl)
	* Maak bij een repository direct ook een README.md aan!
	* Denk goed na over een naam en omschrijving van de repository, zodat men deze ook kan vinden.
	* Vul zo snel mogelijk de README.md met belangrijke informatie:
		* Beschrijf het "product: of resultaat van de repository (in ons geval meestal een standaard). Wat is het doel dat hiermee bereikt wordt.
		* Beschrijf hoe mensen het product kunnen gebruiken. Bijvoorbeeld verwijzing naar functionele specificaties, technische specificaties (schema's), referentie-implementatie.
		* Beschrijf hoe mensen aan de ontwikkeling kunnen bijdragen (contributing guide).
	* Maak, zover mogelijk een goed begin. Mensen dragen makkelijker bij aan iets dat er al (in enig vorm) is, dan aan een lege repository.
	* Nodig relevante belanghebbenden (potentiële gebruikers of deelnemers) uit om het "product" in de repository te gebruiken en eraan bij te dragen.

## Werken vanuit eigen laptop met eigen tooling
Soms wil je met je eigen editor documenten (dat kan ook code of schema zijn) bewerken. Bijvoorbeeld in XmlSpy, Eclipse, enz. Dan is het handiger om de bestanden van de repository op je eigen laptop te hebben staan en van daaruit te bewerken. Hieronder staat hoe je de versiebeheertool git kan gebruiken op je eigen laptop of pc, in combinatie met GitHub.
Beschreven is het gebruik van git vanuit command prompt (CMD) in windows en Terminal op een Mac. Veel tools kennen echter zelf (al dan niet via een plug in) ook voorzieningen om een deel van deze stappen te doen.
Je kan ook GitHub Desktop downloaden en installeren, waarmee je een aantal git/github dingen kunt doen.

1. Ik wil een lokale werkplek beginnen van een repository
	* Preconditie: je hebt git (dat is iets anders dan GitHub!) geïnstalleerd op je computer
	* Preconditie: Om documenten te kunnen bewerken of toevoegen via een push request, moet je eerst een "fork" hebben gemaakt van de VNG Realisatie repository waar je in wilt werken.
	* Preconditie: 	Om vanuit je lokale laptop te mogen pushen naar een VNG Realisatie repository, moet je een personal access token maken. Dit access token moet als "scope" hebben "repo".
	Wanneer bij een git commando gevraagd wordt om inlognaam en wachtwoord, vul je niet je wachtwoord in, maar je personal access token.
	* Open command prompt (Windows) of Terminal (Mac)
	* Ga naar de map waarin de repository moet komen, bijv. met:
  `cd /user/vngr/github`
  	* Wanneer dit de eerste git repository is op je laptop/pc op deze plek:
  	```
  	git init
  	git config --global user.name "username"
	git config --global user.email voornaam.achternaam@vng.nl
	```
	(vervang in de code hierboven "username" door je eigen GitHub gebruikersnaam en "voornaam.achternaam@vng.nl" door je eigen e-mailadres)
	
	* Zoek in GitHub de url van de repository die je wilt gebruiken. Je gebruikt de fork van de VNG-Realisatie repository op je eigen account. 
	Onder tab "Clone" klik op de knop "Clone or download". Selecteer en kopieer de getoonde url. 

	```
	git clone https://github.com/username/repositorynaam.git
	cd repositorynaam
	git remote add upstream https://github.com/VNG-Realisatie/repositorynaam.git
	```
	(vervang in de code hierboven "username" door je eigen GitHub gebruikersnaam en "repositorynaam" door de naam van de repository waar je in wilt wijzigen)

2. Ik wil een document toevoegen of wijzigen
  * Het is altijd verstandig als je iets wilt toevoegen of wijzigen eerst een issue aan te maken. Uit de reacties hierop blijkt dan al of anderen het met je wijziging eens zijn. Dat kan de kans verkleinen dat je veel tijd hebt gestoken in een wijziging die vervolgens wordt afgewezen.
  Een pull request (voorgestelde toevoeging of wijziging) kan ook worden afgewezen.
	* Voor je iets gaat wijzigen of toevoegen zorg je dat je de meest actuele toestand van de repository lokaal hebt:
	```git checkout master
	git pull upstream master
	```
	* Maak een branch voor de wijziging (wanneer je niet kan of wil werken op een branch die al bestaat):
	`git branch branchnaam`
	(waar "branchnaam" moet worden vervangen door een naam van je branch)
	* Zorg dat je wijzigingen betrekking hebben op de branch waarop je wilt wijzigen:
	`git checkout branchnaam`
	(gebruik de branchnaam die je in de vorige stap hebt gemaakt of de bestaande branch die je wil gebruiken)
	* Maak of bewerk het document in de tool of app van jouw keuze (Notepad, Eclipse, XmlSpy, Atom, …)
	* Bekijk (optioneel) welke documenten gewijzigd zijn:
	`git status`
	* Voeg het document toe aan je staging:
	`git add bestandnaam.ext`
	(waar bestandnaam.ext moet worden vervangen door de naam (inc. extensie) van het bestand dat je hebt toegevoegd)
	* Wanneer je meerdere documenten hebt toegevoegd of gewijzigd, kan je ze ook allemaal tegelijk toevoegen aan staging met:
	`git add *`
	* Je legt de wijzigingen vast in je lokale master branch met:
	`git commit -m 'toelichting op de commit'`
	(waarbij je "toelichting op de commit" vervangt door een omschrijving van wat je hebt toegevoegd of gewijzigd)
	* Om het document naar GitHub te sturen doe je:
	`git push -u origin branchnaam`
	(waar "username" moet worden vervangen door je gebruikersnaam en "branchnaam" moet worden vervangen door de naam van de branch die je bij bullit 2 hebt gemaakt)
	* Om een pull request te maken ga je naar GitHub.com, en daar naar je eigen account en daarin de betreffende repository. Bijvoorbeeld https://github.com/username/Architectuur-en-Standaarden
	* Selecteer de branch waar je in de voorgaande stappen in hebt gewerkt.
	* Klik "New pull request". Vul een titel en omschrijving van de pull request die beschrijft wat je waarom hebt gewijzigd of toegevoegd.

3. Ik wil een correctie doen op een bijdrage (pull request) van mijzelf
  * Dit kan op exact dezelfde manier als bij het vorige punt is beschreven.
  * Belangrijk is dat je dezelfde branch gebruikt als is gebruikt bij de pull request.
