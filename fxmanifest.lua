fx_version 'cerulean'
game 'gta5'

author 'Fugas'
description 'anticheat'

shared_scripts {
    '@es_extended/imports.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}
