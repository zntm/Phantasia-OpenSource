sprite_index = spr_Menu_Button_Left;

on_press = function()
{
	if (--global.menu_player_create_page_colour < 0)
	{
		global.menu_player_create_page_colour = floor(array_length(global.colour_data) / (MENU_PLAYERS_CREATE_COLOUR_WIDTH * MENU_PLAYERS_CREATE_COLOUR_HEIGHT));
	}
	
	menu_player_create_update();
}