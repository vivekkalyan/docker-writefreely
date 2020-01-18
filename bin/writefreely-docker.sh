cd /data

WRITEFREELY=/writefreely/writefreely

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

if [ ! -e ./config.ini ]; then
    ${WRITEFREELY} -config
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
