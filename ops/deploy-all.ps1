param(
    [switch]$Pull,
    [switch]$AllowDirtyPull,
    [switch]$RunTests,
    [switch]$SkipVerify
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Server = "49.234.190.106"
$User = "root"
$Key = Join-Path $HOME ".ssh\skyshield_ops_ed25519"
$ClientDir = Join-Path $Root "SkyShield-Client"
$ServerDir = Join-Path $Root "SkyShield-Server"
$BackendJar = Join-Path $ServerDir "skyshield-admin\target\skyshield-admin.jar"
$DeployScript = Join-Path $PSScriptRoot "deploy-uploaded.sh"
$NginxConfig = Join-Path $PSScriptRoot "nginx-jsionit.conf"
$ArtifactsDir = Join-Path $Root ".deploy-artifacts"
$Timestamp = Get-Date -Format "yyyyMMddHHmmss"
$FrontendArchive = Join-Path $ArtifactsDir "frontend-dist-$Timestamp.tar.gz"
$RemoteDir = "/root/skyshield-deploy-$Timestamp"

function Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Run {
    param(
        [string]$Command,
        [string]$WorkingDirectory = $Root
    )
    Push-Location $WorkingDirectory
    try {
        Write-Host "+ $Command" -ForegroundColor DarkGray
        $global:LASTEXITCODE = 0
        Invoke-Expression $Command
        if ($LASTEXITCODE -ne 0) {
            throw "Command failed with exit code ${LASTEXITCODE}: $Command"
        }
    }
    finally {
        Pop-Location
    }
}

function Git-Pull-Safely {
    param([string]$Path)

    $dirty = git -C $Path status --porcelain
    if ($dirty -and -not $AllowDirtyPull) {
        throw "Git working tree is dirty in $Path. Commit/stash changes first, or rerun with -AllowDirtyPull if you really want git pull to merge into local changes."
    }

    Run "git pull --ff-only" $Path
}

if (-not (Test-Path $Key)) {
    throw "SSH key not found: $Key"
}

if (-not (Test-Path $DeployScript)) {
    throw "Deploy script not found: $DeployScript"
}

if (-not (Test-Path $NginxConfig)) {
    throw "Nginx config not found: $NginxConfig"
}

Step "Checking SSH connection"
Run "ssh -o BatchMode=yes -i `"$Key`" ${User}@${Server} `"whoami && hostname`""

if ($Pull) {
    Step "Pulling latest code"
    Git-Pull-Safely $ServerDir
    Git-Pull-Safely $ClientDir
} else {
    Step "Using current local code"
    Write-Host "Skipping git pull. Add -Pull when you want to update from the remote Git repository first."
}

Step "Building backend jar"
$mavenCommand = if ($RunTests) { "mvn clean package" } else { "mvn clean package -DskipTests" }
Run $mavenCommand $ServerDir

if (-not (Test-Path $BackendJar)) {
    throw "Backend jar was not generated: $BackendJar"
}

Step "Building frontend dist"
Run "npm run build:prod" $ClientDir

$DistDir = Join-Path $ClientDir "dist"
if (-not (Test-Path (Join-Path $DistDir "index.html"))) {
    throw "Frontend dist was not generated correctly: $DistDir"
}

Step "Packing frontend dist"
New-Item -ItemType Directory -Force $ArtifactsDir | Out-Null
if (Test-Path $FrontendArchive) {
    Remove-Item -LiteralPath $FrontendArchive -Force
}
Run "tar -czf `"$FrontendArchive`" -C `"$DistDir`" ." $Root

Step "Creating remote deploy directory"
Run "ssh -i `"$Key`" ${User}@${Server} `"mkdir -p $RemoteDir && chmod 700 $RemoteDir`""

Step "Uploading artifacts"
Run "scp -i `"$Key`" `"$BackendJar`" ${User}@${Server}:$RemoteDir/skyshield-admin.jar"
Run "scp -i `"$Key`" `"$FrontendArchive`" ${User}@${Server}:$RemoteDir/frontend-dist.tar.gz"
Run "scp -i `"$Key`" `"$DeployScript`" ${User}@${Server}:$RemoteDir/deploy-uploaded.sh"
Run "scp -i `"$Key`" `"$NginxConfig`" ${User}@${Server}:$RemoteDir/nginx-jsionit.conf"

Step "Deploying on server"
Run "ssh -i `"$Key`" ${User}@${Server} `"bash $RemoteDir/deploy-uploaded.sh $RemoteDir`""

if (-not $SkipVerify) {
    Step "Verifying services and HTTP endpoints"
    Run "ssh -i `"$Key`" ${User}@${Server} `"systemctl is-active skyshield && systemctl is-active nginx && curl -fsS --max-time 10 http://127.0.0.1:8001/ >/dev/null && curl -fsS --max-time 10 http://127.0.0.1:8001/prod-api/captchaImage >/dev/null && echo verify_ok`""
    $home = (Invoke-WebRequest -Uri "http://49.234.190.106:8001/" -UseBasicParsing -TimeoutSec 15).StatusCode
    $captcha = (Invoke-WebRequest -Uri "http://49.234.190.106:8001/prod-api/captchaImage" -UseBasicParsing -TimeoutSec 15).StatusCode
    Write-Host "Public home status: $home"
    Write-Host "Public captcha status: $captcha"
}

Step "Done"
Write-Host "Remote deploy directory: $RemoteDir"
Write-Host "Local frontend archive: $FrontendArchive"
