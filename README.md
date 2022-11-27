## TODO
There are a lot of todos to get this to a fully operational editor
- Scheme for project specific compilation commands
    - The docs recommend symlinking the compilation commands for each project. This seems very not ideal to me, since I'd have a dirty git tree for every project I want to get auto completion for. I'd like to figure out a scheme where I can add a "projects.lua" file with the appropriate overrides for every project on the computer. 
- Find usages
    - Works with the language server, but I'd like a more expansive view. But I'd still like to see the display options out there
- Vim General
    - Delete buffers easily; by name and current open. All without messing up splits
    - Different opening screen for a project
- Git integration
    - annotate https://github.com/emmanueltouzery/agitator.nvim/
- Testing
    - Would be great to have some gtest support? https://github.com/alepez/vim-gtest
    - More comprehensive testing runner solution? https://github.com/vim-test/vim-test
- Debugging
    - I've added a "DAP" plugin,
        - Its not working well for C++. Might consider https://github.com/sakhnik/nvim-gdb
        - I should test it for other languages, like golang or python before ripping out
- Viewing the call tree
    - https://github.com/ldelossa/litee-calltree.nvim
    - Write my own?
- Priority 
    - for popups I'd like the blame popups to be lower than the language server popups
    - for gitsigns i'd like priority of git changes to be before warnings, but after errors? Maybe a way to display both?


### Installed
These are the things I have installed on the system
- [packer](https://github.com/wbthomason/packer.nvim) a package management tool for nvim
- [fzf](https://github.com/junegunn/fzf) a command line fuzzy search tool
- [clangd](https://clangd.llvm.org/) a C/C++ LSP server
- In the `tools/` directory I cloned [getnf](https://github.com/ronniedroid/getnf) to get a [nerd font](https://github.com/ryanoasis/nerd-fonts). I selected the `JetBrainsMono` font
- [lua-language-server](https://github.com/sumneko/lua-language-server) using a pre built binary found in their releases. Work computer uses version 3.5.5 
- [ripgrep](https://github.com/BurntSushi/ripgrep) using a binary on github, `ripgrep_13.0.0_amd64.deb`
- [fd](https://github.com/sharkdp/fd) using a binary on github, `fd-musl_8.4.0_amd64.deb`
