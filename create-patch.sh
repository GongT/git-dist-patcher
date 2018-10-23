#!/bin/bash

set -e

function die() {
    echo -ne "\e[38;5;9m" >&2
    echo -ne "$*" >&2
    echo -e "\e[0m" >&2
    exit 1
}

echo "running git..."
pushd application &>/dev/null || die "no application dir"
git add . || die "git add failed in application dir"
git diff --name-only HEAD > ../changed.lst
popd &>/dev/null

ITEMS=$(cat changed.lst | wc -l)
echo "${ITEMS} items has changed"
if [ "${ITEMS}" -eq 0 ]; then
    echo "Nothing to do."
    exit 0
fi

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=linux;;
    Darwin*)    machine=mac;;
    CYGWIN*)    machine=windows;;
    MINGW*)     machine=windows;;
    *)
    die "Error: Unknown platform: ${unameOut}"
esac

version=$(cat application/package.json | grep -E '^\s*"version":'  | sed -nE 's/^.*:\s*"(.+)".+/\1/p')
patch=$(cat application/package.json | grep -E '^\s*"patchVersion":'  | sed -nE 's/^.*:\s*(.+).+/\1/p')

[ -n "${version}" ] || die "version not set in package.json"
[ -n "${patch}" ] || die "patchVersion not set in package.json"

zipFile="${version}_${patch}_${machine}.tar.gz"

echo "Saving file: ${zipFile}"

cd application
tar -cz \
    "--file=../${zipFile}" \
    "--files-from=../changed.lst" \
    --no-acls --no-selinux --no-xattrs --no-seek

echo "Complete!"
