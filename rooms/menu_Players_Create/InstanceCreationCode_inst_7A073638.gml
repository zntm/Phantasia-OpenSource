text = loca_translate("menu.create_player");

on_press = function()
{
	var _directory = uuid_create();
		
	while (directory_exists($"{DIRECTORY_DATA_PLAYER}/{_directory}/Info.dat"))
	{
		_directory = uuid_create();
	}
	
	save_player(_directory, inst_1B5CE136.text, 100, 100, 0, global.menu_player_create_attire, false);
	
	room_goto(menu_Players);
}