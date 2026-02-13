fx_version "cerulean"
game "gta5"

name "south_webbridge"
author "SouthRP"
description "HTTP bridge for South RP admin panel in-game actions"
version "1.0.0"

server_only "yes"

dependency "oxmysql"

shared_script "@oxmysql/lib/MySQL.lua"

server_scripts {
    "server.lua"
}
