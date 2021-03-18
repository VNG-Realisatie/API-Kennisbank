# GitFlow implementatie

Dit document is geen tutorial over GitFlow, het beoogd slechts een uitleg te geven over de wijze waarop GitFlow geïmplementeerd is binnen de GitHub repositories van VNG Realisatie.

GitFlow kenmerkt zich door het gebruik van enkele standaard branches die elk een specifieke functie vervullen. Waar GitFlow de volgende branches kent:

* 'master' of 'main'
* 'develop'
* 'feature'
* 'release'
* 'hotfix'
* 'support'

wordt er binnen de VNG Realisatie respositories alleen gebruik gemaakt van de eerste 3 branch types. 

> Het is binnen VNG Realisatie gebruik om de werkwijze van GitFlow pas te implementeren na de eerste officiële versie. Het valt echter te overwegen om meteen bij initialisatie van de GitHub repository deze in te richten op het gebruik van GitFlow en direct op deze wijze te gaan werken.
 
## master of main branch 

De 'master' (of tegenwoordig vaak 'main') branch is standaard al aanwezig in een GitHub repository. In onze implementatie van GitFlow wordt deze alleen gebruikt om afgeronde ontwikkelstadia naar te kunnen committen. Uiteindelijk worden op basis daarvan in de 'master' branch de releasetags gegenereerd. Dat hoeven overigens niet alleen final releases te zijn. Ook een 0.0.1 release kan daarvoor in aanmerking komen.

> De 'master' branch wordt ook gebruikt om vanuit de 'docs' folder de GitHub page site van de betreffende repository te genereren.

## develop branch

Deze branch kan meteen bij initialisatie van een repository aangemaakt worden maar ook later. Als deze later wordt aangemaakt dan moet de inhoud van de master brach daarheen gekopieerd worden. Daarna moet de 'develop' branch gebruikt worden voor de doorontwikkeling. Ontwikkelaars die ontwikkelen op deze repository zullen, nadat ze hem ge'cloned' hebben, op de 'develop' branch moeten gaan werken.

Zodra een de 'develop' branch een status heeft bereikt die men als een release wil bewaren wordt de inhoud van de 'develop' branch gecommit naar de 'master' branch. Daarna kan de 'develop' branch weer worden gebruikt om op door te ontwikkelen.

## feature branches
