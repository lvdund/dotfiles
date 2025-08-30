function fish_prompt
    set_color green
    echo -n (whoami)"@"(hostname) ""
    set_color blue
    echo -n (pwd) 
    set_color normal
    echo -n " > "
end
