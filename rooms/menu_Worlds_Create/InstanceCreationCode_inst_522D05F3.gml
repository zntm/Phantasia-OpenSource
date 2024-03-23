sprite_index = spr_Menu_Button_Secondary;

icon = ico_Randomize;

on_press = function()
{
	inst_5A9374D3.text = clipboard_get_text();
	
	clipboard_set_text("");
}