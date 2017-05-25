local iputils = require("resty.iputils")

local function return_serverError(status,msg)
    ngx.status = status
    ngx.header["Content-type"] = "text/html"
    ngx.say(msg or "server error")
    ngx.exit(0)
end

local function getClientIP()
   return ngx.var.http_x_forwarded_for or ngx.var.remote_addr
end

local clientIP = getClientIP()

-- if not in whitelist, then return server error

if iputils.ip_in_cidrs(clientIP, whitelist) == false then
    return_serverError(500)
else
    -- return_serverError(200, clientIP)
end


