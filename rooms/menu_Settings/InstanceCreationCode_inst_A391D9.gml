loca = "menu.settings.graphics";
text = loca_translate(loca);
icon = ico_Graphics;

on_press = function()
{
	global.menu_setting = "graphics";
	
	menu_settings_update();
}