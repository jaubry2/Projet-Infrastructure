# Intention initiale et retour critique

## Idée de départ

À l’origine, mon objectif était de concevoir une **architecture proche d’un environnement réel**, en séparant clairement les rôles et les responsabilités. 
L’idée de base reposait sur une **distinction stricte entre un nœud *edge* et un cluster Spark/HDFS** :

- le *edge* était considéré comme un **front-end**, chargé de l’ingestion des données et de la soumission des jobs,
- le cluster jouait le rôle de **backend**.

Cette approche reposait sur l’hypothèse selon laquelle le *edge* pouvait être conçu de manière **largement indépendante** du cluster, en dehors de la communication réseau.

## Choix d’architecture

L’idée initiale reposait sur la séparation logique du **cluster Spark/HDFS** et du **nœud edge**, via deux sous-réseaux distincts au sein d’un même VPC partagé. Chaque environnement devait disposer de son propre administrateur, avec des droits IAM adaptés (compute et réseau).

Cependant, en raison du fonctionnement des **héritages IAM sur GCP** — les VPC et subnets ne constituant pas des *scopes* valides pour l’attribution de rôles administrateur — cette approche n’était pas applicable directement. La conception a donc évolué vers une architecture plus complexe, reposant sur **deux projets GCP distincts**, chacun disposant de son propre VPC et subnet, interconnectés via du **VPC peering**.

## Limites identifiées

Avec le recul, cette hypothèse s’est révélée **incorrecte**.
Bien que le *edge* puisse être vu comme un point d’entrée, il reste **étroitement couplé à la configuration du cluster Spark et HDFS**, tant sur le plan logiciel qu’opérationnel.

En sous-estimant cette interdépendance — et en m’en rendant compte tardivement — j’ai fini par **complexifier inutilement l’architecture**, aboutissant à une solution fonctionnelle mais **disproportionnée** par rapport aux objectifs du projet.

## Conclusion

C’est pour cette raison que la version finale retenue est celle de mon collègue **Jules**, dont l’architecture correspond mieux aux attentes : **plus simple, plus cohérente et plus maintenable**.

Mon implémentation reste néanmoins exploitable et a surtout servi de **support d’apprentissage**, mettant en évidence l’importance de :
- bien comprendre les **logiciels** que l’on souhaite déployer,
- puis de **valider les hypothèses d’architecture** avant d’industrialiser une solution.
