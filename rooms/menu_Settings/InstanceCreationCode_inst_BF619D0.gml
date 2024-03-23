loca = "menu.settings.audio";
text = loca_translate(loca);
icon = ico_Audio;

on_press = function()
{
	global.menu_setting = "audio";
	
	menu_settings_update();
}