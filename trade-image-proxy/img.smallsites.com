server {
    listen 80;
    listen 443 ssl;
    server_name  img0.sausalitostory.com
                 img1.sausalitostory.com
                 img2.sausalitostory.com
                 img3.sausalitostory.com
                 img4.sausalitostory.com
                 img5.sausalitostory.com
                 img6.sausalitostory.com
                 img7.sausalitostory.com
                 img8.sausalitostory.com
                 img9.sausalitostory.com
                 img.sausalitostory.com
                 img.mingdabeta.com;

    ssl_certificate /etc/letsencrypt/live/img.sausalitostory.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/img.sausalitostory.com/privkey.pem; # managed by Certbot

    ssl_stapling on;
    ssl_stapling_verify on;


    fastcgi_hide_header Set-Cookie;
    add_header X-Cache $upstream_cache_status;

    access_log /var/log/nginx/img.smallsites_access.log cache;
    error_log  /var/log/nginx/img.smallsites_error.log; 

    location ^~ /.well-known/acme-challenge/ {
       default_type "text/plain";
       root   /usr/share/nginx/html;
    }

    location = /.well-known/acme-challenge/ {
       return 404;
    }
  
    location / {
        proxy_pass http://image_ss;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache image_cache;
        proxy_cache_key $host$uri;
        proxy_cache_valid 200 304 30d;

        expires 30d;
        add_header Cache-Control "public";
    }

}

