#macro CREDITS_ICON_OFFSET -2
#macro CREDITS_TEXT_OFFSET 12
#macro CREDITS_HEADER_XSCALE 1.5
#macro CREDITS_HEADER_YSCALE 1.5
#macro CREDITS_USER_XSCALE 0.75
#macro CREDITS_USER_YSCALE 0.75

var _x = room_width / 2;
var _y = global.credits_offset + 64;

var _credit_data = global.credit_data;

var _header;
var _headers = struct_get_names(_credit_data);
var _headers_length = array_length(_headers);

var _user;
var _users;
var _users_length;

var _name;
var _icon;

var i = 0;
var j;

draw_set_valign(fa_middle);

repeat (_headers_length)
{
	_header = _headers[i++];
	
	draw_set_halign(fa_center);
	
	draw_text_transformed(_x, _y, _header, CREDITS_HEADER_XSCALE, CREDITS_HEADER_YSCALE, 0);
	
	draw_set_halign(fa_left);
	
	_y += string_height(_header) / 2;
	
	_users = _credit_data[$ _header];
	_users_length = array_length(_users);
	
	j = 0;
	
	repeat (_users_length)
	{
		_user = _users[j++];
		
		_icon = _user.icon;
		
		if (_icon != -1)
		{
			draw_sprite_ext(_icon, 0, _x - (8 * CREDITS_USER_XSCALE) + CREDITS_ICON_OFFSET, _y, CREDITS_USER_XSCALE, CREDITS_USER_YSCALE, 0, c_white, 1);
		}
		
		_name = _user.name;
		
		draw_text_transformed(_x, _y, _name, CREDITS_USER_XSCALE, CREDITS_USER_YSCALE, 0);
		
		_y += string_height(_name) * CREDITS_USER_YSCALE;
	}
	
	_y += CREDITS_TEXT_OFFSET;
}

--global.credits_offset;

if (mouse_wheel_up())
{
	global.credits_offset += 8;
}

if (mouse_wheel_down())
{
	global.credits_offset -= 8;
}

if (_y < 64) && (!instance_exists(obj_Fade))
{
	global.menu_main_fade = true;
	
	with (instance_create_layer(0, 0, "Instances", obj_Fade))
	{
		image_alpha = 0;
		
		value = FADE_SPEED;
		goto_room = menu_Main;
	}
}