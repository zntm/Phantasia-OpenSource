function menu_worlds_on_press(_inst)
{
	var _directory_name = _inst.directory_name;
	
	if (!directory_exists($"{DIRECTORY_DATA_WORLD}/{_directory_name}/"))
	{
		room_goto(menu_Worlds);
		
		exit;
	}
	
	delete global.world;
	
	global.world = _inst.data;
	global.world.directory_name = _directory_name;
	
	room_goto(rm_World);
}