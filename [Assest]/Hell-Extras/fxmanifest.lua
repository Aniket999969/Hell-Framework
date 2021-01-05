fx_version 'adamant'
games { 'gta5' }

ui_page 'html_car/index.html'
ui_page 'bank_html/ui.html'
ui_page 'bwh_html/index.html'
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
}
shared_script 'discord_config.lua'