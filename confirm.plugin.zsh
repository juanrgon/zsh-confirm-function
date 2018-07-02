export CONFIRM_COMMAND_LIST=()

confirm () {
    _confirm () {
        local respone
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

    _custom_accept_line () {
        local command
        for command in $CONFIRM_COMMAND_LIST
            do
                if [[ "$BUFFER" = *"$command" ]]; then
                    BUFFER="_confirm && $command"
                fi
            done
        zle .accept-line
    }
    zle -N accept-line _custom_accept_line

    local command=$*
    found=false
    for command_in_list in $CONFIRM_COMMAND_LIST
        do
            if [[ $command_in_list == $command ]]; then
                found=true
            fi
        done
    if [[ $found ]]; then
        CONFIRM_COMMAND_LIST+=command
    fi
}
