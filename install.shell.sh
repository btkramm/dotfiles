#!/bin/bash

for file in shell/*
do
  fullpath=$(realpath "$file")

  source="source $fullpath"

  if grep -q "$source" ~/.zshrc; then
    echo "$source is already installed."
  else
    read -r -p "Source $file? (Y/n): " response

    if [ -z "$response" ] || [ "$response" = "y" ]; then
      echo "$source" >> ~/.zshrc
    fi
  fi
done
