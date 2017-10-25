DEFAULT_RZSH_HOME="$HOME/.config/rzsh"
if [[ -z $RZSH_HOME ]]; then
    export RZSH_HOME=$DEFAULT_RZSH_HOME
fi

source $RZSH_HOME/global_settings.zsh

# Load in all of our configs
for config ($RZSH_HOME/configs/*.zsh); do
    source $config
done
