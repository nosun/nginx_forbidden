server {

    listen     80;
    listen     443 ssl;
    server_name  img.junebridals.com;
ssl_certificate /etc/letsencrypt/live/img.junebridals.com-0001/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/img.junebridals.com-0001/privkey.pem; # managed by Certbot

    ssl_stapling on;
    ssl_stapling_verify on;

    #access_log /var/log/nginx/img.junebridals_access.log;

    add_header X-Cache $upstream_cache_status;

    location ^~ /.well-known/acme-challenge/ {
       default_type "text/plain";
       root   /usr/share/nginx/html;
    }

    location = /.well-known/acme-challenge/ {
       return 404;
    }


    location / {
      proxy_pass http://image;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_cache image_cache;
      proxy_cache_key $host$uri;
      proxy_cache_valid 200 304 10m;

      expires 30d;
      add_header Cache-Control "public";
      #access_log off;
    }



}
