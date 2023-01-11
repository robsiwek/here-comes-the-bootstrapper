#!/bin/bash
# 2017 Rob Siwek

# constants
required_bins=("brew" "docker" "yarn" "kubectl" "terraform" "awsume")
username=$(whoami)

# text styles
bold=$(tput bold)
boldcyan=${bold}$(tput setaf 6)
normal=$(tput sgr0)
red=${normal}$(tput setaf 1)
green=${normal}$(tput setaf 2)

# unicode emojis
coffee_emoji="\xe2\x98\x95 "
check_emoji="\xe2\x9c\x94 "
skull_emoji="\xe2\x98\xa0 "
bye_emoji="\xf0\x9f\x91\x8b "

# vars
missing_bins=()

# base64 encoded ascii banner
function print_banner {
  base64 -D <<<"CiAgIF9fX19fX18gICBfX19fX19fXyAgX19fX19fX18gIF9fX19fX19fICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAg4pWxICAgIOKVsSAg4pWy4pWy4pWxICAgICAgICDilbLilbEgICAg
ICAgIOKVsuKVsSAgICAgICAg4pWyICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKIOKVsSAgICAgICAg4pWx4pWxICAgICAgICAg4pWxICAgICAgICAg4pWxICAgICAgICAg4pWxICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAK4pWxICAgICAgICAg4pWxICAgICAgICBf4pWxICAgICAgICBf4pWxICAgICAgICBf4pWxICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCuKVsl9fX+KVsV9fX1/ilbHilbJfX19fX19fX+KVseKVsl9fX1/ilbFfX1/ilbHilbJfX19fX19fX+KVsSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAKICAgIF9fX19fX18gIF9fX19fX19fICBfX19fX19fXyAgX19fX19fX18gIF9fX19fX19fICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICDilbHilbEgICAgICAg4pWy4pWxICAg
ICAgICDilbLilbEgICAgICAgIOKVsuKVsSAgICAgICAg4pWy4pWxICAgICAgICDilbIgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiDilbHilbEgICAgICAgIOKVsSAgICAgICAgIOKVsSAgICAgICAgIOKVsSAg
ICAgICAgIOKVsSAgICAgICAgX+KVsSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAK4pWxICAgICAgIC0t4pWxICAgICAgICAg4pWxICAgICAgICAg4pWxICAgICAgICBf4pWxLSAgICAgICAg4pWxICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAK4pWyX19fX19fX1/ilbHilbJfX19fX19fX+KVseKVsl9f4pWxX1/ilbFfX+KVseKVsl9fX19fX19f4pWx4pWyX19fX19fX1/ilbEgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgX19fX19fX18gIF9fX19fX19fICBfX19fX19fXyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAKICDilbEgICAgICAgIOKVsuKVsSAgICDilbEgICDilbLilbEgICAgICAgIOKVsiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAog4pWxICAgICAgICBf4pWxICAgICAgICAg
4pWxICAgICAgICAg4pWxICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiDilbEgICAgICAg4pWx4pWxICAgICAgICAg4pWxICAgICAgICBf4pWxICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAog4pWyX19fX1/ilbHilbEg4pWyX19f4pWxX19fX+KVseKVsl9fX19fX19f4pWxICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgIF9fX19fX18gIF9fX19fX19fICBfX19fX19fXyAgX19fX19fX18gIF9fX19fX19fICBfX19fX19fXyAgX19fX19fX18gIF9fX19fX19fICBfX19fX19fXyAgX19fX19fX18gIF9fX19fX19fICBfX19f
X19fXyAKICDilbHilbEgICAgICDilbEg4pWxICAgICAgICDilbLilbEgICAgICAgIOKVsuKVsSAgICAgICAg4pWy4pWxICAgICAgICDilbLilbEgICAgICAgIOKVsuKVsSAgICAgICAg4pWy4pWxICAgICAgICDilbLilbEgICAgICAgIOKVsuKVsSAgICAgICAg4pWy4pWxICAgICAgICDilbLi
lbEgICAgICAgIOKVsgog4pWx4pWxICAgICAgIOKVsuKVsSAgICAgICAgIOKVsSAgICAgICAgIOKVsSAgICAgICAgX+KVsSAgICAgICAgX+KVsSAgICAgICAgX+KVsSAgICAgICAgIOKVsSAgICAgICAgIOKVsSAgICAgICAgIOKVsSAgICAgICAgIOKVsSAgICAgICAgIOKVsSAgICAgICAgIOKV
sQrilbEgICAgICAgICDilbEgICAgICAgICDilbEgICAgICAgICDilbHilbEgICAgICAg4pWx4pWxLSAgICAgICAg4pWx4pWxICAgICAgIOKVseKVsSAgICAgICAgX+KVsSAgICAgICAgIOKVsSAgICAgICBfX+KVsSAgICAgICBfX+KVsSAgICAgICAgX+KVsSAgICAgICAgX+KVsSAK4pWyX19f
X19fX1/ilbHilbJfX19fX19fX+KVseKVsl9fX19fX19f4pWxIOKVsl9fX19fX+KVsSDilbJfX19fX19fX+KVsSDilbJfX19fX1/ilbEg4pWyX19fX+KVsV9fX+KVseKVsl9fX+KVsV9fX1/ilbHilbJfX19fX1/ilbEgIOKVsl9fX19fX+KVsSAg4pWyX19fX19fX1/ilbHilbJfX19f4pWxX19f
4pWxICAK"
}

function print_header_info {
  printf "\n ${boldcyan}Hey ${username}!\n Quickly checking your local environment..${coffee_emoji}\n\n${normal}"
}

function print_bye {
  printf "\nYou're all set! Happy Coding ${bye_emoji}\n\n"
}

function print_success {
  printf "${check_emoji}${bold} $1 ${green}installed\n${normal}"
}

function print_error {
  printf "${skull_emoji}${bold} $1 ${red}not installed\n${normal}"
}

function check_env {
  for dependency in "${required_bins[@]}"
  do
    if type -p "$dependency" > /dev/null; then
      print_success ${dependency}
    else
      print_error ${dependency}
      missing_bins+=(${dependency})
    fi
  done
}

function print_local_ip {
  printf "\n${bold}Your local IP:\n${green}"
  eval "ifconfig en0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*'"
  printf "${normal}"
}

function print_local_java_version {
  printf "\n${bold}Your local Java version:\n${green}"
  eval "java --version"
  printf "${normal}"
}

function is_brew_installed {
  if type -p brew > /dev/null; then
      return 0
    else
      return 1
  fi
}

function install_dependency_via_brew {
  printf "\n${coffee_emoji}${bold} Installing $1...\n\n${normal}"
  eval "brew install $1"
}

function install_brew {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function install_bins {
  for dependency in "${missing_bins[@]}"
  do
    if is_brew_installed; then
      install_dependency_via_brew ${dependency}
    else
      install_brew
    fi
  done
}

function all_requirements_met {
  if [ ${#missing_bins[@]} -eq 0 ]; then
    return 0
  else
    return 1
  fi
}

function ask_to_install_missing_bins {
  if all_requirements_met; then
    print_bye
    exit
  fi
  while true; do
      printf "\n\n${boldcyan}"
      read -p "Do you want to install the missing bins? Press y to continue, n to cancel: ${normal}" yn
      case $yn in
          [Yy]*) install_bins; break;;
          [Nn]*) print_bye; exit;;
          *) echo "Please press y or n";;
      esac
  done
}

# setup steps
print_banner
print_header_info
check_env
print_local_ip
print_local_java_version
ask_to_install_missing_bins
