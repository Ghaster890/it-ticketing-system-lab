#!/bin/sh
set -eu

CONFIG_DIR="/var/lib/osticket-config"
CONFIG_FILE="${CONFIG_DIR}/ost-config.php"

mkdir -p "${CONFIG_DIR}"
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
