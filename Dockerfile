FROM ubuntu:24.04

# Installing SNORT dependencies
RUN apt update
RUN apt install snort -y

# Installing LAB dependencies
RUN apt install net-tools inetutils-ping nano tcpdump vsftpd ssh vim psmisc git psmisc nmap netcat-openbsd -y

# Copying hackathon evaluation script
#ADD ./hackathon-tools /root
#RUN chmod +x ./hackathon-tools/attack/* ./hackathon-tools/evaluation/*

# Testing installation
RUN snort -V

# Services start
WORKDIR /root
ENTRYPOINT \
          service ssh start && \
          service vsftpd start && \
          git clone https://github.com/evilsh3ll/Snort_Hackathon && \
          chmod +x ./Snort_Hackathon/hackathon-tools/attack/* && \
          chmod +x ./Snort_Hackathon/hackathon-tools/evaluation/* && \
          /bin/bash