# SkyShield Remote Ops

This folder contains small PowerShell helpers for operating the SkyShield server
through SSH key authentication.

## One-time server setup

Option A: run the installer from local PowerShell and enter the root password:

```powershell
.\ops\install-root-key.ps1
```

Option B: run this on the server as `root` once:

```bash
mkdir -p /root/.ssh
chmod 700 /root/.ssh
cat >> /root/.ssh/authorized_keys <<'EOF'
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPvZdY2KlWA3Ihg7fHbTILljyRec6ACJ3lPYqfNcK9ux skyshield-ops-2026-05-03
EOF
chmod 600 /root/.ssh/authorized_keys
```

After that, from this Windows machine:

```powershell
.\ops\connect-root.ps1
.\ops\remote.ps1 "whoami && hostname"
.\ops\setup-logs.ps1
.\ops\logs.ps1
```

## One-command deploy

Deploy the current local code:

```powershell
.\ops\deploy-all.ps1
```

Pull remote Git code first, then deploy:

```powershell
.\ops\deploy-all.ps1 -Pull
```

Notes:

- `-Pull` refuses to run when the local Git working tree has uncommitted changes.
- Use `-RunTests` when you want Maven tests to run before deployment.
- Use `-SkipVerify` only when you do not want post-deploy HTTP checks.

## GitHub push deploy

The workflow file is `.github/workflows/deploy.yml`.

After pushing this project to GitHub, add these repository secrets:

```text
SKYSHIELD_SERVER_HOST=49.234.190.106
SKYSHIELD_SERVER_USER=root
SKYSHIELD_SSH_PRIVATE_KEY=<contents of C:\Users\陈俊辉\.ssh\skyshield_ops_ed25519>
```

Then every push to `main` or `master` runs:

```text
build backend jar -> build frontend dist -> upload artifacts -> backup and deploy on server -> verify HTTP endpoints
```
