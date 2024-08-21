fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name         'jomidar-fentanyl'
version      '1.1.1'
description  'A multi-framework fentanyl'
author       'Hasib'

shared_scripts {
    'cfg.lua'
}

server_scripts {
    'sv.lua',
    '@mysql-async/lib/MySQL.lua',
	'@oxmysql/lib/MySQL.lua'
}

client_scripts {
    'cl.lua',
    'nui.lua'
}

dependencies {
    'jomidar-ui'
}

ui_page "web/fentanyl.html"

files {
	"web/*.html",
    "web/*.css",
    "web/*.js",
    'web/fonts/*.ttf',
}