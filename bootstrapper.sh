#!/bin/bash
# 2017 Rob Siwek

# constants
required_bins=("brew" "node" "mysql" "carthage")
username=$(whoami)

# text styles
bold=$(tput bold)
boldcyan=${bold}$(tput setaf 6)
normal=$(tput sgr0)
red=${normal}$(tput setaf 1)
green=${normal}$(tput setaf 2)

# unicode emojis
coffee_emoji="\xe2\x98\x95 "
shamrock_emoji="\xe2\x98\x98 "
skull_emoji="\xe2\x98\xa0 "
bye_emoji="\xf0\x9f\x91\x8b "

# vars
missing_bins=()

function print_header_info {
  printf "\n ${boldcyan}Hey ${username}!\n Quickly checking your environment for required binaries...${coffee_emoji}\n\n${normal}"
}

function print_bye {
  printf "\nYou're all set! Bye ${bye_emoji}\n\n"
}

function print_success {
  printf "${shamrock_emoji}${bold} $1 ${green}installed\n${normal}"
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
  printf "\n${bold}Your local ip as the app's baseUrl is:\n"
  eval "ifconfig en0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*'"
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
  eval "export PATH='/usr/local/bin:/usr/local/sbin:~/bin:$PATH'"
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
print_header_info
check_env
print_local_ip
ask_to_install_missing_bins
