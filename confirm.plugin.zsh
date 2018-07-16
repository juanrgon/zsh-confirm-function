typeset -gAH CONFIRM_COMMANDS

confirm () {
    local _command
    _command=$(echo $1 | awk '{$1=$1};1')
    CONFIRM_COMMANDS[$_command]=$2
}

custom-accept-line () {
    local _command
    local _trimmed_buffer
    _trimmed_buffer=$(echo $BUFFER | awk '{$1=$1};1')
    for _command message in ${(kv)CONFIRM_COMMANDS}; do
        _trimmed_command=$(echo $_command | awk '{$1=$1};1')
        if [[ "$_trimmed_buffer" =~ "$_trimmed_command" ]]; then
            extra_message=$CONFIRM_COMMANDS[$_trimmed_buffer]
            if [[ -n $extra_message ]]; then
                print -P "\n%B%F{yellow}$extra_message%f%b"
            fi
            print -P "%B%F{yellow}Are you sure want to do this?%f%b [y/N]"
            if read -q; then
                BUFFER=$_trimmed_buffer
            else
                BUFFER=''
            fi
            break
        fi
    done
    zle .accept-line
}
zle -N accept-line custom-accept-line
