// Feather disable GM1020

if (!surface_exists(surface))
{
	surface = surface_create(room_width, room_height);
}

surface_set_target(surface);
draw_clear_alpha(c_white, 0);

var _halign = draw_get_halign();
var _valign = draw_get_valign();

draw_set_font(global.font_current);
draw_set_align(fa_center, fa_middle);

var _mouse_left = mouse_check_button(mb_left);
var _mouse_left_pressed = mouse_check_button_pressed(mb_left);
var _mouse_left_released = mouse_check_button_released(mb_left);

var _is_popup = global.is_popup;

#macro MENU_BUTTON_INFO_ICON_XOFFSET 0
#macro MENU_BUTTON_INFO_ICON_YOFFSET 0
#macro MENU_BUTTON_INFO_ICON_SCALE 2

#macro MENU_BUTTON_INFO_TEXT_XOFFSET 0
#macro MENU_BUTTON_INFO_TEXT_YOFFSET 4
#macro MENU_BUTTON_INFO_TEXT_SCALE 1.5

#macro MENU_BUTTON_INFO_MIN_SCALE 3
#macro MENU_BUTTON_INFO_SAFE_ZONE 4

#region Draw Button

var _inst = noone;
var _area = area;
var _area_exists = (_area != -1);

with (obj_Menu_Button)
{
	if (point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom)) && ((!_is_popup && (!_area_exists || (!area_bound || (area_bound && point_in_rectangle(mouse_x, mouse_y, _area.bbox_left, _area.bbox_top, _area.bbox_right, _area.bbox_bottom))))) || (_is_popup && popup))
	{
		_inst = id;
		
		break;
	}
}

if (_inst == noone)
{
	with (obj_Menu_Textbox)
	{
		if (point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom)) && ((!_is_popup && (!_area_exists || (!area_bound || (area_bound && point_in_rectangle(mouse_x, mouse_y, _area.bbox_left, _area.bbox_top, _area.bbox_right, _area.bbox_bottom))))) || (_is_popup && popup))
		{
			_inst = id;
		
			break;
		}
	}
}

var _sprite;
var _offset;
var _underscore;

var _width, _icon_width, _text_width;
var _text, _icon;
var _size, _scale, _colour;
var _v;

with (obj_Menu_Button)
{
	if (!_is_popup) && (popup) continue;
	
	if (clickable)
	{
		if (_inst == id)
		{
			if (_mouse_left_pressed)
			{
				audio_play_sound(choose(sfx_Menu_Button_00, sfx_Menu_Button_01, sfx_Menu_Button_02), 0, false, global.settings.audio.master.value * global.settings.audio.sfx.value * volume);
			
				selected = true;
				selected_hold = true;
			}
			else if (selected) && (_mouse_left_released)
			{
				if (on_press != -1)
				{
					on_press(id);
				}
			
				selected = false;
			}
		}
		else
		{
			selected = false;
		}
	
		if (on_hold != -1) && (selected_hold) && (_mouse_left)
		{
			on_hold(id);
		}
	
		if (_mouse_left_released)
		{
			selected_hold = false;
		}
	}
	else
	{
		selected = false;
		selected_hold = false;
	}
	
	if (visible_button)
	{
		_sprite = asset_get_index($"{sprite_get_name(sprite_index)}_Edge");
	
		if (selected)
		{
			draw_rectangle(bbox_left - 1, bbox_top - 1, bbox_right, bbox_bottom, false);
			draw_sprite_ext(sprite_index, 1, x, y, image_xscale, image_yscale, 0, c_white, 1);
		}
		else if (_sprite > -1)
		{
			draw_sprite_ext(_sprite, 0, x, y + (sprite_get_height(sprite_index) / 2 * image_yscale) - sprite_get_height(_sprite), image_xscale, image_yscale, 0, c_white, 1);
		}
	}
	
	if (visible_button) && (!selected)
	{
		_sprite = asset_get_index($"{sprite_get_name(sprite_index)}_Edge");
		_offset = (_sprite > -1 ? sprite_get_height(_sprite) : 0);
	
		if (_inst == id)
		{
			draw_rectangle(bbox_left - 1, bbox_top - 1 - _offset, bbox_right, bbox_bottom - _offset, false);
		}
		
		draw_sprite_ext(sprite_index, 0, x, y - _offset, image_xscale, image_yscale, 0, c_white, 1);
	}
	
	_offset = 0;
	_colour = c_white;
	
	if (selected)
	{
		_offset = 0;
		_colour = c_ltgray;
	}
	else if (visible_button)
	{
		_sprite = asset_get_index($"{sprite_get_name(sprite_index)}_Edge");
	
		if (_sprite > -1)
		{
			_offset = sprite_get_height(_sprite);
		}
	}
	
	_width = 0;
	_icon_width = 0;
	_text_width = 0;
	
	_icon = (icon != -1);
	_text = (text != -1);
	
	if (_icon)
	{
		_icon_width = sprite_get_width(icon);
		_width += _icon_width;
	}
	
	if (_text)
	{
		_text_width = string_width(text);
		_width += _icon_width;
	}
	
	_size  = bbox_right - bbox_left;
	_scale = min((_size - (MENU_BUTTON_INFO_SAFE_ZONE * 2)) / _size * MENU_BUTTON_INFO_TEXT_SCALE, MENU_BUTTON_INFO_MIN_SCALE);
	
	if (_text)
	{
		draw_set_align(fa_center, fa_middle);
			
		if (_icon)
		{
			draw_sprite_ext(icon, 0, x - (_text_width / 2 * MENU_BUTTON_INFO_TEXT_SCALE) + (MENU_BUTTON_INFO_ICON_XOFFSET * _scale), y - _offset + (MENU_BUTTON_INFO_ICON_YOFFSET * _scale), _scale, _scale, 0, _colour, 1);
			draw_text_transformed_colour(x + MENU_BUTTON_INFO_TEXT_XOFFSET + (_icon_width / 2 * MENU_BUTTON_INFO_TEXT_SCALE), y - _offset + (MENU_BUTTON_INFO_TEXT_YOFFSET * MENU_BUTTON_INFO_TEXT_SCALE), text, _scale, _scale, 0, _colour, _colour, _colour, _colour, 1);
		}
		else
		{
			draw_text_transformed_colour(x + (MENU_BUTTON_INFO_TEXT_XOFFSET * _scale), y - _offset + (MENU_BUTTON_INFO_TEXT_YOFFSET * _scale), text, _scale, _scale, 0, _colour, _colour, _colour, _colour, 1);
		}
	}
	else if (_icon)
	{
		draw_sprite_ext(icon, 0, x + (MENU_BUTTON_INFO_ICON_XOFFSET * MENU_BUTTON_INFO_TEXT_SCALE), y - _offset + (MENU_BUTTON_INFO_ICON_YOFFSET * MENU_BUTTON_INFO_TEXT_SCALE), MENU_BUTTON_INFO_ICON_SCALE, MENU_BUTTON_INFO_ICON_SCALE, 0, _colour, 1);
	}
	
	if (on_draw != -1)
	{
		on_draw(x, y - _offset, _colour, id);
	}
}

