cd /data

WRITEFREELY=/writefreely/writefreely

sed -e s/"#APP_TITLE"/${APP_TITLE:-"A Writefreely blog"}/g \
    -e s/"#APP_DESCRIPTION"/${APP_DESCRIPTION:-""}/g \
    -e s/"#APP_URL"/${APP_URL:-"http:\/\/0.0.0.0:8080"}/g \
    -e s/"#APP_THEME"/${APP_THEME:-"write"}/g \
    -e s/"#APP_JS"/${APP_JS:-"false"}/g \
    -e s/"#APP_WEBFONT"/${APP_WEBFONT:-"true"}/g \
    -e s/"#APP_LANDING"/${APP_LANDING:-""}/g \
    -e s/"#APP_SINGLEUSER"/${APP_SINGLEUSER:-"false"}/g \
    -e s/"#APP_OPENREGISTRATION"/${APP_OPENREGISTRATION:-"true"}/g \
    -e s/"#APP_MINNAMELEN"/${APP_MINNAMELEN:-"3"}/g \
    -e s/"#APP_MAXBLOGS"/${APP_MAXBLOGS:-"1"}/g \
    -e s/"#APP_FEDERATION"/${APP_FEDERATION:-"true"}/g \
    -e s/"#APP_PUBLICSTATS"/${APP_PUBLICSTATS:-"false"}/g \
    -e s/"#APP_PRIVATE"/${APP_PRIVATE:-"false"}/g \
    -e s/"#APP_LOCALTIMELINE"/${APP_LOCALTIMELINE:-"false"}/g \
    -e s/"#APP_USERINVITES"/${APP_USERINVITES:-""}/g \
    -e s/"#DB_TYPE"/${DB_TYPE:-"sqlite3"}/g \
    -e s/"#DB_FILENAME"/${DB_FILENAME:-"writefreely.db"}/g \
    -e s/"#DB_USERNAME"/${DB_USERNAME:-""}/g \
    -e s/"#DB_PASSWORD"/${DB_PASSWORD:-""}/g \
    -e s/"#DB_DATABASE"/${DB_DATABASE:-""}/g \
    -e s/"#DB_HOST"/${DB_HOST:-"localhost"}/g \
    -e s/"#DB_PORT"/${DB_PORT:-"3306"}/g \
    /writefreely/config-template.ini > config.ini

if [ -e ./config.ini ] && [ -e ./writefreely.db ] && [ -e ./keys/email.aes256 ]; then
    BACKUP="writefreely.$(date +%s).db"
    cp writefreely.db ${BACKUP}
    ${WRITEFREELY} -migrate
    if cmp writefreely.db ${BACKUP}; then
        rm ${BACKUP}
    else
        echo "Database backed up at /data/${BACKUP}"
    fi
    exec ${WRITEFREELY}
fi

if [ -e ./config.ini ]; then
    if [ ! -s ./writefreely.db ]; then
        ${WRITEFREELY} -init-db
    fi
    if [ ! -e ./keys/email.aes256 ]; then
        ${WRITEFREELY} -gen-keys
    fi

    BACKUP="writefreely.$(date +%s).db"
    cp writefreely.db ${BACKUP}
    ${WRITEFREELY} -migrate
    if cmp writefreely.db ${BACKUP}; then
        rm ${BACKUP}
    else
        echo "Database backed up at /data/${BACKUP}"
    fi
    exec ${WRITEFREELY}

fi
