#!/bin/bash

default=$(tput sgr0)
green=$(tput setaf 2)
red=$(tput setaf 1)
orange=$(tput setaf 3)
cyan=$(tput setaf 6)
my_ip="127.0.0.1"

attacco_3 (){
	echo -e "${green}Benvenuto nel LIVELLO 3 esploratore della rete.\nUn attaccante è entrato nella tua rete e \
sta cercando di rubare i file della tua macchina. Sniffa la rete per capire quali attacchi sono in corso, poi configura \
Snort per rilevarli tutti.${default}

Comandi utili:${orange}
- TERMINA IL LIVELLO: ${cyan}killall bash sleep${orange}
- AVVIA LIVELLO: ${cyan}./root/Snort_Hackathon/hackathon-tools/level3${orange}
- CHECK DEL LIVELLO: ${cyan}./root/Snort_Hackathon/hackathon-tools/evaluate_level3${default}

Consigli:${orange}
 - Ricorda che tutti gli attacchi avvengono sull'interfaccia loopback (parametro ${cyan}'-i lo'${orange})
 - Ricorda di usare il parametro ${cyan}-A full'${orange} per generare i log finali prima della valutazione del livello \
 (il resto del tempo puoi usare ${cyan}'-A console'${orange}
 - Ricorda di usare il parametro ${cyan}'-k none'${orange} per bypassare gli errori di checksum dei pacchetti in loopback${default}
 
Buona difesa!"
	frasi=(
		"Si chiude una porta, si apre un servizio"
		"Esfiltro dati sileniosamente"
		"FTP File Theft Protocol"
		"Winzoz Winzoz Winzoz"
		"LinuxDay Roma 2024"
		"GNU pluuus LINUX"
	)
	# RUMORE
	(	
	 while true; do
		# generatore di rumore
		frase_random=$(shuf -n 1 -e "${frasi[@]}")
	 	echo "$frase_random" | nc -u -N "$my_ip" 80 > /dev/null 2>&1
		sleep 10
	 done
	) &
	
	# RUMORE
	(
	 while true; do
		# ping
	 	wget -q ftp://user:pass@"$my_ip" > /dev/null 2>&1
		sleep 3
	 done
	) &
	
}

# If the user is root
if [ "$(id -u)" -ne 0 ]; then
	sudo -v	
fi

# Level 1 check
PASSWORD="Sn0rtIsN0t@Fir3walL"
echo "Level3 Password:"
read -s INPUT_PASSWORD

# Controlla se la password è errata
if [ "$INPUT_PASSWORD" != "$PASSWORD" ]; then
    echo "Password per il livello 3 errata. Esco.."
    exit 1
fi

attacco_3



