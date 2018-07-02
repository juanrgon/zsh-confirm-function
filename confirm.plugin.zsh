export CONFIRM_COMMAND_LIST=()

confirm () {
    local command=$*
    not_found=true
    for command_in_list in $CONFIRM_COMMAND_LIST
        do
            if [[ $command_in_list == $command ]]; then
                not_found=false
            fi
        done
    if [[ $not_found ]]; then
        CONFIRM_COMMAND_LIST+=$command
    fi
}

_custom_accept_line () {
    local command
    function join_by { local IFS="$1"; shift; echo "$*"; }
    spaceless_buffer=$(join_by ' ' ${=BUFFER})
    for command in $CONFIRM_COMMAND_LIST
        do
            if [[ "$spaceless_buffer" =~ "$command"  ]]; then
                print -P "\n%B%F{yellow}Are you sure want to do this?%f%b [y/N] \c"
                if read -q; then
                    BUFFER=$spaceless_buffer
                else
                    zle -I
                    BUFFER=''
                fi
                break
            fi
        done
    zle .accept-line
}
zle -N accept-line _custom_accept_line
