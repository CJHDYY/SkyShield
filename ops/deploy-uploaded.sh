#!/usr/bin/env bash
set -euo pipefail

DEPLOY_DIR="${1:?deploy dir required}"
TS="$(date +%Y%m%d%H%M%S)"

BACKEND_JAR="/opt/skyshield/app/skyshield-admin.jar"
BACKEND_BACKUP="/opt/skyshield/backup/skyshield-admin.jar.${TS}"
FRONTEND_DIR="/var/www/html"
FRONTEND_BACKUP="/var/www/html.backup.${TS}"

echo "deploy_dir=${DEPLOY_DIR}"
echo "backup_ts=${TS}"

test -f "${DEPLOY_DIR}/skyshield-admin.jar"
test -f "${DEPLOY_DIR}/frontend-dist.tar.gz"

ls -lh "${DEPLOY_DIR}/skyshield-admin.jar" "${DEPLOY_DIR}/frontend-dist.tar.gz"

mkdir -p /opt/skyshield/backup
cp -a "${BACKEND_JAR}" "${BACKEND_BACKUP}"
cp -a "${FRONTEND_DIR}" "${FRONTEND_BACKUP}"

cp -f "${DEPLOY_DIR}/skyshield-admin.jar" "${BACKEND_JAR}"
chown dc2026:dc2026 "${BACKEND_JAR}"

find "${FRONTEND_DIR}" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
tar -xzf "${DEPLOY_DIR}/frontend-dist.tar.gz" -C "${FRONTEND_DIR}"
chown -R www-data:www-data "${FRONTEND_DIR}"

if [[ -f "${DEPLOY_DIR}/nginx-jsionit.conf" ]]; then
  cp -f "${DEPLOY_DIR}/nginx-jsionit.conf" /etc/nginx/sites-available/skyshield.conf
  ln -sfn /etc/nginx/sites-available/skyshield.conf /etc/nginx/sites-enabled/skyshield.conf
fi

nginx -t
systemctl restart skyshield
systemctl reload nginx

sleep 5

systemctl is-active skyshield
systemctl is-active nginx

ls -lh "${BACKEND_JAR}"
ls -lh "${FRONTEND_DIR}" | sed -n '1,20p'

echo "backend_backup=${BACKEND_BACKUP}"
echo "frontend_backup=${FRONTEND_BACKUP}"
