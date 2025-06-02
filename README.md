# Docker-Health

# 🐳 Docker Health Check for Windows Server 2025

Ce script PowerShell est un outil de diagnostic complet conçu par **Ayi NEDJIMI Consultants** pour évaluer la santé et la configuration de Docker sur Windows Server 2025.

---

## Fonctionnalités

* **Vérification de l'OS** : S'assure que le système d'exploitation est bien Windows Server 2025.
* **Détection de Docker** : Vérifie la présence de Docker et récupère sa version.
* **État du service Docker** : Contrôle si le service Docker est actif et tente de le démarrer si nécessaire.
* **Docker Compose** : Détecte l'installation de Docker Compose.
* **Connectivité Docker Hub** : Teste la capacité à tirer des images depuis Docker Hub.
* **Test de conteneur** : Exécute un conteneur `hello-world` pour valider le fonctionnement de Docker.
* **Espace disque** : Vérifie l'espace disque disponible sur le lecteur système (C:).
* **Test réseau** : Valide la connectivité réseau vers le registre Docker.
* **Liste des conteneurs et images** : Affiche les conteneurs en cours d'exécution et les images Docker locales.
* **Rapport détaillé** : Génère un fichier `DockerHealthReport.txt` contenant toutes les informations de diagnostic.

---

## Utilisation

Pour exécuter le script, ouvrez une console PowerShell en tant qu'administrateur sur votre Windows Server 2025 et exécutez le fichier `.ps1`. Un rapport détaillé sera généré dans `C:\DockerHealthReport.txt`.

```powershell
.\DockerHealthCheck.ps1
