#! /usr/bin/env bash

GENERATION=$(readlink /nix/var/nix/profiles/system | grep -o "[0-9]*" | awk 'sub("[0-9]+","Gen:&")')
NIXOSVERSIONNUMB=$(nixos-version | awk -F '.' '{print$1"."$2}')
NIXOSVERSIONNAME=$(nixos-version | grep -o -P '(?<=(\()).*(?=\))')
#echo ${NIXOSVERSIONNAME}
NIXOSVERSION="${NIXOSVERSIONNUMB} ${NIXOSVERSIONNAME}"

echo "Ver: ${NIXOSVERSION} | ${GENERATION}"


