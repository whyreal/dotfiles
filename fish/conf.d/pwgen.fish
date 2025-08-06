function pwgen 
    #command pwgen -y -r'(){}[]<>/\\|"~\':;`?!$^#,.iIlL0oO' $argv[1]
    command pwgen -Bcny1 -r'iIlL0oO(){}[]<>@"\'`,.;:?!\\/|' 16 10
    # pwgen -r'iIlL0oO' $argv[1]

end
