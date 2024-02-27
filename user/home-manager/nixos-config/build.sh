#!/usr/bin/env bash

if [ $1 == "shell" ]; then
    CMD="nix-shell"
else
    CMD="nix-build"
fi

${CMD} --keep-failed --expr "with import <nixpkgs> {}; callPackage ./package.nix {}"
