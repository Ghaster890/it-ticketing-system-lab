#!/bin/sh
set -eu

CONFIG_DIR="/var/lib/osticket-config"
CONFIG_FILE="${CONFIG_DIR}/ost-config.php"
RAILWAY_ATTACHMENTS_DIR="${CONFIG_DIR}/attachments"

mkdir -p "${CONFIG_DIR}"
if [ -n "${RAILWAY_ENVIRONMENT_ID:-}" ]; then
    mkdir -p "${RAILWAY_ATTACHMENTS_DIR}"
    if [ ! -L /var/www/html/attachments ]; then
        rm -rf /var/www/html/attachments
        ln -s "${RAILWAY_ATTACHMENTS_DIR}" /var/www/html/attachments
    fi
fi
mkdir -p /var/www/html/attachments

if [ ! -e "${CONFIG_FILE}" ]; then
    : > "${CONFIG_FILE}"
fi
chown www-data:www-data "${CONFIG_FILE}"
chmod 0640 "${CONFIG_FILE}"
chown www-data:www-data /var/www/html/attachments

if [ ! -L /var/www/html/include/ost-config.php ]; then
    if [ -e /var/www/html/include/ost-config.php ]; then
        rm -f /var/www/html/include/ost-config.php
    fi
    ln -s "${CONFIG_FILE}" /var/www/html/include/ost-config.php
fi

if [ -s "${CONFIG_FILE}" ]; then
    rm -rf /var/www/html/setup
    chmod 0444 "${CONFIG_FILE}"
fi

exec "$@"

