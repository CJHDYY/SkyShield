$ErrorActionPreference = "Stop"

$Server = "49.234.190.106"
$User = "root"
$Key = Join-Path $HOME ".ssh\skyshield_ops_ed25519"

ssh -i $Key "$User@$Server"

