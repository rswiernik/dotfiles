autoload -U colors && colors
autoload -U add-zsh-hook

DEFAULT_RZSH_HOME="$HOME/.config/rzsh"

if [[ -z $RZSH_HOME ]]; then
    export RZSH_HOME=$DEFAULT_RZSH_HOME
fi

# Make sure that global settings are always read in first
source $RZSH_HOME/global_settings.zsh

# Load in all of our configs
for config ($RZSH_HOME/configs/*.zsh); do
    source $config
done

# Pull in all the utilities that we provide through rzsh
source $RZSH_HOME/functions.zsh

# Pull in the theme!
source $(ls $RZSH_HOME/themes/$RZSH_THEME/*)
