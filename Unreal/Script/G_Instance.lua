-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-01
-- Description: Game Instance
-----------------------------------------------------------------------------

---@type G_Instance.lua
local M = UnLua.Class()
Screen = require "Common.Screen"
require "Enum"
require "Common.Init"
require "Test.Main"
require "Proto.Init"


-- 全局变量值，方便开发测试
IsServer = false -- 是否为服务器
IsDev = true -- 是否为开发模式

-- 部署平台
G_PlatformGroup = PlatformGruop.PC

--require "Test.Main"

_G["GameInstance"] = nil -- 将当前对象设置为全局单例对象


function M:ReceiveInit()
    self.Platform = G_PlatformGroup
    print("Platform: ", self.Platform)
end

-- 客户端初始化
function M:Lua_ClientInit()
    -- 客户端初始化
    GameInstance = self
    require("Client.Instance")
    GameInstance:Init()
end

-- 服务端初始化
function M:Lua_ServerInit(args)
    GameInstance = self
    Screen.Print("服务端初始化")
    require("Server.Instance")
    GameInstance:Init(args)
end

function M:ReceiveShutdown()
    print("GameInstance:ReceiveShutdown")
end

return M