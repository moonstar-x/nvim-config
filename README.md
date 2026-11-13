# nvim-config

My personal Neovim configuration, built on [lazy.nvim](https://github.com/folke/lazy.nvim). It's tuned for web development (TypeScript/JavaScript, CSS, Tailwind, MDX) with good support for Python, Lua, shell, Docker and YAML, and it integrates with AI CLIs like Claude Code and Codex.

## Requirements

- **Neovim 0.12+**
- **git**
- A [Nerd Font](https://www.nerdfonts.com/) set as your terminal font
- [ripgrep](https://github.com/BurntSushi/ripgrep) and [fd](https://github.com/sharkdp/fd) for the file and grep pickers
- [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) and a C compiler, to build Treesitter parsers
- **Node.js** and **Python 3**, which Mason uses to install most language servers, formatters and debug adapters

Optional:

- [lazygit](https://github.com/jesseduffield/lazygit) for `<leader>gg`
- [Deno](https://deno.com/), for the Deno language server and formatter in Deno projects
- [tmux](https://github.com/tmux/tmux), for seamless `<C-h/j/k/l>` navigation between Neovim and tmux panes
- [Claude Code](https://claude.com/claude-code) and/or Codex, for the AI integrations
- A `~/.wakatime.cfg` for WakaTime stats, and Discord for the rich presence status

On macOS, set your terminal to send **Option as Alt (Meta)** so the `<A-j>` / `<A-k>` line-moving keys work, and turn off the macOS `Ctrl+arrow` shortcuts for Spaces if you want to use them for resizing windows.

## Installation

Back up any existing configuration, then clone this repository into `~/.config/nvim`:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/moonstar-x/nvim-config.git ~/.config/nvim
nvim
```

On first launch lazy.nvim bootstraps itself and installs every plugin, then Mason installs the language servers and tools and nvim-treesitter builds the parsers. This takes a minute or two; run `:checkhealth` afterwards if anything looks off.

To try it without replacing your current setup, clone it elsewhere under `~/.config` and use `NVIM_APPNAME`:

```sh
git clone https://github.com/moonstar-x/nvim-config.git ~/.config/nvim-moonstar
NVIM_APPNAME=nvim-moonstar nvim
```

Plugin versions are pinned in `lazy-lock.json`. Use `:Lazy` (or `<leader>l`) to update or restore them.

## Structure

```
init.lua                 Entry point: loads lua/config/* in order
lua/config/
  options.lua            Editor options and leader keys
  keymaps.lua            General keymaps and <leader>u toggles
  autocmds.lua           Autocommands (yank highlight, reload on focus, restore cursor, ...)
  filetypes.lua          Extra filetype detection (MDX, MJML, Docker Compose, ...)
  lazy.lua               lazy.nvim bootstrap and setup
lua/plugins/             One plugin spec file per concern, imported automatically
  ai.lua                 Claude Code, sidekick.nvim, MCP Hub
  completion.lua         blink.cmp
  debug.lua              nvim-dap (JS/TS via vscode-js-debug, Python via debugpy)
  editor.lua             Trouble, flash, mini.ai/surround/pairs, grug-far, harpoon, sessions
  extras.lua             Markdown rendering, CSV view, package.json versions, minimap, ...
  formatting.lua         conform.nvim formatters and nvim-lint linters
  git.lua                gitsigns, diffview, lazygit and git pickers
  lsp.lua                Language servers, Mason and diagnostics
  navigation.lua         snacks.nvim (pickers, explorer, dashboard, terminal), oil, tmux navigation
  tasks.lua              overseer.nvim task runner
  test.lua               neotest (Vitest, Jest, pytest)
  treesitter.lua         nvim-treesitter (main branch) and textobjects
  ui.lua                 Catppuccin, lualine, which-key, icons
after/lsp/               Per-server settings that override nvim-lspconfig's defaults
after/ftplugin/          Per-filetype settings
```

## Highlights

- **Language servers** for TypeScript/JavaScript (vtsls, ESLint, Biome, Deno), HTML, CSS, Tailwind, JSON and YAML (with SchemaStore schemas), GraphQL, Markdown/MDX, Docker and Docker Compose, nginx, Python (basedpyright, Ruff), Bash and Lua, plus typos-lsp for spell checking code. They're listed in `lua/plugins/lsp.lua` and installed automatically by Mason.
- **Project-aware formatting** on save with conform.nvim: Deno, Biome or Prettier is chosen based on which one the project is configured for, and ESLint fixes run first where ESLint is attached. Stylua, Ruff and shfmt handle Lua, Python and shell.
- **Debugging** with nvim-dap and dap-ui for Node, Chrome/Edge and Python, including `.vscode/launch.json` configurations and their `preLaunchTask`s (through overseer).
- **Testing** with neotest for Vitest, Jest and pytest/unittest, with each JS runner only claiming projects that actually use it.
- **AI**: Claude Code's IDE integration (selection sharing and diffs inside Neovim), a sidekick.nvim terminal for any AI CLI, and MCP Hub to manage MCP servers.
- **Catppuccin Macchiato** theme with rainbow indent guides and delimiters.

## Keymaps

The leader key is `<Space>` and the local leader is `\`. Press `<leader>?` to browse every keymap with which-key, or `<leader>sk` to search them.

| Prefix      | Group                                       |
| ----------- | ------------------------------------------- |
| `<leader>a` | AI (`<leader>ac` for Claude Code)           |
| `<leader>c` | Code (format, line diagnostics)             |
| `<leader>d` | Debug                                       |
| `<leader>f` | Find files                                  |
| `<leader>g` | Git (`<leader>gh` for hunks)                |
| `<leader>o` | Tasks                                       |
| `<leader>p` | package.json packages (in package.json)     |
| `<leader>q` | Sessions                                    |
| `<leader>s` | Search                                      |
| `<leader>t` | Tests                                       |
| `<leader>u` | UI toggles (format on save, wrap, ...)      |
| `<leader>x` | Diagnostics and lists (Trouble)             |
| `gs`        | Surround                                    |

A few others worth knowing:

| Key                        | Action                                  |
| -------------------------- | --------------------------------------- |
| `<leader><space>`          | Smart file finder                       |
| `<leader>/`                | Grep the project                        |
| `<leader>e`                | File explorer                           |
| `-`                        | Open the parent directory in oil.nvim   |
| `<leader>h` / `<leader>H`  | Harpoon menu / add file                 |
| `<leader>1`–`<leader>5`    | Jump to Harpoon file 1–5                |
| `s` / `S`                  | Flash jump / Treesitter select          |
| `<C-/>`                    | Floating terminal                       |
| `<C-.>`                    | Toggle AI CLI                           |
| `<C-s>`                    | Save                                    |
| `<leader>U`                | Undo tree                               |
| `gd`, `gy`, `grn`, `gra`   | Definition, type definition, rename, code action |
| `]e` / `]w` / `]c` / `]t`  | Next error / warning / git hunk / TODO  |

## Customizing

- **Add a plugin**: create or edit a file in `lua/plugins/`. Every file there is imported automatically.
- **Add a language server**: add it to the `servers` table in `lua/plugins/lsp.lua` with its Mason package name, and put any settings in `after/lsp/<server>.lua`.
- **Add a formatter**: add it to `formatters_by_ft` in `lua/plugins/formatting.lua` and to Mason's `ensure_installed` list.
- **Per-language options**: put them in `after/ftplugin/<filetype>.lua`.

Lua files are formatted with [StyLua](https://github.com/JohnnyMorganz/StyLua) using `.stylua.toml`.
