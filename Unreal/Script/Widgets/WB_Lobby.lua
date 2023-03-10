-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-02-09
-- Description: 绑定: Lobby/Widgets/WB_Lobby 蓝图
-----------------------------------------------------------------------------

---@type WB_Lobby_C
local M = UnLua.Class()

function M:Construct()
	GameInstance.Widgets.Lobby = self
	GameInstance.Widgets.Lobby.RoomList = {}
	self.Overridden.Construct(self)
	GameInstance.Room:RegisteredEventHandler(ClientRoomEvent.ACK_ROOM_LIST, self.AckFrashRoomList, self)
	GameInstance.Room:RegisteredEventHandler(ClientRoomEvent.ACK_ROOM_JOIN, self.AckRoomJoin, self)

	self.TabButton_SearchGame.OnClicked:Add(self, M.OnClicked_TabButton_SearchGame)
	self.Button_PvpMode.OnClicked:Add(self, M.OnClicked_Button_PvpMode)
	GameInstance.Room:RegisteredEventHandler(ClientRoomEvent.ACK_ROOM_CREATE, self.CreateRoom, self)

	self.ButtonRoom_StartOrPrepare.OnClicked:Add(self, M.OnClicked_ButtonRoom_StartOrPrepare)
	self.ButtonRoom_Back.OnClicked:Add(self, M.OnClicked_ButtonRoom_Back)
end

-- 寻找游戏
function M:OnClicked_TabButton_SearchGame()
	print("寻找游戏")
	self:ClearRoomList()
	GameInstance.Room:OnReqRoomList()
end

function M:AckFrashRoomList(data)
	print("Room List.....")
	print_table(data)
	
	for key, value in pairs(data.list) do
		local info = "房间号: " .. value.id .. " 名称: " .. value.name  .. " 玩家:" .. value.nplayers .. " / " .. value.max_players .. "staus: " .. value.status
		self:AddRoomItem(value.id, info)
	end
end

function M:AddRoomItem(roomId, str)
	local widget_class = UE.UClass.Load("/Game/Lobby/Widgets/Buttons/WB_ListButton.WB_ListButton_C")
	local widget = NewObject(widget_class, self)
	-- 只能增加了之后才真正创建UMG对象
	self.VerticalBox_RoomListPanel:AddChildToVerticalBox(widget)
	widget:Init(roomId)
	widget:SetText(str)
end


function M:AckRoomJoin(data)
	if data.code ~= 0 then
		print("加入失败")
		return
	end
	GameInstance.Room.currentRoomId = GameInstance.Room.reqRoomId
	self.Switcher:SetActiveWidgetIndex(1) -- 显示房间信息
end


-- PVP模式
function M:OnClicked_Button_PvpMode()
    print("PVP 模式 ")
    GameInstance.Room:OnReqRoomCreate(" PVP 房间 ", 1) -- 房间名称与 地图id
end

function M:CreateRoom(data)
    print_table(data)
    if data.code == 0 then
        self.Switcher:SetActiveWidgetIndex(1) -- 显示房间信息
        print("创建房间成功: 房间ID: " .. tostring(data.room_id))
        GameInstance.Room.isOwner = true
        GameInstance.Room.currentRoomId = data.room_id
    else
        print("创建房间失败")
    end
end


-- 点击开始游戏或准备游戏
function M:OnClicked_ButtonRoom_StartOrPrepare()
    if GameInstance.Room.isOwner == true then
        GameInstance.Room:OnReqStartGame(GameInstance.Room.currentRoomId)
    else
        -- 加入游戏
        GameInstance.Room:OnReqPvpGameJoin(GameInstance.Room.currentRoomId)
    end
end

-- 退出房间
function M:OnClicked_ButtonRoom_Back()
    print("退出房间")
    if GameInstance.Room.isOwner == true then
        
    end
	self.Switcher:SetActiveWidgetIndex(0)
end


return M