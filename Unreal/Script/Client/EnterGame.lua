-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-04
-- Description: 初次登录游戏后 初始化
-----------------------------------------------------------------------------

EnterGame = Object({})

function EnterGame:Create(NetClient)
    self.netClient = NetClient
    self.netClient:RegisteredDelegation(EGameMsgID.ACK_GAME_LAG_TEST, self.OnAckGameLagTest, self)
    self.netClient:RegisteredDelegation(EGameMsgID.ACK_ENTER_GAME, self.OnAckEnterGame, self)
    self.netClient:RegisteredDelegation(EGameMsgID.ACK_ENTER_GAME_FINISH, self.OnAckEnterGameFinish, self)
    self.netClient:RegisteredDelegation(123, self.OnAckTest, self)
end

-- 请求进入游戏
function EnterGame:OnReqEnterGame()
    local index = 1
    print("请求进入游戏")
    local req = {
        id = GameInstance.Login.cache.roleList[index].id,
        account = GameInstance.Login.cache.account,
        game_id = GameInstance.Login.cache.game_id,
        name = GameInstance.Login.cache.roleList[index].noob_name,
    }
    self.netClient:SendPB(EGameMsgID.REQ_ENTER_GAME, "SquickStruct.ReqEnterGameServer", req )
end

function EnterGame:OnAckGameLagTest(data)
    local ack = assert(pb.decode("SquickStruct.ReqAckLagTest", data))
    --print_table(ack)
    print("Game服务器心跳包: " .. tostring(ack.index))
end

function EnterGame:OnAckTest(data)
    print("测试接收: " .. pb.tohex(data))
    print("测试大小: " .. #data)
    -- 测试发送
    print("测试发送: " .. #data)
    self.netClient:SendData(1234, "你好啊" )
end

function EnterGame:OnAckEnterGame(data)
    local ack = assert(pb.decode("SquickStruct.AckEventResult", data))
    print_table(ack)

    if ack.event_code == "SUCCESS" then
        print("成功进入游戏")
        -- 成功进入游戏后，需要将包的 guid 设置为服务器分发的

        local guid = Guid.New()
        guid.nHead64 = ack.event_object.svrid
        guid.nData64 = ack.event_object.index
        self.netClient.guid = guid
        GameInstance:OnEnterGame()
    else
        print("进入游戏失败")
    end

    
end

function EnterGame:OnReqEnterGameFinish()
    
end

function EnterGame:OnAckEnterGameFinish(data)
    
end

function EnterGame:OnReqGetRoleInfo()
    
end

-- 获取角色列表
function EnterGame:OnAckRoleList()
    
end

-- 加载角色数据
function EnterGame:OnAckLoadRoleData(data)
    
end
