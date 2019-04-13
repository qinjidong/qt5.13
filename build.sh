#!/bin/bash

#all platforms
PlatformArray=(
  pclinux
)

#list platform
function ListPlatform {
  echo -e "\033[36m[sticker] Please enter the number or name of the platform you want to build. \033[0m"
  for((i=0;i<${#PlatformArray[@]};i++))
  do
    echo -e "\033[36m[sticker] $i:${PlatformArray[$i]}\033[0m"
  done
}

#read platform
function ReadPlatform {
  read platform
  if [[ "${platform}" -ge "0" && "${platform}" -lt "${#PlatformArray[@]}" ]]
  then
    export build_platform=${PlatformArray[${platform}]}
  else
    export build_platform=${platform}
  fi
}

#platform only
function PlatformOnly {
  for((i=0;i<${#PlatformArray[@]};i++))
  do
    if [ "${build_platform}" == ${PlatformArray[$i]} ]
    then
      echo -e "\033[36m[sticker] target ${PlatformArray[${platform}]} \033[0m"
      return
    fi
  done
  echo -e "\033[31;5m[sticker] Error: unrecognized platform \033[0m"
  exit 1
}

#export
function Export {
  export ROOT_DIR=${PWD}
  export SRC_DIR=${ROOT_DIR}/src
  export TARGET_DIR=${ROOT_DIR}/target/${build_platform}
  export OUT_DIR=${ROOT_DIR}/out_${build_platform}
  export INSTALL_DIR=${ROOT_DIR}/install_${build_platform}
}

#build qt
function BuildQT {
  echo -e "\033[36m[sticker] build qt... \033[0m"
  mkdir ${OUT_DIR}
  cd ${OUT_DIR}
  source ${TARGET_DIR}/build.sh
  cd ${ROOT_DIR}
}

#delete generate files
function DeleteGenerateFile {
  echo -e "\033[36m[sticker] DeleteGenerateFile... \033[0m"
}

#check result
function CheckResult {
  if [ $? != 0 ]
  then
    echo -e "\033[31;5m[sticker] build failed \033[0m"
    DeleteGenerateFile
    exit 1
  fi
}

function Start {
  ListPlatform
  ReadPlatform
  Export
  PlatformOnly
  BuildQT
  CheckResult
  DeleteGenerateFile
}

Start

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "\033[32;5m[sticker] Congratulations! Build successful at ${OUT_DIR} \033[0m "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
