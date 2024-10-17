FROM ubuntu:24.04

# Installing SNORT dependencies
RUN apt update
RUN apt install snort -y

# Installing LAB dependencies
RUN apt install net-tools inetutils-ping nano tcpdump vsftpd ssh vim psmisc git psmisc nmap netcat-openbsd -y

# Copying hackathon evaluation script
#ADD ./attack-script.sh /root
#RUN chmod +x ./attack-script.sh ./hackathon-evaluation

# Testing installation
RUN snort -V

# Services start
WORKDIR /root
ENTRYPOINT \
          service ssh start && \
          service vsftpd start && \
          git clone https://github.com/evilsh3ll/Snort_Hackathon \
          chmod +x ./Snort_Hackathon/attack/* \
          chmod +x ./Snort_Hackathon/evaluation/* \
          /bin/bash