server {
    listen 80;
    server_name  img.dresspirit.com
                 img.bridalona.com
                 img.thenine5.com
                 img.amorasecret.com
                 img.ceceliasveil.com
                 img.sausalitostory.com
                 img.bridalmelissa.com
                 img.lovingbridal.com
                 img.ms-right.com
                 img.uniqbridal.com
                 img.dearlover-corsets.com
                 img.mingdabeta.com
                 img.amorrosado.com;


    fastcgi_hide_header Set-Cookie;
    add_header X-Cache $upstream_cache_status;

    access_log /data/log/nginx/img.smallsites_access.log cache;
    error_log  /data/log/nginx/img.smallsites_error.log; 
  
    location / {
        proxy_pass http://image;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache image_cache;
        proxy_cache_key $host$uri;
        proxy_cache_valid 200 304 10m;

        expires 30d;
        add_header Cache-Control "public";
    }

}

