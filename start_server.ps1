$ErrorActionPreference = "Stop"

# -----------------------------------------------------------------------------
# Clé secrète (obligatoire en production)
# -----------------------------------------------------------------------------
if (-not $env:SECRET_KEY -or $env:SECRET_KEY.Trim().Length -lt 32) {
    Write-Host "SECRET_KEY manquante ou trop courte. Generation d'une cle temporaire..." -ForegroundColor Yellow
    Add-Type -AssemblyName System.Web
    $generated = [System.Web.Security.Membership]::GeneratePassword(64, 10)
    [Environment]::SetEnvironmentVariable("SECRET_KEY", $generated, "Machine")
    $env:SECRET_KEY = $generated
    Write-Host "SECRET_KEY definie au niveau Machine." -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# Lancement
# -----------------------------------------------------------------------------
Write-Host "Demarrage de l'application via Waitress..." -ForegroundColor Cyan
python run_waitress.py
