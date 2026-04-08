# 🌙 nvim-carvaba & Mac Setup

A modern and customizable NeoVim setup to supercharge your development workflow. This configuration is optimized for performance, supports multiple languages, and includes advanced features like LSP, auto-completion, and syntax highlighting.

Also can do initial configuration for setup the dev environment on Mac

---

## 📦 Features

- **Automated macOS Setup:** One-script installation for Homebrew, Ruby (Mise), Node.js, and CLI tools.
- Fully integrated with LSP for intelligent coding assistance.
- Pre-configured plugins for a seamless development experience.
- Optimized key mappings and UI enhancements.
- Support for multiple programming languages and tools.

---

## 🚀 Quick Start (New Machine)


1. **Clone the repository:**

```bash
   git clone [https://github.com/carVaba/nvim-carvaba.git](https://github.com/carVaba/nvim-carvaba.git) ~/.config/nvim
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

**(Aditional step for iOS Development)**

    Please chech this link https://github.com/wojciech-kulik/xcodebuild.nvim/wiki/Neovim-Configuration


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
