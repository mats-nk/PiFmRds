#!/bin/bash

# URL de la radio en ligne
RADIO_URL="http://icecast.radiofrance.fr/fipelectro-hifi.aac"

# Fréquence de transmission (en MHz, ex: 100.0 pour 100.0 MHz)
FREQUENCY=100.0

# Chemin absolu vers PiFmRds
PIFMRDS_PATH="/home/rom/dab/PiFmRds/src/pi_fm_rds"

# Code RDS - Nom de la station, texte RDS, et code PI
STATION_NAME="MyRadio"
RDS_TEXT="Bienvenue sur MyRadio!"
PI_CODE="0x1234"

# Couleur marron en gras pour les messages d'annonce
BROWN="\e[33;1m"
# Couleur rouge pour les informations
RED="\e[31m"
# Couleur verte pour les messages
GREEN="\e[32m"
# Réinitialiser les couleurs
RESET="\e[0m"

# PID des processus
PIFMRDS_PID=""
SOX_PID=""

# Fonction pour démarrer la diffusion et la transmission
stream_and_transmit() {
    echo -e "${GREEN}Démarrage de la diffusion de la radio et transmission sur FM...${RESET}"
    
    # Diffusion de la radio en utilisant sox et transmission via PiFmRds avec une priorité réduite
    sox -t mp3 $RADIO_URL -t wav - | sudo nice -n 10 $PIFMRDS_PATH -freq $FREQUENCY -audio - -ps "$STATION_NAME" -rt "$RDS_TEXT" -pi "$PI_CODE" &
    SOX_PID=$!
    PIFMRDS_PID=$(pgrep -f "$PIFMRDS_PATH")
    
    echo -e "${BROWN}Transmission en cours sur la fréquence ${RED}${FREQUENCY} MHz${RESET}"
    echo -e "${BROWN}Nom de la station (PS) : ${RED}${STATION_NAME}${RESET}"
    echo -e "${BROWN}Texte RDS (RT) : ${RED}${RDS_TEXT}${RESET}"
    echo -e "${BROWN}Code PI : ${RED}${PI_CODE}${RESET}"
    echo -e "${GREEN}La transmission est en cours. Appuyez sur la touche 'x' pour arrêter la transmission.${RESET}"
}

# Fonction pour arrêter la transmission proprement
stop_transmission() {
    echo "Arrêt de la transmission..."
    if [ -n "$PIFMRDS_PID" ]; then
        sudo kill $PIFMRDS_PID
        echo "PiFmRds arrêté."
    fi
    if [ -n "$SOX_PID" ]; then
        kill $SOX_PID
        echo "Sox arrêté."
    fi
}

# Boucle principale
while true; do
    # Démarrer la transmission
    stream_and_transmit
    
    # Attendre que l'utilisateur appuie sur une touche
    while : ; do
        read -n 1 key
        if [[ $key = "x" ]]; then
            stop_transmission
            break
        elif [[ $key = "t" ]]; then
            stop_transmission
            break
        fi
    done
    
    if [[ $key = "x" ]]; then
        echo -e "${GREEN}Transmission arrêtée. Appuyez sur 't' pour relancer ou 'q' pour quitter.${RESET}"
        while : ; do
            read -n 1 key
            if [[ $key = "t" ]]; then
                break
            elif [[ $key = "q" ]]; then
                exit 0
            fi
        done
    fi
done
