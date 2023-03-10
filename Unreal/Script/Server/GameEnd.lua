-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-08
-- Description: 游戏战斗结果以及状态反馈
-----------------------------------------------------------------------------
GameEnd = Object({})


function GameInit:Create(NetClient)
    self.netClient = NetClient
end
