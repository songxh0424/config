
# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
# export PATH

# Added by Canopy installer on 2016-01-16
# VIRTUAL_ENV_DISABLE_PROMPT can be set to '' to make the bash prompt show that Canopy is active, otherwise 1
# alias activate_canopy="source '/Users/Carl/Library/Enthought/Canopy_64bit/User/bin/activate'"
# VIRTUAL_ENV_DISABLE_PROMPT=1 source '/Users/Carl/Library/Enthought/Canopy_64bit/User/bin/activate'

# added by Anaconda3 4.2.0 installer
export PATH="/Users/Carl/anaconda/bin:$PATH"

# added for sqlplus to fucking work
export ORACLE_HOME=/Applications/oracle/product/instantclient_64/12.1
export PATH=$ORACLE_HOME/bin:$PATH
export DYLD_LIBRARY_PATH=$ORACLE_HOME/lib

# vimr
export PATH="$HOME/.vim/bin:$PATH"

export PATH="$HOME/bin:$PATH"

# avoid perl warnings
export LC_CTYPE=en_US.UTF-8
export LC_ALL=C
