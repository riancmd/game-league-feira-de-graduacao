#!/bin/sh
echo -ne '\033c\033]0;Feira de Grad\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Liga de Jogos.x86_64" "$@"
