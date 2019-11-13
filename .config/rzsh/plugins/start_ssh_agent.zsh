###
# Based off of ssh launch script from http://mah.everybody.org/docs/ssh
###

RZSH_SSH_ENV="$HOME/.ssh/environment"

function start_new_ssh_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${RZSH_SSH_ENV}"
    echo "Succeeded..."
    chmod 600 "${RZSH_SSH_ENV}"
    . "${RZSH_SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${RZSH_SSH_ENV}" ]; then
    . "${RZSH_SSH_ENV}" > /dev/null
    ps -ef | grep "${SSH_AGENT_PID}" | grep "ssh-agent$" > /dev/null || {
        start_new_ssh_agent;
    }
else
    echo
    start_new_ssh_agent;
fi
