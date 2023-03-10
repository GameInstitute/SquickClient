-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-02
-- Description: 绑定的蓝图为 Blueprints/Net/TcpClient
-- 每个场景只能有一个Tcp Client Actor，之后可能还需根据这个TCP插件将Actor模式整改为单例模式
-- 避免在切换场景时多线程创建与销毁，网络连接又断开的情况。
-----------------------------------------------------------------------------

local M = UnLua.Class()
require("Common.TArrayUtil")

TcpClient = nil

local Screen = require "Common.Screen"
-- 提供 send()
function M:Initialize()
    self.netClient = nil
    self.connectionId = -1
    self.ip = ''
    self.port = 0
    -- 将自己绑定在Game Instance之上, 这样就不用通过类来查找了
    TcpClient = self
end

function M:ReceiveBeginPlay()
    -- 每秒发送一次跳心包或检测网络状态
    self.TimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({ self, self.OnTimer }, 3, true)
end

function M:Connect(ip, port)
    self.ip = ip
    self.port = port
    self:TcpConnect(ip, port)
end

function M:BindNetClient(netClient)
    self.netClient = netClient
end

function M:OnDisconnected(connectionId)
    Screen.Print("断开连接: id " .. tostring(connectionId))
    self.connectionId = -1
end

function M:OnConnected(connectionId)
    Screen.Print("连接成功: id " .. tostring(connectionId))
    self.connectionId = connectionId
    if self.netClient then
        self.netClient:OnConnected()
    end
end

-- 网络定时器，定时发送跳心包
function M:OnTimer()
    if self.connectionId == -1 and self.port ~= 0 then
        self:TcpConnect(self.ip, self.port)
        Screen.Print("重新连接服务器 ... ")
        return
    end

    if self.netClient then
        self.netClient:OnHeartBeat()
    end
end

function M:SendData(data)
    if self.connectionId == -1 then
        print("未连接服务器，发送失败")
        return
    end
    self:Send(self.connectionId, StringToTArray(data))
end


function M:OnReceived(connectionId, data)
    -- 解包
    if self.netClient then
        self.netClient:OnDataReceived(TArrayToString(data))
    end
end

return M