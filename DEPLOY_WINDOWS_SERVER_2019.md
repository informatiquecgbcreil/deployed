# Déploiement clé en main (Windows Server 2019)

Ce guide fournit une procédure complète pour exécuter l'application en service Windows.

## Pré-requis

- Python installé et accessible via `python` (ou utilisez le chemin complet).
- Dépendances installées : `pip install -r requirements.txt`
- Droits administrateur (PowerShell en admin).

## 1) Installation du service

Dans un PowerShell **en tant qu'administrateur**, depuis le dossier du projet :

```powershell
.\install_windows_service.ps1 -ServiceName "ERP-CGB" -AppDir "C:\Chemin\Vers\Projet" -PythonExe "C:\Python311\python.exe" -Host "0.0.0.0" -Port 8000 -Threads 12 -OpenFirewall
```

Cette commande :
- crée une `SECRET_KEY` persistante si elle n'existe pas,
- configure `ERP_HOST`, `ERP_PORT`, `ERP_THREADS`,
- installe le service Windows,
- ouvre le port du firewall si demandé.

## 2) Démarrer / arrêter le service

```powershell
sc.exe start ERP-CGB
sc.exe stop ERP-CGB
```

## 3) Mise à jour de l'app

1. Arrêter le service.
2. Mettre à jour le code.
3. Relancer le service.

```powershell
sc.exe stop ERP-CGB
sc.exe start ERP-CGB
```

## 4) Variables optionnelles

Si besoin, définissez ces variables machine via PowerShell :

```powershell
[Environment]::SetEnvironmentVariable("DATABASE_URL", "postgresql://user:pass@host/db", "Machine")
[Environment]::SetEnvironmentVariable("ERP_PUBLIC_BASE_URL", "http://serveur:8000", "Machine")
```

## 5) Démarrage manuel (alternative)

```powershell
.\start_server.ps1
```
