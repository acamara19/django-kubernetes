#!/bin/bash
DJANGO_SUERPUSER_EMAIL=${DJANGO_SUERPUSER_EMAIL:-"ac_socials@icloud.com"}
cd /app/
/opt/venv/bin/python manage.py migrate --noinput
/opt/venv/bin/python manage.py createsuperuser --email $DJANGO_SUERPUSER_EMAIL --noinput || true
