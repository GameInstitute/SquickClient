-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-02-10
-- Description: GM_GameBase
-----------------------------------------------------------------------------

---@type GM_GameBase.lua
local M = UnLua.Class()
local Screen = require "Common.Screen"

function M:ReceiveBeginPlay()
    self.Overridden.ReceiveBeginPlay(self)
    local begin_timestamp = os.time()
    self.begin_timestamp = begin_timestamp
    self.last_player_join_timestamp = begin_timestamp
    self.nobody_destory_time = 120 -- 120秒内无人自行销毁实例
    self.max_game_time = 3600 -- 该局中游玩最长时间1小时
    self.nplayers = 0 -- 在线玩家
    self.is_game_over = false
    self.players = {} -- 所有玩家的Player Controller
    
    print("GameModeBase Begin")
end


function M:ReceiveTick(deltaSeconds)

    if self.is_game_over == true then
        return
    end
    local nowtime = os.time()
    if nowtime - self.begin_timestamp > self.max_game_time then
        self:GameOver()
    end

    if self.nplayers == 0 then
        if nowtime - self.last_player_join_timestamp > self.nobody_destory_time then
            self:GameOver()
        end
    end

end

function M:OnPlayerConnected(player_controller)
    Screen.Print("玩家连接成功")
    self.last_player_join_timestamp = os.time()
    local player_controller_id = #self.players + 1
    self.players[player_controller_id] = player_controller
    self.nplayers = self.nplayers + 1
    player_controller:OnConnected(player_controller_id)
end

function M:OnPlayerJoin_RPC(guid, key, room_id, account, player_controller_id)
    Screen.Print("玩家请求加入游戏, GUID: " .. guid)

    -- 验证guid, key, room_id, account, player_controller_id

    local p = self.players[player_controller_id]
    if p ~= nil then
        self:OnNewPlayerJoin(p, guid, 0, "角色名称", 0)
    end
end

function M:OnPlayerDisconnected(player_controller)
    
    self.nplayers = self.nplayers - 1
    Screen.Print("玩家离线,剩余玩家: ", self.nplayers)
end

function M:GameOver()
    Screen.Print("游戏结束")
    self.is_game_over = true
    GameInstance:QuitApplication()
end


-- 子类可覆盖
M.Base = { 
    ReceiveBeginPlay = M.ReceiveBeginPlay,
    ReceiveTick = M.ReceiveTick
}

return M