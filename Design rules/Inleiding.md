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

VNG conformeert zich aan de [Design Rules en de Rest-principes van de landelijke API-strategie](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/). Daar komen de onderstaande punten aan bod.

**Lijst met functionele regels**
* [/core/naming-resources: Use nouns to name resources](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/naming-resources)
* [/core/naming-collections: Use plural nouns to name collection resources](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/naming-collections)<br/>
  was _API principle: Use plural nouns to indicate resources_ en _3.5 API-05: Use plural nouns to indicate resources_
* [/core/interface-language: Define interfaces in Dutch unless there is an official English glossary available](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/interface-language)<br/>
  was _API principle: Define interfaces in Dutch unless there is an official English glossary_ en _3.4 API-04: Define interfaces in Dutch unless there is an official English glossary_
* [/core/hide-implementation: Hide irrelevant implementation details](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/hide-implementation)
* [/core/http-safety: Adhere to HTTP safety and idempotency semantics for operations](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/http-safety)<br/>
  was _API principle: operations are Safe and/or Idempotent_ en _3.1 API-01: Operations are Safe and/or Idempotent_
* [/core/stateless: Do not maintain session state on the server](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/stateless)<br/>
  was _API principle: do not maintain state information at the server_
* [/core/nested-child: Use nested URIs for child resources](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/nested-child)
* [/core/resource-operations: Model resource operations as a sub-resource or dedicated resource](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/resource-operations)
* [/core/doc-language: Publish documentation in Dutch unless there is existing documentation in English](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/doc-language)<br/>
  was _API principle: Publish documentation in Dutch unless there is existing documentation in English or there is an official English glossary available_ en _3.10 API-17: Publish documentation in Dutch unless there is existing documentation in English or there is an official English glossary available_
* [/core/deprecation-schedule: Include a deprecation schedule when deprecating features or versions](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/deprecation-schedule)<br/>
  was _API principle: Include a deprecation schedule when publishing API changes_ en _3.11 API-18: Include a deprecation schedule when publishing API changes_
* [/core/transition-period: Schedule a fixed transition period for a new major API version](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/transition-period)<br/>
  was _API principle: Allow for a (maximum) 1 year deprecation period to a new API version_  en _3.12 API-19: Allow for a maximum 1 year transition period to a new API version_
* [/core/changelog: Publish a changelog for API changes between versions](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/changelog)
* [/core/geospatial: Apply the geospatial module for geospatial data](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/geospatial)

**Lijst met technische regels**
* [/core/no-trailing-slash: Leave off trailing slashes from URIs ](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/no-trailing-slash)<br/>
  was _API principle: Leave off trailing slashes from API endpoints_ en _3.14 API-48: Leave off trailing slashes from API endpoints_
* [/core/http-methods: Only apply standard HTTP methods](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/http-methods)<br/>
  was _API principle: Only apply default HTTP operations_ en _3.3 API-03: Only apply default HTTP operations_
* [/core/doc-openapi: Use OpenAPI Specification for documentation](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/doc-openapi)
* [/core/publish-openapi: Publish OAS document at a standard location in JSON-format](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/publish-openapi)
* [/core/uri-version: Include the major version number in the URI](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/uri-version)<br/>
  was _API principle: Include only the major version number in the URI_ en _3.13 API-20: Include the major version number only in ihe URI_
* [/core/semver: Adhere to the Semantic Versioning model when releasing API changes](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/semver)
* [/core/version-header: Return the full version number in a response header](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/version-header)
* [/core/transport-security: Apply the transport security module](https://gitdocumentatie.logius.nl/publicatie/api/adr/2.0.2/#/core/transport-security)

**Niet meer in de NL API Design Rules voorkomende regels**

_RESTful principles_

- _API principle: Create relations of nested resources within the endpoint_
- _API principle: Implement custom representation if supported_
- _API principle: Implement operations that do not fit the CRUD model as sub-resources_
- _API principle: Documentation conforms to OAS v3.0 or newer_

_Best practice(s)_
- _API principle: Publish OAS at a base-URI in JSON-format_

_Normative API Principles_
- _3.2 API-02: Do not maintain state information at the server_
- _3.6 API-06: Create relations of nested resources within the endpoint_
- _3.7 API-09: Implement custom representation if supported_
- _3.8 API-10: Implement operations that do not fit the CRUD model as sub-resources_
- _3.9 API-16: Use OAS 3.0 for documentation_
- _3.15 API-51: Publish OAS at the base-URI in JSON-format_

De [niet-normatieve extensions van de landelijke API-strategie](https://docs.geostandaarden.nl/api/API-Designrules/) worden behandeld als richtlijnen bij het opstellen van API-specificaties. Als er binnen VNG Realisatie een aanscherping is gedaan is deze in het volgende hoofdstuk opgenomen als VNG Design Rule. Daarbij wordt ook een verwijzing opgenomen naar de betreffende extension.
