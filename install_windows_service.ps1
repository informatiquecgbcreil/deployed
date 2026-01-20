$ErrorActionPreference = "Stop"

param(
    [string]$ServiceName = "ERP-CGB",
    [string]$AppDir = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [string]$PythonExe = "python",
    [string]$Host = "0.0.0.0",
    [int]$Port = 8000,
    [int]$Threads = 12,
    [switch]$OpenFirewall
)

Write-Host "== Installation service Windows ==" -ForegroundColor Cyan
Write-Host "ServiceName : $ServiceName"
Write-Host "AppDir      : $AppDir"
Write-Host "PythonExe   : $PythonExe"
Write-Host "Host        : $Host"
Write-Host "Port        : $Port"
Write-Host "Threads     : $Threads"

# -----------------------------------------------------------------------------
# SECRET_KEY (obligatoire)
# -----------------------------------------------------------------------------
if (-not $env:SECRET_KEY -or $env:SECRET_KEY.Trim().Length -lt 32) {
    Write-Host "SECRET_KEY manquante ou trop courte. Generation d'une cle persistante..." -ForegroundColor Yellow
    Add-Type -AssemblyName System.Web
    $generated = [System.Web.Security.Membership]::GeneratePassword(64, 10)
    [Environment]::SetEnvironmentVariable("SECRET_KEY", $generated, "Machine")
    $env:SECRET_KEY = $generated
    Write-Host "SECRET_KEY definie au niveau Machine." -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# Variables d'environnement de l'app
# -----------------------------------------------------------------------------
[Environment]::SetEnvironmentVariable("ERP_HOST", $Host, "Machine")
[Environment]::SetEnvironmentVariable("ERP_PORT", "$Port", "Machine")
[Environment]::SetEnvironmentVariable("ERP_THREADS", "$Threads", "Machine")

# -----------------------------------------------------------------------------
# Création du service Windows
# -----------------------------------------------------------------------------
$servicePath = Join-Path $AppDir "run_waitress.py"
if (-not (Test-Path $servicePath)) {
    throw "run_waitress.py introuvable dans $AppDir"
}

$binPath = "`"$PythonExe`" `"$servicePath`""
Write-Host "BinPath : $binPath"

sc.exe create $ServiceName binPath= $binPath start= auto | Out-Null
sc.exe description $ServiceName "ERP CGB (Waitress)" | Out-Null

if ($OpenFirewall) {
    Write-Host "Ouverture du port $Port dans le firewall..." -ForegroundColor Yellow
    New-NetFirewallRule -DisplayName "ERP CGB ($Port)" -Direction Inbound -Action Allow -Protocol TCP -LocalPort $Port | Out-Null
}

Write-Host "Service installe. Pour demarrer :" -ForegroundColor Green
Write-Host "  sc.exe start $ServiceName"
