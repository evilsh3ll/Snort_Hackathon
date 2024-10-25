# HACKATHON

### SVOLGIMENTO DELLA COMPETIZIONE
Per superare un livello è necessario:
1. Entrare nel container docker `sudo docker run -it hackathon:latest`
2. Sniffare il traffico nell'interfaccia loopback (lo) per scoprire gli attacchi in corso (usa `tcpdump` con il parametro `-Xn`)
3. Scrivere le regole Snort per l'intercettazione degli attacchi ([Snort Rules DOCS](http://manual-snort-org.s3-website-us-east-1.amazonaws.com/node27.html))
4. Avviare Snort in modalità `-A full` in modo che vengano generati i log completi (sare il parametro `-k none` per bypassare gli errori di checksum dei pacchetti in loopback)
5. Eseguire la valutazione del livello e ottenere la password per accedere al livello successivo

### COMANDI UTILI
**Avviare un livello**: `/root/Snort_Hackathon/hackathon-tools/attack/level1`

**Valutare il superamento di un livello**: `/root/Snort_Hackathon/hackathon-tools/evaluation/evaluate_level1`

**Stoppare un livello prima del termine**: `killall bash sleep`

**Avviare Snort in modalità log full:** `snort -q -l /var/log/snort -i lo -A full -c /etc/snort/snort.conf -d -k none`

### SETUP
  1. Controlla repository e raggiungibilità repository
  2. Avviare **hackathon-setup.sh**
### DOCKERFILE
  1. Fissa la versione di ubuntu 24.04.1
  2. Installazione di Snort e dipendenze
  3. Clone della repo contenente livelli e valutazioni

