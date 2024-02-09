# Inleiding
Dit document is niet gericht op algemeen gebruik van GitHub, maar toegespitst op gebruik voor het ontwikkelen en beheren van open standaarden van VNG Realisatie.

Eerst wordt een aantal belangrijke concepten uit Git en GitHub kort uitgelegd. Vervolgens wordt de workflow voor het voorstellen en doorvoeren van wijzigingen en de workflow voor releases van standaarden vanuit GitHub (via de browser) besproken. Daarna wordt voor een aantal veel voorkomende situaties ("use cases") uitgelegd hoe dit moet worden gedaan, zowel vanuit GitHub (via de browser) als vanuit je eigen laptop of pc.

Online documentatie:
* [Wat is Git?](https://guides.github.com/introduction/git-handbook/)
* [Hoe werkt Github?](https://guides.github.com/introduction/flow/)

# Belangrijke concepten in github
**git**<br/>
Versiebeheersysteem. Een versiebeheersysteem ondersteunt het beheerst en gecontroleerd doorvoeren van wijzigingen aan een product. Hieruit komen concepten als branches, forks, commits, tags en releases.

**GitHub**<br/>
Online voorziening (www.github.com) gericht op het samen ontwikkelen. Het gebruikt het versiebeheertool git, maar biedt daarnaast workflows voor het open ontwikkelen (in ons geval van open standaarden), en tools voor samenwerking (issues).

**repository**
Verzamelbak voor zaken die onder versiebeheer vallen en/of gezamenlijk ontwikkeld worden.
Een repository betreft één "product" die als zodanig beheerd en gereleased wordt. Voor een repository wordt één of enkele personen als beheerder aangewezen, die verantwoordelijk is voor het beheren van de repository (o.a. beslissen over pull requests, mergen van branches, sluiten van issues). Daarnaast kunnen er nog personen aan toegevoegd worden met schrijf- of andere rechten.
Elke standaard zal een of meer eigen repositories krijgen. Een belangrijk criteria daarbij is of er sprake dient te zijn van een eigen versieontwikkeling. Ook wanneer voor één standaard zowel een provider als een consumer worden ontwikkeld komen beide in een eigen repository.

**branch**<br/>
Om beheerst wijzigingen te kunnen doorvoeren, worden deze op een of meer aparte "aftakkingen" ontwikkeld en beoordeeld. Pas wanneer er geoordeeld is dat de wijziging gewenst, klaar en goed is, wordt deze feitelijk doorgevoerd op de standaard.
In Git zijn branches tijdelijke "afslagen" met de bedoeling een wijziging te maken, testen en beoordelen, en deze daarna weer samen te voegen met de "main" branch.
Er kunnen tegelijkertijd veel verschillende branches actief zijn, zodat verschillende wijzigingen los van elkaar kunnen worden ontwikkeld, beoordeeld en doorgevoerd (toegepast).
Voor een standaard die releasematig wordt beheerd en gepubliceerd, zal er voor elke versie (incl. patchversies) een branch worden gemaakt, waarin de wijzigingen voor die versie worden toegepast.
Voor iemand die een wijziging of toevoeging wil doorvoeren, is het verstandig voor elke wijziging/toevoeging een eigen branch te maken, zodat ook pull requests elk slechts één wijziging/toevoeging bevat. Binnen VNG-Realisatie werken wij volgens [GitFlow](https://vng-realisatie.github.io/API-Kennisbank/GitFlow/Gitflow_implementatie).

**main**<br/>
Er is één speciale branch, "main", vroeger ook wel "master" genoemd. Dit is de basis, de actueel geldende versie van de repository. Wijzigingen voeg je niet direct toe op de "main"-branch, maar op een aparte branch voor deze wijziging.
Pas wanneer de wijziging klaar is en is goedgekeurd en ter publicatie, voeg je de branch met de wijziging samen met de main-branch (dit heet `merge`), zodat de wijzigingen worden doorgevoerd op de main-branch.

**fork**<br/>
Kopie van een repository die apart wordt ontwikkeld maar wel administratief gekoppeld blijft aan de originele repository.
Voor het bijdragen aan de ontwikkeling van een in een GitHub repository vastgelegd product kun je zoals hierboven gebruik maken van aparte branches. Je kunt echter ook een "fork" van die repository maken. Je hebt dan de vrijheid die "fork" van de repository naar gelieve aan te passen en uit te breiden. Wanneer je daarmee klaar bent kan je de betreffende wijziging aanbieden aan de oorspronkelijke repository via een "pull request".

**clone**<br/>
Door het "clonen" (`git clone`) van een repository haal je deze op de eigen laptop of pc binnen. Deze "kloon" is gekoppeld aan de online versie van de repository (op Github). Met `pull` haal je de nieuwste wijzigingen op uit de online versie, en met `push` stuur je de wijzigingen van je eigen laptop of pc naar de online repository.

**staging**<br/>
Wanneer je wijzigingen doorvoert op een document op je eigen laptop of pc, zijn daarmee de wijzigingen nog niet doorgevoerd in git(hub). Voor je wijzigingen kan doorvoeren in het git versiebeheer, moet je aan git vertellen welke gewijzigde of toegevoegde bestanden moeten worden meegenomen. Dit doe je door deze bestanden toe te voegen aan "staging". Dit kan m.b.v. de opdracht `add` (toevoegen van bestand aan commit).

**commit**<br/>
Ook wanneer de gewijzigde documenten op je eigen laptop of pc zijn toegevoegd aan "staging" zijn de wijzigingen nog niet doorgevoerd in git(hub).

Om de wijzigingen daadwerkelijk door te voeren in het git versiebeheer, geef je de opdracht `commit` (set aan wijzigingen doorvoeren).
Het toevoegen van bestanden aan 'staging' en het 'committen' kun je in 1 commando combineren: `git commit -a -m "dit heb ik gedaan..."` (waar `-a` voor `add` staat en alle gewijzigde bestanden toevoegd, en `-m` gevolgd door een beschrijving van de commit).

**pull**<br/>
Wanneer je op je eigen laptop werkt aan bestanden van een GitHub repository, is het verstandig regelmatig je lokale kopie van de repository bij te werken met alle wijzigingen die misschien door iemand anders zijn doorgevoerd. Je hebt dan de meest actuele toestand van de repository op je laptop/pc staan. Dit doe je door de git opdracht `pull`, waarmee je de laatste wijzigingen "naar binnnen trekt".

**push**<br/>
Wanneer je op je eigen laptop/pc werkt aan bestanden van een GitHub repository en je wilt deze doorgeven aan de repository op GitHub, dan stuur je deze via een git opdracht `push` (duwen).

**Pull request**<br/>
Wanneer je wijzigingen hebt doorgevoerd op je eigen "fork" van een repository, maar deze wilt doorgeven aan de repository van VNG Realisatie, dan doe je een "pull request". Je verzoekt dan aan de beheerder van de repository om je voorgestelde wijzigingen/toevoegingen te accepteren en "naar binnen te trekken".

**origin**<br/>
Wanneer je op je eigen laptop/pc werkt aan bestanden, is "origin" de alias voor je eigen GitHub (remote) repository waarop je wijzigingen kunt doorvoeren (via een `git push -u origin branchnaam`).

**upstream**<br/>
Wanneer je op je eigen laptop/pc werkt aan bestanden, is "upstream" de alias voor de GitHub (remote) repository van VNG-Realisatie. Dit gebruik je wanneer je de lokale kopie van de repository wilt actualiseren met alle door anderen doorgevoerde wijzigingen (via een `git pull upstream master`).


**lokale files excluden van commits**<br/>
Hiervoor kan niet de .gitignore worden gebruikt omdat dit bestand ook wordt ingecheckt en dit zou er dan voor zorgen dat de GitHub Actions workflows de gegenereerde bestanden niet kan committen.
In een git repo kan je een .git/info/exclude file opnemen die hetzelfde werkt als de .gitignore. Alleen wordt deze niet gecommit waardoor het alleen voor de lokale repo geldt. De volgende regels moeten worden toegevoegd om de gegenereerde bestanden te excluden voor commit.

Voorbeelden van te excluden mappen en bestanden:
- specificatie/genereervariant/**
- code/**
- test/**
- openapitools.json

Omdat de gegenereerde bestanden al in git worden getracked, moet een extra actie worden uitgevoerd om de in de exclude file genoemde bestanden lokaal niet meer te tracken. Dit moet met de volgende bash statements:

- git ls-files -z code | xargs -0 git update-index --assume-unchanged
- git ls-files -z specificatie/genereervariant | xargs -0 git update-index --assume-unchanged

Om een specifieke file te untracken moet de volgende statement worden gebruikt: git update-index --assume-unchanged <filepath> bijv. git update-index --assume-unchanged test/BRP-Bevragen-postman-collection.json.

Hiermee worden merge conflicts in de gegenereerde bestanden voorkomen.


# GitHub workflow (in de browser) voor open Standaarden
De workflow voor open co-creatie aan standaarden werkt via "pull requests". Dit betekent dat je wijzigingen nooit direct maakt op de VNG Realisatie repository, zelfs niet direct op een branch in de VNG Realisatie repository.
Je doet wijzigingen in je persoonlijke "fork" van de VNG Realisatie repository. Vervolgens bied je deze wijzigingen aan door een "pull request" te doen, een verzoek aan de community om de wijziging toe te voegen aan de VNG Realisatie repository. Wanneer de community positief reageert op de pull request, kan de beheerder de pull request goedkeuren en doorvoeren op de repository.

De algemene workflow is:
1. Maak een issue aan voor de gewenste wijziging of toevoeging.
2. Anderen kunnen op het issue reageren.
3. Wanneer uit het issue blijkt dat men positief reageert op de voorgestelde wijziging, en je wilt deze gaan realiseren, geef je dat aan in het issue. Wijs het issue toe aan jezelf (hiervoor moet je lid zijn van de community van de repository, je kan verzoeken je toe te laten voegen via de beheerder van de repository).
4. Maak (wanneer je dat nog niet hebt) een fork van de repository.
5. Maak in je fork van de repository een branch aan voor de wijziging. Geef deze branch een naam waar de wijziging aan te herkennen is.
6. Voer de wijzigingen en/of toevoegingen door op deze branch in je fork van de repository.
7. Controleer op basis van criteria (kwaliteitseisen) op de standaard of de bijdrage goed en compleet is.
8. Maak een pull request.
9. De beheerder kan ervoor kiezen specifieke leden van de community aan te wijzen om een review te doen op de pull request.
10. Leden van de community (iedereen die zich belanghebbende vindt of voelt) beoordelen de pull request.
10. Wanneer in het commentaar op de pull request (noodzakelijke) verbeteringen worden gevraagd, voer je die door in de betreffende branch op je repository.
11. Wanneer uit de reacties en reviews blijkt dat de pull request goed is, merged te beheerder van de repository het pull request met release-branch de VNG Realisatie repository. (wanneer gewerkt wordt aan de eerste versie van een standaard kan er ook voor worden gekozen direct op de master te mergen).

# Best practices voor pull requests
* Meestal is het verstandig eerst een issue te maken vóór je een pull request indient. Je kan dan al polsen of andere gebruikers in de community het eens zijn met je gewenste wijziging. Wanneer het een kleine, concrete bug betreft (bijvoorbeeld een schema wat niet goed parsed of waar iets in ontbreekt) kun je altijd zelf het voortouw nemen en naast een issue geljk een pull request indienen waarin dit probleem opgelost is. Wanneer je niet eerst een issue maakt, loop je een groter risico dat het pull request wordt afgewezen.
* Houdt pull requests zo klein mogelijk. Dus combineer zo weinig mogelijk verschillende wijzigingen of toevoegingen in één pull request. Dit maakt de discussie over de pull request helder en voorkomt dat het pull request wordt afgewezen over de ene wijziging, terwijl de andere wijziging wel gewenst en goed is.

# Release workflow voor Standaarden
Standaarden volgen criteria voor versiebeheer en versienummering die voor de (soort) standaard is bepaald.
Voor het ontwikkelen van een eerste versie (v1.0) van een standaard kan direct op de master worden ontwikkeld. Zodra er een eerste gepubliceerde versie is van de standaard, worden nieuwe versies of patches ontwikkeld vanuit branches voor de versie. Wanneer je dus een versie 1.1 wilt gaan ontwikkelen, maak je een branch "v1.1" en merge je pull requests voor deze release naar deze branch (i.p.v. naar de Master).

De beheerder van de standaard zal dus de volgende handelingen doen voor een versie van de standaard:
1. Maak de branch aan voor de versie. De naam van de branch = het versienummer. Bijvoorbeeld "v1.3"
2. Merge pull requests voor deze versie met deze branch.
3. Wanneer de versie klaar is:
	1. Merge je de branch met de master via een Pull request.
	2. Publiceer je de release op GitHub.

# Use cases
## Werken op je browser in GitHub.com
1. Ik wil een document toevoegen
	* In GitHub onder tab "Code" klik op "Create new file"
	* Vul de bestandsnaam. Vergeet niet de extensie. Voor een tekstdocument met opmaak (mark down) is dat .md
	* Vul de inhoud van het document. Voor uitleg over gebruik van markdown: https://guides.github.com/features/mastering-markdown/
	* Vul bij "Propose new file" een korte titel voor de bijdrage en een uitgebreide toelichting
	* Klik op "Propose new file"

2. Ik wil een (tekst)document wijzigen
	* Ga naar de tab "Code"
	* Kies daar de branch waarin je de wijzigingen wil aanbrengen
	* Open het document dat je wil aanpassen door te klikken op de bestandsnaam
	* Klik op het pen-icoon
	* Voer de toevoegingen of wijzigingen door in de inhoud van het document
	* Commit de wijzigingen in het document door op "Commit changes" te klikken waarbij je de radio button "Commit directly to the nnnnn branch." selecteert. "nnnnn" staat voor de branch waarin je deze wijziging wilde aanbrengen.

3. Ik wil een "Pull request" indienen
	* Open de tab "Pull requests"
	* Klik op "New pull request"
	* Selecteer bij "base fork" de repository en bij "base" de branch waar het pull request op moet worden geplaatst
	* Selecteer bij "head fork" de repository en bij "compare" de branch waarin de wijziging is aangebracht
	* Klik op "???"
	* Klik daarna op "???" waarna de pull request is geplaatst
	* Selecteer bij "base fork" de repository en bij "base" de branch waar het pull request op moet worden geplaatst. Dit is de 'master' branch van de repository bij VNG-Realisatie
	* Selecteer bij "head fork" de repository en bij "compare" de branch waarin de wijziging is aangebracht
	* Klik op "Create pull request" en ken er een naam aan toe. **Tip**: Als je de volgende conventie:
	  'fixes [nummer issue]' toevoegt aan de naam van de pull request wordt bij het aanvaarden van de pull request het issue meteen gesloten. Indien een pull request betrekking heeft op slechts een deel van een issue neem je geen 'Fixes' op omdat het issue nl. nog niet geheel is opgelost als de pull request wordt goedgekeurd en dus niet afgesloten mag worden. Neem in dat geval 'Ref. #' gevolgd door het nummer van het issue op.
	* Scroll evt. naar beneden en klik op "Create pull request";
	* Kies de eerste van de 3 opties 'Create a merge commit'
	* Ken reviewers toe aan het pull request.

4. Ik wil een opmerking maken over een bijdrage van iemand anders
	* Ga naar de bijdrage vanuit tab "Pull requests" door op de titel van de bijdrage (≠ titel van document) te klikken
	* Vul onderaan de pagina bij "Write" het commentaar
	* Wees altijd opbouwend, correct en vriendelijk. Iemand heeft immers de moeite genomen een bijdrage te leveren.
	* Klik op de knop "Comment"

5. Ik wil reageren op een opmerking van iemand anders op een pull request
	* Ga naar de bijdrage vanuit tab "Pull requests" door op de titel van de bijdrage (≠ titel van document) te klikken
	* Klik op het invulveld (Reply…) onder de betreffende opmerking
	* Vul bij "Write" je reactie op de opmerking
	* Klik op de knop "Add a single comment" (wat is het verschil met "Start a review"?)

6. Ik wil een opmerking maken over een specifieke wijziging (gewijzigd deel van het document)
	* Ga naar de bijdrage vanuit tab "Pull requests" door op de titel van de bijdrage (≠ titel van document) te klikken
	* Ga naar tab "Files changed" (en selecteer zo nodig het gewijzigd bestand?)
	* Wijs met de muis over de betreffende gewijzigde regel (groen of rood gemarkeerd) tot er een blauw icoon met wit + erin links van de regel verschijnt. Klik op het + icoon
	* Vul bij "Write" je reactie op de opmerking
	* Wees altijd opbouwend, correct en vriendelijk. Iemand heeft immers de moeite genomen een bijdrage te leveren.
	* Klik op de knop "Add a single comment" (wat is het verschil met "Start a review"?)

7. Ik wil een correctie doorgeven (doen?) op een bijdrage (pull request) van iemand anders
	* Alleen de indiener van een pull request kan haar/zijn bijdrage aanpassen.
	* Zie verder bij "Ik wil een opmerking maken over een bijdrage van iemand anders"

8. Ik wil een correctie doen op een bijdrage (pull request) van mijzelf
	* Ga naar de bijdrage vanuit tab "Pull requests" door op de titel van de bijdrage (≠ titel van document) te klikken
	* Ga naar tab "Files changed" (en selecteer zo nodig het gewijzigd bestand?)
	* Klik op het pen-icoon
	* Voer de toevoegingen of wijzigingen door in de inhoud van het document
	* Vul bij "Commit changes" een korte titel voor de correctie en een uitgebreide toelichting hiervan
	* Klik op "Commit changes"

9. Ik wil een pull request intrekken
    * Ga naar de bijdrage vanuit tab "Pull requests" door op de titel van de pull request te klikken
    * Vul onderaan de pagina de reden in en klik op "Close pull request"

10. Ik wil anderen uitnodigen mijn bijdrage te beoordelen
	* Kan nu alleen met write access. Volgens https://help.github.com/articles/requesting-a-pull-request-review/ moet iedereen dit kunnen

11. Ik wil op een bijdrage van een ander aangeven dat deze (wat mij betreft) is goedgekeurd
12. Ik wil op bijdrage van een ander aangeven dat er gewenste aanpassingen zijn

13. Ik wil een document in mark down schrijven
	* Zie https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf voor opmaakcodes.
	* Zie https://guides.github.com/features/mastering-markdown/

14. Ik (beheerder van een repository) wil een pull request goedkeuren en toevoegen aan de repository
15. Ik (beheerder van een repository) wil een pull request afkeuren

16. Ik (beheerder van een repository) wil een wijziging doorvoeren aan een document
    * Ook al ben je beheerder, het aanbrengen van wijzigingen in documenten doe je nooit in de rol van beheerder.
    * Wanneer je iets wilt toevoegen of wijzigen volg je dus exact dezelfde procedure als ieder ander die iets wil wijzigen of toevoegen.
    * Ook al ben je beheerder, toch dien je wijzigingen in via een pull request, zodat anderen erop kunnen reageren.
    * Dus ook een beheerder commmit nooit direct op de VNG-Realisatie repository.

17. Ik (beheerder van een repository) wil een release maken
	* Maak een branch om alle wijzigingen en toevoegingen van de release in te verzamelen
	* Als de release af is merge je de branch met de master
	* Vervolgens publiceer je de release op GitHub:
		* Onder tab "Code" klik op "releases"
		* Klik op "Create a new release"
		* Vul de release versie (gebruik semantic versioning, begin de versie met "v", bijvoorbeeld "v1.0")
		* Vul de release titel en omschrijving en klik op "Publish release".

18. Ik wil een repository toevoegen
	* Vraag dit aan de beheerder van de GitHub organisatie VNG-Realisatie: Michiel Verhoef (michiel.verhoef@vng.nl).
	* Maak bij een repository direct ook een README.md aan!
	* Denk goed na over een naam en omschrijving van de repository, zodat men deze ook kan vinden.
	* Vul zo snel mogelijk de README.md met belangrijke informatie:
		* Beschrijf het "product: of resultaat van de repository (in ons geval meestal een standaard). Wat is het doel dat hiermee bereikt wordt.
		* Beschrijf hoe mensen het product kunnen gebruiken. Bijvoorbeeld verwijzing naar functionele specificaties, technische specificaties (schema's), referentie-implementatie.
		* Beschrijf hoe mensen aan de ontwikkeling kunnen bijdragen (contributing guide).
	* Maak, zover mogelijk een goed begin. Mensen dragen makkelijker bij aan iets dat er al (in enig vorm) is, dan aan een lege repository.
	* Nodig relevante belanghebbenden (potentiële gebruikers of deelnemers) uit om het "product" in de repository te gebruiken en eraan bij te dragen.

19. Ik wil voorafgaand aan een nieuwe actie mijn fork updaten.
	* Open de fork die je wil updaten;
	* Alleen indien het project aangeeft dat de master branch achterligt op de VNG-Realisatie:master moet er een update plaatsvinden. Klik rechts naast deze melding op "±Compare";
	* Het volgende scherm toont welke commits uit de head repository (in dit geval dus de fork) nog niet zijn doorgevoerd op de base repository (in dit geval de VNG-Realisatie repository). We willen echter juist weten welke commits uit de VNG-Realisatie repository nog niet zijn doorgevoerd op de fork. Daarom gaan we ze omwisselen.
	Klik op de button met de 'head repository' en kies daar de VNG-Realisatie repository;
	* In het menu verdwijnen nu de buttons met de base en head repositories. Er staat nu dus alleen 'base: master  <-- compare: master'. Klik daarboven nu op 'compare across forks';
	* De buttons met de base en head verschijnen weer en geven nu exact dezelfde repositories aan. Klik nu op de button met de 'base repository' en kies daar je fork;
	* Je krijgt nu alle commits te zien die de fork achterloopt op de upstream master. Als alles goed is wordt er aangegeven dat een merge mogelijk is ('Able to merge') Klik nu op de groene button "Create pull request" en ken er een duidelijke naam aan toe (bijv. 'Update fork');
	* Scroll evt. naar beneden en klik op "Create pull request";
	* Scroll naar beneden naar "Merge pull request";
	* Kies in die button de eerste van de 3 opties 'Create a merge commit';
	* Wijzig indien gewenst de description van de merge en klik op 'Confirm merge'.

	Zie ook [dit youtube filmpje](https://www.youtube.com/watch?v=YhwBgYPfoVE).

20. Ik wil een release uitbrengen van een repository.
	* Zorg dat alle pull requests die relevant zijn voor de release gemerged zijn;
	* Klik op de tab "Code";
	* Klik de subtab "release". Als er al releases zijn worden die hier getoond;
	* Klik op "Draft a new release";
	* Vul de "Tag version" in. We hanteren semantic versioning, dus bv "v1.0.0";
	* Vul de "Release title" in. bv "versie 1.0.0" ;
	* Indien gewenst kan er nog en omschrijving worden toegevoegd;
	* Klik op "Publish release" . Er wordt nu een release aangemaakt en er worden een corresponderende tag aangemaakt van de reposittory. Naar de tag kan worden verwezen vanuit andere repositories.


## Werken vanuit eigen laptop met eigen tooling
Soms wil je met je eigen editor documenten (dat kan ook code of schema zijn) bewerken. Bijvoorbeeld in XmlSpy, Eclipse, enz. Dan is het handiger om de bestanden van de repository op je eigen laptop te hebben staan en van daaruit te bewerken. Hieronder staat hoe je de versiebeheertool git kan gebruiken op je eigen laptop of pc, in combinatie met GitHub.
Beschreven is het gebruik van git vanuit command prompt (CMD) in windows en Terminal op een Mac. Veel tools kennen echter zelf (al dan niet via een plug in) ook voorzieningen om een deel van deze stappen te doen.
Er zijn ook verschillende tools om Git en GitHub handelingen te doen. Bijvoorbeeld:
* GitHub Desktop
* TortoiseGit

1. Ik wil een lokale werkplek beginnen van een repository
	* Preconditie: je hebt git (dat is iets anders dan GitHub!) geïnstalleerd op je computer. Let op, in verband met een aanpassing in de ondersteuning van TLS door GitHub is het noodzakelijk een versie van git te installeren die de TLS 1.2 of hoger ondersteunt. Momenteel is dat versie 2.17.0 (https://github.com/git-for-windows/git/releases).
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
