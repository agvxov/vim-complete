if !exists('g:script_py_started')
    let g:script_py_started = 1

    "let tags_file = '/home/anon/stow/vim/.vim/plugin/HiTags/vim.tags'
    let tags_file = '/home/anon/Swap/vim-complete/vim.tags'
    let cmd = 'python3 /home/anon/Swap/vim-complete ' . getpid() . ' ' . tags_file
    "call job_start(cmd)

    "call system(cmd . ' > /dev/null 2>&1 &')
    "call system(cmd . ' &')
endif

function! MyCustomComplete(findstart, base) abort
    if a:findstart
        let startcol = col('.') - 1
        while startcol > 0 && getline('.')[startcol - 1] =~ '\k'
            let startcol -= 1
        endwhile
        return startcol
    endif

    python3 << EOF
import socket

sock_path = "/tmp/words_socket"

try:
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
        s.settimeout(0.1)
        s.connect(sock_path)
        s.sendall((">" + vim.eval('a:base') + "\n").encode())
        data = b""
        while True:
            chunk = s.recv(4096)
            data += chunk
            if b'\n' in data: break
        words = data.decode('utf-8').split()
except Exception as e:
    words = ['Error:', str(e)]

# Send words back to Vim
vim.command('let g:mywords = {}'.format(words))
EOF

    return get(g:, 'mywords', [''])
endfunction

"setlocal completefunc=MyCustomComplete
setlocal omnifunc=MyCustomComplete


inoremap <expr> <S-Tab> pumvisible() ? "\<C-N>" : "<C-x><C-o>" 
