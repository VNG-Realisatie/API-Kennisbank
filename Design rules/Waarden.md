---
layout: page-with-side-nav
title: API Design rules - Waarden
---

# 1. Waarden

### DR2.1 Voor het uitdrukken van tijdsduur gebruiken we de ISO-8601 standaard
Voor een element van een referentielijst-type, wordt in de response zowel de code als de omschrijving opgenomen. Dit betreft dynamische lijsten (tabellen) met een code en waarde, zoals "Tabel 32 Nationaliteitentabel".

_**Ratio:**_

Dit is een veelgebruikte internationale standaard.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

### DR2.2 Gebruik een boolean voor Ja/Nee of waar/onwaar

Eigenschappen die functioneel alleen de waarde Ja/aan/waar of Nee/uit/onwaar kunnen hebben, worden gedefinieerd als boolean. We gebruiken dus geen enumeratie zoals [J,N] voor dit soort situaties.

_**Ratio:**_ Een boolean is technisch eenduidiger en beter verwerkbaar voor developers.

Datum opname : 29-04-2021
Datum wijziging : 29-04-2021

### DR2.3 Dynamische domeinwaarden worden in de query-parameters met de code opgenomen

Voor een query-parameter waarin een entry uit een waardelijst of een landelijke tabel als selectie-criterium wordt gebruikt wordt de code van de entry gebruikt.

_**Ratio:**_ De omschrijving is human readable tekst. Daar kunnen verschillen in staan, bijvoorbeeld hoofd- of kleine letters. Voor een computer een verschil, voor een mens niet. Daarnaast levert het gebruik van codes ook kortere URL's op.

Datum opname : 29-04-2021
Datum wijziging : 29-04-2021

### DR2.4 Enumeratie-waarden zijn in snake_case

Voor de waarden van enumeraties wordt snake_case toegepast. Deze bevatten dus alleen kleine letters, cijfers en underscores. Geen spaties, geen speciale tekens en geen hoofdletters.

_**Ratio:**_ In sommige development-omgevingen leveren hoofdletters, spaties of speciale tekens in enumeratie-waarden een probleem op met code-genereren.

Datum opname : 17-02-2021
Datum wijziging : 17-02-2021

### DR2.5 Schema componentnamen voor domeinwaarden en enumeraties krijgen een vaste extensie

Schema componenten voor dynamische domeinwaarden (referentielijsten zoals "Tabel 32 Nationaliteitentabel") en enumeraties krijgen respectievelijk extensie "Tabel" en "Enum" zonder de toevoeging van underscores.

_**Ratio:**_ Vaak heeft de property dezelfde naam als de enumeratie die aangemaakt wordt. Onderscheid is dan prettig en soms zelfs nodig i.r.t. codegenratie. Hetzelfde argument geldt voor referentielijsten.

Datum opname : 29-04-2021
Datum wijziging : 29-04-2021

