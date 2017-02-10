ansible-playbook -i vagrant, setup_stiltweb.yml -e stiltweb_app_conf=icos/stiltweb/src/main/resources/application.conf -e stiltweb_jar_file=icos/stiltweb/target/scala-2.11/stiltweb-assembly-0.1.0.jar
