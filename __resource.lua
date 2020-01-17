resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'esx_joblisting2'

version '1.2.0'

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/img/header.png',
    'html/img/tablet.png'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'locales/de.lua',
	'server/esx_joblisting_sv.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'locales/de.lua',
	'client/esx_joblisting_cl.lua',
	'locales/fr.lua'
}

dependency 'es_extended'
