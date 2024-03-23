loca = "menu.settings.general";
text = loca_translate(loca);
icon = ico_General;

on_press = function()
{
	global.menu_setting = "general";
	
	menu_settings_update();
}