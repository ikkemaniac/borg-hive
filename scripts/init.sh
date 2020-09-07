#!/usr/bin/env bash

cat << "EOF"
  ____                    _    _ _
 |  _ \                  | |  | (_)
 | |_) | ___  _ __ __ _  | |__| |___   _____
 |  _ < / _ \| '__/ _` | |  __  | \ \ / / _ \
 | |_) | (_) | | | (_| | | |  | | |\ V /  __/
 |____/ \___/|_|  \__, | |_|  |_|_| \_/ \___|
                   __/ |
                  |___/
EOF

DEBUG="${DEBUG:-True}"
MIGRATE="${MIGRATE:-True}"
FIXTURES="${FIXTURES:-True}"
APP_DB_TIMEOUT="${APP_DB_TIMEOUT:-60}"

echo "DEBUG:     ${DEBUG}"
echo "MIGRATE:   ${MIGRATE}"
echo "FIXTURES:  ${FIXTURES}"

#
# DB INIT
#
echo "Waiting for database..."

while ! nc -z db 3306; do
i=1
  sleep 1
  
  if [[ $i -gt ${APP_DB_TIMEOUT} ]];
  then
    echo "ERROR: Could not connect to 'db:3306'"
    exit 1
  fi
  echo "Ping database instance(${i})"
  ((i=i+1))
done

echo "DB started"

#
# STATIC FILES
#
./manage.py collectstatic --noinput


#
# MIGRATE
#
if [[ "${MIGRATE}" == "True" ]]; then
  ./manage.py migrate --no-input --force-color
fi

#
# LOAD DATA
#
if [[ "${FIXTURES}" == "True" ]]; then
  ./manage.py loaddata borghive/fixtures/setup/*
fi

#
# MODE
#
if [[ "${DEBUG}" == "True" ]]; then
  ./manage.py runserver 0.0.0.0:8000
else
  uwsgi --ini /uwsgi.ini --show-config
fi
