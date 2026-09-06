# Neovim configuration

Personal Neovim configuration for macOS, managed with
[lazy.nvim](https://github.com/folke/lazy.nvim). It includes LSP support,
completion, snippets, formatting, linting, Treesitter, Telescope, diagnostics,
Git-friendly sessions, and the Tokyo Night color scheme.

The instructions below rebuild the complete editor setup on a new or freshly
formatted Mac.

## 1. Install Apple's command-line tools

The command-line tools provide the compiler and `make` required by Treesitter,
LuaSnip, and Telescope's native extension.

```sh
xcode-select --install
```

Complete the macOS installer before continuing.

## 2. Install Homebrew and base packages

Install [Homebrew](https://docs.brew.sh/Installation) if it is not already
available:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the shell setup instructions printed by the installer, then install the
editor and its command-line dependencies:

```sh
brew install neovim git ripgrep fd asdf coreutils bash
brew install --cask font-jetbrains-mono-nerd-font
```

`ripgrep` powers Telescope's text search, `fd` improves file discovery, and the
Nerd Font supplies the icons used throughout the interface. Configure the
terminal application to use **JetBrainsMono Nerd Font** after installing it.

Verify the base installation:

```sh
nvim --version
git --version
rg --version
fd --version
asdf version
```

This configuration is maintained against modern Neovim releases and currently
works with Neovim 0.12.

## 3. Configure asdf and language runtimes

Add the asdf shims directory near the beginning of `~/.zshrc`:

```sh
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
```

Restart the terminal or run `source ~/.zshrc`, then install the runtime plugins:

```sh
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin add python https://github.com/asdf-community/asdf-python.git
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
```

Install Node.js LTS plus the Python and Ruby versions used by this setup:

```sh
NODE_VERSION="$(asdf cmd nodejs resolve lts --latest-available)"
asdf install nodejs "$NODE_VERSION"
asdf install python 3.12.8
asdf install ruby 3.4.1

asdf set -u nodejs "$NODE_VERSION"
asdf set -u python 3.12.8
asdf set -u ruby 3.4.1
```

Node.js is needed by the JavaScript, TypeScript, CSS, HTML, JSON, Svelte,
Tailwind, GraphQL, Prisma, Emmet, Dockerfile, and Bash language servers. Python
is needed by Pyright, Black, isort, and Pylint.

RuboCop is deliberately launched through the asdf Ruby shim so that each Ruby
project can select its own Ruby and bundled gems. Install the fallback global
gems under the selected Ruby:

```sh
gem install bundler rubocop rubocop-performance rubocop-rails
asdf reshim ruby 3.4.1
```

Confirm that asdf, rather than Apple's system Ruby, is first on `PATH`:

```sh
type -a ruby
type -a rubocop
ruby --version
rubocop --version
```

The first entries should point into `~/.asdf/shims/`.

## 4. Clone this repository

Back up or move any existing Neovim configuration first. Then clone with SSH:

```sh
mkdir -p ~/.config
git clone git@github.com:dillo/nvim-setup.git ~/.config/nvim
```

If GitHub SSH access has not been configured, use HTTPS instead:

```sh
git clone https://github.com/dillo/nvim-setup.git ~/.config/nvim
```

## 5. Install Neovim plugins

The first launch bootstraps lazy.nvim automatically. A headless sync installs
the exact plugin revisions recorded in `lazy-lock.json`:

```sh
nvim --headless "+Lazy! sync" +qa
```

This step compiles LuaSnip's `jsregexp` support and Telescope's native FZF
extension, which is why the Apple command-line tools must be installed first.

## 6. Install language servers, formatters, and linters

[Mason](https://github.com/mason-org/mason.nvim) installs editor tooling under
`~/.local/share/nvim/mason`. Install every tool used by the configuration with:

```sh
nvim --headless \
  "+MasonInstall bash-language-server black css-lsp dockerfile-language-server emmet-ls eslint-lsp graphql-language-service-cli html-lsp isort json-lsp lua-language-server prettier prisma-language-server pylint pyright rubocop ruby-lsp stylua svelte-language-server tailwindcss-language-server typescript-language-server" \
  +qa
```

Ruby must already be installed and selected through asdf before running this
command. Mason's Ruby launchers are created using the active Ruby interpreter.

The configured tooling covers:

- Bash and Dockerfiles
- JavaScript, TypeScript, HTML, CSS, JSON, GraphQL, Svelte, Tailwind, and Prisma
- Lua
- Python with Pyright, Black, isort, and Pylint
- Ruby with Ruby LSP and RuboCop

Project-specific runtimes and dependencies still belong in each project's own
setup.

## 7. Finish the first launch

Open Neovim:

```sh
nvim
```

Then run these commands inside Neovim:

```vim
:TSUpdate
:checkhealth
```

Restart Neovim after the initial Treesitter and Mason installations complete.

## Verification

Use these commands inside Neovim when checking the installation:

- `:Lazy` — plugin status and updates
- `:Mason` — language-server, formatter, and linter status
- `:checkhealth` — complete environment health report
- `:LspInfo` — language servers attached to the current buffer
- `:ConformInfo` — formatters available for the current buffer
- `:Trouble diagnostics toggle` — workspace diagnostics

Open a source file and confirm that completion appears in insert mode. Use
`Space d` to show diagnostics on the current line, `[d` and `]d` to move between
diagnostics, and `Space x d` to list all diagnostics in the current file.

## Updating

Inside Neovim, open `:Lazy` and press `U`, or run:

```vim
:Lazy update
```

Update Mason packages from `:Mason` by pressing `U`. Update Treesitter parsers
with `:TSUpdate`.

Plugin updates modify `lazy-lock.json`. Commit that file with related
configuration changes so another machine receives the same plugin revisions.

## Important paths

- Configuration: `~/.config/nvim`
- Plugins: `~/.local/share/nvim/lazy`
- Mason tools: `~/.local/share/nvim/mason`
- State, sessions, logs, and swap files: `~/.local/state/nvim`
- Cache: `~/.cache/nvim`

If a plugin checkout becomes corrupted, close Neovim and move only that
plugin's directory out of `~/.local/share/nvim/lazy/`, then run `:Lazy sync` to
download a clean copy. Do not delete `~/.config/nvim`; it is the Git repository
containing the configuration.
