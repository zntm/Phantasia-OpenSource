icon = ico_Randomize;

on_press = function()
{
	var _attire_data = global.attire_data;
	var _colour_length = array_length(global.colour_data) - 1;
	
	var _menu_player_create_attire = global.menu_player_create_attire;
	
	var _name;
	var _names = struct_get_names(_menu_player_create_attire);
	var _names_length = array_length(_names);
	
	var i = 0;
	
	repeat (_names_length)
	{
		_name = _names[i++];
		
		global.menu_player_create_attire[$ _name].colour = irandom(_colour_length);
		
		if (_name != "base_body")
		{
			global.menu_player_create_attire[$ _name].index = irandom(array_length(_attire_data[$ _name]) - 1);
		}
		
		obj_Menu_Players_Create.refresh[$ _name] = true;
	}
}