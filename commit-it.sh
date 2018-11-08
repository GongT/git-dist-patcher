#!/bin/bash

set -e

function die() {
    echo -ne "\e[38;5;9m" >&2
    echo -ne "$*" >&2
    echo -e "\e[0m" >&2
    exit 1
}

version=$(cat application/package.json | grep -E '^\s*"version":'  | sed -nE 's/^.*:\s*"(.+)".+/\1/p')
patch=$(cat application/package.json | grep -E '^\s*"patchVersion":'  | sed -nE 's/^.*:\s*(.+).+/\1/p')

[ -n "${version}" ] || die "version not set in package.json"
[ -n "${patch}" ] || die "patchVersion not set in package.json"

[ ! -e application ] && mkdir application

cd application
if [ ! -e .git ]; then
    git init .
fi
git add .
git commit -m "Version: ${version} | Patch: ${patch}"
git status

echo "Complete!"
