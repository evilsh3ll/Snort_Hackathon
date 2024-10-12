FROM ubuntu:24.04.1

# Installing SNORT dependencies
RUN apt get update
RUN apt get install snort -y

# Installing LAB dependencies
# TODO...

# Copying hackatlon evaluation script
# TODO...

# Testing installation
RUN snort -V