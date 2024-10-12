#! /bin/bash

default=$(tput sgr0)
green=$(tput setaf 2)
red=$(tput setaf 1)
orange=$(tput setaf 3)

echo "${green}Environment setup${default}"

setup_docker_repos (){
  # Add Docker's official GPG key:
  sudo apt-get update -y
  sudo apt-get install ca-certificates curl -y
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  if [[ $? -ne 0 ]]
  then
        echo "${red}Failed to add Docker's official GPG key${normal}"
        exit -1
  fi

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  if [[ $? -ne 0 ]]
  then
        echo "${red}Failed to add Docker's repository sources${normal}"
        exit -1
  fi
  sudo apt-get update -y
  if [[ $? -ne 0 ]]
  then
        echo "${red}Failed to add Docker's repository sources${normal}"
        exit -1
  fi
}

remove_conflicting_pkgs (){
  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc:
  do
    sudo apt-get remove $pkg
  done
}

install_docker (){
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  if [[ $? -ne 0 ]]
  then
        echo "${red}Failed to install docker packages${normal}"
        exit -1
  fi
}

test_docker (){
  sudo docker run hello-world
  if [[ $? -ne 0 ]]
  then
        echo "${red}Docker is not working correctly${normal}"
        exit -1
  fi
}

echo "${orange}Removing Docker's conflicting packages...${default}"
remove_conflicting_pkgs
echo "${green}Removed Docker's conflicting packages${default}"

echo "${orange}Installing Docker's apt repository${default}"
setup_docker_repos
echo "${green}Docker's repository installed correctly${default}"

echo "${orange}Installing Docker${default}"
install_docker
echo "${green}Docker installed${default}"

echo "${orange}Testing Docker${default}"
test_docker
echo "${green}Docker is working correctly${default}"

echo "${green}Environment ready${default}"