let s:Config = vital#fern#import('Config')
let s:Promise = vital#fern#import('Async.Promise')

function! fern#internal#mapping#call(fn, ...) abort
  try
    call s:Promise.resolve(call('fern#helper#call', [a:fn] + a:000))
          \.catch({ e -> fern#message#error(e) })
  catch
    call fern#message#error(v:exception)
  endtry
endfunction

function! fern#internal#mapping#init(scheme) abort
  let disable_default_mappings = g:fern_disable_default_mappings
  for name in g:fern#internal#mapping#enabled_mapping_presets
    call fern#mapping#{name}#init(disable_default_mappings)
  endfor
  call fern#internal#scheme#call(a:scheme, 'mapping#init', disable_default_mappings)
endfunction

call s:Config.config(expand('<sfile>:p'), {
      \ 'enabled_mapping_presets': [
      \   'tree',
      \   'node',
      \   'open',
      \   'mark',
      \   'filter',
      \   'drawer',
      \ ],
      \})
