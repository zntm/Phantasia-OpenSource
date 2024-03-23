font_enable_effects(fnt_Main, true, (global.settings.accessibility.clear_text.value ? global.font_effects_clear : global.font_effects_default));

var _refresh_rate = global.settings.general.refresh_rate;

game_set_speed(real(_refresh_rate.values[_refresh_rate.value]), gamespeed_fps);

audio_stop_all();
show_debug_overlay(false);

window_set_cursor(cr_none);
cursor_sprite = spr_Mouse;

global.local_settings.draw_fps = false;

#region Splash Text

var _buffer = buffer_load("Resources\\Splash.txt");
var _buffer2;

global.splash_text = array_filter(string_split(buffer_peek(_buffer, 0, buffer_text), "\n"), function(_value, _index)
{
	return (string_length(_value) > 0);
});

buffer_delete(_buffer);

#endregion

#macro SETUP_SURFACE_WIDTH 240
#macro SETUP_SURFACE_HEIGHT 240

#macro BIOME_COLOUR_MAP_XOFFSET 0
#macro BIOME_COLOUR_MAP_YOFFSET 0

#macro PLAYER_COLOUR_MAP_XOFFSET 48
#macro PLAYER_COLOUR_MAP_YOFFSET 0

#macro PLAYER_COLOUR_MAP_BASE_AMOUNT 8
#macro PLAYER_COLOUR_MAP_OUTLINE_AMOUNT 3

if (DEV_MODE)
{
	var _surface = surface_create(SETUP_SURFACE_WIDTH, SETUP_SURFACE_HEIGHT);
	
	surface_set_target(_surface);

	draw_sprite(map_Biome_Colour, 0, BIOME_COLOUR_MAP_XOFFSET, BIOME_COLOUR_MAP_YOFFSET);
	draw_sprite(map_Player_Colour, 0, PLAYER_COLOUR_MAP_XOFFSET, PLAYER_COLOUR_MAP_YOFFSET);

	surface_reset_target();
	
	var _x;
	
	var i = 0;
	var j;
	
	#region Player Colours
	
	var _player_colour_length = sprite_get_width(map_Player_Colour);
	
	_buffer = buffer_create(0xffff, buffer_grow, 1);
	
	i = 0;
	
	repeat (_player_colour_length)
	{
		_x = PLAYER_COLOUR_MAP_XOFFSET + i++;
		
		j = 0;
		
		repeat (PLAYER_COLOUR_MAP_BASE_AMOUNT + PLAYER_COLOUR_MAP_OUTLINE_AMOUNT)
		{
			buffer_write(_buffer, buffer_u32, surface_getpixel(_surface, _x, j++));
		}
	}

	#endregion
	
	surface_free(_surface);
	
	_buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, "Resources\\Cache\\Colours.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}

var i = 0;
var j;

_buffer = buffer_load("Resources\\Cache\\Colours.dat");
_buffer2 = buffer_decompress(_buffer);

var _player_colour_length = sprite_get_width(map_Player_Colour);
	
repeat (_player_colour_length)
{
	global.colour_data[@ i] = [];
		
	j = 0;
		
	repeat (PLAYER_COLOUR_MAP_BASE_AMOUNT + PLAYER_COLOUR_MAP_OUTLINE_AMOUNT)
	{
		global.colour_data[@ i][@ j++] = buffer_read(_buffer2, buffer_u32);
	}
		
	++i;
}

show_debug_message(json_stringify(global.colour_data, true))

buffer_delete(_buffer);
buffer_delete(_buffer2);

var _handle = call_later(8, time_source_units_frames, function()
{
	room_goto(global.settings.general.skip_warning.value ? menu_Main : rm_Warning);
	
	/*
	if (array_length(obj_Mod_Loader.mods) > 0)
	{
		obj_Mod_Loader.alarm[@ 0] = 1;
	}
	else
	{
		room_goto(global.settings.general.skip_warning.value ? menu_Main : rm_Warning);
	}
	*/
});

// Load Selected Language
var _langauage = global.settings.accessibility.language;

loca_setup($"{_langauage.value + 1}. {_langauage.values[_langauage.value]}");