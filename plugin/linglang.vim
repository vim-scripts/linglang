" linglang.vim  Perform actions on basis of the current line's language
" @Author:      Thomas Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2008-07-11.
" @Last Change: 2008-07-11.
" @Revision:    0.1.59
" GetLatestVimScripts: 0 0 linglang.vim

if &cp || exists("loaded_linglang")
    finish
endif
if !exists('g:loaded_hookcursormoved') || g:loaded_hookcursormoved < 7
    echoerr 'hookcursormoved >= 0.7 is required'
    finish
endif
let loaded_linglang = 1

let s:save_cpo = &cpo
set cpo&vim


if !exists('g:linglang_filetypes')
    " Enable |:Linglang| automatically for these filetypes.
    let g:linglang_filetypes = []   "{{{2
endif


if !exists('g:linglang_actions')
    " Actions to be executed when switching languages.
    " :nodefault:
    " :read: let g:linglang_actions = {}   "{{{2
    let g:linglang_actions = {
                \ 'de': 'setlocal spelllang=de',
                \ 'en': 'setlocal spelllang=en',
                \ }
endif


if !exists('g:linglang_words')
    " Significant words (actually regexps matching words) per language.
    " :nodefault:
    " :read: let g:linglang_words = {}   "{{{2
    let g:linglang_words = {
                \ 'de': ['dass\?', 'de[rnm]', 'wo', 'wie', 'wann', 'und', 
                \        'oder', 'ich', 'du', 'er', 'sie', 'es', 'ein\(e[nrs]\?\)',
                \        'als'],
                \ 'en': ['the[mn]\?', 'a%\[nd]', 'for', 'from', 'out', 'to', 
                \        'I', 'you', 's\?he',
                \        'how', 'when', 'where', 'who', 'if', 'or', 'on', 'off\?'],
                \ }
endif


if !exists('g:linglang_patterns')
    " Significant regexps per language.
    " :nodefault:
    " :read: let g:linglang_patterns = {}   "{{{2
    let g:linglang_patterns = {
                \ 'de': '[ßäöüÄÖÜ]',
                \ }
endif


augroup Linglang
    autocmd!
    for s:ft in g:linglang_filetypes
        exec 'au Filetype '. s:ft .' Linglang!'
    endfor
    unlet! s:ft
augroup END


" :display: :Linglang[!] [LANGS ...]
" Toggle linglang support.
" With [!], suppress message.
command! -bang -nargs=* Linglang call linglang#Linglang(empty('<bang>'), <f-args>)


let &cpo = s:save_cpo
unlet s:save_cpo


finish
CHANGES:
0.1
- Initial release

