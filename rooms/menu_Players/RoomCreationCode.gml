var _buffer;
var _buffer2;

var _file_name = file_find_first($"{DIRECTORY_DATA_PLAYER}/*", fa_directory);

var i = 0;

var _sprite;
var _u;
var _n;
var _q;
var _v;
var _w;
var _r;
var _k;
var _l;

var _y;

#macro MENU_PLAYERS_YSTART 220

#macro MENU_PLAYERS_XSCALE 24
#macro MENU_PLAYERS_YSCALE 6

while (_file_name != "" && i <= MENU_SELECTION_MAX)
{
	// show_debug_message($"Menu - Loading Player: '{DIRECTORY_DATA_PLAYER}/{_file_name}'");
	
	try
	{
		_buffer = buffer_load($"{DIRECTORY_DATA_PLAYER}/{_file_name}/Info.dat");
		_buffer2 = buffer_decompress(_buffer);
	
		_y = MENU_PLAYERS_YSTART - (16 * MENU_PLAYERS_YSCALE / 2) + (i * (16 * MENU_PLAYERS_YSCALE));
	
		_sprite = (i % 2 ? spr_Menu_Button_Secondary : spr_Menu_Button_Main);
	
		with (instance_create_layer(480 + (16 * MENU_PLAYERS_XSCALE / 2) + (16 * MENU_WORLDS_ACHIEVEMENT_XSCALE / 2), _y - (16 * MENU_WORLDS_ACHIEVEMENT_YSCALE / 2), "List", obj_Menu_Button))
		{
			sprite_index = _sprite;
		
			image_xscale = MENU_WORLDS_ACHIEVEMENT_XSCALE;
			image_yscale = MENU_WORLDS_ACHIEVEMENT_YSCALE;
		
			icon = ico_Trash;
			list = true;
		
			directory = _file_name;
		
			on_press = menu_players_delete;
			area_bound = true;
		}
	
		with (instance_create_layer(480, _y, "List", obj_Menu_Button))
		{
			sprite_index = _sprite;
		
			image_xscale = MENU_PLAYERS_XSCALE;
			image_yscale = MENU_PLAYERS_YSCALE;
		
			list = true;
			area_bound = true;
		
			_u = buffer_read(_buffer2, buffer_u64);
			_n = buffer_read(_buffer2, buffer_string);
			_v = buffer_read(_buffer2, buffer_u64);
			_q = buffer_read(_buffer2, buffer_u64);
			_k = buffer_read(_buffer2, buffer_f64);
			_l = buffer_read(_buffer2, buffer_u64);
		
			data = {
				name: _n,
				last_played: _k,
				hp: (_u >> 16) & 0xff,
				hp_max: _u & 0xff,
				hotbar: _u >> 32,
				parts: {
					base_body: { colour: _v >> 48 }
				},
				uuid: _file_name,
				hp: _l >> 8,
				hp_max: _l & 0xff,
			};
		
			_r = (_v >> 36) & 0xfff;
			data.parts.headwear = (_r == 0 ? -1 : { index: _r >> 6, colour: _r & 0x3f });
		
			_r = (_v >> 24) & 0xfff;
			data.parts.hair = (_r == 0 ? -1 : { index: _r >> 6, colour: _r & 0x3f });
		
			_r = (_v >> 12) & 0xfff;
			data.parts.head_detail = (_r == 0 ? -1 : { index: _r >> 6, colour: _r & 0x3f });
		
			_r = _v & 0xfff;
			data.parts.eyes = (_r == 0 ? -1 : { index: _r >> 6, colour: _r & 0x3f });
		
			_r = (_q >> 48) & 0xfff;
			data.parts.pants = (_r == 0 ? -1 : { index: _r >> 6, colour: _r & 0x3f });
		
			_r = (_q >> 36) & 0xfff;
			data.parts.shirt = (_r == 0 ? -1 : { index: _r >> 6, colour: _r & 0x3f });
		
			_r = (_q >> 24) & 0xfff;
			data.parts.undershirt = (_r == 0 ? -1 : { index: _r >> 6, colour: _r & 0x3f });
		
			_r = (_q >> 12) & 0xfff;
			data.parts.body_detail = (_r == 0 ? -1 : { index: _r >> 6, colour: _r & 0x3f });
		
			_r = _q & 0xfff;
			data.parts.footwear = (_r == 0 ? -1 : { index: _r >> 6, colour: _r & 0x3f });
		
			directory_name = _file_name;
		
			on_draw = function(_a, _b, _colour)
			{
				draw_set_align(fa_left, fa_top);
			
				var _size = bbox_right - bbox_left - 128;
			
				var _name = $"{data.name} ({data.hp}HP/{data.hp_max}HP)";
				var _scale_name = min(1, _size / string_width(_name));
			
				var _last_played = date_datetime_string(data.last_played);
				var _scale_last_played = min(1, _size / string_width(_last_played));
			
				var _x = x - (16 * image_xscale / 2);
				var _y = y - (16 * image_yscale / 2);
			
				draw_text_transformed_colour(_x + 64, _y + 8, _name, _scale_name, _scale_name, 0, _colour, _colour, _colour, _colour, 1);
				draw_text_transformed_colour(_x + 64, _y + 28, _last_played, _scale_last_played, _scale_last_played, 0, _colour, _colour, _colour, _colour, 1);
			
				var _attire_elements_ordered = global.attire_elements_ordered;
				var i = 0;
				var _length = array_length(_attire_elements_ordered);
			
				var _colour_data = global.colour_data;
				var _attire_data = global.attire_data;
				var _white = _colour_data[8];
				var _part;
				var _v;
				var _w;
				var _u;
				var _g;
				var _t;
				var _match = global.shader_colour_replace_match;
				var _replace = global.shader_colour_replace_replace;
				var _amount = global.shader_colour_replace_amount;
				var _parts = data.parts;
				var _body = _colour_data[_parts.base_body.colour];
				var _white2;
			
				var _index = 1 + ((global.timer_delta / 8) % 6);
			
				var _x2 = _x + 32;
				var _y2 = _y + 56;
			
				repeat (_length)
				{
					_v = _attire_elements_ordered[i++];
					_part = _parts[$ _v];
				
					if (_v == "base_body")
					{
						shader_set(shd_Colour_Replace);
						shader_set_uniform_i_array(_match, _white);
						shader_set_uniform_i_array(_replace, _body);
						shader_set_uniform_i(_amount, PLAYER_COLOUR_MAP_BASE_AMOUNT + PLAYER_COLOUR_MAP_OUTLINE_AMOUNT);
						draw_sprite_ext(att_Base_Body, _index, _x2, _y2, 2, 2, 0, c_white, 1);
						shader_reset();
					}
					else if (_v == "base_left_arm")
					{
						shader_set(shd_Colour_Replace);
						shader_set_uniform_i_array(_match, _white);
						shader_set_uniform_i_array(_replace, _body);
						shader_set_uniform_i(_amount, PLAYER_COLOUR_MAP_BASE_AMOUNT + PLAYER_COLOUR_MAP_OUTLINE_AMOUNT);
						draw_sprite_ext(att_Base_Arm_Left, _index, _x2, _y2, 2, 2, 0, c_white, 1);
						shader_reset();
					}
					else if (_v == "base_right_arm")
					{
						shader_set(shd_Colour_Replace);
						shader_set_uniform_i_array(_match, _white);
						shader_set_uniform_i_array(_replace, _body);
						shader_set_uniform_i(_amount, PLAYER_COLOUR_MAP_BASE_AMOUNT + PLAYER_COLOUR_MAP_OUTLINE_AMOUNT);
						draw_sprite_ext(att_Base_Arm_Right, _index, _x2, _y2, 2, 2, 0, c_white, 1);
						shader_reset();
					}
					else if (_v == "base_legs")
					{
						shader_set(shd_Colour_Replace);
						shader_set_uniform_i_array(_match, _white);
						shader_set_uniform_i_array(_replace, _body);
						shader_set_uniform_i(_amount, PLAYER_COLOUR_MAP_BASE_AMOUNT + PLAYER_COLOUR_MAP_OUTLINE_AMOUNT);
						draw_sprite_ext(att_Base_Legs, _index, _x2, _y2, 2, 2, 0, c_white, 1);
						shader_reset();
					}
					else if (_part != -1)
					{
						_g = _attire_data[$ _v][_part.index];
					
						if (_g != -1)
						{
							shader_set(shd_Colour_Replace);
							shader_set_uniform_i_array(_match, _white);
							shader_set_uniform_i_array(_replace, _colour_data[_part.colour]);
							shader_set_uniform_i(_amount, PLAYER_COLOUR_MAP_BASE_AMOUNT + PLAYER_COLOUR_MAP_OUTLINE_AMOUNT);
							draw_sprite_ext(_g.colour, _index, _x2, _y2, 2, 2, 0, c_white, 1);
						
							_t = _g[$ "colour2"];
						
							if (_t != undefined)
							{
								draw_sprite_ext(_t, _index, _x2, _y2, 2, 2, 0, c_white, 1);
							}
						
							_t = _g[$ "colour3"];
						
							if (_t != undefined)
							{
								draw_sprite_ext(_t, _index, _x2, _y2, 2, 2, 0, c_white, 1);
							}
						
							shader_reset();
						
							_white2 = _g.white;
						
							if (_white2 != -1)
							{
								draw_sprite_ext(_white2, _index, _x2, _y2, 2, 2, 0, c_white, 1);
							}
						}
					}
				}
			};
		
			on_press = function()
			{
				global.player = data;
			
				// spawn creature, spawn structure, gamemode, difficulty, command level, world type
				// 0b0_0_0000_0000_0000_0000
				global.world = {
					info: {},
					environment: {
						value: 0x30000 | (GAMEMODE_TYPE.ADVENTURE << 12) | (DIFFICULTY_TYPE.NORMAL << 8) | (CHAT_COMMAND_LEVEL.NONE << 4) | WORLD.PLAYGROUND
					},
					activity: {}
				};
	
				room_goto(menu_Worlds);
			};
		}
	
		buffer_delete(_buffer);
		buffer_delete(_buffer2);
	}
	catch (_error)
	{
	}
	
	_file_name = file_find_next();
	
	++i;
}

