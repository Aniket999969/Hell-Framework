fx_version 'adamant'
games { 'gta5' }

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@grp-core/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@grp-core/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'grp-core',
	'cron',
	'grp-addonaccount'
}
