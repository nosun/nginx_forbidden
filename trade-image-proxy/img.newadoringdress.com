server {
    listen     80;
    listen     443 ssl http2;
    server_name  img.newadoringdress.com;
    
    rewrite ^  https://img.junebridals.com$request_uri? permanent;
ssl_certificate /etc/letsencrypt/live/img.newadoringdress.com-0001/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/img.newadoringdress.com-0001/privkey.pem; # managed by Certbot
    

    ssl_stapling on;
    ssl_stapling_verify on;

    add_header X-Cache $upstream_cache_status;

    location ^~ /.well-known/acme-challenge/ {
       default_type "text/plain";
       root   /usr/share/nginx/html;
    }

    location = /.well-known/acme-challenge/ {
       return 404;
    }


}
