server {
    listen      80;
    server_name img1.sausalitostory.com
		img2.sausalitostory.com
		img3.sausalitostory.com
		img4.sausalitostory.com
		img5.sausalitostory.com
		img6.sausalitostory.com
		img7.sausalitostory.com
		img8.sausalitostory.com
		img9.sausalitostory.com
		img0.sausalitostory.com;
 
    root  /data/www/image-proxy/public;

    error_log /data/log/nginx/image-proxy.app_nginx_error.log error;
    access_log /data/log/nginx/image-proxy.app_nginx_access.log;

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }    

}

