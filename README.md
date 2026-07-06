# Config Neovim personnelle

Une configuration Neovim pensée pour écrire du C et du C++ au quotidien, sans renoncer au confort ni au plaisir. Elle est prévisible (les choses se comportent toujours de la même façon), ergonomique (les raccourcis sont regroupés par logique et faciles à retenir) et un peu vivante (quelques effets visuels rendent l'édition plus agréable, sans en faire trop).

Elle fonctionne aussi bien sur une machine personnelle que sur les postes de l'école 42, où l'on n'a pas les droits administrateur. La section installation détaille les deux cas.

---

## Table des matières

- [Le principe](#le-principe)
- [Aperçu](#aperçu)
- [Installation](#installation)
  - [Ce qu'il faut vérifier et installer](#ce-quil-faut-vérifier-et-installer)
  - [Sur Arch Linux](#sur-arch-linux)
  - [Sur Fedora](#sur-fedora)
  - [Sur Ubuntu](#sur-ubuntu)
  - [À l'école 42 (sans droits administrateur)](#à-lécole-42-sans-droits-administrateur)
  - [Premier lancement](#premier-lancement)
- [Le formatage du C et C++ (.clang-format)](#le-formatage-du-c-et-c-clang-format)
- [Les raccourcis](#les-raccourcis)
  - [Sauvegarder et fermer](#sauvegarder-et-fermer)
  - [Se déplacer dans le fichier](#se-déplacer-dans-le-fichier)
  - [Naviguer entre les fichiers ouverts](#naviguer-entre-les-fichiers-ouverts)
  - [Fenêtres et découpage de l'écran](#fenêtres-et-découpage-de-lécran)
  - [Le terminal intégré](#le-terminal-intégré)
  - [Recherche de fichiers et de texte](#recherche-de-fichiers-et-de-texte)
  - [L'explorateur de fichiers](#lexplorateur-de-fichiers)
  - [Le code (LSP)](#le-code-lsp)
  - [Renommer](#renommer)
  - [Diagnostics et liste des erreurs](#diagnostics-et-liste-des-erreurs)
  - [Copier-coller et historique](#copier-coller-et-historique)
  - [Entourer, commenter, éditer](#entourer-commenter-éditer)
  - [Formater le code](#formater-le-code)
  - [Git](#git)
  - [Raccourcis Neovim utiles mais méconnus](#raccourcis-neovim-utiles-mais-méconnus)
- [Ce qu'on a ajouté](#ce-quon-a-ajouté)
- [Dépannage](#dépannage)
- [Liste des plugins](#liste-des-plugins)

---

## Le principe

Trois idées guident cette configuration.

**Prévisible.** Il n'y a pas de comportement qui change tout seul. Les mises à jour automatiques de plugins sont désactivées, les fenêtres s'ouvrent toujours au même endroit, et rien ne se déclenche dans le dos de l'utilisateur. On sait ce qui va se passer avant d'appuyer sur une touche.

**Faite pour le C et le C++.** Le serveur de langage clangd est configuré avec l'indexation en arrière-plan et les conseils de qualité de code. Un formatage automatique applique un style cohérent. Une commande dédiée génère le fichier dont clangd a besoin pour comprendre un projet compilé avec `make`.

**Agréable à utiliser.** Le défilement est fluide, le curseur laisse une légère traînée quand il se déplace, les parenthèses et accolades imbriquées prennent des couleurs différentes pour mieux s'y retrouver. Ce sont des détails, mais ils rendent l'ensemble plus vivant.

La configuration est découpée en petits fichiers, un par sujet. Les réglages généraux sont dans `lua/config/`, et chaque plugin a son propre fichier dans `lua/plugins/`. Pour modifier un comportement, on ouvre le fichier concerné : pas besoin de fouiller dans un fichier géant.

```
~/.config/nvim/
├── init.lua                  Point d'entrée
├── .clang-format             Style de formatage C/C++ (référence)
└── lua/
    ├── config/               Réglages généraux (options, raccourcis, buffers, démarrage)
    └── plugins/              Un fichier par plugin
        └── lsp/              Tout ce qui touche aux serveurs de langage
```

---

## Aperçu

<!-- Remplace ces liens par tes propres captures d'écran une fois la config installée. -->

![Vue générale de l'éditeur](docs/screenshot-general.png)

![Les couleurs et les parenthèses arc-en-ciel sur du code C](docs/screenshot-rainbow.png)

![Le terminal intégré et la barre de statut](docs/screenshot-terminal.png)

---

## Installation

L'installation se fait en trois temps : on installe les logiciels dont Neovim a besoin, on clone cette configuration, puis on laisse Neovim installer ses plugins au premier démarrage.

### Ce qu'il faut vérifier et installer

Voici les logiciels externes utilisés par la configuration. Chaque ligne explique à quoi il sert, pour que tu saches ce que tu installes.

- **Neovim version 0.11 ou plus récente.** C'est indispensable. La configuration utilise des fonctions récentes de Neovim (la nouvelle façon de configurer les serveurs de langage, les bordures arrondies natives). Une version plus ancienne ne fonctionnera pas correctement. Pour vérifier ta version : `nvim --version`.
- **git.** Sert à cloner la configuration et à installer les plugins.
- **Un compilateur C et make.** Nécessaires pour compiler tes projets, et pour que certains plugins et outils se construisent correctement. En général `gcc` et `make`.
- **Une police Nerd Font.** C'est ce qui affiche les icônes (dossiers, types de fichiers, symboles dans la barre de statut). Sans elle, tu verras des carrés à la place des icônes. Il faut installer une police Nerd Font, puis la sélectionner dans les réglages de ton terminal. Par exemple « JetBrainsMono Nerd Font » ou « FiraCode Nerd Font ».
- **ripgrep.** Utilisé par la recherche de texte dans le projet. C'est ce qui rend la recherche rapide.
- **fd.** Utilisé par la recherche de fichiers. Rend la liste des fichiers plus rapide et plus pertinente.
- **Node.js.** Nécessaire au serveur de langage Python (pyright), qui tourne sur Node.
- **Un presse-papier système.** Pour copier et coller entre Neovim et le reste du système. Sous Wayland c'est `wl-clipboard`, sous X11 c'est `xclip` ou `xsel`.
- **Python 3 et le module pynvim.** Certains plugins peuvent s'appuyer sur le support Python de Neovim. Installer `pynvim` évite des avertissements et débloque ce support.

Les serveurs de langage (clangd pour le C, pyright pour Python, lua-language-server pour Lua) et les outils de formatage (clang-format, stylua, black) n'ont pas besoin d'être installés à la main : ils sont gérés automatiquement par Mason au premier lancement (voir plus bas).

Pour vérifier que tout est en place une fois installé, Neovim propose la commande `:checkhealth`. Elle passe en revue les dépendances et signale ce qui manque.

### Sur Arch Linux

```bash
sudo pacman -S neovim git base-devel ripgrep fd nodejs npm wl-clipboard python-pynvim
```

`base-devel` fournit `gcc` et `make`. Pour la police, installe par exemple `ttf-jetbrains-mono-nerd` :

```bash
sudo pacman -S ttf-jetbrains-mono-nerd
```

### Sur Fedora

```bash
sudo dnf install neovim git gcc make ripgrep fd-find nodejs npm wl-clipboard python3-neovim
```

Pour la police, télécharge une Nerd Font depuis le site officiel des Nerd Fonts, place les fichiers dans `~/.local/share/fonts/`, puis lance `fc-cache -f`.

### Sur Ubuntu

Attention : la version de Neovim fournie par Ubuntu est souvent trop ancienne. Le plus simple est de passer par le PPA officiel ou par l'AppImage (voir la section 42 pour l'AppImage).

```bash
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim git build-essential ripgrep fd-find nodejs npm wl-clipboard python3-pynvim
```

Sous Ubuntu, la commande `fd` s'appelle parfois `fdfind`. Si c'est le cas, tu peux créer un lien : `ln -s $(which fdfind) ~/.local/bin/fd`.

Pour la police, télécharge une Nerd Font, place les fichiers dans `~/.local/share/fonts/`, puis lance `fc-cache -f`.

### À l'école 42 (sans droits administrateur)

Sur les postes de l'école, on ne peut pas utiliser `sudo`. L'idée est donc d'installer Neovim et les quelques outils manquants dans ton dossier personnel, dans `~/.local`. C'est tout à fait possible et ça ne demande aucun droit particulier.

**1. Installer Neovim en local, sans compilation.**

La méthode la plus simple est l'AppImage : c'est un fichier unique qui contient Neovim, à rendre exécutable.

```bash
mkdir -p ~/.local/bin
cd ~/.local/bin
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage nvim
```

**2. Rendre Neovim accessible.**

Il faut que `~/.local/bin` soit dans ton `PATH`. Ajoute cette ligne à la fin de ton `~/.zshrc` (ou `~/.bashrc` selon ton shell), puis rouvre ton terminal :

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Vérifie ensuite avec `nvim --version` que tu obtiens bien la version 0.11 ou plus.

Remarque : si l'AppImage refuse de se lancer parce que FUSE n'est pas disponible sur le poste, tu peux l'extraire et lancer le binaire extrait :

```bash
cd ~/.local/bin
./nvim --appimage-extract
ln -sf ~/.local/bin/squashfs-root/usr/bin/nvim ~/.local/bin/nvim
```

**3. Les outils manquants.**

`git`, `make` et `gcc` sont déjà présents sur les postes de l'école. Pour `ripgrep` et `fd`, s'ils ne sont pas installés, tu peux récupérer les binaires précompilés depuis leurs pages de sortie GitHub et les placer dans `~/.local/bin` de la même façon que Neovim. Pour le support Python, installe pynvim au niveau utilisateur, sans droits administrateur :

```bash
pip install --user pynvim
```

**4. Les serveurs de langage et formateurs.**

Rien de spécial à faire : Mason installe tout dans ton dossier personnel, sans jamais demander les droits administrateur. Il suffit de lancer Neovim (étape suivante).

**5. Cloner la configuration.**

```bash
git clone https://github.com/Minipl0p/Config-nvim-perso.git ~/.config/nvim
```

Si tu as déjà une configuration Neovim, sauvegarde-la d'abord : `mv ~/.config/nvim ~/.config/nvim.backup`.

### Premier lancement

Une fois les dépendances installées et la configuration clonée dans `~/.config/nvim` (pour les machines personnelles) :

```bash
git clone https://github.com/Minipl0p/Config-nvim-perso.git ~/.config/nvim
nvim
```

Au tout premier démarrage, plusieurs choses se passent automatiquement :

- Le gestionnaire de plugins (lazy.nvim) s'installe puis télécharge tous les plugins. Laisse-le finir.
- Mason installe les serveurs de langage (clangd, pyright, lua-language-server) et les outils de formatage (clang-format, stylua, black). Tu peux suivre l'avancement avec la commande `:Mason`.
- La coloration syntaxique (Treesitter) télécharge ce dont elle a besoin selon les langages.

Ferme et rouvre Neovim une fois que tout est installé. Enfin, lance `:checkhealth` pour vérifier qu'il ne manque rien. Les éventuels avertissements t'indiquent précisément ce qui reste à régler.

---

## Le formatage du C et C++ (.clang-format)

Le style de formatage du C et C++ est défini dans le fichier `.clang-format` présent à la racine de ce dépôt. Il fixe les règles décidées pour cette configuration : indentation par tabulations, accolades des fonctions sur une nouvelle ligne, accolades des `if` et boucles en fin de ligne, largeur maximale de 100 colonnes, étoile du pointeur collée au nom, alignement des déclarations et des signes égal, et ainsi de suite.

Point important à comprendre : le fichier présent dans ce dépôt sert de référence. L'outil clang-format ne le lit pas depuis la configuration Neovim. Il cherche un fichier `.clang-format` à la racine du projet que tu édites, puis, s'il n'en trouve pas, remonte les dossiers parents jusqu'à en trouver un. Il faut donc placer ce fichier là où clang-format ira le chercher. Deux méthodes, au choix.

**Méthode 1 : un style par projet.**

Tu copies le fichier `.clang-format` à la racine de chaque projet C. Le style s'applique alors à ce projet précis, et le fichier voyage avec lui (pratique si tu partages ton code).

```bash
cp ~/.config/nvim/.clang-format /chemin/vers/ton/projet/.clang-format
```

**Méthode 2 : un style par défaut pour tout.**

Tu copies le fichier dans ton dossier personnel. Comme clang-format remonte les dossiers parents, ce fichier servira de style par défaut pour tous tes projets rangés sous ton dossier personnel, sans avoir à le copier partout.

```bash
cp ~/.config/nvim/.clang-format ~/.clang-format
```

Une fois le fichier en place, le formatage se déclenche tout seul à chaque sauvegarde. Tu peux aussi formater à la demande avec le raccourci prévu (voir la section [Formater le code](#formater-le-code)), et couper ou réactiver le formatage automatique avec la commande `:FormatToggle`.

---

## Les raccourcis

La touche « Espace » sert de touche de préfixe (le « leader ») pour de nombreux raccourcis. Dans les tableaux, elle est notée `<leader>`.

### Sauvegarder et fermer

| Raccourci | Ce qu'il fait |
|---|---|
| `Ctrl-s` | Sauvegarde le fichier. Fonctionne aussi en mode insertion et en mode visuel. |
| `Ctrl-q` | Sauvegarde puis ferme le fichier courant. Si c'était le dernier fichier ouvert, quitte Neovim. |
| `Ctrl-Shift-q` | Ferme le fichier courant sans sauvegarder. |

### Se déplacer dans le fichier

| Raccourci | Ce qu'il fait |
|---|---|
| `Ctrl-j` | Descend de dix lignes d'un coup. |
| `Ctrl-k` | Monte de dix lignes d'un coup. |
| `Ctrl-l` | Avance d'un mot. |
| `Ctrl-h` | Recule d'un mot. |

Ces quatre raccourcis fonctionnent en mode normal et en mode visuel.

### Naviguer entre les fichiers ouverts

| Raccourci | Ce qu'il fait |
|---|---|
| `L` | Passe au fichier suivant. |
| `H` | Passe au fichier précédent. |
| `<leader>` puis un chiffre de 1 à 9 | Ferme le fichier qui porte ce numéro dans la barre du haut. |
| `Ctrl-1` à `Ctrl-9` | Ferme aussi le fichier correspondant à ce numéro. |
| `Ctrl-²` (la touche à côté du 1) | Ferme tous les autres fichiers et ne garde que le fichier courant. |

### Fenêtres et découpage de l'écran

| Raccourci | Ce qu'il fait |
|---|---|
| `<leader>v` | Découpe l'écran verticalement (nouvelle fenêtre à droite). |
| `<leader>h` | Découpe l'écran horizontalement (nouvelle fenêtre en dessous). |
| `<leader>w` | Ferme la fenêtre courante. |
| `<leader>=` | Rééquilibre la taille des fenêtres. |
| `<leader>c` | Passe à la fenêtre suivante. |
| `<leader>C` | Passe à la fenêtre précédente. |
| `Ctrl-Flèche haut ou bas` | Agrandit ou réduit la hauteur de la fenêtre. |
| `Ctrl-Flèche gauche ou droite` | Réduit ou agrandit la largeur de la fenêtre. |

Les flèches avec Ctrl redimensionnent les fenêtres en mode normal. En mode terminal, elles servent à changer la taille du terminal (voir juste en dessous).

### Le terminal intégré

| Raccourci | Ce qu'il fait |
|---|---|
| `Ctrl-t` | Ouvre le terminal, ou le masque s'il est déjà ouvert (en gardant son contenu). Fonctionne depuis un fichier comme depuis le terminal. |
| `Échap Échap` | Depuis le terminal, revient en mode normal pour pouvoir se déplacer ou copier du texte. |
| `Ctrl-Flèche haut ou droite` | Agrandit le terminal (il passe par plusieurs tailles prédéfinies). |
| `Ctrl-Flèche bas ou gauche` | Réduit le terminal. |

### Recherche de fichiers et de texte

| Raccourci | Ce qu'il fait |
|---|---|
| `<leader>f` | Cherche un fichier par son nom dans le projet. |
| `<leader>g` | Cherche un texte dans tous les fichiers du projet. |
| `<leader>d` | Ouvre la liste des diagnostics (erreurs et avertissements) dans une fenêtre de recherche. |
| `<leader>M` | Ouvre les pages de manuel dans une fenêtre de recherche. |

### L'explorateur de fichiers

| Raccourci | Ce qu'il fait |
|---|---|
| `<leader>e` | Ouvre l'explorateur de fichiers dans une fenêtre flottante, positionné sur le fichier courant. |

### Le code (LSP)

Ces raccourcis deviennent actifs dès qu'un serveur de langage est attaché au fichier.

| Raccourci | Ce qu'il fait |
|---|---|
| `gd` | Va à la définition de l'élément sous le curseur. |
| `gD` | Va à la déclaration. |
| `gr` | Liste les endroits où l'élément est utilisé. |
| `K` | Affiche une infobulle avec la documentation de l'élément sous le curseur. |
| `<leader>z` | Propose et applique une action de correction ou de refactorisation suggérée par le serveur de langage. |

### Renommer

| Raccourci | Ce qu'il fait |
|---|---|
| `<leader>b` | Renomme l'élément partout dans le projet, proprement, en s'appuyant sur le serveur de langage. Un champ s'ouvre pour taper le nouveau nom. |
| `<leader>n` | Renomme le mot sous le curseur dans le fichier courant seulement. Le curseur est placé prêt à écrire le remplacement. Marche même sans serveur de langage. |
| `<leader>n` | En mode Visuel : Prepare la commande de replace, plus qu'a taper motif/replace. |

### Diagnostics et liste des erreurs

| Raccourci | Ce qu'il fait |
|---|---|
| `[d` | Va au diagnostic précédent. |
| `]d` | Va au diagnostic suivant. |
| `<leader>ln` | Élément suivant dans la liste des erreurs. |
| `<leader>lp` | Élément précédent dans la liste des erreurs. |
| `<leader>lq` | Ferme la liste des erreurs. |
| `<leader>le` | Remplit la liste avec toutes les erreurs du projet. |

Un encadré avec le détail de l'erreur apparaît automatiquement quand le curseur reste posé sur une ligne concernée.

### Copier-coller et historique

Cette configuration garde en mémoire les trois derniers textes copiés. Après avoir collé, on peut remonter dans cet historique pour retrouver un texte copié plus tôt.

| Raccourci | Ce qu'il fait |
|---|---|
| `y` | Copie (la sélection ou avec un mouvement, comme `yy` pour une ligne). Le texte entre dans l'historique. |
| `p` | Colle après le curseur. |
| `P` | Colle avant le curseur. |
| `Ctrl-p` | Juste après un collage, remplace le texte collé par l'entrée précédente de l'historique. |
| `Ctrl-n` | Juste après un collage, remplace le texte collé par l'entrée suivante de l'historique. |

L'historique est limité aux trois derniers textes copiés et repart à zéro à chaque redémarrage de Neovim.

### Entourer, commenter, éditer

| Raccourci | Ce qu'il fait |
|---|---|
| `ys` puis un mouvement puis un caractère | Entoure le texte visé avec le caractère choisi. Par exemple entourer un mot de parenthèses. |
| `ds` puis un caractère | Enlève l'entourage indiqué. |
| `cs` puis deux caractères | Remplace un entourage par un autre (par exemple des guillemets par des parenthèses). |
| `S` en mode visuel puis un caractère | Entoure la sélection. |
| `Ctrl-/` | Commente ou décommente la ligne courante, ou la sélection en mode visuel. |
| `J` | Fusionne la ligne suivante avec la ligne courante, sans que le curseur ne bouge. |
| `<` et `>` en mode visuel | Décale la sélection à gauche ou à droite, en gardant la sélection active pour enchaîner. |

### Formater le code

| Raccourci ou commande | Ce qu'il fait |
|---|---|
| Sauvegarde (`Ctrl-s`) | Le code est reformaté automatiquement au style défini. |
| `<leader>F` | Reformate le fichier à la demande. |
| `:FormatToggle` | Active ou désactive le formatage automatique à la sauvegarde. |

### Git

| Raccourci | Ce qu'il fait |
|---|---|
| `Ctrl-g` | Ouvre l'interface Git (lazygit) pour gérer commits, branches et différences. |

### Nettoyer l'affichage

| Raccourci | Ce qu'il fait |
|---|---|
| `Échap` | Efface le surlignage de la dernière recherche. |

### Sortir du mode insertion

| Raccourci | Ce qu'il fait |
|---|---|
| `jj`, `jk` ou `kk` | En mode insertion, revient en mode normal sans avoir à atteindre la touche Échap. |

### Raccourcis Neovim utiles mais méconnus

Ces raccourcis ne sont pas des ajouts personnels : ils existent dans Neovim et sont pleinement fonctionnels dans cette configuration. Ils valent le détour.

| Raccourci | Ce qu'il fait |
|---|---|
| `gd` | Va directement à la définition d'une fonction ou d'une variable. Indispensable pour naviguer dans un projet. |
| `K` | Affiche la documentation de l'élément sous le curseur, sans quitter le fichier. |
| `ci` puis un caractère | Change l'intérieur d'un entourage. Par exemple `ci"` efface le contenu entre guillemets et te place en insertion. Fonctionne avec parenthèses, crochets, accolades. |
| `di` puis un caractère | Même principe, mais supprime seulement le contenu. |
| `*` | Cherche le mot sous le curseur dans tout le fichier, en avant. |
| `%` | Saute à la parenthèse, au crochet ou à l'accolade correspondante. Très pratique pour vérifier l'appariement en C. |
| `.` | Répète la dernière modification. Un gain de temps considérable une fois pris en main. |
| `gv` | Resélectionne la dernière sélection visuelle. |

---

## Ce qu'on a ajouté

Cette section explique, en clair, les fonctionnalités mises en place au-delà des réglages de base.

**Un historique des copies.** Neovim ne garde normalement qu'un seul texte copié à la fois. Ici, les trois derniers textes copiés sont conservés. Après avoir collé, on peut remonter dans cet historique avec `Ctrl-p` et `Ctrl-n` pour retrouver et coller un texte copié plus tôt. C'est utile quand on jongle entre plusieurs bouts de code. L'historique est volontairement limité à trois entrées pour rester lisible, et il repart à zéro à chaque redémarrage.

**Le formatage automatique du C et C++.** À chaque sauvegarde, le code est remis en forme selon un style précis et cohérent (voir la section sur le fichier `.clang-format`). Plus besoin de réaligner à la main. On peut aussi formater à la demande, ou couper le formatage automatique quand on ne le souhaite pas.

**L'aide à l'écriture du C avec clangd.** Le serveur de langage clangd fournit l'autocomplétion, la navigation vers les définitions, la détection d'erreurs en direct et des conseils de qualité de code. Pour qu'il comprenne un projet compilé avec `make`, une commande `:CompileDB` génère le fichier de configuration dont il a besoin (voir le dépannage).

**Entourer du texte facilement.** On peut ajouter, enlever ou changer des parenthèses, guillemets ou accolades autour d'un mot ou d'une sélection avec quelques touches, sans repositionner le curseur à la main.

**Commenter en une touche.** Un seul raccourci commente ou décommente la ligne ou la sélection, en s'adaptant au langage.

**Un terminal intégré.** Un terminal s'ouvre en bas de l'écran, se masque et réapparaît avec la même touche, et peut passer par plusieurs tailles selon le besoin.

**Une interface Git.** L'ensemble des opérations Git courantes se fait dans une interface dédiée, ouverte en une touche.

**Des touches plus rapides.** Se déplacer de dix lignes, avancer d'un mot, sortir du mode insertion sans atteindre la touche Échap : de petits raccourcis pensés pour garder les mains sur la partie centrale du clavier.

**Quelques effets visuels.** Le défilement est fluide, le curseur laisse une légère traînée quand il se déplace, et les parenthèses et accolades imbriquées prennent des couleurs différentes pour mieux repérer les niveaux. Le tout reste discret et ne gêne pas la lecture.

---

## Dépannage

**Je vois des carrés à la place des icônes.** La police n'est pas une Nerd Font, ou elle n'est pas sélectionnée dans le terminal. Installe une Nerd Font, puis choisis-la dans les réglages de ton terminal.

**clangd ne comprend pas mon projet (il souligne des inclusions correctes).** clangd a besoin de savoir comment ton projet est compilé. Depuis la racine du projet, ouvre Neovim et lance la commande `:CompileDB`. Elle génère le fichier `compile_commands.json` à partir de ton `make`, puis recharge clangd. Si l'outil nécessaire n'est pas présent, la commande te dit quoi installer (par exemple `pip install --user compiledb`, qui ne demande pas de droits administrateur).

**Le formatage ne s'applique pas.** Vérifie que le fichier `.clang-format` est bien à la racine de ton projet ou dans ton dossier personnel (voir la section dédiée). Vérifie aussi que clang-format est installé, en ouvrant `:Mason`.

**Un serveur de langage ou un formateur manque.** Ouvre `:Mason` pour voir ce qui est installé et lancer l'installation de ce qui manque.

**Quelque chose ne va pas et je ne sais pas quoi.** Lance `:checkhealth`. Cette commande vérifie les dépendances et les plugins, et signale précisément ce qui pose problème.

---

## Liste des plugins

Ce dernier chapitre liste tous les plugins, avec leur rôle, le fichier où les régler, et ce que tu peux y modifier. Les chemins sont donnés à partir de `lua/plugins/`.

| Plugin | À quoi il sert | Fichier | Ce que tu peux modifier |
|---|---|---|---|
| lazy.nvim | Le gestionnaire de plugins. Installe, met à jour et charge tout le reste. | `lua/config/lazy.lua` | Réactiver la vérification automatique des mises à jour, changer le style des bordures de son interface. |
| catppuccin | Le thème de couleurs. | `colors.lua` | Changer la saveur du thème (par exemple une variante plus claire ou plus sombre). |
| lualine.nvim | La barre de statut en bas de l'écran. | `lualine.lua` | Choisir les informations affichées à gauche et à droite, changer les séparateurs. |
| bufferline.nvim | La barre des fichiers ouverts en haut. | `bufferline.lua` | Ajuster l'apparence des onglets et la numérotation. |
| neo-tree.nvim | L'explorateur de fichiers. | `neotree.lua` | Changer la position, les icônes, le comportement d'ouverture. |
| telescope.nvim | La recherche de fichiers, de texte et plus. | `telescope.lua` | Modifier la disposition des fenêtres de recherche, ajouter des sources. |
| nvim-treesitter | La coloration syntaxique précise et la compréhension de la structure du code. | `treesitter.lua` | Ajouter des langages, activer des modules supplémentaires. |
| nvim-lspconfig | Configure les serveurs de langage (C, Python, Lua). | `lsp/lsp.lua` | Ajouter un langage, changer les options de clangd, ajuster la commande `:CompileDB`. |
| mason.nvim | Installe automatiquement les serveurs de langage et les outils. | `lsp/mason.lua` | Changer les icônes de son interface. |
| mason-tool-installer | Installe automatiquement les formateurs (clang-format, stylua, black). | `lsp/mason_tools.lua` | Ajouter ou retirer des outils à installer. |
| nvim-cmp | L'autocomplétion en cours de frappe. | `nvim_cmp.lua` | Changer les touches de validation et de navigation, ajouter des sources de complétion. |
| LuaSnip | Le moteur d'extraits de code, utilisé par l'autocomplétion. | `nvim_cmp.lua` | Ajouter tes propres extraits. |
| conform.nvim | Le formatage automatique du code. | `conform.lua` | Choisir les formateurs par langage, activer ou couper le formatage à la sauvegarde. |
| yanky.nvim | L'historique des copies. | `yanky.lua` | Changer la taille de l'historique, la persistance, les touches de navigation. |
| nvim-surround | Entourer, enlever et changer les entourages (parenthèses, guillemets, etc.). | `surround.lua` | Ajouter des paires personnalisées. |
| Comment.nvim | Commenter et décommenter. | `comment.lua` | Changer le raccourci ou le comportement par langage. |
| rainbow-delimiters.nvim | Colore les parenthèses et accolades par niveau d'imbrication. | `rainbow.lua` | Changer les couleurs, activer ou non par langage. |
| smear-cursor.nvim | La traînée du curseur quand il se déplace. | `smircursor.lua` | Régler la longueur et la fluidité de la traînée, la couleur. |
| snacks.nvim | Une boîte à outils : défilement fluide, guides d'indentation, terminal intégré, interface Git. | `snacks.lua` | Activer ou désactiver chaque fonctionnalité indépendamment. |
| noice.nvim | Améliore l'affichage de la ligne de commande et des messages. | `noice.lua` | Ajuster la position et l'apparence des fenêtres, filtrer certains messages. |
| flash.nvim | Sauter rapidement n'importe où à l'écran. | `flash.lua` | Changer les touches de déclenchement et le comportement. |
| nvim-web-devicons | Fournit les icônes de fichiers utilisées par plusieurs plugins. | Chargé comme dépendance | Rien à régler en général. |

---

Si tu veux modifier un comportement, commence par ouvrir le fichier indiqué dans le tableau ci-dessus : chaque réglage y est commenté. Bonne édition.
