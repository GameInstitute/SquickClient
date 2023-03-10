-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-16
-- Description: 测试Tcp
-----------------------------------------------------------------------------


require("Net.Tcp")
local tcp = Tcp.New()
-- local sock = assert(socket.connect(host, 80))
tcp:Connect("127.0.0.1", 15001)

--print("Test Net.Client")