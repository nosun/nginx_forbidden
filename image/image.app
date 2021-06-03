server {
    listen      80;
    server_name image.mingdabeta.com; 
    index index.html index.php;
    root  /data/www/image.app;

    #rewrite_log on;
    error_log /data/log/nginx/image.app_nginx_error.log error;
    access_log /data/log/nginx/image.app_nginx_access.log;


    # /counterfeit/image_data/counterfeit_img/9ace221877362e9f47043f88bf15bdf1/73729-10000.jpg
    location ^~ /counterfeit_img/ {
        root /counterfeit/image_data;
    }

    location / {
       index index.php index.html;

       if (!-f $request_filename){
            rewrite ^(.*)$ /index.php$1;
       }
    }
    
    location ~ /upload/ {
        #allow   117.72.139.184;
        #allow   127.0.0.1;
	#deny    all;
    } 


    location ~ \.php($|/) {
        fastcgi_pass unix:/run/php/php5.6-fpm.sock;
        fastcgi_param PATH_INFO $fastcgi_path_info;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }

}

