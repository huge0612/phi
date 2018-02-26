--
-- Created by IntelliJ IDEA.
-- User: yangyang.zhang
-- Date: 2018/1/17
-- Time: 18:02
-- 预加载所有允许使用的mapper，不建议使用需要解析请求体的api，这会增加额外的开销
--
local _M = {}
local mt = { __index = _M }
local LOGGER = ngx.log
local DEBUG = ngx.DEBUG
local ERR = ngx.ERR

function _M:new(config)
    if type(config) == "table" then
        for _, name in ipairs(config) do
            name = name:lower()
            LOGGER(DEBUG, "[MAPPER_HOLDER]加载:" .. name)
            local mapper = require("core.mapper." .. name .. "_mapper")
            _M[name] = mapper
        end
    else
        config = config:lower()
        LOGGER(DEBUG, "[MAPPER_HOLDER]加载:" .. config)
        local mapper = require("core.mapper." .. config .. _mapper)
        _M[config] = mapper
    end
    return setmetatable({}, mt)
end

function _M:map(ctx, typeStr, tag)
    if type(ctx) ~= "table" or type(typeStr) ~= "string" then
        LOGGER(ERR, "ctx参数不正确？")
    end
    local mapper = self[typeStr]
    if not mapper then
        return nil, "未查询到可用的mapper:" .. typeStr
    end
    return mapper.map(ctx, tag)
end

return _M

