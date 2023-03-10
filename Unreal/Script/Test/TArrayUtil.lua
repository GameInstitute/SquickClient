-- Test Tarray Unti.lua


require("Common.TArrayUtil")


local array = UE.TArray(0)
array:Add(0)
array:Add(1)
array:Add(2)
array:Add(0x41)

local str = TArrayToString(array)
local array2 = StringToTArray(str)

print("array1: ", DumpTArray(array))
print("array2: ", DumpTArray(array2))



str = 'ABCDEFGdasdfasdfasdfasdfasdfasdfasdf'
local array3 = StringToTArray(str)
print("array3: ", DumpTArray(array3))

