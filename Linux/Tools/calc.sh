#!/bin/sh

if [ -n "$1" ]; then
    answer=$(echo "$1" | qalc +u8 -color=never -terse | awk '!/^>/ && !/^$/ {gsub(/^[ \t]+|[ \t]+$/, "", $0); print}')
fi
while [[ $# -gt 0 && $1 != "--" ]]; do
    shift
done
[[ $1 == "--" ]] && shift

action=$(echo -e "Clear\nCopy to clipboard" | bemenu "$@" -p "= $answer")

case $action in
    "Clear") exec "$0" "$@" ;;
    "Copy to clipboard") echo -n "$answer" | wl-copy ;;
    "") ;;
    *) exec "$0" "$answer $action" "$@" ;;
esac
