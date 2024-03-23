loca = "menu.settings.controls";
text = loca_translate(loca);
icon = ico_Controls;

on_press = function()
{
	global.menu_setting = "controls";
	
	menu_settings_update();
}