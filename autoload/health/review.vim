function! health#review#check() abort
  call health#report_start('vim-review checks')

  if exists(':Gvdiffsplit') == 2
    call health#report_ok('vim-fugitive plugin found.')
  else
    call health#report_error('vim-fugitive plugin not found.')
  endif
endfunction
