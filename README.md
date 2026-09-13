# 🌙 nvim-carvaba & Mac Setup

A modern and customizable NeoVim setup to supercharge your development workflow. This configuration is optimized for performance, supports multiple languages, and includes advanced features like LSP, auto-completion, and syntax highlighting.

Also can do initial configuration for setup the dev environment on Mac

---

## 📦 Features

- **Automated macOS Setup:** One-script installation for Homebrew, Ruby (Mise), Node.js, and CLI tools.
- **`Brewfile`:** Single source of truth for every brew package/cask this setup installs.
- **`sync.sh`:** Idempotent — run it on a new Mac or an already-configured one to install/update everything.
- Fully integrated with LSP for intelligent coding assistance.
- Pre-configured plugins for a seamless development experience.
- Optimized key mappings and UI enhancements.
- Support for multiple programming languages and tools.

---

## 🚀 Quick Start (New Machine)


1. **Clone the repository:**

```bash
   git clone https://github.com/carVaba/nvim-carvaba.git ~/.config/nvim
   cd ~/.config/nvim
```

2. **Install and configure XCode**
```bash
chmod +x setup_xcode.sh
./setup_xcode.sh
```

3. **Run the setup script:**

```bash
chmod +x first-setup.sh
./first-setup.sh
```

### 🔄 Keeping a Mac up to date

On this Mac, or any other Mac already running this config, run `sync.sh` any
time to install missing packages and pick up config changes. It is safe to
run repeatedly — it only installs what's missing:

```bash
chmod +x sync.sh
./sync.sh
```

To add a new tool for every machine, add it to `Brewfile` (CLI tools) or
`Brewfile.gui` (GUI apps) and run `./sync.sh`.

**Headless machines (e.g. a Mac mini with no display):** on first setup, skip
GUI apps entirely and install terminal tools only:

```bash
./first-setup.sh --no-gui
```

`sync.sh` itself never takes arguments — `first-setup.sh --no-gui` caches
that preference for the machine, so every later plain `./sync.sh` run keeps
skipping GUI apps too. Run `./first-setup.sh --gui` to turn GUI installs
back on.

**(Additional step for iOS Development)**

    Please check this link https://github.com/wojciech-kulik/xcodebuild.nvim/wiki/Neovim-Configuration


**Markdown Installation**

   Please before start working on the markdown file check the build is installed

   ```sh
   :Lazy build markdown-preview.nvim
   ```

   For more information check [here](https://github.com/iamcco/markdown-preview.nvim/issues/690#issuecomment-2283748484)

**Final step**


   Start nvim and let's have fun 🎉

> **Note:** After the script finishes, run `source ~/.zshrc` or restart your terminal to activate all the new tools!

---

## 🛠 Additional Tools

This setup benefits from the following tools:

- **[npm](https://nodejs.org/)**: For managing JavaScript dependencies.
- **[Xcode Command Line Tools](https://developer.apple.com/xcode/)**: For macOS development tools.
- **[Homebrew](https://brew.sh/)**: For managing system packages.
- **[Python](https://www.python.org/)**: For plugins requiring Python integration.
- **[ripgrep](https://github.com/BurntSushi/ripgrep)**: A faster alternative to `grep`.
- **[fd](https://github.com/sharkdp/fd)**: A simple and fast alternative to `find`.
- **[fzf](https://github.com/junegunn/fzf)**: A command-line fuzzy finder.
- **[iOS Development with NeoVim](https://wojciechkulik.pl/ios/the-complete-guide-to-ios-macos-development-in-neovim)**: A guide for config NeoVim to be iOS IDE.
