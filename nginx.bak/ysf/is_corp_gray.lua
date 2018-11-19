local cache = require "gray_cache"
local config = cache.get_config()
----------- config format ---------
-- #appkey=appkey1#appkey=appkey2##code=code1#code=code2##corpid=corpid1#corpid=corpid2##appid=appid1#appid=appid2#
---------------------------------
local args = ngx.var.lua_args
if (args == nil or args == "") then
       local post_args, err = ngx.req.get_post_args()
    if not post_args then
        ngx.var.lua_args="appkey="
    else
        for key, val in pairs(post_args) do
            if (key == "appkey" or key == "k") then
                args = ("appkey="..val)
                break
            end
        end
     end
end

if ((config == nil) or (args == "") or (string.find(config, "#" .. args .. "#") == nil)) then
       ngx.var.gray = "0"
else
       ngx.var.gray = "1"
end
