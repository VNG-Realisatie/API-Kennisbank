# GitHub Pages implementatie voor VNG Realisatie

Er is speciaal voor VNG Realisatie een theme ontwikkeld.
Om  de gebruikers van deze repository gebruik te kunnen laten maken van dit theme moet in de GitHub Pages sectie van de Settings aangegeven worden welke branch en 
folder als bron voor de GitHub Pages moet worden beschouwd. Binnen Haal Centraal gebruiken wij in principe altijd de 'docs' folder van de 'master/main' branch. 

Aan het bestand '\_config.yml' dat daarop in die folder wordt aangemaakt moet de volgende regel toegevoegd worden om de repo het onderliggende theme te laten gebruiken:

```
remote_theme: VNG-Realisatie/jekyll-theme-haal-centraal
```

Daarna kan de content van de GitHub Pages site door de gebruikers van de repository zelf worden opgezet. 
Voor een uitleg over hoe dit te doen met het aangegeven theme verwijs ik naar [de beschrijving daarvan in de repository van het theme](https://github.com/VNG-Realisatie/jekyll-theme-haal-centraal/blob/master/README.md).
