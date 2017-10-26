autoload -U colors && colors
autoload -U add-zsh-hook

DEFAULT_RZSH_HOME="$HOME/.config/rzsh"

if [[ -z $RZSH_HOME ]]; then
    export RZSH_HOME=$DEFAULT_RZSH_HOME
fi

source $RZSH_HOME/plugins/prompts.zsh
source $RZSH_HOME/global_settings.zsh

# Load in all of our configs
for config ($RZSH_HOME/configs/*.zsh); do
    source $config
done
