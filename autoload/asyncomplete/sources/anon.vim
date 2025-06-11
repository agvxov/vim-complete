source /home/anon/.vim/autoload/swp-completion.vim

function! asyncomplete#sources#anon#get_source_options(opts)
    return extend({
        \ 'events': ['BufWinEnter'],
        \ 'on_event': function('s:on_event'),
        \}, a:opts)
endfunction

" XXX
function! s:on_event(opt, ctx, event) abort
    if a:event == 'BufWinEnter'
        "call s:refresh_keywords()
    endif
endfunction

function! asyncomplete#sources#anon#completor(opt, ctx) abort
    let l:typed    = a:ctx['typed']
    let l:col      = a:ctx['col']
    let l:kw       = matchstr(l:typed, '\w\+$')
    let l:kwlen    = len(l:kw)
    let l:startcol = l:col - l:kwlen

    call CompletionQuery(l:typed)

    let [l:status, l:words] = CompletionPoll()

    if l:status == 1 && empty(l:words)
        call asyncomplete#log('anon', 'matches not ready yet')
        " This from the documentation:
        " > If you are returning incomplete results and would like to trigger completion
        " > on the next keypress pass 1 as the fifth parameter to asyncomplete#complete
        " > which signifies the result is incomplete.
        " is a lie.
        " It seems to have been partially implemented.
        " `asyncomplete-lsp.vim` seems to use it anyways, I do wonder if they have noticed.
        call timer_start(500, {
        \     timer-> asyncomplete#sources#anon#completor(a:opt, a:ctx)}
        \ )
        return
    endif

    let l:matches = map(l:words, {_,v -> {'word':v, 'dup':1, 'icase':1, 'menu':'[anon]'}})

    call asyncomplete#log('anon', 'matches: ', l:matches)

    call asyncomplete#complete(
        \ a:opt['name'],
        \ a:ctx,
        \ l:startcol,
        \ l:matches,
        \ 0
        \ )
endfunction
