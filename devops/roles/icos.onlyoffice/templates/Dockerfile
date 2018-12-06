FROM onlyoffice/documentserver:{{ onlyoffice_version }}

RUN apt update -y && apt install -y patch
COPY reject_unauthorized.diff /app/onlyoffice
RUN patch -p1 < /app/onlyoffice/reject_unauthorized.diff
