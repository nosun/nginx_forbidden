upstream  enki-main  {
    server  192.168.143.57:80 weight=1 fail_timeout=10 max_fails=1;
}

upstream  enki-second  {
    server 192.168.218.65:80 weight=1 fail_timeout=10 max_fails=1;
}

#upstream backend {
#    server  192.168.143.57:80 weight=1 fail_timeout=10 max_fails=1;
#    server  192.168.218.65:80 weight=1 fail_timeout=10 max_fails=1;
#}


server {
    listen 8080;
    server_name enkivillage.com;
    rewrite ^ http://www.enkivillage.com$request_uri? permanent;
}

server {

    listen 8080 backlog=16384;
    server_name  www.enkivillage.com;
    default_type text/html;
    access_log /data/logs/nginx/access_enki_test.log;

    location / {
        #proxy_pass http://backend;
        #proxy_set_header Host $host;
        #proxy_set_header X-Real-IP $remote_addr;
        #proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        
        content_by_lua_file '/data/nginx/conf/lua/abTestByIP.lua';
    }

    #location /test {
    #    content_by_lua 'ngx.say("this is test infomation")';
    #}

    location @server1 {
         proxy_pass http://enki-main;
    }

    location @server2 {
        proxy_pass http://enki-second;
    }
}


