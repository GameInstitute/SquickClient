-- 利用lua的特性实现基础的面向对象


function Object(super)
    if type(super) ~= 'table' then
        error_log('super class must be table type')
        return nil
    end

    local inst = {}
    setmetatable(inst, {__index = super} )

    inst.super = super

    inst.__index = inst
    function inst.New(...) 
        local t = {}
        --update_table(t, inst)
        setmetatable(t, {__index = inst})
        if inst.Create then
            t:Create(...)
        end
        return t
    end

    return inst
end