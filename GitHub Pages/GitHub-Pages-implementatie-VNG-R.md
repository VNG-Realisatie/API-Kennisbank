---
layout: landing-page
title: GitHub Pages implementatie voor VNG Realisatie
---
# GitHub Pages implementatie voor VNG Realisatie

GitHub repositories bieden de ideale omgeving om samen te werken aan code (in welke vorm dan ook).
Het is echter wel een complexe omgeving en niet zo geschikt om informatie te publiceren voor personen die geen ontwikkelaar zijn.
* Het is erg technisch van aard en niet altijd even intuïtief in gebruik. 
* Het biedt functionaliteit waarmee je de genoemde doelgroep niet wil confronteren. Functionaliteit die het alleen nog maar complexer maakt.
* Er zijn binnen een repository geen mogelijkheden om de informatie in een eigen opmaak te presenteren. Opmaak is van ondergeschikt belang en de gebruikte opmaak is over alle GitHub repositories gelijk.

GitHub Pages komen hieraan tegemoet.
Het is een extensie op GitHub die eenvoudig te activeren is en waarmee je bezoekers kunt afschermen van de complexe interface en functionaliteit.
Een respository eigenaar kan de content van zijn GitHub repository op de gewenste wijze presenteren (vormgeving en navigatiestructuur) zonder dat daarvoor veel kennis van html nodig is. Ook hoeft er geen energie te worden gestoken in het inrichten en configureren van databases en servers. 

GitHub Pages bestanden staan gewoon in de GitHub repository zelf. In die zin wijken ze niet af van andere bestanden in een GitHub repository en je kunt dus ook alle tools en workflows die je voor je core content hanteert loslaten op deze bestanden. Voor het onderhouden van je site kun je dus:
* issues opvoeren en gebruik maken van alle daaraan gekoppelde functionaliteit;
* branches en pull requests aanmaken waarin je gezamenlijk kunt werken aan nieuwe versies van de GitHub Pages bestanden;
* project boards inrichten om de voortgang van de wijzigingen op de GitHub pages bestanden goed te monitoren en te sturen;
* etc…

De GitHub repo weet echter dat deze bestanden vertaalt moeten worden naar een GitHub Pages site.
GitHub Pages genereert de html code waaruit je website bestaat en draagt ook zorg voor het deployen van je website.
Daardoor kan een repository eigenaar zich helemaal focussen op de content van de website.

Het genereren gebeurd m.b.v. Jekyll. Zo gewenst kunnen er ook andere site generatoren worden gebruikt maar GitHub adviseert om Jekyll te gebruiken en binnen VNG-R doen we dat ook. Speciaal voor VNG Realisatie is een zogenaamd theme ontwikkeld. Een theme wordt vastgelegd in een separate GitHub repository en bevat standaard componenten waarmee een website kan worden vervaardigd:
* Html bestanden;
* Images;
* CSS bestanden;
* Scripts;
* Etc…

Alle GitHub project sites hebben een unieke 'github.io' url met de volgende syntax:

`https://[naam].github.io/[repository-naam]`

bijv:

`https://vng-realisatie.github.io/klantinteracties/)`

## Configuratie van GitHub Pages
Ten einde gebruik te kunnen maken van GitHub Pages moet dit voor elke GitHub repository geconfigureerd worden. In de basis gebeurd dat door aan te geven in welke branch en folder de GitHub Pages bestanden staan. Ga daarvoor naar het GitHub Pages settings menu ('Setting' en daarna in het side menu 'Pages').
Binnen VNG-R gebruiken we standaard de 'master' of 'main' branch en plaatsen we alle content standaard in de 'docs' folder. 

<img src="https://user-images.githubusercontent.com/20185784/176900351-8db4ec14-d292-4502-853b-5fde9c2a137f.png" width="500"/>

Als er goede redenen voor zijn kan natuurlijk van deze regel afgeweken worden.

Het is een goede gewoonte om de link die na activatie in het bovenstaande menu wordt getoond (zie de rode pijl) te kopiëren en in de repository details in het veld 'Website' te plakken. De GitHub Pages site is daarmee altijd eenvoudig via de home pagina van de repository te benaderen.

