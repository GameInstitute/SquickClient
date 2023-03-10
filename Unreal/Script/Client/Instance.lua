-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-04
-- Description: 客户端游戏单例
-----------------------------------------------------------------------------

require "Net.Client"
require "Net.Tcp"
require "Client.Login"
require "Client.Room"
require "Client.EnterGame"


-- 在Lua层面创建客户端 Instance 
function GameInstance:Init()
    self.NetClient = NetClient.New()
    self.Login = ClientLogin.New(self.NetClient)
    self.EnterGame = EnterGame.New(self.NetClient)
    self.Room = ClientRoom.New(self.NetClient)
    self.Tcp = Tcp.New()
    self.NetClient:BindClient(self.Tcp)

    self.isLogin = false
    self.NetClient:RegisteredNetEventHandler(NetEventType.Connected, self.OnNetConnected, self)
    self.NetClient:RegisteredNetEventHandler(NetEventType.Disconnected, self.OnNetDisConnected, self)
    self:EventBind()

    self.Widgets = { }

    -- 初始化完毕，连接服务器
    self:ConnectToServer()
end

function GameInstance:EventBind()
    
end

-- 第一次运行不会调用，由InstanceEventActor 来进行触发调用
function GameInstance:BeginPlay() 

end

--  连接代理服务器
function GameInstance:ConnectToServer()
    print("Connect to Server")
    self.NetClient:Connect(Servers.proxys[1].ip, Servers.proxys[1].port)

    print(self.TcpClient)
end

-- 网络连接成功
function GameInstance:OnNetConnected()
    print("OnNetConnected")
    -- 如果已经登录过，那么不用再次登录，直接通过token验证即可
    if self.isLogin == true then
        -- token 验证
    end
end

function GameInstance:OnNetDisConnected()
    print("OnNetDisConnected")
end


-- 获取到游戏服务器列表, 由登录系统进行调用
function GameInstance:OnAckGameServerList(servers)
    print_table(servers)
    -- server_id
    Servers.games = servers.info
    -- 选择服务器
    self.Login:OnReqSelectServer(Servers.games[1].server_id)
end



-- 选择服务器成功
function GameInstance:OnSelectGameServerSuccess()
    print("选择服务器成功")

    
    -- 获取当前游戏服角色列表
    --self.DelayEvent:Add(3, self.Login.OnReqRoleList, self.Login)
    self.Login:OnReqRoleList()
end

-- 获取角色列表成功
function GameInstance:OnRoleListSuccess(roleList)
    print("得到角色列表")
    -- 选择默认角色
    -- 没有角色，需要创建角色
    if roleList.char_data[1] == nil then
        print("没有角色, 自动创建默认角色")
        self.Login:OnReqCreateRole(self.Login.cache.account .. "_Role")
        return
    end
    -- 保存角色列表数据
    self.Login.cache.roleList = roleList.char_data

    print("进入游戏")
    -- 进入游戏
    --self.DelayEvent:Add(1, self.EnterGame.OnReqEnterGame, self.EnterGame, 1)
    self.EnterGame:OnReqEnterGame()
    -- -- 存在角色
    print_table(roleList)
end

-- 客户端进入游戏
function GameInstance:OnEnterGame()
    Screen.Print("成功进入游戏")
    
    -- 进入游戏
    self:LoadLevel("/Game/Maps/Lobby")
    --self:UIShow_GameMode()
end

-- 网络请求完毕通知
function GameInstance:OnReqFinished()
    
end

-- 连接成功
function GameInstance:OnVerifyConnectKeySecsuss()
    print("OnVerifyConnectKeySecsuss")

    -- 获取Game服务器列表
    self.Login:OnReqGameServerList()

    -- -- 选择PVP服务器
    -- self.Login:OnReqSelectServer(0) -- 0 代表由服务端进行分配
end

function GameInstance:OnNetDisconnected()
    
end

function GameInstance:Tick(deltaSeconds)
    if  self.Tcp ~= nil then
        self.Tcp:Tick()
    end
end

function GameInstance:EndPlay()
    
end

-----
