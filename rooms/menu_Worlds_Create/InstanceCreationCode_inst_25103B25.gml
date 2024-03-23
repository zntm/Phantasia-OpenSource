sprite_index = spr_Menu_Button_Secondary;

icon = ico_Randomize;

on_press = function()
{
	if (!clipboard_has_text())
	{
		clipboard_set_text(inst_5A9374D3.text);
	}
}