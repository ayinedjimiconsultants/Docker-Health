# Réalisé par Ayi NEDJIMI Consultants

$report = @()
$report += "=== Diagnostic Docker - Windows Server 2025 ==="
$report += "Date : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$report += ""

# 1. OS Check
$osVersion = (Get-CimInstance Win32_OperatingSystem).Caption
$report += "🖥️ OS détecté : $osVersion"
if ($osVersion -notlike "*Windows Server*2025*") {
    $report += "❌ Cet OS n'est pas officiellement reconnu comme Windows Server 2025."
} else {
    $report += "✅ OS compatible."
}

# 2. Docker installé ?
$dockerPath = Get-Command docker -ErrorAction SilentlyContinue
if ($dockerPath) {
    $dockerVersion = (docker version --format '{{.Server.Version}}' 2>$null)
    $report += "`n🐳 Docker détecté : $dockerVersion"
} else {
    $report += "`n❌ Docker n'est pas installé. Interruption du diagnostic."
    $report | Out-File "DockerHealthReport.txt" -Encoding utf8
    exit 1
}

# 3. Service Docker actif ?
$service = Get-Service -Name "docker" -ErrorAction SilentlyContinue
if ($service -and $service.Status -eq "Running") {
    $report += "✅ Service Docker est en cours d'exécution."
} else {
    $report += "❌ Service Docker non démarré ou absent."
    if ($service) {
        $report += "Tentative de démarrage du service..."
        Start-Service docker
        Start-Sleep -Seconds 3
        if ((Get-Service docker).Status -eq "Running") {
            $report += "➡️ Service démarré avec succès."
        } else {
            $report += "❌ Échec du démarrage automatique du service."
        }
    }
}

# 4. Docker Compose présent ?
$composeTest = & docker-compose version 2>$null
if ($composeTest) {
    $report += "`n🔧 Docker Compose est disponible."
} else {
    $report += "`n❌ Docker Compose non détecté."
}

# 5. Test pull Docker Hub
$report += "`n🌐 Test de connexion à Docker Hub..."
try {
    docker pull hello-world | Out-Null
    $report += "✅ Téléchargement de l'image 'hello-world' réussi."
} catch {
    $report += "❌ Échec du téléchargement de l'image 'hello-world'."
    $report += "🔎 Vérifiez la connectivité réseau et le proxy éventuel."
}

# 6. Test conteneur hello-world
$report += "`n🚀 Test de conteneur 'hello-world'..."
try {
    docker run --rm hello-world | Out-Null
    $report += "✅ Conteneur exécuté avec succès."
} catch {
    $report += "❌ Échec de l'exécution du conteneur."
}

# 7. Espace disque disponible sur disque système
$disk = Get-PSDrive C
$freeGB = [math]::Round($disk.Free / 1GB, 2)
$report += "`n💾 Espace libre sur C:\ : $freeGB GB"
if ($freeGB -lt 10) {
    $report += "⚠️ Risque d’espace disque faible (<10GB)."
}

# 8. Test réseau vers Docker Registry
$report += "`n📡 Test réseau vers registry-1.docker.io..."
$ping = Test-NetConnection registry-1.docker.io -Port 443
if ($ping.TcpTestSucceeded) {
    $report += "✅ Connexion TCP au registre Docker OK."
} else {
    $report += "❌ Échec de connexion TCP vers registry-1.docker.io:443"
}

# 9. Liste des conteneurs actifs
$runningContainers = docker ps --format "table {{.Names}}\t{{.Status}}"
$report += "`n📦 Conteneurs en cours d'exécution :"
$report += $runningContainers

# 10. Liste des images présentes
$images = docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
$report += "`n🗂️ Images locales :"
$report += $images

# Export final
$reportPath = "C:\DockerHealthReport.txt"
$report | Out-File $reportPath -Encoding utf8
Write-Host "`n✅ Rapport généré : $reportPath"
