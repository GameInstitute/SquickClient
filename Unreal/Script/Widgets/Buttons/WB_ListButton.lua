-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-02-09
-- Description: 绑定: Lobby/Widgets/Buttons/WB_ListButton 蓝图
-----------------------------------------------------------------------------

local M = UnLua.Class()

function M:Construct()
	self.WB_TextButton.OnClicked:Add(self, M.OnClicked)
    self.roomId = -1
end

function M:Init(roomId)
    self.roomId = roomId
    GameInstance.Widgets.Lobby = self
    print(" Room : ", GameInstance.Widgets.Lobby.RoomList)
    --GameInstance.Widgets.Lobby.RoomList[roomId] = self
end

function M:OnClicked()
    GameInstance.Room:OnReqRoomJoin(self.roomId)
end

return M
