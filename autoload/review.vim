function! s:base()
  if ! exists('g:review_base')
    let g:review_base = 'develop'
  endif

  return g:review_base
endfunction

function! s:useTabs()
  if ! exists('g:review_use_tabs')
    let g:review_use_tabs = 1
  endif

  return g:review_use_tabs
endfunction

function! s:createTab()
  silent! exec 'tabnew!'
endfunction

function! s:clearPanes()
  if winnr('$') >= 2
    for i in range(2, winnr('$')-1)
      silent! exec i.'wincmd c'
    endfor
  endif
endfunction

function! review#review(...)
  let s:base = a:0 == 0 ? s:base() : a:1
  let l:files = system('git diff --numstat --no-renames $(git merge-base HEAD "'. s:base . '")')
  let l:files = split(l:files, '\n')
  let l:list = []

  if s:useTabs()
    call s:createTab()
  else
    call s:clearPanes()
  endif

  for l:file in l:files
    let l:item = split(l:file, '\t')
    call add(l:list, { 'filename': l:item[2], 'lnum': 1, 'text': '+' . l:item[0] . ' -' . l:item[1] })
  endfor

  call setqflist([], ' ', { 'id': 'reviewqf', 'title': 'Review' , 'items': l:list})
  copen
  setlocal switchbuf="uselast"
  nnoremap <buffer> <ENTER> :call review#file()<CR>
endfunction

function! review#file()

  if exists(':Gvdiffsplit') != 2
    echomsg 'Gvdiffsplit not available, install vim-fugitive and try again.'
    return
  endif

  let l:item = getqflist()[line('.') - 1]
  let l:bufnr = l:item['bufnr']+0
  call bufload(l:bufnr)

  let oldwn = winnr()
  silent! exec "normal! \<c-w>k"
  let newwn = winnr()
  silent! exe oldwn.'wincmd w'

  if oldwn == newwn
    silent! exec 'above new'
  endif

  call s:clearPanes()

  silent! exec "normal! \<c-w>k"
  silent! exec 'buffer ' . l:bufnr
  silent! exec 'Gvdiffsplit ' . s:base
endfunction
