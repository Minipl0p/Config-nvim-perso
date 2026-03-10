# Mes Keymaps Neovim

Ce fichier documente mes raccourcis clavier personnalisés pour Neovim, incluant Quickfix, LSP, Telescope, Neo-tree, Snacks et plus.

---

## Préfixe Leader

Le leader est défini sur **espace** :

```lua
vim.g.mapleader = " "
```

## Navigation Quickfix

| Mode   | Touche       | Description                                   |
| ------ | ------------ | --------------------------------------------- |
| Normal |     `s`      | quick word search                             |


## Navigation Quickfix

| Mode   | Touche       | Description                                   |
| ------ | ------------ | --------------------------------------------- |
| Normal |     `<leader>bb`      | replace infile                             |
| Normal |     `<leader>bn`      | replace project                             |

## Navigation Quickfix

| Mode   | Touche       | Description                                   |
| ------ | ------------ | --------------------------------------------- |
| Normal | `<leader>ln` | Aller au quickfix suivant                     |
| Normal | `<leader>lp` | Aller au quickfix précédent                   |
| Normal | `<leader>lq` | Fermer la fenêtre quickfix                    |
| Normal | `<leader>le` | Mettre les erreurs du projet dans le quickfix |


## Terminal floattant
| Mode     | Touche  | Description                 |
| -------- | ------- | --------------------------- |
| Terminal | `<C-t>` | Fermer le terminal flottant |
| Normal   | `<C-t>` | Toggle terminal Snacks      |


## LSP
| Mode   | Touche       | Description                            |
| ------ | ------------ | -------------------------------------- |
| Normal | `gd`         | Aller à la définition                  |
| Normal | `gD`         | Aller à la déclaration                 |
| Normal | `gr`         | Voir les références                    |
| Normal | `K`          | Hover / documentation                  |
| Normal | `<leader>rn` | Renommer localement                    |
| Normal | `<leader>rN` | Renommer projet-wide (best effort)     |
| Normal | `<leader>z`  | Code action (applique automatiquement) |
| Normal | `[d`         | Diagnostic précédent                   |
| Normal | `]d`         | Diagnostic suivant                     |


## Neo-tree flottant
| Mode   | Touche      | Description             |
| ------ | ----------- | ----------------------- |
| Normal | `<leader>e` | Ouvrir Neo-tree (float) (motions with jkl)|


## Telescope
| Mode   | Touche      | Action     |
| ------ | ----------- | ---------- |
| Normal | `<leader>f` | Find files |
| Normal | `<leader>g` | Live grep  |
| Normal | `<leader>m` | Man pages  |

## Snacks moves
| Mode   | Touche  | Action        |
| ------ | ------- | ------------- |
| Normal | `<C-n>` | Mot suivant   |
| Normal | `<C-p>` | Mot précédent |


## Lazy Git
| Mode   | Touche      | Action         |
| ------ | ----------- | -------------- |
| Normal | `<leader>G` | Ouvrir LazyGit |


## Folding fonctions
| Mode   | Touche      | Action      |
| ------ | ----------- | ----------- |
| Normal | `<leader>m` | Fold all    |
| Normal | `<leader>r` | Unfold all  |
| Normal | `<leader>j` | Toggle fold |


## Navigation fenetre

| Mode   | Touche      | Action           |
| ------ | ----------- | ---------------- |
| Normal | `<leader>c` | Next window      |
| Normal | `<leader>C` | Previous window  |
| Normal | `<C-h>`     | Buffer précédent |
| Normal | `<C-l>`     | Buffer suivant   |
| Normal | `<leader>v` | Vertical split   |


## Save and Quit
| Mode                 | Touche  | Action          |
| -------------------- | ------- | --------------- |
| Normal/Insert/Visual | `<C-s>` | Save            |
| Normal/Insert/Visual | `<C-q>` | Save & Quit|
| Normal/Insert/Visual | `<C-Q>` | Quit all|


## Escape ergonomiques
| Mode   | Touche           | Action               |
| ------ | ---------------- | -------------------- |
| Insert | `jj`, `jk`, `kk` | Échapper vers Normal |


## Smart Paste
| Mode   | Touche | Action                  |
| ------ | ------ | ----------------------- |
| Normal | `p`    | Paste + reindent        |
| Normal | `P`    | Paste before + reindent |

