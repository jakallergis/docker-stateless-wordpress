#!/bin/bash
set -euo pipefail

# Default params
SECRETS_DIRECTORY="${PWD}"

while [[ $# -gt 0 ]];do case $1 in
    -d | --secrets-dir)
    echo "passed -d or --secrets-dir argument"
    SECRETS_DIRECTORY=$2
    shift
    shift
    ;;
    --default)
    echo "reached default"
    shift
    ;;
esac; done

generate_secrets_for_dir() {
    echo "Searching for passwords to generate in $1 directory".
    pushd $1
    for file in *; do
        [ -e "$file" ] || continue;

        filename="${file##*/}"

        if [ -d "$file" ];then
            generate_secrets_for_dir "$file"

        elif ! [ -s "$file" ] ;then
            echo "Generating password for $filename..."
            echo "$(pwgen -sAB 16 1)" > "$file"

        else
            echo "$filename is not empty. Ignoring..."
        fi
    done
    popd
}

generate_secrets_for_dir "$SECRETS_DIRECTORY"