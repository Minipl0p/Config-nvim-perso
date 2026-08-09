<div align="center">

# 🚀 Config Neovim Perso — AstroNvim v4

[![Neovim](https://img.shields.io/badge/Neovim-0.10+-green?logo=neovim&logoColor=white)](https://neovim.io)
[![AstroNvim](https://img.shields.io/badge/AstroNvim-v4-blue?logo=astronvim)](https://github.com/AstroNvim/AstroNvim)
[![Fedora](https://img.shields.io/badge/Fedora-Linux-blue?logo=fedora)](https://fedoraproject.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

*Une configuration Neovim moderne, rapide et personnalisée, basée sur AstroNvim v4.*

</div>

---

## 🎯 Philosophie

Cette configuration repose sur **AstroNvim v4** comme base solide, complétée par **AstroCommunity** pour les packs de langages. Elle conserve les habitudes clavier de l'ancienne config LazyVim tout en apportant :

- Terminal **float centré** (snacks.nvim)
- Explorateur de fichiers **yazi** avec sync du cwd
- **IA intégrée** : Copilot (complétion inline) + Avante (chat style Cursor)
- **DAP** prêt pour C/C++ Unreal Engine 5 et Python
- **Bufferline avec ordinaux** pour fermer les onglets avec `<C-1>..<C-9>`
- Thème **Catppuccin** + curseur animé smear

---

## ⚙️ Prérequis Fedora

### Neovim (dernière version)

```bash
# Option 1 : via dnf (version officielle)
sudo dnf install neovim

# Option 2 : AppImage (toujours la dernière release)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod +x nvim-linux-x86_64.appimage
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
```

### Dépendances de base

```bash
sudo dnf install -y \
  git gcc gcc-c++ make cmake unzip wget curl \
  ripgrep fd-find fzf \
  nodejs npm \
  python3 python3-pip
```

### Yazi (explorateur de fichiers)

```bash
# Via cargo (recommandé pour la dernière version)
cargo install yazi-fm yazi-cli

# Ou via dnf (peut être une version moins récente)
sudo dnf install yazi
```

### Lazygit

```bash
# Via dnf (Fedora 39+)
sudo dnf install lazygit

# Ou via le binaire officiel
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
```

### Wakatime CLI

```bash
pip3 install wakatime
```

### codelldb (pour le debug C/C++)

> Installé automatiquement par **Mason** au premier lancement de Neovim (`mason-nvim-dap`).

---

## 📦 Installation

```bash
# 1. Sauvegarder l'ancienne config si besoin
mv ~/.config/nvim ~/.config/nvim.bak

# 2. Cloner ce repo
git clone https://github.com/Minipl0p/Config-nvim-perso ~/.config/nvim
cd ~/.config/nvim
git checkout astronvim

# 3. Lancer Neovim — lazy.nvim installera tout automatiquement
nvim

# 4. Attendre la fin de l'installation, puis :
# :Lazy   → voir le statut des plugins
# :Mason  → installer/mettre à jour les LSP et outils
```

---

## 🗂️ Structure de la config

```
~/.config/nvim/
├── init.lua                    ← Point d'entrée (bootstrap lazy.nvim + AstroNvim)
├── lua/
│   ├── community.lua           ← Packs AstroCommunity (langages + plugins)
│   ├── lib/
│   │   └── buffers.lua         ← Logique custom buffers (close_ordinal, write_and_close…)
│   └── plugins/
│       ├── astrocore.lua       ← Options Vim + tous les keybinds
│       ├── astroui.lua         ← Thème Catppuccin + highlights
│       └── user/
│           ├── terminal.lua    ← Terminal float centré (snacks)
│           ├── yazi.lua        ← Explorateur yazi avec sync cwd
│           ├── ai.lua          ← Copilot + Avante
│           ├── git.lua         ← Diffview + git-conflict
│           ├── dap.lua         ← Debug (nvim-dap + dap-ui + mason-nvim-dap)
│           ├── markdown.lua    ← render-markdown + markdown-preview
│           ├── buffers.lua     ← Keybinds <C-1>..<C-9> (Kitty protocol)
│           ├── neo_tree.lua    ← Override Neo-tree (float)
│           ├── bufferline.lua  ← Override bufferline (ordinaux, slant)
│           ├── editing.lua     ← Flash, surround, yanky, rainbow, smear-cursor
│           ├── wakatime.lua    ← Suivi du temps
│           ├── 42header.lua    ← Header 42
│           └── noice.lua       ← Override noice (cmdline popup centré)
└── README.md
```

---

## ⌨️ Keybinds complets

> **Leader** = `<Space>`

### 🗂️ Navigation & buffers

| Touche | Action |
|--------|--------|
| `<C-h>` | Buffer précédent |
| `<C-l>` | Buffer suivant |
| `<leader>1`..`<leader>9` | Fermer le buffer à la position N |
| `<C-1>`..`<C-9>` | Fermer le buffer N (Kitty/WezTerm) |
| `<C-\`` ` | Fermer tous les autres buffers |
| `H` | Mot précédent (`b`) |
| `L` | Mot suivant (`w`) |
| `<C-j>` | 10 lignes bas |
| `<C-k>` | 10 lignes haut |

### 📂 Fichiers

| Touche | Action |
|--------|--------|
| `<leader>e` | Neo-tree float (explorateur) |
| `<leader>y` | Yazi (fichier courant) |
| `<leader>Y` | Yazi (répertoire de travail) |
| `<C-y>` | Yazi toggle (dernier) |
| `<leader>f` | Telescope : trouver des fichiers |
| `<leader>g` | Telescope : recherche textuelle |
| `<leader>d` | Telescope : diagnostics |
| `<leader>M` | Telescope : pages man |

### 💾 Sauvegarde & fermeture

| Touche | Action |
|--------|--------|
| `<C-s>` | Sauvegarder |
| `<C-q>` | Sauvegarder et fermer le buffer |
| `<C-S-q>` | Fermer de force (sans sauvegarder) |

### 🖥️ Terminal

| Touche | Action |
|--------|--------|
| `<C-t>` | Toggle terminal float |
| `<Esc><Esc>` | Terminal → mode normal |
| `<C-Up>` / `<C-Right>` | Agrandir le terminal float |
| `<C-Down>` / `<C-Left>` | Réduire le terminal float |

### 🪟 Fenêtres & splits

| Touche | Action |
|--------|--------|
| `<leader>v` | Split vertical |
| `<leader>h` | Split horizontal |
| `<leader>w` | Fermer la fenêtre (split) |
| `<leader>=` | Équilibrer les splits |
| `<leader>c` / `<leader>C` | Fenêtre suivante / précédente |
| `<C-Up/Down/Left/Right>` | Redimensionner le split (mode normal) |

### 🔍 LSP

| Touche | Action |
|--------|--------|
| `gd` | Aller à la définition |
| `gD` | Aller à la déclaration |
| `gr` | Références |
| `K` | Documentation hover |
| `<leader>b` | Renommer (LSP, projet entier) |
| `<leader>z` | Code action |
| `[d` / `]d` | Diagnostic précédent / suivant |
| `<leader>n` | Renommer dans le fichier (sans LSP) |

### 🌿 Git

| Touche | Action |
|--------|--------|
| `<leader>gd` | Diffview : ouvrir |
| `<leader>gh` | Diffview : historique fichier |
| `<leader>gx` | Diffview : fermer |
| `<C-g>` | LazyGit |

### 🐛 Debug (DAP)

| Touche | Action |
|--------|--------|
| `<F5>` | Continuer |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<leader>db` | Toggle breakpoint |
| `<leader>du` | Toggle DAP UI |
| `<leader>dr` | Ouvrir le REPL |

### 🤖 IA

| Touche | Action |
|--------|--------|
| `<leader>aa` | Avante : demander (Ask) |
| `<leader>ae` | Avante : éditer la sélection (visuel) |
| `<Tab>` | Copilot : accepter la suggestion |

### 📝 Édition

| Touche | Action |
|--------|--------|
| `jj` / `jk` / `kk` | Escape (mode insertion) |
| `<C-/>` / `<C-_>` | Commenter la ligne / la sélection |
| `J` | Joindre (curseur fixe) |
| `<` / `>` | Désindenter / indenter (garde la sélection) |
| `p` / `P` | Coller via yanky (cycle le ring) |
| `<C-p>` / `<C-n>` | Cycle dans l'historique yanky |
| `<leader>mp` | Markdown preview toggle |

### ⚡ Quickfix

| Touche | Action |
|--------|--------|
| `<leader>ln` | Quickfix suivant |
| `<leader>lp` | Quickfix précédent |
| `<leader>lq` | Fermer la quickfix list |
| `<leader>le` | Erreurs projet → quickfix |

---

## 🌐 Langages supportés

| Langage | Pack | Icône |
|---------|------|-------|
| Lua | `astrocommunity.pack.lua` | 🌙 |
| C / C++ | `astrocommunity.pack.cpp` | 🔷 |
| C# | `astrocommunity.pack.cs` | 🟣 |
| Go | `astrocommunity.pack.go` | 🐹 |
| TypeScript / JavaScript | `astrocommunity.pack.typescript` | 🟦 |
| HTML / CSS | `astrocommunity.pack.html-css` | 🌐 |
| Rust | `astrocommunity.pack.rust` | 🦀 |
| OCaml | `astrocommunity.pack.ocaml` | 🐪 |
| Java | `astrocommunity.pack.java` | ☕ |
| Python | `astrocommunity.pack.python` | 🐍 |
| PHP | `astrocommunity.pack.php` | 🐘 |
| Kotlin | `astrocommunity.pack.kotlin` | 🅺 |
| Swift | `astrocommunity.pack.swift` | 🍎 |
| Zig | `astrocommunity.pack.zig` | ⚡ |
| Bash | `astrocommunity.pack.bash` | 🐚 |
| SQL | `astrocommunity.pack.sql` | 🗃️ |
| YAML | `astrocommunity.pack.yaml` | 📄 |
| JSON | `astrocommunity.pack.json` | 📋 |
| Markdown | `astrocommunity.pack.markdown` | 📝 |
| Docker | `astrocommunity.pack.docker` | 🐳 |
| CMake | `astrocommunity.pack.cmake` | 🔨 |
| TailwindCSS | `astrocommunity.pack.tailwindcss` | 🎨 |
| Vue | `astrocommunity.pack.vue` | 💚 |

---

## 🎮 Unreal Engine 5

Pour activer l'autocomplétion et le LSP clangd avec UE5 :

### 1. Générer `compile_commands.json`

```bash
# Dans le répertoire de ton projet UE5
# Utilise UnrealBuildTool pour générer le fichier
cd /path/to/your/UE5Project

# Avec clang (recommandé)
/path/to/UnrealEngine/Engine/Build/BatchFiles/Linux/Build.sh \
  YourProject Linux Development \
  -Project="/path/to/YourProject.uproject" \
  -GenerateClangDatabase \
  -OutputDirectory="/path/to/YourProject"
```

### 2. Configurer clangd

Crée un fichier `.clangd` à la racine de ton projet :

```yaml
CompileFlags:
  CompilationDatabase: .
  Add:
    - -std=c++17
    - -ferror-limit=0
    - -Wno-unknown-pragmas
    - -Wno-unused-command-line-argument
  Remove:
    - -msse4.2

Diagnostics:
  Suppress:
    - drv_unknown_argument

InlayHints:
  Enabled: No
```

### 3. Utiliser codelldb pour le debug

Mason installe codelldb automatiquement. Configure ton `.vscode/launch.json` compatible ou utilise `<leader>du` pour ouvrir le DAP UI et lancer une session de debug.

---

## 🗺️ Yazi — Workflow

Yazi est un explorateur de fichiers en terminal qui **synchronise le cwd** de Neovim :

```
<leader>y  → Ouvrir Yazi sur le fichier courant
<leader>Y  → Ouvrir Yazi sur le répertoire de travail
<C-y>      → Toggle le dernier Yazi ouvert
```

**Dans Yazi :**
- Naviguer dans les dossiers → le cwd de Neovim suit automatiquement
- `Enter` → ouvrir le fichier dans Neovim
- `<f1>` → aide de yazi
- `q` → fermer Yazi

---

## 🤖 IA — Copilot + Avante

### Copilot (complétion inline)

GitHub Copilot s'active automatiquement en mode insertion. Accepte la suggestion avec `<Tab>`. Pour s'authentifier au premier lancement :

```vim
:Copilot auth
```

### Avante (chat IA style Cursor)

```
<leader>aa  → Ouvrir le chat Avante (Ask)
<leader>ae  → Éditer la sélection avec l'IA (visuel)
```

Avante utilise Copilot comme provider par défaut. Il peut aussi utiliser Claude, GPT-4, etc. (configurable dans `lua/plugins/user/ai.lua`).

---

## 🔄 Mise à jour

```vim
" Mettre à jour tous les plugins
:Lazy update

" Mettre à jour les LSP / outils Mason
:Mason
" puis appuyer sur U pour tout mettre à jour
```

---

## 🔧 Dépannage Fedora

### SELinux bloque un binaire

```bash
# Vérifier les refus SELinux
sudo ausearch -c 'nvim' --raw | audit2allow

# Corriger les permissions pour codelldb (DAP)
sudo restorecon -rv ~/.local/share/nvim/mason/packages/codelldb/
```

### Permissions sur les fichiers Mason

```bash
chmod +x ~/.local/share/nvim/mason/bin/*
```

### Chemin Python non trouvé

```bash
# Assure-toi que python3 est dans le PATH
which python3

# Ou configure explicitement dans neovim
:lua vim.g.python3_host_prog = '/usr/bin/python3'
```

### Node.js trop vieux pour certains LSP

```bash
# Installer la dernière LTS via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
nvm install --lts
nvm use --lts
```

### Problème de police (icônes manquantes)

Cette config utilise des **Nerd Fonts**. Installe une police compatible :

```bash
# Exemple avec FiraCode Nerd Font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "FiraCode Nerd Font.zip" \
  "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
unzip "FiraCode Nerd Font.zip"
fc-cache -fv
```

---

<div align="center">

*Made with ❤️ by Minipl0p — basé sur [AstroNvim](https://github.com/AstroNvim/AstroNvim)*

</div>
