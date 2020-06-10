#!/bin/sh

set -e

cd "$(dirname "$0")"

URL_BASE="https://net.tsinghua.edu.cn"
URL_LOGIN="$URL_BASE/do_login.php"
URL_INFO="$URL_BASE/rad_user_info.php"
CURL="curl -s -m 5"
AUTH="$(cat config-auth)"

do_login() {
    $CURL -s -X POST -d "action=login&ac_id=1&$AUTH" "$URL_LOGIN"
    echo
}

do_logout() {
    $CURL -s -X POST -d "action=logout" "$URL_LOGIN"
    echo
}

do_info() {
    dat="$($CURL "$URL_INFO")"
    if [ "$dat" == "" ]; then
        echo offline
    else
        echo online
    fi
}

usage() {
    echo "Usage: $0 login|logout|info" >&2
    exit 1
}

[ $# -lt 1 ] && usage

case "$1" in
    login)
        do_login
        ;;
    logout)
        do_logout
        ;;
    info)
        do_info
        ;;
    *)
        usage
        ;;
esac