#endregion

#region Popup

if (_is_popup)
{
	draw_sprite_ext(spr_Square, 0, 0, 0, room_width, room_height, 0, c_black, 0.75);
	
	with (obj_Menu_Button)
	{
		if (!popup) continue;
	
		if (visible_button)
		{
			_sprite = asset_get_index($"{sprite_get_name(sprite_index)}_Edge");
	
			if (selected)
			{
				draw_rectangle(bbox_left - 1, bbox_top - 1, bbox_right, bbox_bottom, false);
				draw_sprite_ext(sprite_index, 1, x, y, image_xscale, image_yscale, 0, c_white, 1);
			}
			else if (_sprite > -1)
			{
				draw_sprite_ext(_sprite, 0, x, y + (sprite_get_height(sprite_index) / 2 * image_yscale) - sprite_get_height(_sprite), image_xscale, image_yscale, 0, c_white, 1);
			}
			
			if (!selected)
			{
				_sprite = asset_get_index($"{sprite_get_name(sprite_index)}_Edge");
				_offset = (_sprite > -1 ? sprite_get_height(_sprite) : 0);
	
				if (_inst == id)
				{
					draw_rectangle(bbox_left - 1, bbox_top - 1 - _offset, bbox_right, bbox_bottom - _offset, false);
				}
		
				draw_sprite_ext(sprite_index, 0, x, y - _offset, image_xscale, image_yscale, 0, c_white, 1);
			}
		}
	
		_offset = 0;
		_colour = c_white;
	
		if (selected)
		{
			_offset = 0;
			_colour = c_ltgray;
		}
		else if (visible_button)
		{
			_sprite = asset_get_index($"{sprite_get_name(sprite_index)}_Edge");
	
			if (_sprite > -1)
			{
				_offset = sprite_get_height(_sprite);
			}
		}
	
		_width = 0;
		_icon_width = 0;
		_text_width = 0;
	
		_icon = (icon != -1);
		_text = (text != -1);
	
		if (_icon)
		{
			_icon_width = sprite_get_width(icon);
			_width += _icon_width;
		}
	
		if (_text)
		{
			_text_width = string_width(text);
			_width += _icon_width;
		}
	
		_size  = bbox_right - bbox_left;
		_scale = min((_size - (MENU_BUTTON_INFO_SAFE_ZONE * 2)) / _size * MENU_BUTTON_INFO_TEXT_SCALE, MENU_BUTTON_INFO_MIN_SCALE);
	
		if (_text)
		{
			draw_set_align(fa_center, fa_middle);
			
			if (_icon)
			{
				draw_sprite_ext(icon, 0, x - (_text_width / 2 * MENU_BUTTON_INFO_TEXT_SCALE) + (MENU_BUTTON_INFO_ICON_XOFFSET * _scale), y - _offset + (MENU_BUTTON_INFO_ICON_YOFFSET * _scale), _scale, _scale, 0, _colour, 1);
				draw_text_transformed_colour(x + MENU_BUTTON_INFO_TEXT_XOFFSET + (_icon_width / 2 * MENU_BUTTON_INFO_TEXT_SCALE), y - _offset + (MENU_BUTTON_INFO_TEXT_YOFFSET * MENU_BUTTON_INFO_TEXT_SCALE), text, _scale, _scale, 0, _colour, _colour, _colour, _colour, 1);
			}
			else
			{
				draw_text_transformed_colour(x + (MENU_BUTTON_INFO_TEXT_XOFFSET * _scale), y - _offset + (MENU_BUTTON_INFO_TEXT_YOFFSET * _scale), text, _scale, _scale, 0, _colour, _colour, _colour, _colour, 1);
			}
		}
		else if (_icon)
		{
			draw_sprite_ext(icon, 0, x + (MENU_BUTTON_INFO_ICON_XOFFSET * MENU_BUTTON_INFO_TEXT_SCALE), y - _offset + (MENU_BUTTON_INFO_ICON_YOFFSET * MENU_BUTTON_INFO_TEXT_SCALE), MENU_BUTTON_INFO_ICON_SCALE, MENU_BUTTON_INFO_ICON_SCALE, 0, _colour, 1);
		}
	
		if (on_draw != -1)
		{
			on_draw(x, y - _offset, _colour, id);
		}
	}
}

