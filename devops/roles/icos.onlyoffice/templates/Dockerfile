FROM onlyoffice/documentserver:{{ onlyoffice_version }}

RUN apt update -y && apt upgrade -y && apt install -y patch unrar

COPY reject_unauthorized.diff /app/onlyoffice
RUN patch -p1 < /app/onlyoffice/reject_unauthorized.diff

COPY droidserif.rar /tmp
# https://helpcenter.onlyoffice.com/server/linux/document/install-fonts.aspx
# Don't run the 'documentserver-generate-allfonts.sh' during build as
# it's run by the entrypoint script during startup.
RUN cd /usr/share/fonts/truetype/custom && unrar x /tmp/droidserif.rar && fc-cache
