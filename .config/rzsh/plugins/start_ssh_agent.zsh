###
# Based off of ssh launch script from http://mah.everybody.org/docs/ssh
###

RZSH_SSH_ENV="$HOME/.ssh/environment"

function start_new_ssh_agent {
    echo
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${RZSH_SSH_ENV}"
    echo "Succeeded..."
    chmod 600 "${RZSH_SSH_ENV}"
    . "${RZSH_SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

function get_ssh_agent_status {
    echo $(ps -f -p "${SSH_AGENT_PID}" | grep "ssh-agent$")
}


# If we dont have any agent information, attempt to start one
if [[ -z get_ssh_agent_status ]]; then
    # Attempt to prime SSH env variables if we have previously set up the rzsh ssh env
    if [ -f "${RZSH_SSH_ENV}" ]; then
        . "${RZSH_SSH_ENV}" > /dev/null
    fi
    # If we still dont have a running agent, start one
    [[ -z get_ssh_agent_status ]] && start_new_ssh_agent
fi
