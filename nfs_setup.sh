#!/bin/bash

set -e

mounts=("$@")

echo "#NFS Exports" > /etc/exports

for mnt in "${mounts[@]}"; do
  OLDIFS=$IFS; IFS=',';
  # Separate "tuple" arguments with positional notation
  set -o noglob
  set -- ${mnt};
  path=$1
  net=$2
  opts=(${@:3})
  set +o noglob

  # Put a comm after each options
  fullopts=()
  for op in "${opts[@]}"; do
    fullopts+=(${op})
    fullopts+=(",")
  done
  # remove spaces between options
  fullopts="$(printf "%s" "${fullopts[@]}")"

  src=$(echo $path | awk -F':' '{ print $1 }')
  mkdir -p $src
  echo "$src $net(${fullopts}no_subtree_check,no_root_squash,insecure)" >> /etc/exports

  IFS=$OLDIFS;
done

exec runsvdir /etc/sv
