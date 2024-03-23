sprite_index = spr_Menu_Button_Success;

text = loca_translate("menu.exit.no");

on_press = function()
{
	room_goto(menu_Main);
}