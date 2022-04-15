---
layout: page-with-side-nav
title: API Kennisbank
---


# Inleiding Design Rules

In de onderliggende Design Rules zijn de inzichten vastgelegd die zijn opgedaan bij het ontwerpen en specificeren van API's binnen diverse projecten waar VNG Realisatie bij betrokken is.
Deze Design Rules zijn binnen het team Standaarden besproken en er is consensus bereikt over het feit dat deze Design Rules toegepast worden op API-specificaties die door VNR Realisatie worden gemaakt of in beheer worden genomen.

Dit is een levende set van Design Rules die beïnvloed kan worden door voortschrijdend inzicht en door technologische ontwikkelingen. We houden bij een Design Rule bij wanneer we deze hebben toegevoegd, wanneer die is gewijzigd en indien van toepassing wanneer deze is afgevoerd. Door een opmerking te plaatsen en de datum van afvoeren toe te voegen.

Om die reden kan het zijn dat de specificaties die door VNG Realisatie zijn opgesteld of in beheer zijn genomen niet voldoen aan alle Design Rules.
Op het moment dat een nieuwe versie van een dergelijke  API-specificatie gepland wordt waarmee breaking changes worden doorgevoerd bepaalt de betreffende designer of dat een kans is om correcties door te voeren waardoor de API weer voldoet aan de onderstaande Design Rules.

Een nieuwe versie van een API specificatie met een breaking change houdt dus niet automatisch in dat deze is aangepast aan de Design Rules.

# Landelijke API-strategie

VNG conformeert zich aan de [Design Rules en de Rest-principes van de landelijke API-strategie](https://docs.geostandaarden.nl/api/API-Designrules/). Daar komen de onderstaande punten aan bod.

_RESTful principles_

- _API principle: operations are Safe and/or Idempotent_
- _API principle: do not maintain state information at the server_
- _API principle: Only apply default HTTP operations_
- _API principle: Leave off trailing slashes from API endpoints_
- _API principle: Define interfaces in Dutch unless there is an official English glossary_
- _API principle: Use plural nouns to indicate resources_
- _API principle: Create relations of nested resources within the endpoint_
- _API principle: Implement custom representation if supported_
- _API principle: Implement operations that do not fit the CRUD model as sub-resources_
- _API principle: Documentation conforms to OAS v3.0 or newer_
- _API principle: Publish documentation in Dutch unless there is existing documentation in English or there is an official English glossary available_
- _API principle: Include a deprecation schedule when publishing API changes_

_Best practice(s)_
- _API principle: Publish OAS at a base-URI in JSON-format_
- _API principle: Allow for a (maximum) 1 year deprecation period to a new API version_
- _API principle: Include only the major version number in the URI_


_Normative API Principles_

- _3.1 API-01: Operations are Safe and/or Idempotent_
- _3.2 API-02: Do not maintain state information at the server_
- _3.3 API-03: Only apply default HTTP operations_
- _3.4 API-04: Define interfaces in Dutch unless there is an official English glossary_
- _3.5 API-05: Use plural nouns to indicate resources_
- _3.6 API-06: Create relations of nested resources within the endpoint_
- _3.7 API-09: Implement custom representation if supported_
- _3.8 API-10: Implement operations that do not fit the CRUD model as sub-resources_
- _3.9 API-16: Use OAS 3.0 for documentation_
- _3.10 API-17: Publish documentation in Dutch unless there is existing documentation in English or there is an official English glossary available_
- _3.11 API-18: Include a deprecation schedule when publishing API changes_
- _3.12 API-19: Allow for a maximum 1 year transition period to a new API version_
- _3.13 API-20: Include the major version number only in ihe URI_
- _3.14 API-48: Leave off trailing slashes from API endpoints_
- _3.15 API-51: Publish OAS at the base-URI in JSON-format_

De [niet-normatieve extensions van de landelijke API-strategie](https://docs.geostandaarden.nl/api/API-Designrules/) worden behandeld als richtlijnen bij het opstellen van API-specificaties. Als er binnen VNG Realisatie een aanscherping is gedaan is deze in het volgende hoofdstuk opgenomen als VNG Design Rule. Daarbij wordt ook een verwijzing opgenomen naar de betreffende extension.
