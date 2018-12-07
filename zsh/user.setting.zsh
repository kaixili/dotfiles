# alias {{{
alias open='kde-open5 '
alias vi='vim '
alias gp='grep --color=auto '
alias get='/usr/bin/axel -n 5 -a '
alias yd='ydcv '
alias h='glances'
alias aria2rpc='aria2c --conf-path=/etc/aria2.conf -D '
alias rm='rm -i '
alias mv='mv -i '
alias cp='cp -i '
alias cd..='cd .. '
alias wifi='nmcli dev wifi '
# }}}
#
export TERM='xterm-256color'

function proxy_on() {
#    export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
    sudo systemctl start delegate
    export http_proxy="127.0.0.1:8000"
    export https_proxy=$http_proxy
    echo "Proxy environment variable set."

}

function proxy_off(){
    unset http_proxy
    unset https_proxy
    sudo systemctl stop delegate
    echo -e "Proxy environment variable removed."
}
