resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	'@mysql-async/lib/MySQL.lua'
}

client_scripts {
	'locales/en.lua',
	'config.lua',
	"client/main.lua"
}

fx_version 'adamant'
games { 'gta5' }