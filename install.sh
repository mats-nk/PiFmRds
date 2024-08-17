#!/bin/bash

# Vérifier si l'utilisateur a fourni un nom d'utilisateur
if [ -z "$1" ]; then
  echo "Usage: $0 <nom_utilisateur>"
  exit 1
fi

# Définir le répertoire d'installation
USER_HOME="/home/$1"
PIFMRDS_DIR="$USER_HOME/PiFmRds"

# Installer les dépendances
echo "Installation des dépendances..."
sudo apt-get update
sudo apt-get install -y sox libsox-fmt-mp3 libsndfile1-dev

# Cloner le dépôt PiFmRds
echo "Clonage du dépôt PiFmRds dans $PIFMRDS_DIR..."
git clone https://github.com/DABodr/PiFmRds.git "$PIFMRDS_DIR"

# Compiler PiFmRds
echo "Compilation de PiFmRds..."
cd "$PIFMRDS_DIR/src"
make clean
make

# Rendre le script run.sh exécutable
chmod +x "$PIFMRDS_DIR/run.sh"

# Indiquer que l'installation est terminée
echo "Installation de PiFmRds terminée dans $PIFMRDS_DIR."
echo "Vous pouvez exécuter PiFmRds avec une configuration prédéfinie en utilisant le fichier $PIFMRDS_DIR/run.sh"
