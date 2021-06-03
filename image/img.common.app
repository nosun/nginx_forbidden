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
    access_log /data/log/nginx/img.common_access.log;

    # /image/300x200/99/1/feea0668c44f456789/feea0668c44fd5ea69f65fc62750de76.jpg
    location ~ "^/image/(\d+)x(\d+)/([\d]{1,3})/(\d)/([a-f0-9]{16})/([a-f0-9]{32})\.(gif|jpg|png|css)$" {
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

    location = / {
        default_type text/html;
        content_by_lua_block {
            ngx.say("")
        }
    }

    location / {
      proxy_pass http://thumbor;
      proxy_cache        image_cache;
      proxy_cache_key    $host$uri$is_args$args;
      proxy_cache_valid  200 304 90d;
      add_header Pragma  public;
      proxy_ignore_headers Expires Cache-Control Set-Cookie;
      proxy_hide_header  Set-Cookie;
      expires 60d;
    }
}
