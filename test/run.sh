#!/bin/sh

_pp='pack/travis/start'
_clone="-C $_pp clone --depth=1 --recurse-submodule"

mkdir -p $_pp
[ -d $_pp/vader.vim    ] || git $_clone --depth=1 https://github.com/junegunn/vader.vim.git
[ -d $_pp/vim-ducttape ] || git $_clone --depth=1 https://github.com/rsrchboy/vim-ducttape.git

# vim *MUST* also load a file here for all tests to pass
vim --clean -Nnu test/vimrc -c 'Vader! test/*' LICENSE
