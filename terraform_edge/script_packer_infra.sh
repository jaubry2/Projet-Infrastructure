#!/usr/bin/env bash
set -euo pipefail
set -x


# URLs des artefacts à télécharger
JDK_URL="https://hagimont.freeboxos.fr/hagimont/software/jdk-8u202-linux-x64.tar.gz"
HADOOP_URL="https://hagimont.freeboxos.fr/hagimont/software/hadoop-2.7.1.tar.gz"
SPARK_URL="https://hagimont.freeboxos.fr/hagimont/software/spark-2.4.3-bin-hadoop2.7.tgz"


# Dossier cible et groupe
DEST_DIR="/home/front"
GROUP="admin_edge_front"


# Création du groupe et du dossier
sudo groupadd -f -r "${GROUP}" || true
sudo mkdir -p "${DEST_DIR}"
sudo chown root:root "${DEST_DIR}"
sudo chgrp "${GROUP}" "${DEST_DIR}"
sudo chmod 2775 "${DEST_DIR}"


# Mise à jour système et dépendances
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends ca-certificates curl tar gzip


# Téléchargement et extraction
cd "${DEST_DIR}"

sudo curl -fL --retry 5 --retry-delay 2 -o jdk-8u202-linux-x64.tar.gz "$JDK_URL"
sudo curl -fL --retry 5 --retry-delay 2 -o hadoop-2.7.1.tar.gz "$HADOOP_URL"
sudo curl -fL --retry 5 --retry-delay 2 -o spark-2.4.3-bin-hadoop2.7.tgz "$SPARK_URL"

sudo tar -xzf jdk-8u202-linux-x64.tar.gz -o jdk1.8.0_202
sudo tar -xzf hadoop-2.7.1.tar.gz -o hadoop-2.7.1
sudo tar -xzf spark-2.4.3-bin-hadoop2.7.tgz -o spark-2.4.3-bin-hadoop2.7

sudo rm jdk-8u202-linux-x64.tar.gz
sudo rm hadoop-2.7.1.tar.gz
sudo rm spark-2.4.3-bin-hadoop2.7.tgz


# Corriger le groupe sur les dossiers et fichiers existants (post-extract)
sudo chgrp -R "${GROUP}" "${DEST_DIR}/hadoop-2.7.1" "${DEST_DIR}/jdk1.8.0_202" "${DEST_DIR}/spark-2.4.3-bin-hadoop2.7"


# Assurer setgid sur tous les dossiers extraits (pour le futur)
sudo find "${DEST_DIR}/hadoop-2.7.1" "${DEST_DIR}/jdk1.8.0_202" "${DEST_DIR}/spark-2.4.3-bin-hadoop2.7" -type d -exec chmod 2775 {} +


echo "OK : téléchargé et extrait dans ${DEST_DIR}"

