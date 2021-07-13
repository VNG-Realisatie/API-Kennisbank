# Policy Design Rules

In dit document beschrijven we hoe we in het Kenniscentrum Standaarden van VNG Realisatie omgaan met Design Rules. 
Daarbij doelen we op de eigen Design Rules, de Design Rules die in de Nederlandse API Strategie zijn beschreven maar ook op de Extensions die op beide niveaus beschikbaar zijn.
Extensions hebben geen officiële status, ze kunnen worden gezien als potentiële Design Rules.

## Toepassing Design Rules en Extensions

Het toepassen van Design Rules en Extensions is aan de volgende regels gebonden:

1. Bij het vervaardigen van API specificaties houden we ons aan [de Design Rules zoals gedefinieerd in de Nederlandse API Strategie](https://docs.geostandaarden.nl/api/API-Designrules/);
2. Tevens houden we ons aan [de Design Rules van VNG Realisatie](https://github.com/VNG-Realisatie/API-Kennisbank/blob/master/Design%20rules/readme.md);
3. Waar mogelijk volgen we [de Extensions van de Nederlandse API Strategie](https://docs.geostandaarden.nl/api/API-Strategie-ext/) en (zodra we daarover beschikken) de Extensions van VNG Realisatie voor zover die van toepassing zijn. In een Design Decision van het project waarin de API specificatie wordt vervaardigd beschrijven we aan welke Extensions we ons houden;

Als vanuit project-belang wordt overwogen om een Design Rule (landelijk of VNG) niet toe te passen dan worden de argumenten waarom dat binnen het project niet wordt gedaan gedocumenteerd. Die argumenten worden binnen het team besproken.

## Het toevoegen, wijzigen of verwijderen van VNG Realisatie Design Rules en Extensions

Zoals al gesteld in [de Design Rules van VNG Realisatie](https://github.com/VNG-Realisatie/API-Kennisbank/blob/master/Design%20rules/readme.md) kunnen Design Rules en Extensions onderhevig zijn aan voortschrijdend inzicht en technologische ontwikkelingen. 
Het kan dus noodzakelijk blijken een Design Rule of Extension te wijzigen of te verwijderen. Ook kan er behoefte aan een nieuwe Design Rule of Extension ontstaan, een behoefte die over het algemeen in een project naar voren zal komen en die daar dan als een Design Decision wordt gedocumenteerd.

Het proces voor het wijzigen, verwijderen van een bestaande of opvoeren van een nieuwe Design Rule of Extension is als volgt:

1. Er wordt in de API-Kennisbank repository een issue ingediend met het label 'Design Rule'. 
2. Indien het om een voorstel voor een nieuwe Design Rule gaat wordt deze zo duidelijk mogelijk beschreven, zo mogelijk voorzien van voorbeelden en ratio;
3. Indien het om een voorstel tot wijziging gaat wordt beschreven welke Design Rule moet worden gewijzigd, wat die wijziging inhoudt en wat daarvoor de ratio is;
4. Betreft het een verwijderingsvoorstel dan wordt beschreven welke Design Rule het betreft en wat de reden is van het verzoek;
5. Vervolgens wordt er in een eerste reactie een lijstje met initialen van de medewerkers van het Kenniscentrum Standaarden op deze wijze geplaatst:

> JB: <br/>
> HK: <br/>
> RM: <br/>
> MV: <br/>
> GJ: <br/>
> JBi: <br/>

6. Het issue wordt assigned aan alle medewerkers van het Kenniscentrum Standaarden;
7. Elke medewerker geeft vervolgens z.s.m. in de lijst met initialen achter zijn initialen aan hoe hij over het issue denkt ('Overnemen', 'Bespreken', 'Geen mening', 'Toelichting gewenst). Daarnaast kan elke medewerker zijn mening ook nog toelichten in een aparte post. Evt. kan daarin ook worden aangegeven dat het betreffende issue alleen als Extension moet worden opgenomen.
8. Kan iedereen zich vinden in het issue en de status (Design Rule of Extension) dan wordt het zonder verdere discussie doorgevoerd;
9. Indien dat niet het geval is dan wordt zo mogelijk de inhoudelijke discussie digitaal gevoerd en beslecht middels github comments. Als dat niet lukt, dan wordt het issue als onderwerp van het teamoverleg Kenniscentrum Standaarden geagendeerd;
10. In dat overleg wordt besloten of het voorstel wordt gehonoreerd en met welke status (Design Rule of Extension); 
11. Indien goedgekeurd wordt de Design Rule of de Extension toegevoegd aan [de Design Rules van VNG Realisatie](https://github.com/VNG-Realisatie/API-Kennisbank/blob/master/Design%20rules/readme.md).
12. In de zeldzame gevallen waarin we met een Design Rule structureel afwijken van de landelijke Rest-API-strategie is een "Leg uit"-situatie van toepassing. In de Design Rule moet dan heel goed uitgelegd worden waarop we afwijken en waarom deze afwijking van belang is. In zo'n geval moet ook weer de discussie met de rest van de community worden opgestart om te kijken waar deze verschillen in inzicht in zitten en of we de landelijke strategie dan niet iets losser of juist strakker moeten definiëren.

M.b.t. het wijzigen en verwijderen van Design Rules wordt in de periode tussen het opvoeren van het issue en het besluit in de projecten niet vooruitgelopen op dat besluit. Aanpassingen n.a.v. het honoreren van het voorstel worden dus pas aangebracht nadat het voorstel is gehonoreerd.

Voorwaarde daarvoor is wel een pro-actieve houding in de discussie van de medewerkers van Kenniscentrum Standaarden. Zo'n aanpassing kan voor een project nl. erg urgent zijn, dus het niet vooruitlopen op een beslissing kan problematisch zijn. Als het team het niet eens wordt over de wijziging of verwijdering van de Design Rule mag wel vooruitgelopen worden in een project. In dat geval dient dit feit wel als een Design Decision van je project te worden gedocumenteerd.

## Voordracht VNG Realisatie Design Rules voor Landelijke API Strategie

Design Rules van VNG Realisatie kunnen door het Kenniscentrum Standaarden worden aangeboden aan de werkgroep 'API design rules' van het Kennisplatform API's.
Eenieder kan daartoe een verzoek indienen. De te volgen procedure is daarbij als volgt:

1. Er wordt in de API-kennisbank repository een issue ingediend met het label 'Kandidaat DR landelijke API_strategie';
2. Het voorstel voor de Design Rule, inclusief de ratio wordt beschreven en daarbij wordt tevens de argumentatie waarom deze opgenomen moet worden in de landelijke API-strategie opgenomen;
3. Vervolgens wordt er in een eerste reactie een lijstje met initialen van de medewerkers van het Kenniscentrum Standaarden op deze wijze geplaatst:

> JB: <br/>
> HK: <br/>
> RM: <br/>
> MV: <br/>
> GJ: <br/>
> JBi: <br/>

4. Het issue wordt assigned aan alle medewerkers van het Kenniscentrum Standaarden;
5. Elke medewerker geeft vervolgens z.s.m. in de lijst met initialen achter zijn initialen aan hoe hij over het issue denkt ('Overnemen', 'Bespreken', 'Geen mening', 'Toelichting gewenst). 
6. Kan iedereen zich vinden in het issue dan zal de daarvoor verantwoordelijke medewerker (op dit moment Henri Korver) er voor zorgdragen dat de betreffende Design Rule wordt aangeboden aan de genoemde werkgroep;
7. Indien dat niet het geval is dan wordt zo mogelijk de inhoudelijke discussie digitaal gevoerd en beslecht middels github comments. Als dat niet lukt, dan wordt het issue als onderwerp van het teamoverleg Kenniscentrum Standaarden geagendeerd;
8. In dat overleg wordt besloten of het voorstel wordt gehonoreerd; 
9. Indien het voorstel akkoord wordt bevonden zal de daarvoor verantwoordelijke medewerker er voor zorgdragen dat de betreffende Design Rule wordt aangeboden aan de genoemde werkgroep.
