-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-04
-- Description: 延迟执行Lua
-----------------------------------------------------------------------------

Delay = Object({})

function Delay:Create()
    self.callbacks = {}
end

function Delay:Add(seconds, callback, arg1, arg2, arg3)
    if arg2 == nil then
        arg2 = 1
    end
    if arg3 == nil then
        arg3 = 2
    end
    self.callbacks[callback] = { endTime = seconds + os.time(), arg1 = arg1, arg2 = arg2, arg3 = arg3}
end

function Delay:Tick()
    for k, v in pairs(self.callbacks) do
        if v.endTime < os.time() then
            k(v.arg1, v.arg2, v.arg3) -- 调用
            self.callbacks[k] = nil
        end
    end
end