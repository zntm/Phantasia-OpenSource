sprite_index = spr_Menu_Button_Right;

visible_button = false;

on_press = function()
{
	var _menu_player_create = global.menu_player_create;
	
	if (_menu_player_create == "base_body") || (_menu_player_create == "undershirt") exit;
	
	if (++global.menu_player_create_page_attire >= floor(array_length(global.attire_data[$ global.menu_player_create]) / (MENU_PLAYERS_CREATE_ATTIRE_WIDTH * MENU_PLAYERS_CREATE_ATTIRE_HEIGHT)))
	{
		global.menu_player_create_page_attire = 0;
	}
	
	menu_player_create_update();
}