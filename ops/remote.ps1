param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Command
)

$ErrorActionPreference = "Stop"

$Server = "49.234.190.106"
$User = "root"
$Key = Join-Path $HOME ".ssh\skyshield_ops_ed25519"

ssh -o BatchMode=yes -i $Key "$User@$Server" $Command
