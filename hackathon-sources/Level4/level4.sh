#!/bin/bash

default=$(tput sgr0)
green=$(tput setaf 2)
red=$(tput setaf 1)
orange=$(tput setaf 3)
cyan=$(tput setaf 6)
my_ip="127.0.0.1"

attacco_4 (){
	echo -e "${green}Benvenuto nel LIVELLO 4 esploratore della rete.\nUn attaccante è entrato nella tua macchina e \
ha installato un Trojan RAT (Remote Administration Tool).Sniffa la rete per capire quali attacchi sono in corso, poi configura \
Snort per rilevarli tutti.${default}

Comandi utili:${orange}
- TERMINA IL LIVELLO: ${cyan}killall bash sleep${orange}
- AVVIA LIVELLO: ${cyan}/root/Snort_Hackathon/hackathon-tools/attack/level4${orange}
- CHECK DEL LIVELLO: ${cyan}/root/Snort_Hackathon/hackathon-tools/evaluate/evaluate_level4${default}

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
                # generatore di ping
                ping -c 1 "$my_ip" > /dev/null 2>&1
		sleep 3
         done
        ) &


	# RUMORE
	(
	 while true; do
		# ping
		scapy > /dev/null 2>&1 << EOF
payload1="shellbackdoor"
payload2="exploit"
payload3="anormaluseragent"
payload4="method"
payload5="maliciousdomain"
junk="\x41"*23
nop="\x90"*34
alternate='\x42'*11
fullpayload= junk + payload1 + nop + payload2 + 4*"C" + payload2 + payload4 + 20*"D" +payload3 + nop + payload5
send(IP(dst="$my_ip")/TCP(dport=1337)/fullpayload)
EOF

		sleep 15
	 done
	) &
	
}

# If the user is root
if [ "$(id -u)" -ne 0 ]; then
	sudo -v	
fi

# Level 1 check
PASSWORD="P@ck3TSh1ffeR"
echo "Level4 Password:"
read -s INPUT_PASSWORD

# Controlla se la password è errata
if [ "$INPUT_PASSWORD" != "$PASSWORD" ]; then
    echo "Password per il livello 4 errata. Esco.."
    exit 1
fi

attacco_4
