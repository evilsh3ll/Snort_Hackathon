FROM ubuntu:24.04

# Installing SNORT dependencies
RUN apt update
RUN apt install snort -y

# Installing LAB dependencies
RUN apt install net-tools inetutils-ping nano tcpdump vsftpd ssh vim psmisc git psmisc nmap netcat-openbsd -y

# Copying hackathon evaluation script
# TODO...

# Copying attack script
ADD ./attack-script.sh /root

# Testing installation
RUN snort -V

# Services start
ENTRYPOINT service ssh start && service vsftpd start && bash