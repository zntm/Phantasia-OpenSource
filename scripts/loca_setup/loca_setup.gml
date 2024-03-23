global.language = {};
global.font_current = fnt_Main;

global.font_effects_default = {
	outlineEnable: true,
	outlineDistance: 1,
	outlineColour: #151221
};

global.font_effects_clear = {
	outlineEnable: true,
	outlineDistance: 2,
	outlineColour: #000000
};

function loca_setup(_langauge)
{
	// show_debug_message($"Loading language: '{_language}'");
	
	if (global.font_current != fnt_Main)
	{
		font_delete(global.font_current);
	}
	
	delete global.language;
	
	var _directory = $"Resources\\Languages\\{_langauge}";
	var _buffer = buffer_load(_directory + "\\Loca.json");
	
	if (file_exists(_directory + "\\Font.ttf"))
	{
		global.font_current = font_add(_directory + "\\Font.ttf", 9, false, false, 32, 0xffff);
		
		font_enable_sdf(global.font_current, true);
		font_enable_effects(global.font_current, true, (global.settings.accessibility.clear_text.value ? global.font_effects_clear : global.font_effects_default));
	}
	else if (file_exists(_directory + "\\Font.otf"))
	{
		global.font_current = font_add(_directory + "\\Font.otf", 9, false, false, 32, 0xffff);
		
		font_enable_sdf(global.font_current, true);
		font_enable_effects(global.font_current, true, (global.settings.accessibility.clear_text.value ? global.font_effects_clear : global.font_effects_default));
	}
	else
	{
		global.font_current = fnt_Main;
	}
	
	global.language = json_parse(buffer_peek(_buffer, 0, buffer_text));
	
	buffer_delete(_buffer);
	
	// show_debug_message($"Finished loading language: '{_name}'");
}