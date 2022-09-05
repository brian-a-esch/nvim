## TODO
There are a lot of todos to get this to a fully operational editor
- Scheme for project specific compilation commands
    - The docs recommend symlinking the compilation commands for each project. This seems very not ideal to me, since I'd have a dirty git tree for every project I want to get auto completion for. I'd like to figure out a scheme where I can add a "projects.lua" file with the appropriate overrides for every project on the computer. 
- Syntax highlighting, needed so user defined types stand out
    - I think `treesitter` is the app to do this, still need to configure
- Buffer management, need clean way for tabs to work
- Search
    - Needed features
	- Load files by name
	- Git grep
	- Find usages. This is more of a language server thing. But I'd still like to see the display options out there
    - Tools I've seen
	- fzf, a fuzzy searcher
	- ripgrep, a fast grepper thing
- Git integration
    - gitsigns is a tool that at least gives the "this line has been edited" view
    - would love some sort of diff tool with a meld like view
- Build
    - Need a way to run build targets for make, cmake, go build, etc. 
    - Would be great to have some gtest support. Might have to write my own plugin for that 
- Debugging
    - This is a bit unexplored atm. Tools I've seen are `DAP` and `Dlv`, but I am not sure what they do