#endregion

with (obj_Menu_Textbox)
{
	if (_mouse_left_pressed)
	{
		if (_inst == id)
		{
			audio_play_sound(sfx_Menu_Textbox, 0, false, global.settings.audio.master.value * global.settings.audio.sfx.value);
			
			keyboard_string = text;
			selected = true;
		}
		else
		{
			selected = false;
		}
	}
	
	_offset = 0;
	_colour = c_white;
	
	if (visible_button)
	{
		if (selected) || (_inst == id)
		{
			draw_rectangle(bbox_left - 1, bbox_top - 1, bbox_right, bbox_bottom, false);
		}
		
		draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, c_white, 1);
	}
	
	_underscore = (selected && (round((global.timer % 60) / 60) == 0) ? "_" : "");
	
	_size  = bbox_right - bbox_left;
	_scale = clamp(((_size - (MENU_BUTTON_INFO_SAFE_ZONE * 2)) / string_width(text + _underscore) / MENU_BUTTON_INFO_TEXT_SCALE), 0, 1) * MENU_BUTTON_INFO_TEXT_SCALE;
	
	if (selected)
	{
		if (enter_newline) && (keyboard_check_pressed(vk_enter))
		{
			keyboard_string += chr(1 << 16);
		}
		
		// TODO: Make custom input system
		if (text != keyboard_string)
		{
			audio_play_sound(sfx_Menu_Key, 0, false, global.settings.audio.master.value * global.settings.audio.sfx.value, 0, random_range(0.8, 1.2));
			
			text = string_replace_all(keyboard_string, chr(1 << 16), "\n");
		}
		
		if (on_update != -1)
		{
			on_update();
		}
		
		if (text == "")
		{
			draw_text_cuteify(x + (MENU_BUTTON_INFO_TEXT_XOFFSET * _scale), y + _offset + (MENU_BUTTON_INFO_TEXT_YOFFSET * _scale), placeholder + _underscore, _scale, _scale, 0, _colour, 0.25);
		}
		else
		{
			var _x = x + (MENU_BUTTON_INFO_TEXT_XOFFSET * _scale);
			var _y = y + _offset + (MENU_BUTTON_INFO_TEXT_YOFFSET * _scale);
			
			draw_text_cuteify(_x,                                            _y, text + _underscore, _scale, _scale, 0, c_black, 0.25);
			draw_text_cuteify(_x - (string_width(_underscore) / 2 * _scale), _y, text,               _scale, _scale, 0, _colour, 1);
		}
	}
	else
	{
		if (text == "")
		{
			draw_text_cuteify(x + (MENU_BUTTON_INFO_TEXT_XOFFSET * _scale), y + _offset + (MENU_BUTTON_INFO_TEXT_YOFFSET * _scale), placeholder, _scale, _scale, 0, _colour, 0.25);
		}
		else
		{
			draw_text_cuteify(x + (MENU_BUTTON_INFO_TEXT_XOFFSET * _scale), y + _offset + (MENU_BUTTON_INFO_TEXT_YOFFSET * _scale), text, _scale, _scale, 0, _colour, 1);
		}
	}
}

#endregion

draw_set_align(_halign, _valign);

surface_reset_target();

if (shader != -1)
{
	shader_set(shader);
	
	if (on_shader != -1)
	{
		on_shader();
	}
	
	draw_surface(surface, 0, 0);
	
	shader_reset();
}
else
{
	draw_surface(surface, 0, 0);
}

with (obj_Menu_Text)
{
	draw_set_align(halign, valign);
	
	if (on_draw != -1)
	{
		on_draw(x, y);
	}
	
	if (drop_shadow)
	{
		draw_text_transformed_colour(x, y + (2 * yscale), text, xscale, yscale, image_angle, c_black, c_black, c_black, c_black, alpha * 0.3);
	}
	
	draw_text_transformed_colour(x, y, text, xscale, yscale, image_angle, colour, colour, colour, colour, alpha);
}