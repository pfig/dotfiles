source /Users/pfig/Development/antigen/antigen.zsh
antigen-lib

antigen-bundles <<EOBUNDLES
brew
cpanm
django
encode64
git
git-flow
git-hubflow
git-remote-branch
github
gnu-utils
lein
mvn
npm
osx
perl
pip
python
redis-cli
rvm
sublime
svn
vagrant

sharat87/autoenv
zsh-users/zsh-syntax-highlighting
EOBUNDLES

antigen-theme sorin

antigen-apply

COMPLETION_WAITING_DOTS="true"
zstyle ':completion:*' rehash true

# Personal customisations

export EDITOR='subl -w'

# virtualenvwrapper
export WORKON_HOME=/Users/pfig/Development/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

# perlbrew
source ~/perl5/perlbrew/etc/bashrc

# java & friends
export JAVA_HOME=/Library/Java/Home
export GROOVY_HOME=/usr/local/Cellar/groovy/2.0.4/libexec

# Hadoop & friends
export HIVE_HOME=/Users/pfig/Applications/BigData/Hadoop/hive-0.8.1
export HADOOP_HOME=/Users/pfig/Applications/BigData/Hadoop/hadoop-1.0.4
PATH=${PATH}:${HADOOP_HOME}/bin:${HIVE_HOME}/bin

# aliases
if [ -r ~/.sh_aliases ]; then
    source ~/.sh_aliases
fi

PATH=/usr/local/bin:/usr/local/sbin:${PATH}

PATH=$PATH:$HOME/.rvm/bin

# Node
PATH=$PATH:/usr/local/share/npm/bin

export PATH
