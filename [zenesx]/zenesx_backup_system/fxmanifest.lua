fx_version 'cerulean'
game 'gta5'

author 'Zen Scripts'
description 'ZenESX Framework - Automatic Backup System'
version '1.0.0'
url 'https://github.com/zenscripts/zenesx-framework'

-- Backup System
server_scripts {
    'zenesx_backup.lua'
}

-- Dependencies
dependencies {
    'es_extended',
    'oxmysql'
}

lua54 'yes'

