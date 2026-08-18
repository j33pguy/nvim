# nvim

neovim, tuned until it stopped being an editor and started being a habit.
lazy.nvim underneath, pop-punk on top — neon on black, the way the terminal
wants it.

## what's inside

- **lazy.nvim** — plugin manager, bootstraps itself on first launch
- **telescope** + **neo-tree** — find the thing, then find where it lives
- **lsp + mason** — language servers on demand, gopls first among equals
- **go.nvim** — most of what gets written here is Go
- **treesitter, cmp, snippets** — the modern conveniences
- **heirline** statusline, **startify** greeting, **pop-punk** colors
- **lazygit, fugitive, gitgutter** — git without leaving the building
- **trouble, todo-comments, undotree, which-key, neogen** — quality of life
- **floatterm, no-neck-pain** — comfort features I refuse to apologize for

## install

```bash
git clone https://github.com/j33pguy/nvim ~/.config/nvim
nvim
```

or clone it anywhere and run `install.sh` — it backs up whatever config is
already there and symlinks this one in. part of the wider dotfiles suite
([zsh](https://github.com/j33pguy/zsh), [tmux](https://github.com/j33pguy/tmux),
[fonts](https://github.com/j33pguy/fonts)), wired together by home-manager
across macOS, NixOS, and WSL.

---

<p align="center"><strong>Don't Panic. Hack the Planet.</strong></p>
