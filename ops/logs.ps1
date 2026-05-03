param(
    [ValidateSet("info", "error", "user", "journal")]
    [string]$Type = "info",

    [int]$Lines = 100,

    [switch]$Follow
)

$ErrorActionPreference = "Stop"

$Server = "49.234.190.106"
$User = "root"
$Key = Join-Path $HOME ".ssh\skyshield_ops_ed25519"

if ($Type -eq "journal") {
    $Command = if ($Follow) {
        "journalctl -u skyshield -n $Lines -f"
    } else {
        "journalctl -u skyshield -n $Lines --no-pager"
    }
} else {
    $Map = @{
        info = "/home/skyshield/logs/sys-info.log"
        error = "/home/skyshield/logs/sys-error.log"
        user = "/home/skyshield/logs/sys-user.log"
    }
    $File = $Map[$Type]
    $Command = if ($Follow) {
        "tail -n $Lines -f $File"
    } else {
        "tail -n $Lines $File"
    }
}

ssh -o BatchMode=yes -i $Key "$User@$Server" $Command
