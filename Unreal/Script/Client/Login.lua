-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-01
-- Description: 登录模块
-----------------------------------------------------------------------------


ClientLogin = Object({})

function ClientLogin:Create(NetClient)
    self.netClient = NetClient
    self.netClient:RegisteredDelegation(EGameMsgID.ACK_LOGIN, self.OnAckLogin, self)
    self.netClient:RegisteredDelegation(EGameMsgID.ACK_CONNECT_KEY, self.OnAckVerifyConnectKey, self)
    self.netClient:RegisteredDelegation(EGameMsgID.ACK_SELECT_SERVER, self.OnAckSelectServer, self)
    self.netClient:RegisteredDelegation(EGameMsgID.ACK_WORLD_LIST, self.OnAckGameServerList, self)
    self.netClient:RegisteredDelegation(EGameMsgID.ACK_ROLE_LIST, self.OnAckRoleList, self)
    self.cache = {
        account = "none",
        password = "",
        security_code = "test",
        signBuff = "",
        clientVersion = 0,
        clientMAC = 0,
        device_info = "VRShoot",
        extra_info = "",
        platform_type = 0,
        game_id = 0, -- 游戏服务器 ID
        playerId = nil,
        verifyedSrverId = nil,
        roleList = nil,
    }
    self.isLogin = false
    self.currentGameServerId = 0
end

-- 后面通过向服务器发包检测是否已经登录
function ClientLogin:CheckIsLogin()
    return self.isLogin
end

-- 先进行登录，登录后获取连接Key, 登录系统看需求情况
function ClientLogin:OnReqLogin()
    
end

function ClientLogin:OnAckLogin(data)
    
end

function ClientLogin:OnReqVerifyConnectKey(account)
    Screen.Print("登录用户: " .. account)
    if self:CheckIsLogin() then
        print("已经登录过了")
        GameInstance:UIShow_GameMode()
        return
    end

    -- 获取连接的key
    local loginData = {
        account = account,
        password = self.cache.security_code,
        security_code = self.cache.security_code,
        signBuff = "",
        clientVersion = self.cache.clientVersion,
        loginMode = ELoginMode.ELM_AUTO_REGISTER_LOGIN,
        clientIP = 0,
        clientMAC = self.cache.clientMAC,
        device_info = self.cache.device_info,
        extra_info = self.cache.extra_info,
        platform_type = self.cache.platform_type,
    }
    self.cache.account = account
    print("验证Key中")
    self.netClient:SendPB(EGameMsgID.REQ_CONNECT_KEY, "SquickStruct.ReqAccountLogin", loginData )
end

function ClientLogin:OnAckVerifyConnectKey(data)
    local ack = assert(pb.decode("SquickStruct.AckEventResult", data))
    print("event_code", ack.event_code, type(ack.event_code))
    if "VERIFY_KEY_SUCCESS" == ack.event_code then
        print("验证key成功")
        local guid = Guid.New()
        guid.nHead64 = ack.event_client.svrid
        guid.nData64 = ack.event_client.index
        self.cache.verifyedSrverId = guid
        --self.netClient.guid = guid -- 验证成功后设置网络GUID
        -- 通知
        self.isLogin = true
        GameInstance:OnVerifyConnectKeySecsuss()
        
    else
        print("验证key失败")
    end
    
    print_table(ack)
end


-- 获取游戏服务器列表
function ClientLogin:OnReqGameServerList()
    print("选择服务游戏服务器")
    local data = {
        type = ReqServerListType.RSLT_GAMES_ERVER -- 获取Game Server 列表
    }
    self.netClient:SendPB(EGameMsgID.REQ_WORLD_LIST, "SquickStruct.ReqServerList", data )
end

function ClientLogin:OnAckGameServerList(data)
    print("OnAckGameServerList")
    local ack = assert(pb.decode("SquickStruct.AckServerList", data))
    GameInstance:OnAckGameServerList(ack)
end

-- 选择游戏服务器
function ClientLogin:OnReqSelectServer(serverId)
    print("选择服务服务器")
    self.cache.game_id = serverId
    local data = {
        world_id = serverId -- PVP Server ID
    }
    self.netClient:SendPB(EGameMsgID.REQ_SELECT_SERVER, "SquickStruct.ReqSelectServer", data )
end

-- 获取角色列表，角色选择一个，才能进入游戏服务器
function ClientLogin:OnReqRoleList()
    local req = {
        game_id = self.cache.game_id,
        account = self.cache.account,
    }
    print_table(req)
    print("请求获取角色列表")
    self.netClient:SendPB(EGameMsgID.REQ_ROLE_LIST, "SquickStruct.ReqRoleList", req )
end

function ClientLogin:OnAckRoleList(data)
    print("获取角色列表成功 -------------------")
    local ack = assert(pb.decode("SquickStruct.AckRoleLiteInfoList", data))
    GameInstance:OnRoleListSuccess(ack)
end

function ClientLogin:OnReqCreateRole(name)
    print("创建角色, account: ", self.cache.account)
    local req = {
        account = self.cache.account,
        career = 1,
        sex = 1,
        race = 0,
        noob_name = name
    }
    self.netClient:SendPB(EGameMsgID.REQ_CREATE_ROLE, "SquickStruct.ReqCreateRole", req )
end

function ClientLogin:OnAckSelectServer(data)
    local ack = assert(pb.decode("SquickStruct.AckEventResult", data))
    --print("event_code", ack.event_code, type(ack.event_code))
    if "SELECTSERVER_SUCCESS" == ack.event_code then
        GameInstance:OnSelectGameServerSuccess()
        -- 通知
    else
        print("选择服务器失败")
    end

    --GameInstance.Room:OnReqRoomCreate("test")
    print_table(ack)
end