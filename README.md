## TODO
There are a lot of todos to get this to a fully operational editor
- Scheme for project specific compilation commands
    - The docs recommend symlinking the compilation commands for each project. This seems very not ideal to me, since I'd have a dirty git tree for every project I want to get auto completion for. I'd like to figure out a scheme where I can add a "projects.lua" file with the appropriate overrides for every project on the computer. 
- Find usages
    - Works with the language server, but I'd like a more expansive view. But I'd still like to see the display options out there
- Code navigation
    - Move cursor to previous/next location across buffers
    - Move between .h and .cpp
- Vim General
    - Easy way to close project
    - Delete buffers easily; by name and current open. All without messing up splits
    - 80 character line for C++. Maybe 120 for other languages?
    - Different opening screen for a project
    - Figure out how to remove highlighting after search, without removing highlighting all together
- Git integration
    - gitsigns is a tool that at least gives the "this line has been edited" view
    - would love some sort of diff tool with a meld like view
- Build
    - Need a way to run build targets for make, cmake, go build, etc. 
    - Would be great to have some gtest support. Might have to write my own plugin for that 
- Debugging
    - This is a bit unexplored atm. Tools I've seen are `DAP` and `Dlv`, but I am not sure what they do
- Formatting
    - Need language specific formatting
    - C++ needs clang format, but to be scoped based on project?
    - Lua needs something else
    - If I get those set up can I restore four space tabs?
- Viewing the call tree
    - https://github.com/ldelossa/litee-calltree.nvim
    - Write my own?



### Installed
These are the things I have installed on the system
- [packer](https://github.com/wbthomason/packer.nvim) a package management tool for nvim
- [fzf](https://github.com/junegunn/fzf) a command line fuzzy search tool
- [clangd](https://clangd.llvm.org/) a C/C++ LSP server
- In the `tools/` directory I cloned [getnf](https://github.com/ronniedroid/getnf) to get a [nerd font](https://github.com/ryanoasis/nerd-fonts). I selected the `JetBrainsMono` font
