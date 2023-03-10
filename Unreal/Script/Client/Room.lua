-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-03
-- Description: 房间模块
-----------------------------------------------------------------------------
ClientRoomEvent = {
    ACK_ROOM_CREATE = 1,
    ACK_START_PVP_GAME = 2,
    ACK_ROOM_JOIN = 3,
    ACK_ROOM_LIST = 4,
}

ClientRoom = Object({})

function ClientRoom:Create(NetClient)
    self.netClient = NetClient
    self.netClient:RegisteredDelegation(EGameMsgID.ACK_ROOM_CREATE, self.OnAckRoomCreate, self)
    self.netClient:RegisteredDelegation(EGameMsgID.ACK_ROOM_LIST, self.OnAckRoomList, self)
    self.netClient:RegisteredDelegation(EGameMsgID.ACK_ROOM_JOIN, self.OnAckRoomJoin, self)
    self.netClient:RegisteredDelegation(EGameMsgID.ACK_START_PVP_GAME, self.OnAckPvpGameStart, self)
    self.netClient:RegisteredDelegation(EGameMsgID.ACK_PVP_GAME_JOIN, self.OnAckPvpGameJoin, self)
    
    self.eventHandlers = {}
    self.isOwner = false
    self.currentRoomId = -1
    self.reqRoomId = -1
end

-- 选择为 pvp 服务器，让代理服务器能够转发数据到 proxy 服务器
function ClientRoom:ReqSelectServer()
   
end

-- 创建房间请求
function ClientRoom:OnReqRoomCreate(name, map_id)
    print("测试创建房间")
    local req = {
        name = name,
        map_id = map_id,
    }
    self.netClient:SendPB(EGameMsgID.REQ_ROOM_CREATE, "SquickStruct.ReqRoomCreate", req )
end


-- 创建房间返回, 创建房间时，并不启动对战服务器，点击开始游戏才启动对战服务器
function ClientRoom:OnAckRoomCreate(data)
    print(" ClientRoom:OnAckRoomCreate 返回 " .. data)
    local ack = assert(pb.decode("SquickStruct.AckRoomCreate", data))
    print_table(ack)
    self:CallEvent(ClientRoomEvent.ACK_ROOM_CREATE, ack)
end

function ClientRoom:CallEvent(event, data)
    if self.eventHandlers[event] == nil then
        print("不存在该 Event, event id: " .. tostring(event))
        return
    end
    local handler = self.eventHandlers[event]
    handler.callback(handler.this, data)
end

-- 创建房间请求
function ClientRoom:OnReqRoomList()
    print("获取房间列表")
    local req = {
        start = 0,
        limit = 10,
    }
    self.netClient:SendPB(EGameMsgID.REQ_ROOM_LIST, "SquickStruct.ReqRoomList", req )
end

-- 创建房间返回, 创建房间时，并不启动对战服务器，点击开始游戏才启动对战服务器
function ClientRoom:OnAckRoomList(data)
    local ack = assert(pb.decode("SquickStruct.AckRoomList", data))
    self:CallEvent(ClientRoomEvent.ACK_ROOM_LIST, ack)
end

-- 开始游戏, 在服务端创建上创建pvp服务器
function ClientRoom:OnReqStartGame(roomId)
    print("测试开始游戏, 房间ID: " .. tostring(roomId))
    local req = {
        room_id = roomId,
    }
    self.netClient:SendPB(EGameMsgID.REQ_START_PVP_GAME, "SquickStruct.ReqStartPvpGame", req )
end


-- 开始游戏返回
function ClientRoom:OnAckPvpGameStart(data)
    print("开始游戏返回，等待服务器初始化中 ")
end

-- 进入PVP服务器
function ClientRoom:OnAckPvpGameJoin(data)
    print("正式开始游戏，即将进入PVP服务器")
    local ack = assert(pb.decode("SquickStruct.AckPvpGameJoin", data))
    print_table(ack)
    if ack.server.port == 0 then
        print("服务端未初始化，进入失败")
        return
    end
    local level = ack.server.ip .. ":" .. tostring(ack.server.port)
    GameInstance:LoadLevel(level)
end


-- 加入房间请求
function ClientRoom:OnReqRoomJoin(roomId)
    self.reqRoomId = roomId
    print("请求加入房间: " .. roomId)
    local req = {
        room_id = roomId,
    }
    self.netClient:SendPB(EGameMsgID.REQ_ROOM_JOIN, "SquickStruct.ReqRoomJoin", req )
end


-- 加入房间返回, 加入成功返回其他玩家所有数据
function ClientRoom:OnAckRoomJoin(data)
    print("响应加入房间")
    local ack = assert(pb.decode("SquickStruct.AckRoomJoin", data))
    print_table(ack)
    self:CallEvent(ClientRoomEvent.ACK_ROOM_JOIN, ack)
end

-- 房间内事件：包含玩家加入、玩家退出、玩家整选装备
function ClientRoom:OnAckRoomEvent()
    
end

-- 请求加入游戏
function ClientRoom:OnReqPvpGameJoin(roomId)
    
    print("请求加入游戏: " .. roomId)
    local req = {
        room_id = roomId,
    }
    self.netClient:SendPB(EGameMsgID.REQ_PVP_GAME_JOIN, "SquickStruct.ReqPvpGameJoin", req )
end


function ClientRoom:RegisteredEventHandler(event, callback, this)
    self.eventHandlers[event] = { callback = callback, this = this }
end


function ClientRoom:IsOwner()
    return self.isOwner
end