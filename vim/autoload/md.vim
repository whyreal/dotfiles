function md#createUnOrderedList()
lua <<EOF
    local Range = require"wr.Range"
    Range:newFromVisual():mdCreateUnOrderedList()
EOF
endfunction

function md#createOrderedList()
lua <<EOF
    local Range = require"wr.Range"
    Range:newFromVisual():mdCreateOrderedList()
EOF
endfunction

function md#deleteList()
lua <<EOF
    local Range = require"wr.Range"
    Range:newFromVisual():mdDeleteList()
EOF
endfunction
