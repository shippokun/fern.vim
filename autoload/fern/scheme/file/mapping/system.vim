let s:Promise = vital#fern#import('Async.Promise')

function! fern#scheme#file#mapping#system#init(disable_default_mappings) abort
  nnoremap <buffer><silent> <Plug>(fern-action-open:system) :<C-u>call <SID>call('open_system')<CR>

  if !a:disable_default_mappings
    nmap <buffer><nowait> x <Plug>(fern-action-open:system)
  endif
endfunction

function! s:call(name, ...) abort
  return call(
        \ "fern#internal#mapping#call",
        \ [funcref(printf('s:map_%s', a:name))] + a:000,
        \)
endfunction

function! s:map_open_system(helper) abort
  let node = a:helper.get_cursor_node()
  let Done = a:helper.process_node(node)
  return fern#scheme#file#shutil#open(node._path, a:helper.fern.source.token)
        \.then({ -> fern#message#info(printf('%s has opened', node._path)) })
        \.finally({ -> Done() })
endfunction
