-----------------------------------------------------------------------------
-- Author: i0gan
-- Email : l418894113@gmail.com
-- Date  : 2023-01-03
-- Description: 客户端配置
-----------------------------------------------------------------------------

deploy_mode = DeployMode.Online

if deploy_mode == DeployMode.Online then
    -- Public Server
    Servers = {
        gateways = { [1] = "http://1.14.123.62:12080/list", },
        proxys = {
            [1] = { ip = "1.14.123.62", port = 15001 },
        },
        pvp_manager = {
            [1] = { ip = "1.14.123.62", port = 20001 },
        }
    }
elseif deploy_mode == DeployMode.Development then
    -- Local Development
    Servers = {
        gateways = { [1] = "http://192.168.0.123:12080/list", },
        proxys = {
            [1] = { ip = "192.168.0.123", port = 15001 },
        },
        pvp_manager = {
            [1] = { ip = "192.168.0.123", port = 20001 },
        }
    }
elseif deploy_mode == DeployMode.Localhost then
    -- Local Host
    Servers = {
        gateways = { [1] = "http://127.0.0.1:12080/list", },
        proxys = {
            [1] = { ip = "127.0.0.1", port = 15001 },
        },
        pvp_manager = {
            [1] = { ip = "127.0.0.1", port = 20001 },
        }
    }
else
end


-- 场景地图
Maps = {
    --[1] = "/Game/Maps/Test",
    [1] = "/Game/Maps/Game/Level_2",
}
