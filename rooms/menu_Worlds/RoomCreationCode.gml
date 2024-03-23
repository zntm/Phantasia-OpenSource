var _file_name = file_find_first($"{DIRECTORY_DATA_WORLD}/*", fa_directory);

var i = 0;

#macro MENU_WORLDS_YSTART 220

#macro MENU_WORLDS_XSCALE 24
#macro MENU_WORLDS_YSCALE 6

#macro MENU_WORLDS_ACHIEVEMENT_XSCALE 3
#macro MENU_WORLDS_ACHIEVEMENT_YSCALE 3

var _buffer;
var _buffer2;

var _y;
var _sprite;

var _v;
var _version;

while (_file_name != "" && i <= MENU_SELECTION_MAX)
{
	// show_debug_message($"Menu - Loading World: '{DIRECTORY_DATA_WORLD}/{_file_name}'");
	
	try
	{
		_buffer = buffer_load($"{DIRECTORY_DATA_WORLD}/{_file_name}/Info.dat");
		_buffer2 = buffer_decompress(_buffer);
		
		_y = MENU_WORLDS_YSTART - (16 * MENU_WORLDS_YSCALE / 2) + (i * (16 * MENU_WORLDS_YSCALE));
	
		_sprite = (i % 2 ? spr_Menu_Button_Secondary : spr_Menu_Button_Main);
	
		with (instance_create_layer(480 + (16 * MENU_WORLDS_XSCALE / 2) + (16 * MENU_WORLDS_ACHIEVEMENT_XSCALE / 2), _y - (16 * MENU_WORLDS_ACHIEVEMENT_YSCALE / 2), "List", obj_Menu_Button))
		{
			sprite_index = _sprite;
		
			image_xscale = MENU_WORLDS_ACHIEVEMENT_XSCALE;
			image_yscale = MENU_WORLDS_ACHIEVEMENT_YSCALE;
		
			icon = ico_Trash;
			list = true;
			directory = _file_name;
		
			on_press = menu_worlds_delete;
		}
	
		/*
		with (instance_create_layer(480 + (16 * MENU_WORLDS_XSCALE / 2) + (16 * MENU_WORLDS_ACHIEVEMENT_XSCALE / 2), _y + (16 * MENU_WORLDS_ACHIEVEMENT_YSCALE / 2), "List", obj_Menu_Button))
		{
			sprite_index = _sprite;
		
			image_xscale = MENU_WORLDS_ACHIEVEMENT_XSCALE;
			image_yscale = MENU_WORLDS_ACHIEVEMENT_YSCALE;
		
			icon = ico_YouTube;
			list = true;
			directory = _file_name;
		}
		*/
	
		with (instance_create_layer(480, _y, "List", obj_Menu_Button))
		{
			sprite_index = _sprite;
		
			image_xscale = MENU_WORLDS_XSCALE;
			image_yscale = MENU_WORLDS_YSCALE;
		
			list = true;
			data = {
				info: {},
				environment: {},
				activity: {}
			};
		
			data.info.name = buffer_read(_buffer2, buffer_string);
			data.info.seed = buffer_read(_buffer2, buffer_s32);
		
			_v = buffer_read(_buffer2, buffer_u64);
		
			data.environment.weather_wind  = ((_v >> 56) & 0xff) / 100;
			data.environment.weather_storm = ((_v >> 48) & 0xff) / 100;
		
			data.environment.biome      = (_v >> 40) & 0xff;
			data.environment.biome_type = (_v >> 32) & 0xff;
			
			data.environment.time  = buffer_read(_buffer2, buffer_f64);
			data.environment.value = _v & 0xffffffff;
		
			data.activity.date = buffer_read(_buffer2, buffer_f64);
		
			_version = buffer_read(_buffer2, buffer_u32);
		
			data.activity.type = _version >> 24;
			
			data.activity.major = (_version >> 16) & 0xff;
			data.activity.minor = (_version >> 8) & 0xff;
			data.activity.patch = _version & 0xff;
		
			directory_name = _file_name;
		
			on_draw = menu_worlds_on_draw;
			on_press = menu_worlds_on_press;
		}
	
		buffer_delete(_buffer);
		buffer_delete(_buffer2);
	
		++i;
	}
	catch (_error)
	{
	}
	
	_file_name = file_find_next();
}

file_find_close();

global.menu_world_length = i;

#macro MENU_WORLDS_SCROLL_SPEED 20
#macro MENU_WORLDS_SCROLL_STRENGTH 0.5

with (obj_Menu_Control)
{
	offset_speed = 0;
	offset = 0;

	on_step = function()
	{
		if (mouse_wheel_up())
		{
			offset_speed = -MENU_WORLDS_SCROLL_SPEED;
		}
		else if (mouse_wheel_down())
		{
			offset_speed = MENU_WORLDS_SCROLL_SPEED;
		}
		
		var _max = (16 * MENU_WORLDS_YSCALE * global.menu_world_length) - (room_height - MENU_WORLDS_YSTART - (16 * MENU_WORLDS_YSCALE / 2));
	
		offset_speed = lerp(offset_speed, 0, 0.2);
		offset = clamp(offset + offset_speed, 0, _max);
		
		var _offset = cubic_midpoint_ease_in_out(offset / _max, MENU_WORLDS_SCROLL_STRENGTH) * _max;
	
		with (obj_Menu_Button)
		{
			if (variable_instance_exists(id, "list"))
			{
				y = ystart - _offset;
			}
		}
	}
}

obj_Menu_Control.area = inst_38520057;
obj_Menu_Control.shader = shd_Menu_List;
obj_Menu_Control.on_shader = function()
{
	var _t = surface_get_texture(obj_Menu_Control.surface);
	var _w = texture_get_texel_width(_t);
	var _h = texture_get_texel_height(_t);
	
	shader_set_uniform_f(
		global.shader_menu_list_area,
		inst_38520057.bbox_left   * _w,
		inst_38520057.bbox_top    * _h,
		inst_38520057.bbox_right  * _w,
		inst_38520057.bbox_bottom * _h
	);
	
	var _x1 = inst_3D1C6FF7.bbox_left;
	var _y1 = inst_3D1C6FF7.bbox_top;
	var _x2 = inst_3D1C6FF7.bbox_right;
	var _y2 = inst_3D1C6FF7.bbox_bottom;
	
	if (!inst_3D1C6FF7.selected)
	{
		var _sprite = asset_get_index(sprite_get_name(inst_3D1C6FF7.sprite_index) + "_Edge");
		
		if (_sprite != -1)
		{
			_y1 -= sprite_get_height(_sprite);
		}
	}
	
	if (instance_position(mouse_x, mouse_y, obj_Menu_Button) == inst_3D1C6FF7)
	{
		--_x1;
		--_y1;
		++_x2;
		++_y2;
	}
	
	shader_set_uniform_f(global.shader_menu_list_create, _x1 * _w, _y1 * _h, _x2 * _w, _y2 * _h);
}