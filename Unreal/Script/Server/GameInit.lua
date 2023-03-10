-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-08
-- Description: 连接成功后，对游戏对局，玩家数据初始化
-----------------------------------------------------------------------------

GameInit = Object({})

function GameInit:Create(NetClient)
    print("Init Game Init: ", NetClient)
    self.netClient = NetClient

    self.netClient:RegisteredDelegation(ServerMsgId.ACK_PVP_GAME_INIT, self.OnReqAckPvpGameInit, self)
end

function GameInit:OnReqPvpGameInit()
    print("请求服务端游戏数据初始化... ")
    local req = {
        instance_id = ServerArgs.instance_id,
        instance_key = ServerArgs.instance_key,
        room_id = tonumber(ServerArgs.room_id),
    }
    self.netClient:SendPB(ServerMsgId.REQ_PVP_GAME_INIT, "SquickStruct.ReqPvpGameInit", req )
end

-- 获取房间内详细信息
function GameInit:OnReqAckPvpGameInit(data)
    print("数据初始化中...")
    local ack = assert(pb.decode("SquickStruct.RoomDetails", data))
    print_table(ack)
    --print("event_code", ack.event_code, type(ack.event_code))
    -- 进入场景
    GameInstance:LoadLevelAndListen(Maps[ack.map_id], ack.max_players)
end

function GameInit:OnReqPvpGameInitFinished(port)
    print("服务端初始化完成，绑定端口为: ", port)
    local req = {
        code = 0,
        instance_id = ServerArgs.instance_id,
        instance_key = ServerArgs.instance_key,
        room_id = ServerArgs.room_id,
        ip = ServerArgs.ip,
        port = port,
        name = ServerArgs.name,
    }
    self.netClient:SendPB(ServerMsgId.REQ_PVP_GAME_INIT_FINISHED, "SquickStruct.ReqPvpGameInitFinished", req )
end