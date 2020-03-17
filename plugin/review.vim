if exists('g:loaded_vim_review_plugin')
  finish
endif

let g:loaded_vim_review_plugin = 1

command! -nargs=? Review call review#review(<f-args>)
noremap <unique> <Plug>Review :call review#review(<f-args>)
