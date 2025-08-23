fx_version 'cerulean'
game 'gta5'

author 'Zen Scripts'
description 'ZenESX Framework - Enhanced Admin System'
version '1.0.0'
url 'https://github.com/zenscripts/zenesx-framework'

-- Admin System Scripts
server_scripts {
    'zenesx_admin.lua'
}

client_scripts {
    'zenesx_admin_client.lua'
}

-- Dependencies
dependencies {
    'es_extended',
    'esx_menu_default'
}

lua54 'yes'
