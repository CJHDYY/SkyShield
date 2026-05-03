$ErrorActionPreference = "Stop"

$Server = "49.234.190.106"
$User = "root"
$PublicKeyPath = Join-Path $HOME ".ssh\skyshield_ops_ed25519.pub"

if (-not (Test-Path $PublicKeyPath)) {
    throw "Public key not found: $PublicKeyPath"
}

$PublicKey = (Get-Content $PublicKeyPath -Raw).Trim()
$Credential = Get-Credential -UserName "$User@$Server" -Message "Enter the root SSH password for $Server"

if (-not (Get-Module -ListAvailable -Name Posh-SSH)) {
    Install-Module -Name Posh-SSH -Scope CurrentUser -Force
}

Import-Module Posh-SSH

$Session = New-SSHSession -ComputerName $Server -Credential $Credential -AcceptKey -Force
try {
    $EscapedKey = $PublicKey.Replace("'", "'\''")
    $Command = @"
mkdir -p /root/.ssh
chmod 700 /root/.ssh
grep -qxF '$EscapedKey' /root/.ssh/authorized_keys 2>/dev/null || echo '$EscapedKey' >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
"@
    Invoke-SSHCommand -SessionId $Session.SessionId -Command $Command | Out-Host
}
finally {
    Remove-SSHSession -SessionId $Session.SessionId | Out-Null
}

Write-Host "Root SSH key installed. Test with: .\ops\remote.ps1 `"whoami && hostname`""

