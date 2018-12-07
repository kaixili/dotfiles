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
