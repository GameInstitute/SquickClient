-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-02
-- Description: 网络管理器，用于监听Protobuf消息事件以及Protobuf消息发送，动态绑定事件与解除等
-----------------------------------------------------------------------------

NetHeader = Object({})

function NetHeader:Create()
    self.id = 0
    self.size = 0
    self.data = nil
end

function NetHeader:Reset()
    self.id = 0
    self.size = 0
    self.data = nil
end

-- ref: https://www.cfanzp.com/lua-string-pack/
-- ref: https://blog.csdn.net/beyond706/article/details/105949783
-- 采用大端字节序进行编码解码，目前还是小端，之后整改
function NetHeader:Encode()
    -- 采用大端来进行包裹
    self.data = string.pack(">I2", self.id) .. string.pack(">I4", self.size)
    return self.data
end

function NetHeader:Decode()
    self.id = string.unpack(">I2", self.data, 1)
    self.size = string.unpack(">I4", self.data, 3)
    return true
end

NetState = {
    Connecting = 0,
    Connected = 1,
    Disconnected = 2,
}

NetEventType = {
    None = 0,
    Connected = 1,
    Disconnected = 2,
    ConnectionRefused = 3,
    DataReceived = 4,
}


-- NetClient 采用Game Instance来创建的，之后再绑定在 TcpClient Actor之上，再切换场景的时候 TcpClient会销毁断开连接，切换完毕后，继续绑定在该对象上，重新自动会与服务器建立连接。
NetClient = Object({})


function NetClient:Create()
    self.delegations = {}
    self.netEventHandlers = {}
    self.guid = Guid.New()
    self.isLogined = false
    self.heartBeatIndex = 0
    self.isConnected = false
    self.evnetType = NetEventType.None
    self.events = nil
    self.isReceivedAll = true
    self.isReceivedHeader = false
    self.cacheData = ''
    self.cacheSize = 0

    self:RegisteredDelegation(EGameMsgID.ACK_GATE_LAG_TEST, self.OnAckHeartBeat, self)
end

-- 包裹最基本的包体
function NetClient:SendData(msgId, data)
    local ident = {
        svrid = self.guid.nHead64,
        index = self.guid.nData64
    }
    --print("servi: ", ident.svrid, "  index: ", ident.index)
    
    local msgBase = {
        player_id = ident,
        msg_data = data,
        player_Client_list = nil,
        hash_ident = nil,
    }
    local bytes = assert(pb.encode("SquickStruct.MsgBase", msgBase))
    local header = NetHeader.New()
    header.id = msgId
    header.size = #bytes + 6 -- 包的总大小: 包头 和 包体
    local sendBytes = header:Encode() .. bytes
    --Screen.Print("SendData: MsgID" .. tostring(msgId) .. "  " .. pb.tohex(sendBytes) )
    print("发送数据: " .. pb.tohex(sendBytes))
    self.client:SendData(sendBytes)
    self.cacheData = ''
    self.cacheSize = 0
end
-- TCP层面发送数据
function NetClient:SendRaw(data)
    
    self.client:SendData(data)
end

-- 最常用接口，提供msgid, protobuf结构体名称， 还有对应的 table 值即可
function NetClient:SendPB(msgId, pkg, tb)
    local data =  assert(pb.encode(pkg, tb))
     self:SendData(msgId,data)
end

-- 双向绑定
function NetClient:BindClient(client)
    self.client = client
    self.client:BindNetClient(self)
end

function NetClient:OnConnected()
    self.heartBeatIndex = 0
    self.isConnected = true
    local handler = self.netEventHandlers[NetEventType.Connected]
    if  handler then
        handler.callback(handler.this)
    end
end

function NetClient:OnDisconnected()
    self.isConnected = false
    local handler = self.netEventHandlers[NetEventType.Disconnected]
    if  handler then
        handler.callback(handler.this)
    end
end

function NetClient:OnConnectionRefused()
    self.isConnected = false
end

function NetClient:Connect(ip, port)
    print("wanna connect to " .. ip .. tostring(port))
    self.client:Connect(ip, port)
end

-- 只进行事件通知，不提供数据
function NetClient:OnDataReceived(data)

    local ret = self:UnpackMsg(data)
    if ret == 0 then -- 收到完整包
        --print("收到完整包")
    elseif ret == 1 then -- 收到分包
        print("收到分包, 等待完成接收")
    elseif ret == 2 then -- 收到粘包
        print("收到粘包, 已拆解完毕")
    elseif ret == 3 then
        print("收到粘包, 部分包拆解失败")
    elseif ret == 4 then
        print("收到粘包, 包量过大，已丢弃部分包") 
    elseif ret == 5 then
        print("收到粘包, 最后一个包存在分包, 等待接收") 
    else -- 
        print("未知错误")
    end
    
end

