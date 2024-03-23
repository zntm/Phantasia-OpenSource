loca = "menu.settings.accessibility";
text = loca_translate(loca);
icon = ico_Accessibility;

on_press = function()
{
	global.menu_setting = "accessibility";
	
	menu_settings_update();
}