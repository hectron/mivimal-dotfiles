# Mivimal

A minimal Neovim configuration which tries to leverage as much stock Neovim as possible.

> [!NOTE]
> This configuration assumes that Neovim 0.12+ is installed. This is because [0.12 is the first release which aims to be "Out of the Box."](https://neovim.io/roadmap/)

In order to get started with core tooling, make sure that [mise][mise] is installed and run:

```zsh
mise install
```

## Additional tooling

In order to enhance Neovim, we need to install tools which provide functionality such as LSPs, Formatters, Linters, etc.

Historically, this is done via Mason. In order to keep the set up light and portable, I'm opting to use [mise][mise] as the tool provider instead; whenever a new LSP, formatter, etc needs to be added, it should be installed via [mise][mise].

Rather than leveraging the `./lsp` directory, we rely on **neovim/nvim-lspconfig** to provide LSP server configurations. **In order to get LSPs working**:

1. Install new LSP via [mise][mise]
1. Enable the LSP by adding an entry to the `vim.lsp.enable` table.

[mise]: https://mise.jdx.dev/
