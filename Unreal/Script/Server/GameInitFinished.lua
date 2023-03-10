-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-16
-- Description: 关卡加载初始化成功后，反馈信息给Game服务器，通知房间内玩家加入游戏
-----------------------------------------------------------------------------

local M = UnLua.Class()
function M:Initialize()

end

function M:ReceiveBeginPlay()
    -- 执行蓝图里的 BeginPlay
    self.Overridden.ReceiveBeginPlay(self) 
end

-- 初始化完成
function M:InitFinished(port)
    GameInstance.GameInit:OnReqPvpGameInitFinished(port)
end


function M:ReceiveEndPlay()

end

return M