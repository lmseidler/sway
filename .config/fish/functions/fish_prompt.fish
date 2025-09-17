function fish_prompt
    # Line 1: Path, VCS, user/host, time
    set_color red --bold
    echo -n (prompt_pwd)
    set_color normal
    echo -n ' '
    set_color green
    echo -n (fish_vcs_prompt)
    set_color normal
    echo -n ' '
    set_color white
    echo -n '['(whoami)'@'(prompt_hostname)']'
    set_color normal
    echo -n ' ['
    set_color white
    echo -n (date +%T)
    set_color normal
    echo -n ']'
    if set -q CONDA_DEFAULT_ENV
        echo -n ' '(set_color yellow)"("$CONDA_DEFAULT_ENV")"
        set_color normal
    end

    # Line 2: Prompt character
    echo
    echo -n '> '
end
