#!/bin/sh
printf '\033c\033]0;%s\a' Speed4Need
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Speed4Need.x86_64" "$@"
