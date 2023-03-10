-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-08
-- Description: PVP服务器登录模块，登录成功后，有权访问Game服务器
-----------------------------------------------------------------------------


ServerLogin = Object({})

function ServerLogin:Create(NetClient)
    self.netClient = NetClient
    self.netClient:RegisteredDelegation(ServerMsgId.ACK_CONNECT_GAME_SERVER, self.OnAckVerifyConnectKey, self)
    self.cache = {
    }
    self.isLogin = false
    self.currentGameServerId = 0
end

-- 后面通过向服务器发包检测是否已经登录
function ServerLogin:CheckIsLogin()
    return self.isLogin
end

function ServerLogin:OnReqVerifyConnectKey(account)

    print("验证key")
    -- 获取连接的key
    local req = {
        instance_id = "ssss";
        instance_key = "123",
        name = "test",
        security_code = "123",
        platform_type = 0,
        game_id = 16001, -- game 服务器id
    }
    print("验证Key中") --
    self.netClient:SendPB(ServerMsgId.REQ_CONNECT_GAME_SERVER, "SquickStruct.ReqConnectGameServer", req )
end

function ServerLogin:OnAckVerifyConnectKey(data)
    local ack = assert(pb.decode("SquickStruct.AckEventResult", data))
    print("event_code", ack.event_code, type(ack.event_code))
    if "VERIFY_KEY_SUCCESS" == ack.event_code then
        print("验证key成功")
        self.isLogin = true
        GameInstance:OnVerifyConnectKeySecsuss()

    else
        print("验证key失败")
    end
    --print_table(ack)
end
