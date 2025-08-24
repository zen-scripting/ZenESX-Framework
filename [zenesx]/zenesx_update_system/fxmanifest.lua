fx_version 'cerulean'
game 'gta5'

author 'Zen Scripts'
description 'ZenESX Framework - GitHub Update System'
version '1.0.0'
url 'https://github.com/zenscripts/zenesx-framework'

-- GitHub Update System
server_scripts {
    'update_checker.lua'
}

client_scripts {
    'client_update_notifications.lua'
}

-- Dependencies
dependencies {
    'es_extended'
}

lua54 'yes'

