-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-02-10
-- Description: GM_Server
-----------------------------------------------------------------------------

---@type GM_Server.lua
local M = UnLua.Class()
local Screen = require "Common.Screen"
-- function M:ReceiveBeginPlay()
--     self.Overridden.BeginPlay(self) 
--     -- 加载蓝图时，需要在尾部添加  .{name}_C 才能被加载进来
--     self.InstanceEventActor = UE.UClass.Load("/Game/Blueprints/InstanceEventActor.InstanceEventActor_C")
--     self:GenerateActor()
-- end

-- function M:GenerateActor()
--     UE.UAIBlueprintHelperLibrary.SpawnActorFromClass(self, self.InstanceEventActor, nil, UE.FVector(0, 0, 0), UE.FVector(0, 0, 0))
-- end

return M