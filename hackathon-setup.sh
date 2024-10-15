#! /bin/bash

default=$(tput sgr0)
green=$(tput setaf 2)
red=$(tput setaf 1)
orange=$(tput setaf 3)

remove_docker_repos (){
  sudo rm /etc/apt/sources.list.d/docker.list
}


remove_sudoers (){
  sudo rm /etc/sudoers.d/sudoers_hackathon
  if [[ $? -ne 0 ]]
  then
        echo "${red}Errore: sudoers file /etc/sudoers.d/sudoers_hackathon NON rimosso${default}"
        exit -1
  fi
}


remove_hackathon_image (){
  sudo docker image rm hackathon:latest -f
  if [[ $? -ne 0 ]]
  then
        echo "${red}Errore nella rimozione dell'immagine per l'hackathon${default}"
        exit -1
  fi
}


remove_docker (){
  sudo apt-get remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  if [[ $? -ne 0 ]]
  then
        echo "${red}Errore nella rimozione di Docker${default}"
        exit -1
  fi
}


remove_lab (){
  echo "${green}Avvio rimozione completa ambiente hackathon${default}"

  echo "${orange}Rimozione repository apt di docker${default}"
  remove_docker_repos
  echo "${green}Reposotory docker rimossi${default}"
  echo "${orange}Rimozione dell'immagine docker per hackathon${default}"
  remove_hackathon_image
  echo "${green}Immagine hackathon rimossa${default}"
  echo "${orange}Disinstallazione Docker${default}"
  remove_docker
  echo "${green}Docker disinstallato${default}"
  echo "${orange}Rimozione sudoers per docker${default}"
  remove_sudoers
  echo "${green}Rimosso sudoers${default}"

  echo "${green}Ambiente hackathon rimosso${default}"
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
        echo "${red}Fallimento nell'aggiunta della chiave GPG di Docker${default}"
        exit -1
  fi

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  if [[ $? -ne 0 ]]
  then
        echo "${red}Fallimento nell'aggiunta dei repository docker${default}"
        exit -1
  fi
  sudo apt-get update -y
  if [[ $? -ne 0 ]]
  then
        echo "${red}Fallimento nell'aggiunta dei repository docker${default}"
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
        echo "${red}Fallimento durante l'installazione di docker${default}"
        exit -1
  fi
}


add_sudoers (){
    echo "${USER} ALL=(root) NOPASSWD: /usr/bin/docker run -it hackathon\:latest" > /tmp/sudoers_hackathon && sudo mv /tmp/sudoers_hackathon /etc/sudoers.d/sudoers_hackathon && chmod 440 /etc/sudoers.d/sudoers_hackathon && chown root:root /etc/sudoers.d/sudoers_hackathon
    if [[ $? -ne 0 ]]
    then
          echo "${red}Errore: sudoers file /etc/sudoers.d/sudoers_hackathon NON creato${default}"
          exit -1
    fi
}


test_docker (){

  sudo docker run hello-world
  if [[ $? -ne 0 ]]
  then
        echo "${red}Docker non funziona correttamente${default}"
        exit -1
  fi
}


build_hackathon_image (){

  sudo docker build -t hackathon:latest .
  if [[ $? -ne 0 ]]
  then
        echo "${red}Errore nella build dell'immagine per l'hackathon${default}"
        exit -1
  fi

  echo "${green}Accedi al container per l'hackathon con: sudo docker run -it hackathon:latest${default}"
}


install_lab_docker (){

  echo "${green}Avvio configurazione ambiente${default}"
  echo "${orange}Rimozione dei pacchetti confluttuali docker....${default}"
  remove_conflicting_pkgs
  echo "${green}Pacchetti confluttuali docker rimossi${default}"
  echo "${orange}Aggiunta repository apt di docker${default}"
  setup_docker_repos
  echo "${green}Reposotory docker aggiunti${default}"
  echo "${orange}Installazione Docker${default}"
  install_docker
  echo "${green}Docker installato${default}"
  echo "${orange}Verifica funzionamento Docker${default}"
  test_docker
  echo "${green}Docker funziona${default}"
  echo "${orange}Build dell'immagine docker per hackathon${default}"
  build_hackathon_image
  echo "${green}Build completa${default}"
  echo "${orange}Aggiunta sudoers per docker${default}"
  add_sudoers
  echo "${green}Creato sudoers${default}"
  echo "${green}Ambiente pronto${default}"
}


