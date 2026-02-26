# 🛠️ Scripts Utilitaires

Ce dossier rassemble divers scripts d'automatisation et outils en ligne de commande (CLI) créés pour faciliter et accélérer le développement, le déploiement et la gestion du projet.

---

## 📋 Sommaire des Scripts

- [docker-build-tag-push.sh](#1-docker-build-tag-pushsh) : Automatise la construction et la publication d'images Docker.
- *(D'autres scripts seront ajoutés ici...)*

---

## 1. `docker-build-tag-push.sh`

Ce script Bash permet d'automatiser le processus de construction (build), de marquage (tag) et de publication (push) d'une image Docker vers un registre (par exemple, Docker Hub ou un registre privé). Il intègre également un suivi détaillé du temps d'exécution pour chaque étape.

### 📋 Prérequis

- **Docker** doit être installé et en cours d'exécution.
- Vous devez être **connecté** à votre registre Docker (via `docker login`).
- Le script doit avoir les permissions d'exécution :
  ```bash
  chmod +x docker-build-tag-push.sh
  ```

### 🛠️ Utilisation

```bash
./docker-build-tag-push.sh --name <nom_image> --version <version> [OPTIONS]
```

#### Options disponibles

| Option | Raccourci | Description | Requis |
| :--- | :--- | :--- | :--- |
| `--name` | `-n` | Nom de l'image Docker à construire. | **Oui** |
| `--version` | `-v` | Tag de la version à publier (ex: `v1.0.0`). | **Oui** |
| `--namespace`| `--ns` | Espace de noms du registre. (Défaut : `mobisoft2024`) | Non |
| `--arg` | | Argument de build (`--build-arg`) au format `Clé=Valeur`. | Non |
| `--no-cache` | | Désactive l'utilisation du cache Docker lors du build. | Non |
| `--help` | `-h` | Affiche l'aide complète. | Non |

#### 💡 Exemples

**Déploiement standard :**
```bash
./docker-build-tag-push.sh -n mon-application -v v1.0.0
```
*(Génère et pousse : `mobisoft2024/mon-application:v1.0.0`)*

**Déploiement avec cache désactivé et arguments personnalisés :**
```bash
./docker-build-tag-push.sh -n api -v v2.0.0 --ns mon-organisation --arg ENV=prod --no-cache
```

---

## ➕ Ajouter un nouveau script

Pour chaque nouveau script ajouté à ce dossier, merci de :
1. Lui donner un nom clair (*ex: `db-backup.sh`*).
2. Le rendre exécutable (`chmod +x nom-du-script.sh`).
3. Venir documenter son rôle, ses prérequis et son utilisation en ajoutant une nouvelle section dans ce fichier `README.md`.
