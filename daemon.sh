echo "Lancement des daemons Hadoop et Spark sur les machines..."
gcloud compute ssh master-node \
    --zone=europe-west1-b \
    --quiet \
    --command="source /home/newsletters_box149_gmail_com/.bashrc && bash -l /home/newsletters_box149_gmail_com/wordcount/scale-subject/start.sh"
echo "Fin du lancement des daemons Hadoop et Spark sur les machines..."