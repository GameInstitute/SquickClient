require("Net.Net")


local netHeader = NetHeader.New()
netHeader.id = 0x4141
netHeader.size = 0x42434445
local data = netHeader:Encode()
print("NetHeader encode data: ", data, "  ", type(data))

netHeader.data = '\x01\x00\x01\x01\x00\x00'
netHeader:Decode()
print("NetHeader decode data:", netHeader.id , netHeader.size)

