sprite_index = spr_Menu_Button_Success;

text = loca_translate("menu.create_world");

on_press = function()
{
	var _seed;
	var _seed_text = inst_5A9374D3.text;
	
	try
	{
		_seed = floor(real(_seed_text));
	}
	catch (_error)
	{
		_seed = string_get_seed(_seed_text);
	}
		
	#macro WORLD_FOLDER_LENGTH 14
	
	var _directory_name = uuid_create();
		
	while (directory_exists($"{DIRECTORY_DATA_WORLD}/{_directory_name}"))
	{
		_directory_name = uuid_create();
	}
	
	global.world.info.name = inst_FD842A4.text;
	global.world.info.seed = _seed;
	
	global.world.environment.weather_wind = random_range(0.4, 0.6);
	global.world.environment.weather_storm = 0;
	
	global.world.environment.time = 0;
	
	global.world.directory_name = _directory_name;
		
	room_goto(rm_World);
}