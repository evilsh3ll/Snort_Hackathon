FROM ubuntu:24.04

# Installing SNORT dependencies
RUN apt update
RUN apt install snort -y

# Installing LAB dependencies
RUN apt install net-tools inetutils-ping nano tcpdump vsftpd ssh vim psmisc -y

# Copying hackathon evaluation script
# TODO...

# Testing installation
RUN snort -V