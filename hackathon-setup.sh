#! /bin/bash

default=$(tput sgr0)
green=$(tput setaf 2)
red=$(tput setaf 1)
orange=$(tput setaf 3)

uninstall_lab_podman (){
    echo "TODO..."
    exit 0
}

uninstall_lab_docker (){
    echo "TODO..."
    exit 0
}

install_podman (){
  osversion=$(cat /etc/os-release 2>/dev/null | grep "^NAME" | cut -d '"' -f 2)
  release=$(bc -l <<< `cat /etc/os-release 2>/dev/null | grep "^VERSION_ID" | cut -d '"' -f 2`)
  # ubuntu/xbuntu check
  if [[ ${osversion,,} == *"ubuntu"* ]]
  then
        if [[ $(echo "${release} < 20.10" | bc -l) ]]
        then
              sudo apt-get update
              sudo apt-get -y install podman
        else
              echo "${red}Incompatible OS Version (Detected version: ${release}. Must be >= 20.10)${normal}"
              exit -1
        fi
  else
        echo "${red}Incompatible OS${normal}"
        exit -1
  fi

  # TODO: fedora, debian, centos
}

test_podman (){
  
  podman run hello-world
  if [[ $? -ne 0 ]]
  then
        echo "${red}Docker is not working correctly${normal}"
        exit -1
  fi
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
  if [[ $1 == "podman" ]]
  then
      mv ./Dockerfile ./Containerfile 2>/dev/null
      podman build -t hackathon:latest .
      if [[ $? -ne 0 ]]
      then
            echo "${red}Error encountered while building hackathon image${normal}"
            exit -1
      fi
      echo "${green}Access your LAb environment with: sudo podman run --privileged -it hackathon:latest${normal}"
  elif [[ $1 == "docker" ]]
  then
      mv ./Containerflie ./Dockerfile 2>/dev/null
      sudo docker build -t hackathon:latest .
      if [[ $? -ne 0 ]]
      then
            echo "${red}Error encountered while building hackathon image${normal}"
            exit -1
      fi
      echo "${green}Access your LAb environment with: sudo docker run -it hackathon:latest${normal}"
  fi
}

install_lab_podman (){
  echo "${green}Environment setup${default}"

  echo "${orange}Installing podman${default}"
  install_podman
  echo "${green}Podman installed correctly${default}"

  echo "${orange}Testing Podman${default}"
  test_podman
  echo "${green}Podman is working correctly${default}"

  echo "${orange}Building hackathon image${default}"
  build_hackathon_image "podman"
  echo "${green}Hackathon image ready${default}"

  echo "${green}Environment ready${default}"
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

if [[ $# -ne 2 ]]
then
      echo "${orange}Usage: ./hackathon-setup <podman/docker> <install/uninstall>${default}"
      exit -1
fi

if [[ $1 == "podman" ]]
then
      if [[ $2 == "install" ]]
      then
          install_lab_podman
      elif [[ $2 == "uninstall" ]]
      then
          uninstall_lab_podman
      else
          echo "${orange}[Please select install or uninstall] Usage: ./hackathon-setup podman <install/uninstall>${default}"
          exit -1
      fi
elif [[ $1 == "docker" ]]
then
      if [[ $2 == "install" ]]
      then
          install_lab_docker
      elif [[ $2 == "uninstall" ]]
      then
          uninstall_lab_docker
      else
          echo "${orange}[Please select install or uninstall] Usage: ./hackathon-setup docker <install/uninstall>${default}"
          exit -1
      fi
else
      echo "${orange}[Please select podman or docker] Usage: ./hackathon-setup <podman/docker> <install/uninstall>${default}"
      exit -1 
fi