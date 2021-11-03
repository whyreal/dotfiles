function CocListOpenWith(coc_list_context, cmd)
  let list_name = a:coc_list_context["name"]
  let label_name = a:coc_list_context["targets"][0]["label"]
  call substitute(label_name, " ", "\\ ", "g")
  if list_name == "files"
	  call system(a:cmd . " '" . label_name . "'")
  endif
endfunction
function! OpenWithSystemApp(coc_list_context)
  call CocListOpenWith(a:coc_list_context, "open")
endfunction

function! OpenWithFinder(coc_list_context)
  call CocListOpenWith(a:coc_list_context, "open -R")
endfunction
