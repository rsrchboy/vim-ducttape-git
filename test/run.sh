#!/bin/sh

[ -d vader.vim     ] || git clone --depth=1 https://github.com/junegunn/vader.vim.git
[ -d vimi-ducttape ] || git clone --depth=1 https://github.com/rsrchboy/vim-ducttape.git

# _LIB=$(find p5/ -maxdepth 2 -name lib -type d -printf ':%p')
# find autoload -name '*.pm' | PERL5LIB=$PERL5LIB:$_LIB xargs -L1 perl -I autoload -I lib -I t/lib -MVIM -wc 2>&1

# vim *MUST* also load a file here for all tests to pass
vim -Nu test/vimrc -c 'Vader! test/*' LICENSE 2>&1
