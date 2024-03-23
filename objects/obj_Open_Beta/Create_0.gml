with (instance_create_layer(0, 0, "Instances", obj_Fade))
{
	value = -FADE_SPEED;
}

audio_stop_all();

show_debug_overlay(false);

global.local_settings.draw_fps = false;

window_set_fullscreen(global.settings.graphics.fullscreen.value);
window_set_showborder(!global.settings.graphics.borderless.value);
window_center();

var _window_size = global.settings.graphics.window_size;
var _size = string_split(_window_size.values[_window_size.value], "x");

window_set_size(real(_size[0]), real(_size[1]));

window_set_cursor(cr_none);
cursor_sprite = spr_Mouse;

transition = 600;

#region Generate Flare

var _x = room_width  / 2;
var _y = room_height / 2;

flares = [];

var _offset = 112;

var _hue = irandom_range(30,  225);
var _hue_offset = 32;

var _sat = irandom_range(210, 245);
var _sat_offset = 14;

var _val = irandom_range(8, 14);
var _val_offset = 6;

var _scale;

var i = 0;

repeat (irandom_range(4, 8))
{
	_scale = random_range(3, 8);
	
	flares[@ i] = {
		x: _x + random_range(-_offset, _offset),
		y: _y + random_range(-_offset, _offset),
		
		xvelocity: random_range(-2, 2),
		yvelocity: random_range(-2, 2),
		
		xscale: _scale,
		yscale: _scale,
		
		colour: make_colour_hsv(
			_hue + irandom_range(-_hue_offset, _hue_offset),
			_sat + irandom_range(-_sat_offset, _sat_offset),
			_val + irandom_range(-_val_offset, _val_offset)
		)
	};
}

#endregion