    # This is the default collabora/nginx config as recommended by nextcloud.
    # https://nextcloud.com/collaboraonline/ - which then refers to
    # https://icewind.nl/entry/collabora-online

    # static files
    location ^~ /loleaflet {
        proxy_pass {{ nextcloud_collabora_host_url }};
        proxy_set_header Host $http_host;
    }

    # WOPI discovery URL
    location ^~ /hosting/discovery {
        proxy_pass {{ nextcloud_collabora_host_url }};
        proxy_set_header Host $http_host;
    }

   # main websocket
   location ~ ^/lool/(.*)/ws$ {
       proxy_pass {{ nextcloud_collabora_host_url }};
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection "Upgrade";
       proxy_set_header Host $http_host;
       proxy_read_timeout 36000s;
   }
   
   # download, presentation and image upload
   location ~ ^/lool {
       proxy_pass {{ nextcloud_collabora_host_url }};
       proxy_set_header Host $http_host;
   }
   
   # Admin Console websocket
   location ^~ /lool/adminws {
       proxy_pass {{ nextcloud_collabora_host_url }};
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection "Upgrade";
       proxy_set_header Host $http_host;
       proxy_read_timeout 36000s;
   }