global.menu_player_length = i;

file_find_close();

#macro MENU_PLAYERS_SCROLL_SPEED 20
#macro MENU_PLAYERS_SCROLL_STRENGTH 0.5

with (obj_Menu_Control)
{
	offset_speed = 0;
	offset = 0;

	on_step = function()
	{
		if (mouse_wheel_up())
		{
			offset_speed = -MENU_PLAYERS_SCROLL_SPEED;
		}
		else if (mouse_wheel_down())
		{
			offset_speed = MENU_PLAYERS_SCROLL_SPEED;
		}
		
		var _max = (16 * MENU_PLAYERS_YSCALE * global.menu_player_length) - (room_height - MENU_PLAYERS_YSTART - (16 * MENU_PLAYERS_YSCALE / 2));
	
		offset_speed = lerp(offset_speed, 0, 0.2);
		offset = clamp(offset + offset_speed, 0, _max);
	
		var _offset = cubic_midpoint_ease_in_out(offset / _max, MENU_PLAYERS_SCROLL_STRENGTH) * _max;
	
		with (obj_Menu_Button)
		{
			if (variable_instance_exists(id, "list"))
			{
				y = ystart - _offset;
			}
		}
	}
}

obj_Menu_Control.area = inst_34B2EE2C;
obj_Menu_Control.shader = shd_Menu_List;
obj_Menu_Control.on_shader = function()
{
	var _t = surface_get_texture(obj_Menu_Control.surface);
	var _w = texture_get_texel_width(_t);
	var _h = texture_get_texel_height(_t);
	
	shader_set_uniform_f(
		global.shader_menu_list_area,
		inst_34B2EE2C.bbox_left   * _w,
		inst_34B2EE2C.bbox_top    * _h,
		inst_34B2EE2C.bbox_right  * _w,
		inst_34B2EE2C.bbox_bottom * _h
	);
	
	var _x1 = inst_6199EE69_1.bbox_left;
	var _y1 = inst_6199EE69_1.bbox_top;
	var _x2 = inst_6199EE69_1.bbox_right;
	var _y2 = inst_6199EE69_1.bbox_bottom;
	
	if (!inst_6199EE69_1.selected)
	{
		var _sprite = asset_get_index(sprite_get_name(inst_6199EE69_1.sprite_index) + "_Edge");
		
		if (_sprite != -1)
		{
			_y1 -= sprite_get_height(_sprite);
		}
	}
	
	if (instance_position(mouse_x, mouse_y, obj_Menu_Button) == inst_6199EE69_1)
	{
		--_x1;
		--_y1;
		++_x2;
		++_y2;
	}
	
	shader_set_uniform_f(global.shader_menu_list_create, _x1 * _w, _y1 * _h, _x2 * _w, _y2 * _h);
}