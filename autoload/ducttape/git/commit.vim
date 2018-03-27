" For those following along at home:  the reason we can get away with
" autoloaded functions is that we execute the VimL that creates them from
" inside this script/file.  That's enough to convince vim that these functions
" belong in that namespace -- or perhaps just that we're determined so it may
" as well get out of the way.

if !ducttape#require('Git::Raw')
    " TODO FIXME create a FuncUndefined au here to warn?
    let g:ducttape#git#commit#loaded = 0
    finish
endif

let s:prototype = {}

fun! ducttape#git#commit#New(git_dir, id) abort
    return extend({ 'git_dir': a:git_dir, 'id': a:id }, s:prototype, 'keep')
endfun

" execute ducttape#symbiont#autoload(expand('<sfile>'))

" __END__
