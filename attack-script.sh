#!/bin/bash

my_ip="127.0.0.1"

kill_jobs (){
	# per killare i jobs alla fine di un esercizio
	kill -9 $(jobs -p) > /dev/null 2>&1	
	kill -9 $(jobs -p) > /dev/null 2>&1	
	kill -9 $(jobs -p) > /dev/null 2>&1
}

attacco_1 (){
	echo -e "Benvenuto nel LIVELLO 1 esploratore della rete. Un attaccante sta cercando di ottenere \
  delle informazioni sulla tua macchina tramite delle scansioni. Usa Snort per rilevare le scansioni \
  (puoi aiutarti con strumenti di analisi del traffico come tcpdump.\n\
  Buona caccia!"
	
	# RUMORE
	(	
	 while true; do
		# generatore di rumore
	 	echo "I'm banana" | nc -u -N "$my_ip" 80 > /dev/null 2>&1
		sleep 2
	 done
	) &
	
	# NMAP XMAS SCAN
	(	
	 while true; do
		# generatore di rumore
	 	sudo nmap -sX "$my_ip"  > /dev/null 2>&1
		sleep 2
	 done
	) &

		
	# NMAP SYN SCAN
	(	
	 while true; do
		# generatore di rumore
	 	sudo nmap -sS "$my_ip"  > /dev/null 2>&1
		sleep 2
	 done
	) &

	# NMAP ACK SCAN
	(	
	 while true; do
		# generatore di rumore
	 	sudo nmap -sA "$my_ip"  > /dev/null 2>&1
		sleep 2
	 done
	) &
	
}

attack_menu (){
  # TODO...
}