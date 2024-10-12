# HACKATHON

## GITREPO

* Spiegazione di come installare e fare setup del laboratorio
* Script che (**hackathon-setup.sh**)
  1. Controlla repository e raggiungibilità repository
  2. Scarica ed installa docker
  3. Verifica il corretto funzionamento di docker
  4. Fa il setup del LAB usando il dockerfile

## DOCKERFILE

Logica del dockerfile:
  1. Fissata la versione di ubuntu 24.04.1
  2. Installazione di snort
  3. Copia dello script per condurre TEST e valutazione del lab
  4. Creazione di una regola scema + attacco e check di identificazione
  5. /bin/bash/

## SCRIPT VALUTAZIONE HACKATHON