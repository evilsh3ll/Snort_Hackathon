#!/bin/bash

default=$(tput sgr0)
green=$(tput setaf 2)
red=$(tput setaf 1)
orange=$(tput setaf 3)
cyan=$(tput setaf 6)
my_ip="127.0.0.1"

attacco_5 (){
	echo -e "${green}Benvenuto nel LIVELLO 5 esploratore della rete.\nUn attaccante è entrato nella tua rete e \
e sta lanciando degli attacchi sql injection e xss. Sniffa la rete per capire come gli attacchi sono effettuati, poi configura \
Snort per rilevarli tutti.${default}

Comandi utili:${orange}
- TERMINA IL LIVELLO: ${cyan}killall bash sleep${orange}
- AVVIA LIVELLO: ${cyan}/root/Snort_Hackathon/hackathon-tools/attack/level5${orange}
- CHECK DEL LIVELLO: ${cyan}/root/Snort_Hackathon/hackathon-tools/evaluate/evaluate_level5${default}

Consigli:${orange}
 - Ricorda che tutti gli attacchi avvengono sull'interfaccia loopback (parametro ${cyan}'-i lo'${orange})
 - Ricorda di usare il parametro ${cyan}-A full'${orange} per generare i log finali prima della valutazione del livello \
 (il resto del tempo puoi usare ${cyan}'-A console'${orange}
 - Ricorda di usare il parametro ${cyan}'-k none'${orange} per bypassare gli errori di checksum dei pacchetti in loopback${default}
 
Buona difesa!"
	frasi=(
		"Il codice è legge"
		"Sfida l'autorità"
		"Pensa in modo diverso"
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
	
	# PING
        (
         while true; do
                # SQLINJECTION
                curl -X GET --silent "http://localhost/login?username=admin%27%20OR%20%271%27%3D%271&password=pass" > /dev/null 2>&1
		#curl -X GET "http://localhost/login?username=admin%27%20OR%20%271%27%3D%271&password=pass"
		sleep 5
         done
        ) &


	(
         while true; do
                # XSS
                curl -X GET --silent "http://localhost/search?q=<script>alert('XSS')</script>" > /dev/null 2>&1
                #curl -X GET "http://localhost/search?q=<script>alert('XSS')</script>"
		sleep 8
         done
        ) &
	
}

# If the user is root
if [ "$(id -u)" -ne 0 ]; then
	sudo -v	
fi

# Level 1 check
PASSWORD="RATb4nD1t#S3cur1ty"
echo "Level5 Password:"
read -s INPUT_PASSWORD

# Controlla se la password è errata
if [ "$INPUT_PASSWORD" != "$PASSWORD" ]; then
    echo "Password per il livello 5 errata. Esco.."
    exit 1
fi

attacco_5
