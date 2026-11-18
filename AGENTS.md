# AGENTS.md — DAISY Pipeline 2 (`NPavie/pipeline`)

## Architecture du dépôt

Dépôt multi-modules Maven (pom racine `pom.xml`) pour le serveur de conversion « DAISY Pipeline 2 » :

- `assembly/` — packaging java/maven de la distribution (server + CLI embarqué + UI graphique Swing).
  C'est ici que se trouvent :
  - `src/main/java/GraphicalInterface.java` (package par défaut) : UI Swing embarquée, lancée par
    `pipeline2 ui` (voir `src/main/resources/bin/pipeline2` et `pipeline2.bat`). Affiche une fenêtre de
    progression (barre + label live + zone de log + bouton « Annuler ») pour une conversion lancée en
    ligne de commande, via `api.SimpleAPI.startJob(...)` et le monitoring `api.CommandLineJob`.
  - `src/main/java/CommandLineInterface.java` : CLI embarqué (`pipeline2 cli`), avec les commandes
    `descriptors`, `scripts`, `script --id`, `datatypes`, `datatype --id`, `settable-properties`, `help`
    qui exportent les descripteurs XML via `api.SimpleAPI` et les writers du package `xml/`.
  - `src/main/java/api/` (`SimpleAPI`, `CommandLineJob`, `CommandLineJobParser`, `MessageQueueItem`),
    `src/main/java/xml/` (writers XML : scripts, datatypes, properties), `src/main/java/ui/`
    (`LiveJLabel`, label accessible `AccessibleRole.ALERT` pour les annonces lecteur d'écran).
  - `scripts.xml`, `datatypes.xml`, `properties.xml` à la racine d'`assembly/` : exports XML de
    référence (générés par les commandes CLI, ne pas éditer à la main).
  - Le profil Maven `with-simple-api` compile `src/main/java` en **Java 8** (source/target 8) vers
    `target/simple-api`, sur classpath simple (pas de JPMS). Build de dev : `make -C assembly
    dev-launcher` → `assembly/target/dev-launcher/pipeline2` (modes `ui` / `cli`).
  - Répertoire de données utilisateur : variable d'env `PIPELINE2_DATA` (`%APPDATA%/DAISY Pipeline 2`
    sous Windows, `$PIPELINE2_HOME/data` par défaut sous Linux/macOS).
- `cli/` — client CLI natif (Go) `dp2` parlant au webservice.
- `clientlib/` — clients du webservice.
- `framework/` — cœur du pipeline (jobs, scripts, datatypes, webservice), ex `framework/common-utils`
  contient `org.daisy.common.properties.Properties` (propriétés réglables, `settable-properties`).
- `modules/` — scripts de conversion XProc (un dossier par script, ex `daisy3-to-epub3`,
  `word-to-dtbook`).
- `libs/` — bibliothèques (braille-utils, dotify).
- `utils/`, `website/`, `.make/`, `.git-utils/` — outillage, site, Makefiles internes.

Conventions : commits en « conventional commits » (`type(scope): sujet`, ex `dev(xsl): ...`,
`fix(...)`), branches de fonctionnalités préfixées par le sujet. Pas de tests automatisés pour l'UI
Swing (`assembly/src/test` ne contient que des tests xspec).

## Dernières modifications effectuées

Sur la branche `embedded-ui` (commit `e602d636` « dev: prepare features definition for AI agent dev"),
le fichier `assembly/improvedui.md` a été **complété** pour servir de plan de développement déléguable
à un agent IA (type GLM 5.3) :

- ajout d'une section « Codebase map » pointant précisément les fichiers concernés
  (`GraphicalInterface.java`, `CommandLineInterface.java`, `api/SimpleAPI.java`, `xml/*`,
  `ui/LiveJLabel.java`, lanceurs `bin/pipeline2(.bat)`) et le format des XML de référence
  (`scripts.xml`, `datatypes.xml`, `properties.xml`) ;
- documentation de la résolution du répertoire de données utilisateur (`PIPELINE2_DATA`, `%APPDATA%`,
  XDG) et de la procédure de build/test (`make -C assembly dev-launcher`, `pipeline2 ui` / `cli`) ;
- les fonctionnalités demandées initialement (cache scripts/datatypes, boîte de dialogue « Settings »,
  fusion formulaire de conversion + fenêtre de progression, scénarios GUI complets avec détection de
  type de fichier et commande `prepare`) ont été reprises, complétées (paragraphe inachevé de la
  fenêtre unique finalisé) et structurées en exigences F1–F4 avec critères d'acceptation ;
- ajout d'un plan de développement ordonné (T1–T5), de conventions (Java 8, Swing, accessibilité via
  `LiveJLabel`/`ACCESSIBLE_NAME_PROPERTY`, codes de sortie 0/1/2, `Map<String,List<String>>` pour les
  options) et d'une procédure de vérification manuelle.

Aucun code source n'a été modifié : seuls des documents Markdown (`assembly/improvedui.md` et le
présent `AGENTS.md`) ont changé.
