resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'GRPCore Billing'

version '1.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@grp-core/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@grp-core/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua'
}

dependency 'grp-core'