ARG PYTHON_VERSION=3.6
FROM python:$PYTHON_VERSION

ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o geoip
RUN useradd -m -u $UID -g $GID -o -s /bin/bash --home-dir=/geoip geoip

RUN pip install pipenv
USER geoip

COPY repo/src/main/python/geoip /geoip
COPY config.py /geoip/py/config.py

WORKDIR /geoip
RUN pipenv install --deploy
CMD  ["pipenv", "run", "gunicorn", "--bind", "0.0.0.0:5000", "wsgi"]
