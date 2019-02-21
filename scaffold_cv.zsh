#!/usr/bin/env zsh

function main {
    local lang="$1"
    local version="$2"
    local dir=cvs/$lang/$version
    local config=$dir/config.yml
    mkdir -p $dir
    sed -e "s/<lang>/$lang/" -e "s/<version>/$version/" cvs/templates/cv-template.yml > $dir/cv.yml
    echo "name: Robert Dober" > $config
    echo "lang: $lang" >> $config
    echo "version: \"$version\"" >> $config
}


function usage {
    echo "$1 <lang> <version>"
}

if test -z "$2"; then
    usage $0
    exit
fi

case $1 in
    -h|--help) usage $0;;
    *)         main $@;;
esac
