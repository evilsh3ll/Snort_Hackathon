#!/bin/bash

default=$(tput sgr0)
green=$(tput setaf 2)
red=$(tput setaf 1)
orange=$(tput setaf 3)
cyan=$(tput setaf 6)
my_ip="127.0.0.1"

attacco_1 (){
	echo -e "${green}Benvenuto nel LIVELLO 1 esploratore della rete.\nUn attaccante sta cercando di ottenere \
delle informazioni sulla tua macchina tramite delle scansioni nmap. Sniffa la rete per capire quali attacchi \
sono in corso, poi configura Snort per rilevarli tutti.${default}

Comandi utili:${orange}
- KILLA IL LIVELLO: ${cyan}killall bash sleep${orange}
- AVVIA LIVELLO: ${cyan}/root/Snort_Hackathon/hackathon-tools/attack/level1${orange}
- CHECK DEL LIVELLO: ${cyan}/root/Snort_Hackathon/hackathon-tools/evaluation/evaluate_level1${default}

Consigli:${orange}
 - Ricorda che tutti gli attacchi avvengono sull'interfaccia loopback (parametro ${cyan}'-i lo'${orange})
 - Ricorda di usare il parametro ${cyan}-A full'${orange} per generare i log finali prima della valutazione del livello \
 (il resto del tempo puoi usare ${cyan}'-A console'${orange}
 - Ricorda di usare il parametro ${cyan}'-k none'${orange} per bypassare gli errori di checksum dei pacchetti in loopback${default}
 
Buona difesa!"

	frasi=(
		"Il codice è la mia arma"
		"Connettersi è solo l'inizio"
		"Non esistono segreti, solo dati"
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
	 	ping -c 1 "$my_ip" > /dev/null 2>&1
		sleep 15
	 done
	) &
	
	# NMAP XMAS SCAN
	(	
	 while true; do
		# generatore di rumore
	 	nmap -sX "$my_ip"  > /dev/null 2>&1
		sleep 3
	 done
	) &

		
	# NMAP SYN SCAN
	(	
	 while true; do
		# generatore di rumore
	 	nmap -sS "$my_ip"  > /dev/null 2>&1
		sleep 4
	 done
	) &

	# NMAP ACK SCAN
	(	
	 while true; do
		# generatore di rumore
	 	nmap -sA "$my_ip"  > /dev/null 2>&1
		sleep 3
	 done
	) &
	
}

# If the user is root
if [ "$(id -u)" -ne 0 ]; then
	sudo -v	
fi

attacco_1



