" --- Init:
if !exists('g:script_py_started')
    let g:script_py_started = 1

	let s:completion_channel = v:null

    let tags_file = '/home/anon/stow/vim/.vim/plugin/HiTags/vim.tags'
    "let tags_file = '/home/anon/Swap/vim-complete/vim.tags'
    "let tags_file = '/home/anon/Swap/vim-complete/test.tags'
    let cmd = 'python3 /home/anon/Swap/vim-complete/script.py ' . getpid() . ' ' . tags_file
    "call job_start(cmd)

    "call system(cmd . ' > /dev/null 2>&1 &')
    call system(cmd . ' &')
endif

" --- Client protocol
function! s:open_channel()
	if type(s:completion_channel) != v:t_channel || ch_status(s:completion_channel) !=# 'open'
        let sockpath = 'unix:/tmp/completion_server.sock'
        let s:completion_channel = ch_open(sockpath, {"mode": "nl"})
        if ch_status(s:completion_channel) !=# 'open'
            echoerr "Failed to open completion server socket."
			return 1
        endif
    endif
	return 0
endfunction

function! CompletionPush()
    if s:open_channel() | return | endif

    call ch_sendraw(s:completion_channel, "< \n")
endfunction

function! CompletionQuery(filter)
    if s:open_channel() | return | endif

    call ch_sendraw(s:completion_channel, '? ' . a:filter . "\n")
endfunction

function! CompletionPoll()
    if s:open_channel() | return | endif

	call ch_sendraw(s:completion_channel, "= \n")
	let response = ch_readraw(s:completion_channel)

	if response =~ '^> ' " Push
		let words = split(strpart(response, 2), ' ')
        return [0, words]
	elseif response =~ '^-' " Pass
        return [1, []]
	endif
endfunction

" --- Completion setup
function! MyCustomComplete(findstart, base) abort
    if a:findstart
        let startcol = col('.') - 1
        while startcol > 0 && getline('.')[startcol - 1] =~ '\k'
            let startcol -= 1
        endwhile

        let prefix = getline('.')[startcol : col('.') - 2]
		
        call CompletionQuery(prefix)

        return startcol
    endif

	let [status, words] = CompletionPoll()

    return ['']
endfunction

setlocal omnifunc=MyCustomComplete

inoremap <expr> <S-Tab> pumvisible() ? "\<C-N>" : "<C-x><C-o>"

autocmd BufWritePost * call CompletionPush()

" Private
"autocmd CompleteDone *
"    \ if get(v:completed_item, 'word', '') == '__dummy__' |
"    \     echo '' |
"    \ endif
autocmd CompleteDone * echo ''
