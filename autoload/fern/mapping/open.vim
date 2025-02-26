let s:Promise = vital#fern#import('Async.Promise')

function! fern#mapping#open#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-open:select)   :<C-u>call <SID>call('open', 'select')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:split)    :<C-u>call <SID>call('open', 'split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:vsplit)   :<C-u>call <SID>call('open', 'vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:tabedit)  :<C-u>call <SID>call('open', 'tabedit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:above)    :<C-u>call <SID>call('open', 'leftabove split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:left)     :<C-u>call <SID>call('open', 'leftabove vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:below)    :<C-u>call <SID>call('open', 'rightbelow split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:right)    :<C-u>call <SID>call('open', 'rightbelow vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:top)      :<C-u>call <SID>call('open', 'topleft split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:leftest)  :<C-u>call <SID>call('open', 'topleft vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:bottom)   :<C-u>call <SID>call('open', 'botright split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:rightest) :<C-u>call <SID>call('open', 'botright vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:edit-or-error)   :<C-u>call <SID>call('open', 'edit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:edit-or-split)   :<C-u>call <SID>call('open', 'edit/split')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:edit-or-vsplit)  :<C-u>call <SID>call('open', 'edit/vsplit')<CR>
  nnoremap <buffer><silent> <Plug>(fern-action-open:edit-or-tabedit) :<C-u>call <SID>call('open', 'edit/tabedit')<CR>

  " Smart map
  nmap <buffer><silent><expr>
        \ <Plug>(fern-action-open:side)
        \ fern#smart#drawer(
        \   "\<Plug>(fern-action-open:left)",
        \   "\<Plug>(fern-action-open:right)",
        \ )
  nmap <buffer><silent><expr>
        \ <Plug>(fern-open-or-enter)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open)",
        \   "\<Plug>(fern-action-enter)",
        \ )
  nmap <buffer><silent><expr>
        \ <Plug>(fern-open-or-expand)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open)",
        \   "\<Plug>(fern-action-expand)",
        \ )

  " Alias map
  nmap <buffer><silent> <Plug>(fern-action-open:edit) <Plug>(fern-action-open:edit-or-error)
  nmap <buffer><silent> <Plug>(fern-action-open) <Plug>(fern-action-open:edit)

  if !a:disable_default_mappings
    nmap <buffer><nowait> <C-m> <Plug>(fern-open-or-enter)
    nmap <buffer><nowait> l <Plug>(fern-open-or-expand)
    nmap <buffer><nowait> s <Plug>(fern-action-open:select)
    nmap <buffer><nowait> e <Plug>(fern-action-open)
    nmap <buffer><nowait> E <Plug>(fern-action-open:side)
    nmap <buffer><nowait> t <Plug>(fern-action-open:tabedit)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ "fern#internal#mapping#call",
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_open(helper, opener) abort
  let node = a:helper.get_cursor_node()
  if node is# v:null
    return s:Promise.reject("no node found on a cursor line")
  elseif node.bufname is# v:null
    return s:Promise.reject("the node does not have bufname")
  endif
  try
    call fern#lib#buffer#open(expand(node.bufname), {
          \ 'opener': a:opener,
          \ 'locator': a:helper.is_drawer(),
          \})
    return s:Promise.resolve()
  catch
    return s:Promise.reject(v:exception)
  endtry
endfunction
