# 语言
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PGDATA=~/pgdata
export LD_LIBRARY_PATH=/usr/local/Cellar/openssl@1.1/1.1.1t/lib:$LD_LIBRARY_PATH

export HOMEBREW_NO_AUTO_UPDATE=1

export PATH=/Users/leiwenyong/Library/Android/sdk/platform-tools:$PATH
export PATH=/Users/leiwenyong/Library/Android/sdk/tools:$PATH
export PATH=$(brew --prefix)/opt/llvm/bin:$PATH


# abp
export PATH="$PATH:/Users/leiwenyong/.dotnet/tools"

# android sdk location
# /Users/leiwenyong/Library/Android/sdk
alias als="cd /Users/leiwenyong/Library/Android/sdk/tools && emulator -list-avds"
alias iphone="cd /Users/leiwenyong/Library/Android/sdk/tools && emulator -avd Iphone"
alias ipad="cd /Users/leiwenyong/Library/Android/sdk/tools && emulator -avd Ipad"


# mysql配置
alias my="mysql -uroot -p123456";
alias mit="mitmproxy --set console_mouse=false --set block_global=false -s /Users/leiwenyong/Desktop/code/mitm.py"
alias s="neofetch"

# arthas配置
alias scr="scrcpy  -m 720 -b 1m"
# vpn
alias vpn="sudo openconnect --protocol=anyconnect sslvpn.sankuai.com"


alias mvnt="mvn -Dmaven.test.skip=true"

# java debug命令
# export _JAVA_LAUNCHER_DEBUG=1

# JDK配置
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home"
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_341.jdk/Contents/Home"
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/graalvm-ce-java17-22.3.1/Contents/Home"
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home"
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home"
export PATH="${JAVA_HOME}/bin:$PATH:/usr/local/pgsql/bin"

# google源码管理工具
# export PATH=$PATH:/Users/leiwenyong/Desktop/google/depot_tools

# 代理配置
alias scl='export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890 && networksetup -setsocksfirewallproxy "Wi-Fi" 127.0.0.1 7890 && networksetup -setwebproxy "Wi-Fi" 127.0.0.1 7890  && networksetup -setsecurewebproxy "Wi-Fi" 127.0.0.1 7890 && echo clash'
alias sch='export https_proxy=http://127.0.0.1:8888 http_proxy=http://127.0.0.1:8888 all_proxy=socks5://127.0.0.1:8888 && networksetup -setsocksfirewallproxy "Wi-Fi" 127.0.0.1 8888 && networksetup -setwebproxy "Wi-Fi" 127.0.0.1 8888  && networksetup -setsecurewebproxy "Wi-Fi" 127.0.0.1 8888 && echo charles'
alias u='unset https_proxy http_proxy all_proxy && networksetup -setsecurewebproxystate Wi-Fi off && networksetup -setwebproxystate Wi-Fi off && networksetup -setsocksfirewallproxystate Wi-Fi off && echo ok'

# python@10.11
# export PATH=/usr/local/Cellar/python@3.11/3.11.3/bin:$PATH

alias jp="ssh -i ~/.ssh/id_rsa_jumper wb_leiwenyong@jumper.sankuai.com"


# export NVM_DIR="$HOME/.nvm"
# source $(brew --prefix nvm)/nvm.sh
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(type -w __init_nvm)" = '__init_nvm: function' ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn' 'gulp' 'grunt' 'webpack')
  function __init_nvm() {
    for i in "${__node_commands[@]}"; do unalias $i; done
    . "$NVM_DIR"/nvm.sh
    unset __node_commands
    unset -f __init_nvm
  }
  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi


___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi