param(
    [string]$DbPassword = $env:SKYSHIELD_DB_PASSWORD,
    [string]$DruidPassword = $env:SKYSHIELD_DRUID_PASSWORD,
    [switch]$Restart,
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$ClientDir = Join-Path $Root "SkyShield-Client"
$ServerDir = Join-Path $Root "SkyShield-Server"
$JarDir = Join-Path $ServerDir "skyshield-admin\target"
$JarPath = Join-Path $JarDir "skyshield-admin.jar"
$LogsDir = Join-Path $Root "logs"
$FrontendOut = Join-Path $LogsDir "frontend.out.log"
$FrontendErr = Join-Path $LogsDir "frontend.err.log"
$BackendOut = Join-Path $LogsDir "backend.out.log"
$BackendErr = Join-Path $LogsDir "backend.err.log"

function Ensure-LogsDir {
    New-Item -ItemType Directory -Force -Path $LogsDir | Out-Null
}

function Get-Listener {
    param([int]$Port)
    Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction SilentlyContinue |
        Select-Object -First 1
}

function Stop-Port {
    param([int]$Port)
    $listener = Get-Listener -Port $Port
    if ($listener) {
        $process = Get-Process -Id $listener.OwningProcess -ErrorAction SilentlyContinue
        if ($process) {
            Write-Host "Stopping port $Port process: $($process.ProcessName) ($($process.Id))"
            Stop-Process -Id $process.Id -Force
            Start-Sleep -Seconds 2
        }
    }
}

function Require-Command {
    param([string]$Name)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Command '$Name' was not found. Please install it or add it to PATH."
    }
}

function Start-Backend {
    if ([string]::IsNullOrWhiteSpace($DbPassword)) {
        $script:DbPassword = Read-Host "Enter MySQL root password"
    }
    if ([string]::IsNullOrWhiteSpace($DruidPassword)) {
        $script:DruidPassword = $script:DbPassword
    }

    if ($Restart) {
        Stop-Port -Port 8080
    }

    if (Get-Listener -Port 8080) {
        Write-Host "Backend already listening on http://localhost:8080"
        return
    }

    if ((-not $SkipBuild) -or (-not (Test-Path $JarPath))) {
        Require-Command "mvn"
        Write-Host "Building backend jar..."
        Push-Location $ServerDir
        try {
            mvn package -DskipTests
        }
        finally {
            Pop-Location
        }
    }

    if (-not (Test-Path $JarPath)) {
        throw "Backend jar not found: $JarPath"
    }

    Remove-Item $BackendOut, $BackendErr -ErrorAction SilentlyContinue

    $command = "set SKYSHIELD_DB_PASSWORD=$DbPassword&& set SKYSHIELD_DRUID_PASSWORD=$DruidPassword&& java -Xms256m -Xmx1024m -jar skyshield-admin.jar"
    $process = Start-Process -FilePath "cmd.exe" `
        -ArgumentList @("/c", $command) `
        -WorkingDirectory $JarDir `
        -RedirectStandardOutput $BackendOut `
        -RedirectStandardError $BackendErr `
        -PassThru `
        -WindowStyle Hidden

    Write-Host "Starting backend, launcher PID: $($process.Id)"
}

function Start-Frontend {
    if ($Restart) {
        Stop-Port -Port 8001
    }

    if (Get-Listener -Port 8001) {
        Write-Host "Frontend already listening on http://localhost:8001/"
        return
    }

    Require-Command "npm.cmd"
    Remove-Item $FrontendOut, $FrontendErr -ErrorAction SilentlyContinue

    $process = Start-Process -FilePath "npm.cmd" `
        -ArgumentList @("run", "dev", "--", "--host", "0.0.0.0") `
        -WorkingDirectory $ClientDir `
        -RedirectStandardOutput $FrontendOut `
        -RedirectStandardError $FrontendErr `
        -PassThru `
        -WindowStyle Hidden

    Write-Host "Starting frontend, PID: $($process.Id)"
}

function Wait-Port {
    param(
        [int]$Port,
        [string]$Name,
        [int]$Seconds = 45
    )

    for ($i = 0; $i -lt $Seconds; $i++) {
        if (Get-Listener -Port $Port) {
            Write-Host "$Name is ready on port $Port"
            return $true
        }
        Start-Sleep -Seconds 1
    }

    Write-Host "$Name did not open port $Port within $Seconds seconds"
    return $false
}

Ensure-LogsDir
Start-Backend
Start-Frontend

$backendReady = Wait-Port -Port 8080 -Name "Backend"
$frontendReady = Wait-Port -Port 8001 -Name "Frontend"

Write-Host ""
Write-Host "Frontend: http://localhost:8001/"
Write-Host "Backend:  http://localhost:8080/"
Write-Host "Logs:"
Write-Host "  Frontend stdout: $FrontendOut"
Write-Host "  Frontend stderr: $FrontendErr"
Write-Host "  Backend stdout:  $BackendOut"
Write-Host "  Backend stderr:  $BackendErr"
Write-Host ""
Write-Host "Common usage:"
Write-Host "  .\ops\start-local.ps1 -DbPassword '<your-mysql-password>'"
Write-Host "  .\ops\start-local.ps1 -DbPassword '<your-mysql-password>' -Restart"
Write-Host "  .\ops\start-local.ps1 -DbPassword '<your-mysql-password>' -SkipBuild"

if (-not ($backendReady -and $frontendReady)) {
    exit 1
}
