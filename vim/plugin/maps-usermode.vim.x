let g:map_table = {
            \ "window" : {
                \ "j" : ["\<c-w>j", 'n'],
                \ "h" : ["\<c-w>h", 'n'],
                \ "k" : ["\<c-w>k", 'n'],
                \ "l" : ["\<c-w>l", 'n'],
                \ "q" : ["\<c-w>q", 'n'],
                \ "v" : ["\<c-w>v", 'n'],
                \ "s" : ["\<c-w>s", 'n'],
                \ "1" : ["1\<c-w>w", 'n'],
                \ "2" : ["2\<c-w>w", 'n'],
                \ "3" : ["3\<c-w>w", 'n'],
                \ "4" : ["4\<c-w>w", 'n'],
                \ "5" : ["5\<c-w>w", 'n'],
                \ "6" : ["6\<c-w>w", 'n'],
                \ "7" : ["7\<c-w>w", 'n'],
                \ "8" : ["8\<c-w>w", 'n'],
                \ "9" : ["9\<c-w>w", 'n'],
                \ "n" : ["\<c-w>w", 'n'],
                \ "p" : ["\<c-w>W", 'n'],
                \ "c" : ["\<c-w>n", 'n'],
                \ "o" : ["\<c-w>p", 'n'],
                \ },
            \ "scroll": {
                \ "y": ["\<c-y>", 'n'],
                \ "e": ["\<c-e>", 'n'],
                \ "u": ["\<c-u>", 'n'],
                \ "d": ["\<c-d>", 'n'],
                \ "f": ["\<c-f>", 'n'],
                \ "b": ["\<c-b>", 'n'],
                \ },
            \ }

let g:mode = ""

set stl^=[UM:%{get(g:,'mode','')}]

function Leave_mode() abort
    let g:mode = ""
    return ""
endfunction

function Enter_mode(mode) abort
    let g:mode = a:mode
endfunction

function ModeMap(key)
    if has_key(g:map_table, g:mode) && has_key(g:map_table[g:mode], a:key)
        call feedkeys(g:map_table[g:mode][a:key][0],
                      g:map_table[g:mode][a:key][1])
        return
    endif
    call feedkeys(a:key, 'n')
endfunction

nnoremap <silent> <ESC> :call Leave_mode()<cr>

nnoremap <silent> <Leader><Leader>w :call Enter_mode('window')<cr>
nnoremap <silent> <Leader><Leader>s :call Enter_mode('scroll')<cr>

nnoremap <silent> A :call ModeMap("A")<cr>
nnoremap <silent> B :call ModeMap("B")<cr>
nnoremap <silent> C :call ModeMap("C")<cr>
nnoremap <silent> D :call ModeMap("D")<cr>
nnoremap <silent> E :call ModeMap("E")<cr>
nnoremap <silent> F :call ModeMap("F")<cr>
nnoremap <silent> G :call ModeMap("G")<cr>
nnoremap <silent> H :call ModeMap("H")<cr>
nnoremap <silent> I :call ModeMap("I")<cr>
nnoremap <silent> J :call ModeMap("J")<cr>
nnoremap <silent> K :call ModeMap("K")<cr>
nnoremap <silent> L :call ModeMap("L")<cr>
nnoremap <silent> M :call ModeMap("M")<cr>
nnoremap <silent> N :call ModeMap("N")<cr>
nnoremap <silent> O :call ModeMap("O")<cr>
nnoremap <silent> P :call ModeMap("P")<cr>
nnoremap <silent> Q :call ModeMap("Q")<cr>
nnoremap <silent> R :call ModeMap("R")<cr>
nnoremap <silent> S :call ModeMap("S")<cr>
nnoremap <silent> T :call ModeMap("T")<cr>
nnoremap <silent> U :call ModeMap("U")<cr>
nnoremap <silent> V :call ModeMap("V")<cr>
nnoremap <silent> W :call ModeMap("W")<cr>
nnoremap <silent> X :call ModeMap("X")<cr>
nnoremap <silent> Y :call ModeMap("Y")<cr>
nnoremap <silent> Z :call ModeMap("Z")<cr>
nnoremap <silent> a :call ModeMap("a")<cr>
nnoremap <silent> b :call ModeMap("b")<cr>
nnoremap <silent> c :call ModeMap("c")<cr>
nnoremap <silent> d :call ModeMap("d")<cr>
nnoremap <silent> e :call ModeMap("e")<cr>
nnoremap <silent> f :call ModeMap("f")<cr>
nnoremap <silent> g :call ModeMap("g")<cr>
nnoremap <silent> h :call ModeMap("h")<cr>
nnoremap <silent> i :call ModeMap("i")<cr>
nnoremap <silent> j :call ModeMap("j")<cr>
nnoremap <silent> k :call ModeMap("k")<cr>
nnoremap <silent> l :call ModeMap("l")<cr>
nnoremap <silent> m :call ModeMap("m")<cr>
nnoremap <silent> n :call ModeMap("n")<cr>
nnoremap <silent> o :call ModeMap("o")<cr>
nnoremap <silent> p :call ModeMap("p")<cr>
nnoremap <silent> q :call ModeMap("q")<cr>
nnoremap <silent> r :call ModeMap("r")<cr>
nnoremap <silent> s :call ModeMap("s")<cr>
nnoremap <silent> t :call ModeMap("t")<cr>
nnoremap <silent> u :call ModeMap("u")<cr>
nnoremap <silent> v :call ModeMap("v")<cr>
nnoremap <silent> w :call ModeMap("w")<cr>
nnoremap <silent> x :call ModeMap("x")<cr>
nnoremap <silent> y :call ModeMap("y")<cr>
nnoremap <silent> z :call ModeMap("z")<cr>

nnoremap <silent> 1 :call ModeMap("1")<cr>
nnoremap <silent> 2 :call ModeMap("2")<cr>
nnoremap <silent> 3 :call ModeMap("3")<cr>
nnoremap <silent> 4 :call ModeMap("4")<cr>
nnoremap <silent> 5 :call ModeMap("5")<cr>
nnoremap <silent> 6 :call ModeMap("6")<cr>
nnoremap <silent> 7 :call ModeMap("7")<cr>
nnoremap <silent> 8 :call ModeMap("8")<cr>
nnoremap <silent> 9 :call ModeMap("9")<cr>
nnoremap <silent> 0 :call ModeMap("0")<cr>
