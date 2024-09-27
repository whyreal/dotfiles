function pwgen 
    #command pwgen -y -r'(){}[]<>/\\|"~\':;`?!$^#,.iIlL0oO' $argv[1]
    command pwgen -r'iIlL0oO' $argv[1]
end
