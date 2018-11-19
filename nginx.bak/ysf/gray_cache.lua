local _M = {}

local config = nil
local update_time = nil

function update_by_http()
    local http = require "resty.http"
    local url = "http://10.201.48.24/inner/gray/config"

    local time_out = 20
    if not config then
        time_out = 100
    end
    local httpc = http.new()
    httpc:set_timeout(time_out)
    local res, err = httpc:request_uri(url, {
        method = "GET"
    })

    -- if not res then
        -- write_log("http request failed, err:" .. err)
    -- end

    -- write_log("http code:" .. res.status .. " result:".. res.body)

    update_time=ngx.now()
    if (res ~= nil and res.status == 200) then
        config = res.body
    end
end

function _M.get_config()
    -- cache config for 500 ms
    if ((not config) or (not update_time) or (ngx.now() - update_time > 0.5)) then
            update_by_http()
    end

    return config
end

return _M
