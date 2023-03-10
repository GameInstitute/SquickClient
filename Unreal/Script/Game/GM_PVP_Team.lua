-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-02-10
-- Description: GM_PVP_Team.lua
-----------------------------------------------------------------------------


local M = require "GM_GameBase"

function M:ReceiveBeginPlay()
    self.Base.ReceiveBeginPlay(self)
    print("GM_GameChild")
end


function M:ReceiveTick(deltaSeconds)
    self.Base.ReceiveTick(self)
end


return M