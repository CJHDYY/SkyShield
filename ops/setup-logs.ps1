$ErrorActionPreference = "Stop"

$Server = "49.234.190.106"
$User = "root"
$Key = Join-Path $HOME ".ssh\skyshield_ops_ed25519"

$Command = @'
set -e
mkdir -p /home/skyshield/logs
chown -R dc2026:dc2026 /home/skyshield/logs
chmod -R 755 /home/skyshield/logs
systemctl restart skyshield
sleep 2
systemctl --no-pager --full status skyshield | sed -n '1,18p'
ls -lh /home/skyshield/logs
'@

ssh -o BatchMode=yes -i $Key "$User@$Server" $Command
