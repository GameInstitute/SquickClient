-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-02
-- Description: 将Actor 的BeginPlay, Tick, EndPlay 绑定在Game Instance 事件上。 对应蓝图为: /Blueprints/InstanceEventActor
-- 想进行事件通知Game Instance 的，由 Game Mode 丢在场景中
-----------------------------------------------------------------------------


local M = UnLua.Class()
function M:Initialize()

end

function M:ReceiveBeginPlay()
    if GameInstance then
        GameInstance:BeginPlay()
    end
end

function M:ReceiveTick(deltaSeconds)
    -- 保持连接
    if GameInstance then
        GameInstance:Tick(deltaSeconds)
    end
    
end

function M:ReceiveEndPlay()
    if GameInstance then
        GameInstance:EndPlay()
    end
end

return M