function NetClient:UnpackMsg(data)
    print("DataReceived data: " .. pb.tohex(data)  )
    -- 头部不完整，继续接受6字节的头部
    if self.isReceivedHeader == false then
        if #data == 6 then
            self.cacheData = data
            self.isReceivedHeader = true
            self.isReceivedAll = false
            --print("收到头部")
            return 1
        end

        if #data < 6 then
            --print("头部不完整")
            self.cacheData = data
            return
        elseif #data > 5  then
            -- 存在头部
            self.isReceivedHeader = true
        elseif self.cacheData then
            if #self.cacheData + #data > 5 then
               -- print("存在头部")
                self.isReceivedHeader = true
            end
        else
            --print("头部未接收完毕")
            self.cacheData = self.cacheData .. data
        end
    end

    -- 分包处理
    if self.isReceivedAll == false then
        -- 如果接收分包总时间大于5秒，将其该全部丢弃掉
        -- 分包处理
        local data_size = #data

        local cache_data_size = #self.cacheData

        if data_size + cache_data_size == self.cacheSize then
            -- 接收分包完成
            self.isReceivedAll = true
            self.cacheData = self.cacheData .. data
            local id = string.unpack(">I2", self.cacheData, 1)
            local bytes = assert(pb.decode("SquickStruct.MsgBase", string.sub(self.cacheData, 7, -1)))
            --print("收到完整,调用: ", id)
            self:OnMessageEvent(id, bytes.msg_data)
            self.isReceivedAll = true
        elseif data_size + cache_data_size > self.cacheSize then
            self.cacheData = self.cacheData .. data
            -- 收到的数据多余，直接丢改下面进行处理
            local id = string.unpack(">I2", self.cacheData, 1)
            local body = string.sub(self.cacheData, 7, self.cacheSize)
            local bytes = assert(pb.decode("SquickStruct.MsgBase", body))
            --print("收到多余,调用: ", id)
            self:OnMessageEvent(id, bytes.msg_data)
            
            -- 将剩余的直接交给下面处理
            data = string.sub(self.cacheData, self.cacheSize + 1, -1)
            self.isReceivedAll = true
        else
            -- 继续接收分包
            self.cacheData = self.cacheData .. data
        end
    end

    -- 头部还不完整
    if #data < 6 then
        --print("头部不完整")
        self.cacheData = data
        self.isReceivedHeader = false
        return
    end

    -- 拆解头部
    local id = string.unpack(">I2", data, 1)
    local size = string.unpack(">I4", data, 3)

    
    if size == #data then
        self.isReceivedAll = true
        local bytes = assert(pb.decode("SquickStruct.MsgBase", string.sub(data, 7, -1)))
        self:OnMessageEvent(id, bytes.msg_data)
        return 0
    end
    
    -- 还存在，部分数据未接收，等待5秒接收完毕
    --print("收到包含头部的分包 或 出现粘包情况 header_size: ", size, "  net pakage size:", #data)
    if size > #data then
        --print("出现分包", data)
        self.cacheData = data
        self.cacheSize = size
        self.isReceivedAll = false
        return 1
    else
        --print("出现粘包", data)
        for i=1, 1000 do -- 最多一次拆解1000个包，其余丢弃
            local pak = string.sub(data, 1, size)
            local left_data = string.sub(data, size + 1, #data)

            if left_data == nil then
                return 3
            end

            if #pak == size then
                --print("分包调用: ", id, " size: ", #pak)
                local bytes = assert(pb.decode("SquickStruct.MsgBase", string.sub(pak, 7, -1)))
                self:OnMessageEvent(id, bytes.msg_data)
            end

            id = string.unpack(">I2", left_data, 1)
            size = string.unpack(">I4", left_data, 3)
            if size == #left_data then -- 最后一个包
                --print("分包最后一个调用: ", id, " size: ", #left_data)
                self.isReceivedAll = true
                self.cacheSize = 0
                local bytes = assert(pb.decode("SquickStruct.MsgBase", string.sub(left_data, 7, -1)))
                self:OnMessageEvent(id, bytes.msg_data)
                return 2
            elseif size > #left_data then
                -- 分包
                self.cacheData = left_data
                self.cacheSize = size
                self.isReceivedAll = false
                
                return 5
            else 
                -- 还存在粘包，继续拆解
                data = left_data
            end
        end
        return 4
    end
    
    return -1

end


-- 每3秒由 Client 进行调用
function NetClient:OnHeartBeat()
    self.heartBeatIndex = self.heartBeatIndex + 1
    --Screen.Print("心跳包: " )
    if self.isLogined == false then
        self:SendData(EGameMsgID.REQ_LAG_TEST, assert(pb.encode("SquickStruct.ReqAckLagTest", { index = self.heartBeatIndex})))
    end
end

-- 服务端返回
function NetClient:OnAckHeartBeat(data)
    --Screen.Print("心跳包返回: " )
end

-- 由 Client 进行Tick调用
function NetClient:Tick()
    
end


-- 收到消息
function NetClient:OnMessageEvent(msgId, data)
    if self.delegations[msgId] == nil then
        print("不存在该Msg, msg id: " .. tostring(msgId))
        --print("data: ", data)
        return
    end
    local delegation = self.delegations[msgId]
    delegation.callback(delegation.this, data)
end


function NetClient:RegisteredNetEventHandler(event, callback, this)
    self.netEventHandlers[event] = { callback = callback, this = this }
end

-- 注册
function NetClient:RegisteredDelegation(msgId, callback, this)
    if msgId == nil then
        print("MsgID == nil", this)
        dump(this, " NetClient:RegisteredDelegation")
        --print_table(this)
    end
    
    self.delegations[msgId] = { callback = callback, this = this }
end

function NetClient:RemoveDelegation(msgId)
    self.delegations[msgId] = nil
end
