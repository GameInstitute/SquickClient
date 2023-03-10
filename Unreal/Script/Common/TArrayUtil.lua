-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-01
-- Description: Unlua TArray 与 string 互相转换
-----------------------------------------------------------------------------

function TArrayToString(array)
    local ret = ''
    for i = 1, array:Length() do
        ret = ret .. string.pack("B", array:Get(i))
    end
    return ret
end


function StringToTArray(str)
    local array = UE.TArray(1)
    for c in str:gmatch"." do
        local num = string.unpack("B", c)
        array:Add(num)
    end
    return array
end


function DumpTArray(array)
    local ret = ''
    for i = 1, array:Length() do
        ret = ret .. string.format("%02X,", array:Get(i))
    end
    return "[" .. ret .. "]"
end
