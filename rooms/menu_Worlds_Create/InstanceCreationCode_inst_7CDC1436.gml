sprite_index = spr_Menu_Button_Secondary;

icon = ico_Randomize;

on_press = function()
{
	inst_FD842A4.text = clipboard_get_text();
	
	clipboard_set_text("");
}