## Gebruik 'docs' folder
In de 'docs' folder kunnen allerlei bestanden geplaats worden maar minimaal moet daar een 'index.md' of 'index.html' gecreëerd worden.
Het 'index.md' bestand zal door GitHub Pages geconverteerd worden naar html. In deze folder kunnen echter meer '.md' en/of '.html' bestanden worden geplaatst al dan niet in subfolders en in al deze bestanden kunnen links opgenomen worden naar die bestanden. Zie deze [cheatsheet](https://www.markdownguide.org/cheat-sheet/) voor wat meer informatie over de markdown-syntax.

## Deployment
Steeds als er wijzigingen worden aangebracht in een van de bestanden in de 'docs' folder zal Jekyll een nieuwe versie van de site genereren. Er kunnen echter enkele minuten overheen gaan voordat dit klaar is. De status van dit proces kan gevolgd worden via het 'Actions' menu en het betreft dan de action 'pages build en deployment'. Een andere optie is in de home pagina van de repository het 'Environment' menu aan de linkerzijde te selecteren.

## Op smaak brengen
Om de gegenereerde pagina's nog wat beter op smaak te brengen dien je in het GitHub Pages settings menu ('Setting' en daarna in het side menu 'Pages') een theme te kiezen. 

<img src="https://user-images.githubusercontent.com/20185784/176908026-247c9b23-1166-496e-ba2d-61b2dfbc4513.png" width="500"/>

Het maakt niet zo heel veel uit welk theme je kiest. Het belangrijkste is dat door deze actie de GitHub repository wordt voorbereid op het gebruik van themes en in het bijzonder op het gebruik van het VNG-R theme. Zo zal door deze actie in de folders 'docs' het bestand '\_config.yml' worden aangemaakt. Om gebruik te kunnen maken van het VNG-R theme hoeft alleen de volgende regel te worden toegevoegd.

```
remote_theme: VNG-Realisatie/jekyll-theme-vng-realisatie
```
Voor een uitgebreidere uitleg over het VNG-R theme verwijzen wek naar [de beschrijving daarvan in de repository van het theme](https://github.com/VNG-Realisatie/jekyll-theme-haal-centraal/blob/master/README.md).
Om echter echt gebruik te kunnen maken van dat VNG-R theme moet boven elk '.md' bestand ook nog de volgende header worden opgenemen:

```
---
layout: [layout optie]
date: [datum]
title: "[Titel van de pagina]"
---
```

Met name de header property ‘layout’ is daarbij van belang. Daar kan gekozen worden voor 2 smaken:
* landing-page
* page-with-side-nav

De eerste optie zet het '.md' bestand om naar een pagina zonder side navigatie, de tweede optie genereert wel een side navigatie. Beide optie krijgen wel dezelfde top-navigatie.

## Side navigatie
Indien er in een van de '.md' bestanden bij de 'layout' header is gekozen voor de optie 'page-with-side-nav' moet de gewenste side navigatie wel geconfigureerde worden. Dat gebeurd door het '_config.yml' bestand te voorzien van de volgende structuur:

```
baseurl: "[baseurl]"
apiname: "[api-naam]"
url: "http://localhost:4000"
nav:
  - title: [Title]
    subnav:
      - title: [Title]
        path: /
  - title: [Title] 
    subnav:
      - title: [Title]
        path: /intro
      - title: [Title]
        path: /speciale-technieken
```
Daarbij dien je de volgende variabelen zelf van een waarde te voorzien:
* [baseurl]
  vervangen deze door de baseurl van de GitHub repository. Is de url van je GitHub repository bijv. 'https://github.com/VNG-Realisatie/klantinteracties' dan is de baseurl '/klantinteracties'.
* [api-naam]
  Deze is niet strikt noodzakelijk voor de side navigatie maar wordt door het VNG-R theme wel gebruikt. Vul de naam van de API in zoals je deze visueel op de pagina getoond wil hebben.
* [Title]
  De titel van het betreffende niveau zoals dit zal worden getoond in de side navigatie. Het aantal karakters is onbeperkt maar een te groot aantal karakters zal de side navigatie er niet duidelijker op maken.
  
Zoals je ziet bestaat de side navigatie uit 2 navigatie niveau's (de 'nav' en 'subnav' property) en kun je binnen die niveau's meerdere titels opnemen. In principe wordt je daarin niet beperkt.
De 'path' property kan de waarde '/' bevatten wat eigenlijk betekent dat er een link naar het 'index.md' bestand in de 'docs' folder wordt gegenereerd. Of om het helemaal correct te zeggen naar het 'index.html' bestand dat wordt gegenereerd op basis van het 'index.md' bestand in de 'docs' folder.
De 'path' property kan echter ook een verwijzing bevatten naar een ander '.md' bestand of '.html' bestand. In het geval van een '.md' bestand wordt de '.md' weggelaten.

Als alternatief voor de 'path' property mag je overigens ook de 'url' property gebruiken. In dat geval moet je voorzien in een volledig http(s) adres. Handig als je naar een geheel andere repository of zelfs webadres wil verwijzen.
Tenslotte kan je aan elk 'nav' of 'subnav' item nog de property 'target' toevoegen met de waarde 'blank'. Selectie van de gegenereerde link resulteert er dan in dat de betreffende pagina in een nieuw tabbald wordt geöpend.

## Top navigatie
De top navigatie wordt geregeld in het VNG-R theme en is voor alle repositories die dit theme gebruiken gelijk.
De top navigatie kent het item 'VNGR API Standaarden'. Indien je de door jouw vervaardigde GitHub Pages site opgenomen wil hebben in dat menu, dien dan een verzoek in bij [Robert Melskens](mailto:robert.melskens@vng.nl).

Als je ideeën hebt voor andere aanpassingen in de top navigatie maak dan een issue aan in de repository van het [VNG-R theme](https://github.com/VNG-Realisatie/jekyll-theme-vng-realisatie/issues). Aangezien deze repo niet de continue aandacht van zijn beheerder is het goed om ook deze ook hier even een mailtje over te sturen ([Robert Melskens](mailto:robert.melskens@vng.nl))
