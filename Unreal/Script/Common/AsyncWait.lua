-------------------------------------------------------------------------------
-- @file: async_wait.lua
-- @author: rickhan <317085872@qq.com>
-- @date: 2022/2/10
-- @desc: 仿c# async await
-------------------------------------------------------------------------------

local function step_to_next(thread, succeed, ...)
    local res = { coroutine.resume(thread, succeed, ...) }
    if coroutine.status(thread) ~= 'dead' then 
        res[2](function (...)
            step_to_next(thread, succeed, ...)
        end)
    else
        succeed(table.unpack(res, 2))
    end
end

function __async__(func)
    assert(type(func) == 'function', 'async params must be function')
    local res = { is_done = false, data = nil, cb = nil }
    step_to_next(coroutine.create(func), function (...)
        res.is_done = true
        res.data = {...}
        if res.cb ~= nil then
          res.cb(table.unpack(res.data))
        end
    end)

    return function (cb)
        if res.is_done then
          cb(table.unpack(res.data))
        else
          res.cb = cb
        end
    end
end

function __await__(async_cb)
    if type(async_cb) ~= 'function' then 
        error('param must be function!')
        return
    end
    return coroutine.yield(async_cb)
end

--[[
--example:
print('async_wait test')

local test_func = __async__(function ()
    local result1 = __await__(function (cb)
        timer_manager:delay_execute(function ()
            print('1000ms +++++++++++++++++')
            cb('await_return after 1000ms')
        end, 1000)
    end)

    local result2 = __await__(function (cb)
        timer_manager:delay_execute(function()
            print('500ms +++++++++++++++++')
            cb('await_return after 500ms')
        end, 500)
    end)

    return result1,result2
end)

local main_func = __async__(function ()
    local result1, result2 = __await__(test_func)
    print('result1=' .. result1 .. ',result2=' .. result2)
end)

main_func()
--]]