# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$ORACLE_HOME/bin:$PATH

# vimr
export PATH="$HOME/.vim/bin:$PATH"

export PATH="$HOME/bin:$PATH"

# added by Anaconda3 4.2.0 installer
export PATH="/Users/Carl/anaconda/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=/Users/Carl/.oh-my-zsh


# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
# export PATH

# Added by Canopy installer on 2016-01-16
# VIRTUAL_ENV_DISABLE_PROMPT can be set to '' to make the bash prompt show that Canopy is active, otherwise 1
# alias activate_canopy="source '/Users/Carl/Library/Enthought/Canopy_64bit/User/bin/activate'"
# VIRTUAL_ENV_DISABLE_PROMPT=1 source '/Users/Carl/Library/Enthought/Canopy_64bit/User/bin/activate'


# added for sqlplus to fucking work
export ORACLE_HOME=/Applications/oracle/product/instantclient_64/12.1
export DYLD_LIBRARY_PATH=$ORACLE_HOME/lib

# avoid perl warnings
LC_CTYPE=en_US.UTF-8
LANG=en_US.UTF-8
LC_ALL=C


# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="agnoster"
# ZSH_THEME="powerlevel9k/powerlevel9k"
ZSH_THEME="pygmalion"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
# Awesome-Terminal-Fonts
#source ~/.fonts/*.sh
#
# syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# powerlevel9k settings
# #POWERLEVEL9K_MODE='awesome-patched'
# POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status battery time)
# 
# POWERLEVEL9K_OS_ICON_BACKGROUND="white"
# POWERLEVEL9K_OS_ICON_FOREGROUND="blue"
# POWERLEVEL9K_DIR_HOME_FOREGROUND="white"
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="white"
# POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white"
# # POWERLEVEL9K_STATUS_OK_BACKGROUND="yellow"
# # POWERLEVEL9K_STATUS_ERROR_BACKGROUND="yellow"
# POWERLEVEL9K_BATTERY_LOW_BACKGROUND="blue"
# POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND="blue"
# POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND="blue"
# POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND="blue"
# POWERLEVEL9K_BATTERY_LOW_FOREGROUND="white"
# POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND="white"
# POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND="white"
# POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND="white"
# POWERLEVEL9K_BATTERY_LOW_VISUAL_IDENTIFIER_COLOR="red"
# POWERLEVEL9K_BATTERY_CHARGING_VISUAL_IDENTIFIER_COLOR="yellow"
# POWERLEVEL9K_BATTERY_CHARGED_VISUAL_IDENTIFIER_COLOR="green"
# POWERLEVEL9K_BATTERY_DISCONNECTED_VISUAL_IDENTIFIER_COLOR="white"
# POWERLEVEL9K_TIME_BACKGROUND="green"
# POWERLEVEL9K_TIME_FOREGROUND="white"
# # POWERLEVEL9K_VCS_CLEAN_FOREGROUND='125'
# # POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='125'
# # POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='125'
# POWERLEVEL9K_VCS_CLEAN_FOREGROUND='white'
# POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='white'
# POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='white'
# POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='yellow'
# POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
# POWERLEVEL9K_STATUS_OK_BACKGROUND="white"
# POWERLEVEL9K_STATUS_OK_FOREGROUND="green"
