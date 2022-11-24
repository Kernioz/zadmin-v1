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

   
    "utils/cl_utils.lua",
    "utils/server-callback/client.lua",
    "utils/**/cl_*.lua",

    -- Module / Core
    "module/cl_admin.lua",
    -- Module / Core
    "module/cl_player.lua",
    -- Module / Core
    "module/staffmenu/cfg_staff.lua",
    "module/staffmenu/cl_staff.lua",


}


server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "config/sh_config.lua",
    "config/enums/webhook.lua",
    "config/others/cfg_anticheat.lua",


    "utils/sv_*.lua",
    "utils/server-callback/server.lua",
    "utils/logger/sv_logger.lua",
    "utils/discord-api/sv_discord.lua",
    "utils/discord-api/classes/sv_webhook.lua",

    "module/sv_admin.lua",
    "module/commands/sv_commands.lua",
    "module/commands/sv_commandsManager.lua",
    "module/bans/sv_bans.lua",
}