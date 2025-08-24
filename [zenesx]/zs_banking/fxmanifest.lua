fx_version 'cerulean'
game 'gta5'

name 'ZS Banking - Premium Banking System'
description 'Modernes Banking-System mit Premium-Features, Aktienhandel, Überweisungen und mehr'
author 'ZenScripts'
version '1.0.0'

shared_script 'config.lua'
client_script 'client.lua'
server_script 'transactions/storage.lua'
server_script 'transactions/transactions.lua'
server_script 'server.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'sounds/open.ogg',
    'sounds/confirm.ogg',
    'sounds/error.ogg'
}

dependencies {
    'es_extended'
}

lua54 'yes'




