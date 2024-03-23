sprite_index = spr_Menu_Button_Danger;

text = loca_translate("menu.exit");

on_press = function()
{
	room_goto(menu_Exit);
}