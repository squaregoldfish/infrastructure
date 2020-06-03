Example command for deployment, restheart nginx only:

`ansible-playbook -tnginx -e '{"extra_configs": ["restheart"]}' -i production.inventory icosprod.yml -l fsicos.lunarc.lu.se`
