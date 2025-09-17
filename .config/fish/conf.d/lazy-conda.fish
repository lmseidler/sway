# directory where conda lives
set -g __conda_prefix /opt/miniforge

# commands that should wake conda up
set -g __lazy_conda_cmds conda

# -------------------------------------------------
function __load_conda
    # ask conda for the fish initialisation code
    set -l __hook ( $__conda_prefix/bin/conda shell.fish hook | source )
    if test $status -eq 0
        eval $__hook
    else if test -f "$__conda_prefix/etc/profile.d/conda.fish"
        source "$__conda_prefix/etc/profile.d/conda.fish"
    else
        set -gx PATH "$__conda_prefix/bin" $PATH
    end
    functions --erase __load_conda
end

# thin wrappers ------------------------------------------------------------
for c in $__lazy_conda_cmds
    eval "
        function $c
            functions --erase $c    # drop wrapper
            __load_conda            # bring conda in
            $c \$argv               # re-run original command
        end
    "
end

functions --erase fish_right_prompt