confirm (){

    if [[ $# -eq 1 ]]
    then
        echo "${red}$1${default}"
    fi

    read -p "${orange}Sei sicuro di voler proseguire ?${default} (y|n)" choice
    if [[ $choice == "y" ]]
    then
        echo "${green}Conferma ottenuto, proseguo${default}"
        return 0
    fi
    echo "${orange}Conferma NON ottenuta, esco${default}"
    return -1
}


menu_remove (){
  while true
  do
        echo "---------------------RIMOZIONE------------------------------"
        echo "${green}Rimozione ambiente per hackathon Par-Tec${default}"
        echo "${orange}[Solo per PC del LAB Tor Vergata o PC ocnfigurati con setep 1)] (esegue gli step dal 2 al 4)${default}"
        echo "${orance}1)${default} Rimuovi ambiente hackathon${orange}${default}"
        echo ""
        echo "${orange}[Configurazione su PC personale]${default}"
        echo "${orance}2)${default} Rimuovi repository Docker"
        echo "${orance}3)${default} Rimuovi immagine hackathon"
        echo "${orance}4)${default} Rimuovi Docker"
        echo "------------------------------------------------------------"
        echo "${orance}Q)${default} Esci"
        echo ""
        read -p "${orange}Selezione: ${default}" choice

        case $choice in
        "1" )
          confirm "Se avevi docker gia' installato prima di questo hackathon, questa opzione ELIMINARA' COMPLETAMENTE le tue configurazioni"
          if [[ $? -eq 0 ]]
          then
              echo "${orange}Rimozione dell'ambiente docker${default}"
              remove_lab
              echo "${green}Rimozione completata${default}"
          fi
        ;;
        "2" )
          echo "${orange}Rimozione repository apt di docker${default}"
          remove_docker_repos
          echo "${green}Reposotory docker rimossi${default}"
          ;;
        "3" )
          echo "${orange}Rimozione dell'immagine docker per hackathon${default}"
          remove_hackathon_image
          echo "${green}Immagine hackathon rimossa${default}"
          ;;
        "4" )
          echo "${orange}Disinstallazione Docker${default}"
          remove_docker
          echo "${green}Docker disinstallato${default}"
          ;;
        "Q" )
          echo "${green}Ciao !${default}"
          exit 0
          ;;
        * )
          echo "${orange}Selezione non disponibile${default}"  
          ;;
        esac
  done
}


menu_install (){
  while true
  do
        echo "---------------------INSTALLAZIONE---------------------------"
        echo "${green}Peparazione ambiente per hackathon Par-Tec${default}"
        echo "${orange}[Solo per PC del LAB Tor Vergata o PC senza docker] (esegue gli step dal 2 al 6)${default}"
        echo "${orance}1)${default} Configura ambiente completo ${orange}${default}"
        echo ""
        echo "${orange}[Configurazione su PC personale]${default}"
        echo "${orance}2)${default} Rimuovi eventuali pacchetti docker non compatibili"
        echo "${orance}3)${default} Aggiunta repository Docker"
        echo "${orance}4)${default} Installazione Docker"
        echo "${orance}5)${default} Verifica funzionamento Docker"
        echo "${orance}6)${default} Build immagine Docker per l'hackathon"
        echo "------------------------------------------------------------"
        echo "${orance}Q)${default} Esci"
        echo ""
        read -p "${orange}Selezione: ${default}" choice

        case $choice in
        "1" )
          confirm "Se hai docker gia' installato, questa opzione potrebbe sovrascrivere le tue configurazioni"
          if [[ $? -eq 0 ]]
          then
              echo "${orange}Rimozione dei pacchetti confluttuali docker....${default}"
              install_lab_docker
              echo "${green}Pacchetti confluttuali docker rimossi${default}"
          fi
        ;;
        "2" )
          confirm "Se hai docker gia' installato, questa opzione potrebbe eliminare pacchetti in uso"
          if [[ $? -eq 0 ]]
          then
              echo "${orange}Rimozione dei pacchetti confluttuali docker....${default}"
              remove_conflicting_pkgs
              echo "${green}Pacchetti confluttuali docker rimossi${default}"
          fi
          ;;
        "3" )
          echo "${orange}Aggiunta repository apt di docker${default}"
          setup_docker_repos
          echo "${green}Reposotory docker aggiunti${default}"
          ;;
        "4" )
          echo "${orange}Installazione Docker${default}"
          install_docker
          echo "${green}Docker installato${default}"
          ;;
        "5" )
          echo "${orange}Verifica funzionamento Docker${default}"
          test_docker
          echo "${green}Docker funziona${default}"
          ;;
        "6" )
          echo "${orange}Build dell'immagine docker per hackathon${default}"
          build_hackathon_image
          echo "${green}Build completa${default}"
          ;;
        "Q" )
          echo "${green}Ciao !${default}"
          exit 0
          ;;
        * )
          echo "${orange}Selezione non disponibile${default}"  
          ;;
        esac
  done
}


if [[ $# -ne 1 ]]
then
      echo "${orange}Uso: ./hackathon-setup install/remove${default}"
      exit -1
fi
if [[ $1 == "install" ]]
then
    menu_install
elif [[ $1 == "remove" ]]
then
    menu_remove
elif [[ $1 == "autoinstall" ]]
then
    install_lab_docker
elif [[ $1 == "autoremove" ]]
then
    remove_lab
else
    echo "${orange}[Seleziona 'install' o 'remove'] Usage: ./hackathon-setup <install/remove>${default}"
    exit -1
fi

# In lab lanciare con "sudo --preserve-env=USER /tmp/hackathon-setup.sh autoinstall"