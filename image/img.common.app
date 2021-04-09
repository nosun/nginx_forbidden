server {

    listen     80;

    server_name  
                 img.sausalitostory.com
                 img.mingdabeta.com

                 img.doriswedding.com
                 img.dorriswedding.com
                 img.dressafford.com
                 img.junebridals.com
                 img.newadoringdress.com
                 img.ucenterdress.com
                 img.june-bridals.com
                 img.ucenter-dress.com
                 img.dorriswedding.co
                 *.cdn.dressafford.com
                 *.cdn.junebridals.com
                 *.cdn.dorriswedding.com
                 *.cdn.ucenterdress.com
                 *.cdn.sausalitostory.com;


    root /data/www/image.app/upload/;
    #access_log /data/log/nginx/img.common_access.log;


    # /image/300x200/99/1/feea0668c44f456789/feea0668c44fd5ea69f65fc62750de76/sometitle.jpg
    location ~ "^/image/(\d+)x(\d+)/([\d]{1,3})/(\d)/([a-f0-9]{16})/([a-f0-9]{32})/(.*)\.(gif|jpg|png|css)$" {
      default_type text/html;
      set $width $1;
      set $height $2;
      set $quality $3;
      set $type $4;
      set $sig $5;
      set $name $6;
      set $ext $8;
      set $h $host;
      set $root $document_root;
      #expires 7d;
      rewrite_by_lua_file "/etc/nginx/lua/rewrite_image.lua";
    }


    # /image/300x200/99/50/feea0668c44f456789/feea0668c44fd5ea69f65fc62750de76.jpg
    location ~ "^/image/(\d+)x(\d+)/([\d]{1,3})/([\d]{2})/([a-f0-9]{16})/([a-f0-9]{32})\.(gif|jpg|png|css)$" {
      default_type text/html;
      set $width $1;
      set $height $2;
      set $quality $3;
      set $type $4;
      set $sig $5;
      set $name $6;
      set $ext $7;
      set $h $host;
      set $root $document_root;
      #expires 7d;
      rewrite_by_lua_file "/etc/nginx/lua/rewrite_split_image.lua";
    }


    # /image/300x200/99/1/feea0668c44f456789/feea0668c44fd5ea69f65fc62750de76.jpg
    location ~ "^/image/(\d+)x(\d+)/([\d]{1,3})/(\d)/([a-f0-9]{16})/([a-f0-9]{32})\.(gif|jpg|png|css)$" {
      default_type text/html;
      set $width $1;
      set $height $2;
      set $quality $3;
      set $type $4;
      set $sig $5;
      set $name $6;
      set $ext $7;
      set $h $host;
      set $root $document_root;
      set $format $arg_format;
      #expires 7d;
      rewrite_by_lua_file "/etc/nginx/lua/rewrite_image.lua";
    }

    #location ~ "robots.txt" {
    #  rewrite_by_lua_file "/etc/nginx/lua/rewrite_robots.lua";
    #}

    location ~ "\.txt" {
      allow all;
    }

    location ~ ^/upload/ {
      deny all;
    }

    location = /favicon.ico {
      log_not_found off;
    }

    location / {
      proxy_pass http://thumbor;
      expires 60d;
      add_header Cache-Control "public";

      access_by_lua '
        if ngx.var.sig == "" then
           ngx.exit(ngx.HTTP_FORBIDDEN)
        end
      ';
    }

}
