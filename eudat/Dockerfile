FROM irods/icommands:4.0.3

COPY ./egirepokey.key /opt/

RUN apt-key add /opt/egirepokey.key \
&& echo 'deb http://repository.egi.eu/sw/production/cas/1/current egi-igtf core' >> /etc/apt/sources.list \
&& apt-get update -y \
&& apt-get install -y ca-policy-egi-core fetch-crl globus-core globus-gass-copy-progs

COPY ./irodsEnv.txt ./.irods/.irodsEnv
