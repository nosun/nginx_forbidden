dofile "/etc/nginx/lua/config.lua"
local width, height, quality, type, name, ext, host, sig=
tonumber(ngx.var.width), tonumber(ngx.var.height), tonumber(ngx.var.quality), tonumber(ngx.var.type),
ngx.var.name, ngx.var.ext, ngx.var.h ,ngx.var.sig 
-- local webp = tonumber(ngx.var.webp)
local format = ngx.var.format

local max_width,max_height = 1684,2000
local thumbor_key = "unsafe"

local function my_split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

local function IsInTable(value, tbl)
    for k,v in ipairs(tbl) do
        if v == value then
            return true;
        end
    end
    return false;
end

-- http not found
local function return_not_found(msg)
    ngx.status = 404
    ngx.header["Content-type"] = "text/html"
    ngx.say(msg or "not found")
    ngx.exit(0)
end

-- http forbidden
local function return_forbidden(msg)
    ngx.status = 403
    ngx.header["Content-type"] = "text/html"
    ngx.say(msg or "forbidden")
    ngx.exit(0)
end

-- check file if exist

local function file_exists(name)
    local f = io.open(name)
    if f then io.close(f) return true else return false end
end

-- get file path
local function get_file_path(name)
    local p1 = math.floor(tonumber(string.sub(name,1,3),16) % 50)
    local p2 = math.floor(tonumber(string.sub(name,4,6),16) % 50)
    return p1 .. "/" .. p2 .. "/"
end

-- check size if too big
local function get_size(width,height)

    if width  > max_width then
        width = max_width
    end

    if height > max_height then
        height = max_height
    end
    return width,height
end

local function check_if_mark(mark, width)
    if mark == 'mingdabeta.com' then
	    return true
    end

    if width >= 400 or width == 0  then
        return true
    end

    return false
end

-- get filters
local function get_mark(mark,width,height)
    if check_if_mark(mark,width) == false then
        return ''
    end
    return ":watermark(/mark/" .. mark .. ".png,0,0,0,100)"
end

local function get_webp(format)
    if format == 'webp' then
        return ":format(webp)"
    else
        return ""
    end
end

local function get_cropType(type)
    local crop = 'smart';
    if  type == 2
    then crop = 'top'
    end
    return crop;
end

local crop = get_cropType(type)
local arr  = my_split(host,'.')
local site = arr[#arr-1]
local domain = arr[#arr-1] .. '.' .. arr[#arr]

-- check access 
local file_name = name ..".".. ext

if IsInTable(file_name, image_forbidden)  == true then
    ngx.exit(ngx.HTTP_NOT_FOUND) 
end

--check signature
local signature = string.sub(ngx.md5(ngx.md5(site) .. width .. height .. quality .. type .. name .. '.' ..ext),0,16)
if signature ~= sig then return_forbidden(signature) end


-- check file if exist
local file_path = get_file_path(name,ext).. name ..".".. ext

-- begin rewrite
local width,height = get_size(width,height)
local filter_mark = get_mark(domain,width,height)
local filter_webp = get_webp(format)
local filter_quality = ":quality(" .. quality ..")"
local filters = "filters" .. filter_mark .. filter_quality .. filter_webp
--local filters = "filters" .. filter_quality

local real_path = "/" .. thumbor_key .. "/" .. width .. "x" .. height .. "/" .. crop .. "/" .. filters .. "/" .. file_path

ngx.var.args = ''
ngx.req.set_uri(real_path, true)
