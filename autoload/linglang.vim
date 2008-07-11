" linglang.vim
" @Author:      Thomas Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2008-07-11.
" @Last Change: 2008-07-11.
" @Revision:    0.0.81

if &cp || exists("loaded_linglang_autoload")
    finish
endif
let loaded_linglang_autoload = 1
let s:save_cpo = &cpo
set cpo&vim


function! s:Initialize() "{{{3
    if exists('b:linglang')
        return
    endif
    if exists('b:linglang_patterns')
        let b:linglang = copy(b:linglang_patterns)
    else
        let b:linglang = copy(g:linglang_patterns)
    endif
    if exists('b:linglang_words')
        let wordlist = b:linglang_words
    else
        let wordlist = g:linglang_words
    endif
    for [lang, words] in items(wordlist)
        let rx = '\<\('. join(words, '\|') .'\)\>'
        if has_key(b:linglang, lang)
            let b:linglang[lang] = '\c'. b:linglang[lang] .'\|'. rx
        else
            let b:linglang[lang] = '\c'. rx
        endif
    endfor
    " call TLogDBG(string(b:linglang))
endf


function! linglang#Linglang(...) "{{{3
    let verbose = a:0 >= 1 ? a:1 : 1
    if exists('b:linglang')
        call hookcursormoved#Register("linechange", "linglang#Set", '', 1)
        unlet b:linglang
        if verbose
            echom 'Linglang off'
        endif
    else
        call s:Initialize()
        call hookcursormoved#Register("linechange", "linglang#Set")
        if a:0 >= 2
            let b:linglanglangs = []
            for i in range(2, a:0)
                call add(b:linglanglangs, a:{i})
            endfor
        else
            let b:linglanglangs = keys(b:linglang)
        endif
        if verbose
            echom 'Linglang on'
        endif
    endif
endf


" :def: function! linglang#Set(mode, ?condition_name=b:hookcursormoved_syntax)
function! linglang#Set(mode, ...) "{{{3
    " let condition_name = a:0 >= 1 ? a:1 : b:hookcursormoved_linechange
    " TLogVAR a:mode
    let line = getline('.')
    " TLogVAR line, b:linglanglangs
    " for l in b:linglanglangs
    "     let rx = b:linglang[l]
    "     let mtch = matchstr(line, l)
    "     TLogVAR l, rx, mtch
    " endfor
    let lang = filter(copy(b:linglanglangs), 'line =~ b:linglang[v:val]')
    " TLogVAR lang
    if len(lang) == 1
        call s:Set(lang[0])
    else
        let score0 = 0
        let lang0 = ''
        let words = split(line, '[[:space:][:punct:]]\+')
        for lang1 in b:linglanglangs
            let rx1 = b:linglang[lang1]
            let score1 = len(filter(copy(words), 'v:val =~ rx1'))
            if score1 > score0
                " TLogVAR lang1, score1
                let lang0 = lang1
                let score0 = score1
            endif
        endfor
        if !empty(lang0)
            call s:Set(lang0)
        endif

    endif
endf


function! s:Set(lang) "{{{3
    if !exists('b:linglang_last') || b:linglang_last != a:lang
        let b:linglang_last = a:lang
        exec get(g:linglang_actions, a:lang, '')
    endif
endf


let &cpo = s:save_cpo
unlet s:save_cpo
