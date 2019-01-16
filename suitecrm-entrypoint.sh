#!/bin/bash
set -xeuo pipefail

write_suitecrm_config() {
    echo "Write config_si file..."
    sed -i -e 's/DEFAULT_CURRENCY_ISO4217/'"${DEFAULT_CURRENCY_ISO4217:-USD}"'/g' /var/www/html/config_si.php
    sed -i -e 's/DEFAULT_CURRENCY_NAME/'"${DEFAULT_CURRENCY_NAME:-US Dollars}"'/g' /var/www/html/config_si.php
    sed -i -e 's/DEFAULT_CURRENCY_SIGNIFICANT_DIGITS/'"${DEFAULT_CURRENCY_SIGNIFICANT_DIGITS:-2}"'/g' /var/www/html/config_si.php
    sed -i -e 's/DEFAULT_CURRENCY_SYMBOL/'"${DEFAULT_CURRENCY_SYMBOL:-$}"'/g' /var/www/html/config_si.php
    sed -i -e 's/DEFAULT_DATE_FORMAT/'"${DEFAULT_DATE_FORMAT:-Y-m-d}"'/g' /var/www/html/config_si.php
    sed -i -e 's/DEFAULT_DECIMAL_SEPERATOR/'"${DEFAULT_DECIMAL_SEPERATOR:-.}"'/g' /var/www/html/config_si.php
    sed -i -e 's/DEFAULT_EXPORT_CHARSET/'"${DEFAULT_EXPORT_CHARSET:-utf-8}"'/g' /var/www/html/config_si.php
    sed -i -e 's/DEFAULT_LANGUAGE/'"${DEFAULT_LANGUAGE:-en-us}"'/g' /var/www/html/config_si.php
    sed -i -e 's/DEFAULT_LOCALE_NAME_FORMAT/'"${DEFAULT_LOCALE_NAME_FORMAT:-s f l}"'/g' /var/www/html/config_si.php
    sed -i -e 's/DEFAULT_NUMBER_GROUPING_SEPERATOR/'"${DEFAULT_NUMBER_GROUPING_SEPERATOR:-,}"'/g' /var/www/html/config_si.php
    sed -i -e 's/DEFAULT_TIME_FORMAT/'"${DEFAULT_TIME_FORMAT:-H:i}"'/g' /var/www/html/config_si.php
    sed -i -e 's/EXPORT_DELIMITER/'"${EXPORT_DELIMITER:-,}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_DB_ADMIN_PASSWORD/'"${SETUP_DB_ADMIN_PASSWORD:-suitecrm}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_DB_ADMIN_USER_NAME/'"${SETUP_DB_ADMIN_USER_NAME:-root}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_DB_CREATE_DATABASE/'"${SETUP_DB_CREATE_DATABASE:-1}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_DB_DROP_TABLES/'"${SETUP_DB_DROP_TABLES:-1}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_DB_SUGARSALES_PASSWORD_RETYPE/'"${SETUP_DB_SUGARSALES_PASSWORD_RETYPE:-suitecrm}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_DB_SUGARSALES_PASSWORD/'"${SETUP_DB_SUGARSALES_PASSWORD:-suitecrm}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_DB_SUGARSALES_USER/'"${SETUP_DB_SUGARSALES_USER:-suitecrm}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_DB_TYPE/'"${SETUP_DB_TYPE:-mysql}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_DB_HOST_NAME/'"${SETUP_DB_HOST_NAME:-db}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_DB_PORT_NUM/'"${SETUP_DB_PORT_NUM:-3306}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_DB_CREATE_SUGARSALES_USER/'"${SETUP_DB_CREATE_SUGARSALES_USER:-0}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_DB_DATABASE_NAME/'"${SETUP_DB_DATABASE_NAME:-suitecrm}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_DB_POP_DEMO_DATA/'"${SETUP_DB_POP_DEMO_DATA:-0}"'/g' /var/www/html/config_si.php
    sed -i -e 's/DBUSRDATA/'"${DBUSRDATA:-provide}"'/g' /var/www/html/config_si.php
    sed -i -e 's/DEMODATA/'"${DEMODATA:-yes}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_LICENSE_KEY/'"${SETUP_LICENSE_KEY:-}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_SITE_ADMIN_USER_NAME/'"${SETUP_SITE_ADMIN_USER_NAME:-admin}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_SITE_ADMIN_PASSWORD_RETYPE/'"${SETUP_SITE_ADMIN_PASSWORD_RETYPE:-admin}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_SITE_ADMIN_PASSWORD/'"${SETUP_SITE_ADMIN_PASSWORD:-admin}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_SITE_URL/'"${SETUP_SITE_URL:-http:\/\/localhost}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_SYSTEM_NAME/'"${SETUP_SYSTEM_NAME:-'*** SENZIL SRL - SuiteCRM DEMO INSTANCE *** '.date('Y-m-d H:i')}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_FTS_TYPE/'"${SETUP_FTS_TYPE:-}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_FTS_HOST/'"${SETUP_FTS_HOST:-}"'/g' /var/www/html/config_si.php
    sed -i -e 's/SETUP_FTS_PORT/'"${SETUP_FTS_PORT:-9200}"'/g' /var/www/html/config_si.php

    cat /var/www/html/config_si.php
}


if [ ! -e /suitecrmok ] && [ "${SILENT_INSTALL:-TRUE}" != FALSE ]; then

echo "##################################################################################"
echo "##Running silent install, will take a couple of minutes ##########################"
echo "##################################################################################"

echo "Configuring suitecrm for first run"
write_suitecrm_config

echo "making directories writables"
mkdir -p cache && chown www-data:www-data cache upload && chmod -R 775 cache custom modules themes data upload

until nc ${SETUP_DB_HOST_NAME:-db} ${SETUP_DB_PORT_NUM:-3306}; do sleep 3; echo Using DB host: ${SETUP_DB_HOST_NAME}; echo "Waiting for DB to come up..."; done
echo "DB is available now."

echo "Configuring suitecrm in silent mode"
php -r "\$_SERVER['HTTP_HOST'] = 'localhost'; \$_SERVER['REQUEST_URI'] = 'install.php';\$_REQUEST = array('goto' => 'SilentInstall', 'cli' => true);require_once 'install.php';";

echo "##################################################################################"
echo "##SuiteCRM is ready to use #######################################################"
echo "##################################################################################"

touch /suitecrmok

fi

exec "$@"