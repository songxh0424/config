# If you come from bash you might have to change your $PATH.

# Path to your oh-my-zsh installation.
export ZSH=/Users/shane/.oh-my-zsh

# avoid perl warnings
LC_CTYPE=en_US.UTF-8
LANG=en_US.UTF-8
LC_ALL=C

# add custom bash scripts to PATH
export PATH="/Users/shane/bin:$PATH"

# added by Anaconda3 5.0.1 installer
export PATH="/Users/shane/anaconda3/bin:$PATH"

# use anaconda r in rstudio
#export RSTUDIO_WHICH_R="/Users/shane/anaconda3/bin/R"
export RSTUDIO_WHICH_R="/usr/local/bin/R"
export RSTUDIO_PANDOC="/usr/local/Cellar/pandoc/2.0.2/bin/pandoc"
launchctl setenv RSTUDIO_WHICH_R $RSTUDIO_WHICH_R

# rJava package
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_151.jdk/Contents/Home/jre
export R_JAVA_LD_LIBRARY_PATH=${JAVA_HOME}/lib/that/server

# alias for julia
alias julia=/Applications/JuliaPro-0.6.1.1.app/Contents/Resources/julia/Contents/Resources/julia/bin/julia

# sqlplus
export ORACLE_HOME=/Applications/oracle/product/instantclient_64/12.2.0.1.0
export PATH=$ORACLE_HOME/bin:$PATH
export DYLD_LIBRARY_PATH=$ORACLE_HOME/lib


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
plugins=(
  git
  osx
)

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

# syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
