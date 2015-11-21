" Vim global plugin for syntax highlighting only few lines surrounding cursor
" Maintainer:	Barry Arthur <barry.arthur@gmail.com>
" License:	Vim License (see :help license)
" Location:	plugin/unsullied.vim
" Website:	https://github.com/dahu/unsullied
"
" See unsullied.txt for help.  This can be accessed by doing:
"
" :helptags ~/.vim/doc
" :help unsullied

" Vimscript Setup: {{{1
" Allow use of line continuation.
let s:save_cpo = &cpo
set cpo&vim

" if exists("g:loaded_unsullied")
"       \ || v:version < 700
"       \ || v:version == 703 && !has('patch338')
"       \ || &compatible
"   let &cpo = s:save_cpo
"   finish
" endif
let g:loaded_unsullied = 1

" Options: {{{1

if !exists('g:unsullied_window_marks')
  let g:unsullied_window_marks = ['t', 'b']
endif

if !exists('g:unsullied_height')
  let g:unsullied_height = 4
endif

" Private Functions: {{{1

function! s:update_page_marks()
  call setpos("'" . g:unsullied_window_marks[0], getpos('w0'))
  call setpos("'" . g:unsullied_window_marks[1], getpos('w$'))
endfunction

" Public Interface: {{{1

function! Unsullied(...)
  let b:unsullied_height = a:0 ? a:1 : g:unsullied_height
  try
    hi Unsullied ctermfg=250 ctermbg=235 guifg=#bcbcbc guibg=#262626
    call matchdelete(b:unsullied_1)
    call matchdelete(b:unsullied_2)
    augroup Unsullied
      au!
    augroup END
  catch
  endtry
  if b:unsullied_height > 0
    augroup Unsullied
      au!
      au CursorHold * call s:update_page_marks()
    augroup END
    call s:update_page_marks()
    let b:unsullied_1 = matchadd('Unsullied', '\%''' . g:unsullied_window_marks[0] . '\_.*\ze\(.*\n\)\{' . b:unsullied_height . '}.*\%#')
    let b:unsullied_2 = matchadd('Unsullied', '\%#\(.*\n\)\{' . b:unsullied_height . '}\zs\_.*\%''' . g:unsullied_window_marks[1] . '.*')
  endif
endfunction

" Commands: {{{1
command! -bang -nargs=? Unsullied call Unsullied(<args>)

" Teardown: {{{1
" reset &cpo back to users setting
let &cpo = s:save_cpo

" Template From: https://github.com/dahu/Area-41/
" vim: set sw=2 sts=2 et fdm=marker:
