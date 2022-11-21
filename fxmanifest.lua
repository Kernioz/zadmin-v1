fx_version 'adamant'
games { 'gta5' };

author 'Yuuu#0002'
resource_type 'gametype' {name = 'Los Santos'}

ui_page 'utils/web/index.html'

files {
    'utils/web/index.html',
    'utils/web/*.png',
    'utils/web/*.woff',
    'utils/web/*.js',
    'utils/web/*.css',
}


client_scripts {
    "utils/vendor/RMenu.lua", "utils/vendor/UIInstructionalButton.lua",
    "utils/vendor/menu/RageUI.lua", "utils/vendor/menu/Menu.lua",
    "utils/vendor/menu/MenuController.lua", "utils/vendor/components/*.lua",
    "utils/vendor/menu/elements/*.lua", "utils/vendor/menu/items/*.lua",
    "utils/vendor/menu/panels/*.lua", "utils/vendor/menu/panels/*.lua",
    "utils/vendor/menu/windows/*.lua"
}



client_script {
    "config/cl_config.lua",
    "config/others/cfg_*.lua",

    "utils/cfx/mapmanager_shared.lua",
    "utils/cfx/mapmanager_client.lua",
    "utils/cfx/spawnmanager.lua",

    "utils/cl_utils.lua",
    "utils/server-callback/client.lua",
    "utils/**/cl_*.lua",

    -- Module / Core
    "module/cl_core.lua",
    -- Module / Death
    "module/cl_death.lua",

    -- Base / Commands
    "base/commands/cl_commands.lua",

    -- Base / Players
    "base/players/cl_players.lua",

    -- Module / Admin
    "module/admin/cfg_admin.lua",
    "module/admin/cl_admin.lua",

    -- Module / Admin / Weather 
    "module/admin/weather/cfg_weather.lua",
    "module/admin/weather/cl_weather.lua",

    -- Module / Admin / StaffMenu
    "module/admin/staffmenu/cfg_staff.lua",
    "module/admin/staffmenu/cl_staff.lua",
    
    -- Module / Admin / Anticheat
    "module/admin/anticheat/cl_anticheat.lua",

    -- Module / Instance
    "module/instance/cl_instance.lua",

    -- Module / Duel
    "module/duel/cl_duel.lua",

    -- Module / Duel
    "module/zone/cl_safezone.lua",

}


server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "utils/cfx/mapmanager_shared.lua",
    "utils/cfx/mapmanager_server.lua",
    "utils/cfx/sessionmanager.lua",

    "config/sh_config.lua",
    "config/enums/webhook.lua",
    "config/others/cfg_anticheat.lua",


    "utils/sv_*.lua",
    "utils/server-callback/server.lua",
    "utils/logger/sv_logger.lua",
    "utils/discord-api/sv_discord.lua",
    "utils/discord-api/classes/sv_webhook.lua",

    "module/sv_core.lua",
    "base/sv_base.lua",
    
    -- Base / Society
    "base/society/sv_society.lua",
    "base/society/sv_societyManager.lua",

    -- Base / Players
    "base/players/sv_players.lua",
    "base/players/sv_playersManager.lua",

    -- Module / Admin 
    "module/admin/sv_admin.lua",
    
    -- Module / Admin / Weather 
    "module/admin/weather/cfg_weather.lua",
    "module/admin/weather/sv_weather.lua",

    -- Module / Admin / Bans
    "module/admin/bans/sv_bans.lua",
    
    -- Module / Admin / Anticheat
    "module/admin/anticheat/sv_anticheat.lua",

    -- Module / Admin / Anticheat / Events
    "module/admin/anticheat/events/*.lua",

    -- Module / Admin / Commands 
    "module/admin/commands/sv_commandsManager.lua",
    "module/admin/commands/sv_commands.lua",

    -- Module / Instance
    "module/instance/sv_instance.lua",

    -- Module / Duel
    "module/duel/sv_duel.lua",
}