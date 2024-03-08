fx_version 'cerulean'
game 'gta5'


files {
	'common/carvariations.meta',
	'common/vehicles.meta',
	'common/*.meta'
}
data_file 'VEHICLE_METADATA_FILE' 'common/vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'common/carvariations.meta'

client_scripts {
	 'client.lua',
	 'config.lua'
}

server_scripts {
   
	'server.lua',
	'config.lua',
	'@mysql-async/lib/MySQL.lua'
	
}

shared_script '@es_extended/imports.lua'