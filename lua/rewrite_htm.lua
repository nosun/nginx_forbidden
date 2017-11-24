local uri = ngx.var.uri

local rewrite_area = {
    "wedding-dresses-for-pregnant-women",
    "pregnancy-formal-dresses",
    "pregnancy-cocktail-dresses",
    "maternity-wedding-dresses",
    "maternity-wedding-dresses-canada",
    "maternity-semi-formal-dresses",
    "maternity-formal-dresses",
    "maternity-evening-dresses-online",
    "maternity-evening-dresses--formal-gowns",
    "maternity-cocktail-dresses-cheap",
    "maternity-bridesmaid-dresses",
    "maternity-bridesmaid-dresses-canada",
    "maternity-bridal-gowns",
    "formal-dresses-for-pregnant-ladies",
    "designer-maternity-wedding-dresses",
    "cheap-maternity-wedding-dresses-under-100",
    "cheap-maternity-evening-dresses",
    "short-maternity-wedding-dresses",
    "plus-size-maternity-formal-dresses",
    "maternity-wedding-dresses-under-100",
    "maternity-wedding-dresses-cheap",
    "designer-maternity-evening-dresses",
    "cheap-maternity-wedding-dresses"
}


function IsInTable(value, tbl)
    for k,v in ipairs(tbl) do
        if v == value then
            return true;
        end
    end
    return false;
end

local function check_uri(uri)
    if IsInTable(uri, rewrite_area) then
        return true
    else
        return false
    end
end

local result = check_uri(uri)

if result == false then
    ngx.req.set_uri( uri .. "l", true)
end