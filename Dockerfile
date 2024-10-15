FROM ubuntu:24.04

# Installing SNORT dependencies
RUN apt update
RUN apt install snort -y

# Installing LAB dependencies
# TODO...

# Copying hackatlon evaluation script
# TODO...

# Testing installation
RUN snort -V