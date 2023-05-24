## TODO
There are a lot of todos to get this to a fully operational editor
- Scheme for project specific compilation commands
    - The docs recommend symlinking the compilation commands for each project. This seems very not ideal to me, since I'd have a dirty git tree for every project I want to get auto completion for. I'd like to figure out a scheme where I can add a "projects.lua" file with the appropriate overrides for every project on the computer. 
- Find usages
    - Works with the language server, but I'd like a more expansive view. But I'd still like to see the display options out there
- Vim General
    - Different opening screen for a project
- Testing
    - Would be great to have some gtest support? https://github.com/alepez/vim-gtest
    - More comprehensive testing runner solution? https://github.com/vim-test/vim-test
    - Another option? https://github.com/nvim-neotest/neotest
    - Build tasks with? https://github.com/skywind3000/asynctasks.vim
    - Use tree-sitter to determine gtest, and then feed that as an arg
- Debugging
    - I've added a "DAP" plugin,
        - Its not working well for C++. Might consider https://github.com/sakhnik/nvim-gdb
        - I should test it for other languages, like golang or python before ripping out
    - Vimspector is an option https://github.com/puremourning/vimspector
- Viewing the call tree
    - https://github.com/ldelossa/litee-calltree.nvim
    - Write my own?
- Language server 
    - show when code actions are available, like we do for diagnostics
    - Display "pending" lsp requests, so I know that something is taking a second vs never completing
- Completion
    - Don't want take up the whole screen with completions
    - Better sorting to prefer variable > member function > global function
    - `cmp-path` for filesystem paths
    - `cmp-cmdline` for command completions
    - Special config for `gitcommit` files, can be seen on `nvim-cmp` home README
- Snippets
    - Play with the keybindings, not sold on snippet selection
    - Explore the world of snippets, either making useful ones, existing ones, and lua scrirpting
- Signcolumn
    - A slight thing that bugs me is if a gitsign and lsp error both show up, the lsp error is more on the left.
      It seems like this is being looked at with a few issues & PRs. Something they may add in 0.10 release?
      - https://github.com/neovim/neovim/issues/16632
      - https://github.com/neovim/neovim/pull/19737, the feature that will implement it
    - Statuscolumn and Foldcolumn
      There seems to be a new set of features for customizing the column. We may want to display fold options,
      also maybe could reverse column display order?
- Orgmode
    - There are some limitations of the current org mode that can be solved with plugins
      - [table support](https://github.com/dhruvasagar/vim-table-mode)
      - [code snippets](https://github.com/michaelb/sniprun)
- LSP
    - [type heirarchy](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#typeHierarchy_supertypes)
      This is supported by clangd too https://clangd.llvm.org/extensions#type-hierarchy
- Refactoring tools
    - https://github.com/ThePrimeagen/refactoring.nvim
    - https://github.com/simrat39/rust-tools.nvim
    - https://github.com/smjonas/inc-rename.nvim


### Installed
These are the things I have installed on the system
- [packer](https://github.com/wbthomason/packer.nvim) a package management tool for nvim
- [fzf](https://github.com/junegunn/fzf) a command line fuzzy search tool
- [clangd](https://clangd.llvm.org/) a C/C++ LSP server
- In the `tools/` directory I cloned [getnf](https://github.com/ronniedroid/getnf) to get a [nerd font](https://github.com/ryanoasis/nerd-fonts). I selected the `JetBrainsMono` font
- [lua-language-server](https://github.com/sumneko/lua-language-server) using a pre built binary found in their releases. Work computer uses version 3.5.5 
- [ripgrep](https://github.com/BurntSushi/ripgrep) using a binary on github, `ripgrep_13.0.0_amd64.deb`
- [fd](https://github.com/sharkdp/fd) using a binary on github, `fd-musl_8.4.0_amd64.deb`
- [lldb](https://apt.llvm.org/) Specifically lldb-14. On my work ubuntu station I had to cleanup the
path the python files, since the package appears to be broken. Made a symlink from 
`/usr/lib/lib/python3.6/site-packages` to the real directory 
`/usr/lib/llvm-14/lib/python3/dist-packages/lldb/`
- [tree-sitter](https://github.com/tree-sitter/tree-sitter/blob/master/cli/README.md) installed on workstation via 
  `cargo install tree-sitter-cli`. Should be in path and can run `tree-sitter` command. Running `:checkheath` in vim
  command prompt, under the tree sitter section we can see if the plugin is picking it up
- [vim-snippets](https://github.com/honza/vim-snippets.git) installed in `~/.config/vim-snippets` via a `git clone`.
  Don't know if that's the best place for it, or if a submodule would be better
- [rust-analyzer](https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary) installed via
  `rustup component add rust-analyzer`
- [tsserver](https://github.com/Microsoft/TypeScript/wiki/Standalone-Server-%28tsserver%29) installed via `npm install -g typescript typescript-language-server`
