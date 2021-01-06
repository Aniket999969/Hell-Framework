fx_version 'adamant'
games { 'gta5' }

ui_page 'html_car/index.html'
ui_page 'bank_html/ui.html'
ui_page 'bwh_html/index.html'
ui_page 'hack.html'
ui_page "html_radar/radar.html"
ui_page 'html/ui.html'
ui_page('html_sound/index.html')

client_script {
    
    '3dme_c.lua',
    'carcontrol_c.lua',
    'bank_c.lua',
    'sh_queue.lua',
    'discord_c.lua',
    'debug_c.lua',
    'bwh_c.lua',
    'bwh_config.lua',
    'heli_client.lua',
    'isped_c.lua',
    'vehcontrol_c.lua',
    'mhacking.lua',
    'sequentialhack.lua',
    'chairs.lua',
    'chair_c.lua',
    'chair_config.lua',
    'NativeUI.lua',
    'wpdeleter_c.lua',
    'cl_radar.lua',
    'ss_shared_functions.lua',
    'config/Keybinds.lua',
    'config/ServerSync.lua',
    'ss_cli_traffic_crowd.lua',
    'ss_cli_weather.lua',
    'ss_cli_time.lua',
    'shop_c.lua',
    'shop_gui.lua',
    'race_config.lua',
    'races_cl.lua',
    'radio_cl.lua',
    'sound_c.lua',
    '@grp-core/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua'

}  

files {
    'html_car/index.html',
    'html_car/script.js',
    'html_car/style.css',
    'html_car/doorL1.png',
    'html_car/doorL2.png',
    'html_car/doorR1.png',
    'html_car/doorR2.png',
    'html_car/hood.png',
    'html_car/trunk.png',
    'html_car/seat.png',
    'html_car/windowL1.png',
    'html_car/windowL2.png',
    'html_car/windowR1.png',
    'html_car/windowR2.png',
    'html_car/buttonOff.png',
    'html_car/buttonOn.png',
    'html_car/buttonHover.png',
    'html_car/engine.png',
	'bank_html/ui.html',
	'bank_html/pricedown.ttf',
	'bank_html/bank-icon.png',
	'bank_html/logo.png',
	'bank_html/cursor.png',
	'bank_html/styles.css',
	'bank_html/scripts.js',
    'bank_html/debounce.min.js'
    'bwh_html/index.html',
    'bwh_html/script.js',
    'bwh_html/style.css',
    'bwh_html/jquery.datetimepicker.min.css',
    'bwh_html/jquery.datetimepicker.full.min.js',
    'bwh_html/date.format.js'
    'phone.png',
    'snd/beep.ogg',
    'snd/correct.ogg',
    'snd/fail.ogg', 
    'snd/start.ogg',
    'snd/finish.ogg',
    'snd/wrong.ogg',
    'hack.html'
    "html_radar/digital-7.regular.ttf", 
	"html_radar/radar.html",
	"html_radar/radar.css",
    "html_radar/radar.js"
    'html/icons/properties.png',
	'html/icons/properties2.png',
	'html/icons/decrypt.png',
	'html/icons/groups.png',
	'html/icons/blackmarkettasks.png',
	'html/icons/delivery.png',
	'html/icons/stocks.png',
	'html/icons/camera.png',
	'html/icons/help.png',
	'html/icons/csms.png',
	'html/icons/home.png',
	'html/icons/call.png',
	'html/icons/call2.png',
	'html/icons/chathistory.png',
	'html/icons/trash.png',
	'html/icons/account.png',
	'html/icons/car.png',
	'html/icons/jobalerts.png',
	'html/icons/twatter.png',
	'html/icons/contacts.png',
	'html/icons/gps.png',
	'html/icons/internet.png',
	'html/icons/newsms.png',
	'html/icons/notepad.png',
	'html/icons/pager.png',
	'html/icons/pager2.png',
	'html/icons/pager3.png',
	'html/icons/phone.png',
	'html/icons/phonenumber.png',
	'html/icons/sms.png',
	'html/icons/yellowpages.png',
	'html/icons/packages.png',
	'html/icons/trucker.png',
	'html/ui.html',
	'html/gurgle.png',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/background.png',
	'html/backgroundwhite.png',
	'html/styles.css',
	'html/scripts.js',
    'html/debounce.min.js'
    'html_sound/index.html',
    'html_sound/sounds/*.ogg',
}
server_script {
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
    'server/sv_queue_config.lua',
    'connectqueue.lua',
    'sh_queue.lua',
    'cron_s.lua',
    'bwh_config.lua'
    'bwh_s.lua',
    'heli_server.lua',
    'isped_s.lua',
    'vehcontrol_s.lua',
    'chair_config.lua'
    'chairs.lua',
    'chair_s.lua',
    'wpdeleter_s.lua',
    'ss_shared_functions.lua',
    'config/ServerSync.lua',
    'ss_srv_weather.lua',
    'ss_srv_time.lua'
    "race_config.lua",
    "port_sv.lua",
    "races_sv.lua",
    'sound_s.lua',
    '@grp-core/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua'
}

shared_script 'discord_config.lua'


export "GetClosestNPC"
export "IsPedNearCoords"
export "isPed"
export "GroupRank"
export "GlobalObject"
export "retreiveBusinesses"


exports {
    'cleanupRecording',
    'isRecordingRace',
    'cpCount'
}