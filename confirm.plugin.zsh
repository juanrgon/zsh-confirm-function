export CONFIRM_COMMAND_LIST=()

confirm () {
    _confirm () {
        local response
        print -P "%B%F{yellow}Are you sure want to do this%f%b? [y/N] \c"
        read -r response
        case "$response" in
            [yY][eE][sS]|[yY])
                true
                ;;
            *)
                false
                ;;
        esac
    }

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


    _custom_accept_line () {
        local command
        function join_by { local IFS="$1"; shift; echo "$*"; }
        spaceless_buffer=$(join_by ' ' ${=BUFFER})
        for command in $CONFIRM_COMMAND_LIST
            do
                if [[ "$spaceless_buffer" = *"$command" ]]; then
                    BUFFER="_confirm && $command"
                    break
                fi
            done
        zle .accept-line
    }
    zle -N accept-line _custom_accept_line
}
