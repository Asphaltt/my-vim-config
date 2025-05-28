" adscriven@gmail.com 2017-05-07. Public domain.

" From vimrc. Usual caveats apply. Comparable in effectiveness to
" DetectIndent and Sleuth in practice, IME. Different trade-offs.

" This works better for code rather than for arbitrarily formatted
" files such as the help files, though it sometimes gets those right
" too. If somebody has used set noet ts=4 in a file that should be
" et sw=4, there's no easy way to detect that. You'll probably get
" ts=8 in that situation. But the file will need fixing anyway.

fun! s:guessindent()
    let view = winsaveview()
    silent! 0/^\t\%(\s*$\)\@!/
    let tabs = getline('.') =~ '^\t\%(\s*$\)\@!'
    silent! 0/^ \{2,8}\S/
    " Probably.
    let spaceshort = len(matchstr(getline('.'), '^ \{2,8}\ze\S'))
    " Fool's errand.
    silent! 0/^ \+\S.*\n\%(\s*\n)*\t/
    let spacelong = len(matchstr(getline('.'),
            \ '^ \+\ze\S.*\n\%(\s*\n\)*\t'))
    let &l:sw = spaceshort ? spaceshort : (tabs ? 0 : &sw)
    let &l:sts = -1
    let &l:et = !tabs
    let ts = spaceshort + spacelong
    " Sanity check. ts has to be a multiple of 4 and > sw. Otherwise 8.
    let &l:ts = ts%4 || ts<=&l:sw ? 8 : ts
    call winrestview(view)
endfun

augroup vimrc_guessindent
au!
au stdinreadpost,filterreadpost,filereadpost,bufreadpost,bufwritepost
        \ * call s:guessindent()
augroup end

