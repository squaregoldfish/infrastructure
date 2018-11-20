FROM python:{{ geoip_python_version }}

RUN groupadd --gid {{ _user.group }} {{ _user.name }} && \
	useradd --gid {{ _user.group }} --uid {{ _user.uid }} {{ _user.name }} \
  	        --home-dir /geoip --create-home

RUN pip install pipenv
USER {{ _user.name }} {# geoip #}

COPY repo/src/main/python/geoip /geoip
COPY config.py /geoip/py/config.py

WORKDIR /geoip
RUN pipenv install --deploy
CMD  ["pipenv", "run", "gunicorn", "--bind", "0.0.0.0:5000", "wsgi"]
