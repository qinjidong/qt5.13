#!/bin/bash

CleanArray=(
  out_*
  install_*
)

function clean {
  for((i=0;i<${#CleanArray[@]};i++))
  do
    rm -rf ${CleanArray[$i]}
  done
}

clean

find -name "*.pyc" | xargs rm

echo -e "\033[32;5m[sticker] clean successful \033[0m "
