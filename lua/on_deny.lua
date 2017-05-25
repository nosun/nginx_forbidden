local iputils = require("resty.iputils")

local function return_serverError(msg)
    ngx.status = 500
    ngx.header["Content-type"] = "text/html"
    ngx.say(msg or "server error")
    ngx.exit(0)
end

local function getClientIP()
   return ngx.var.http_x_forwarded_for;
end

local clientIP = getClientIP();

if iputils.ip_in_cidrs(clientIP, whitelist) == false then
    return_serverError()
end