server {
    listen 80;
    server_name  img.dresspirit.com
                 img.sausalitostory.com
                 img.uniqbridal.com
                 img.dearlover-corsets.com
                 img.mingdabeta.com
                 img.amorrosado.com;


    fastcgi_hide_header Set-Cookie;
    add_header X-Cache $upstream_cache_status;

    access_log /var/log/nginx/img.smallsites_access.log cache;
    error_log  /var/log/nginx/img.smallsites_error.log; 
  
    location / {
        proxy_pass http://image;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache image_cache;
        proxy_cache_key $host$uri$webp;
        proxy_cache_valid 200 304 30d;

        expires 30d;
        add_header Cache-Control "public";
    }

}

