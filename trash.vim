" --- Completion setup
"function! MyCustomComplete(findstart, base) abort
"    if a:findstart
"        let startcol = col('.') - 1
"        while startcol > 0 && getline('.')[startcol - 1] =~ '\k'
"            let startcol -= 1
"        endwhile
"
"        let prefix = getline('.')[startcol : col('.') - 2]
"		
"        call CompletionQuery(prefix)
"
"        return startcol
"    endif
"
"	let [status, words] = CompletionPoll()
"
"    return [''] " XXX
"endfunction

"setlocal omnifunc=MyCustomComplete

"    inoremap <expr> <S-Tab> pumvisible() ? "\<C-N>" : "<C-x><C-o>"

" Private
"autocmd CompleteDone *
"    \ if get(v:completed_item, 'word', '') == '__dummy__' |
"    \     echo '' |
"    \ endif
"autocmd CompleteDone * echo ''
