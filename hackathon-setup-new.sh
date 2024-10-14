#! /bin/bash

default=$(tput sgr0)
green=$(tput setaf 2)
red=$(tput setaf 1)
orange=$(tput setaf 3)


uninstall_lab_docker (){
    echo "TODO..."
    exit 0
}

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

build_hackathon_image (){
  sudo docker build -t hackathon:latest .
  if [[ $? -ne 0 ]]
  then
        echo "${red}Error encountered while building hackathon image${normal}"
        exit -1
  fi
  echo "${green}Access your LAb environment with: sudo docker -it hackathon:latest${normal}"
}

install_lab_docker (){
  echo "${green}Environment setup${default}"

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

  echo "${orange}Building hackathon image${default}"
  build_hackathon_image "docker"
  echo "${green}Hackathon image ready${default}"

  echo "${green}Environment ready${default}"
}

if [[ $# -ne 1 ]]
then
      echo "${orange}Usage: ./hackathon-setup install/uninstall${default}"
      exit -1
fi

# TODO
# Switch Case Menu

if [[ $1 == "install" ]]
then
    install_lab_docker
elif [[ $2 == "uninstall" ]]
then
    uninstall_lab_docker
else
    echo "${orange}[Please select install or uninstall] Usage: ./hackathon-setup podman <install/uninstall>${default}"
    exit -1
fi