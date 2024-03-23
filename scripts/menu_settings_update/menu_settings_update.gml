function menu_settings_update()
{
	
	
	var _depth = layer_get_depth(layer_get_id("Settings"));
	
	with (all)
	{
		if (depth == _depth)
		{
			instance_destroy();
		}
	}
	
	var _category = global.menu_setting;
	var _settings = global.settings[$ _category];
	
	var _name;
	var _setting;
	var _inst;
	
	var _y;
	
	var _value;
	
	var _names = struct_get_names(_settings);
	var _length = array_length(_names);
	
	var i = 0;
	
	repeat (_length)
	{
		_name = _names[i++];
		_setting = _settings[$ _name];
		
		_y = 152 + (40 * _setting.order);
		
		#macro MENU_SETTINGS_X 840
		#macro MENU_SETTINGS_XOFFSET 80
		
		with (instance_create_layer(16, _y, "Settings", obj_Menu_Text))
		{
			name = _name;
			
			text = loca_translate($"settings.{_category}.{_name}.name");
			description_loca = $"settings.{_category}.{name}.description";
			description = loca_translate(description_loca);
			
			halign = fa_left;
			valign = fa_middle;
			
			on_draw = function(_x, _y)
			{
				if (description != description_loca)
				{
					draw_text_ext_transformed_colour(_x, _y + 8, description, 0, 100_000, 0.5, 0.5, 0, c_white, c_white, c_white, c_white, 0.5);
				}
			}
		}
		
		switch (_setting.type)
		{
		
		case SETTINGS_TYPE.SWITCH:
			_value = _setting.value;
			
			with (instance_create_layer(MENU_SETTINGS_X + (_value ? 8 : -8), _y, "Settings", obj_Menu_Button))
			{
				sprite_index = spr_Menu_Button_Secondary;
				
				image_xscale = 1;
				image_yscale = 2;
				
				value = _value;
				
				category = _category;
				type = _name;
				
				on_press = function()
				{
					value = !value;
					
					x = MENU_SETTINGS_X + (value ? 8 : -8);
					
					global.settings[$ category][$ type].value = value;
					
					var _setting = global.settings[$ category][$ type];
					var _on_press = _setting.on_press;
					
					if (_on_press != -1)
					{
						_on_press(_setting);
					}
				}
				
				on_draw = function(_x, _y, _colour, _id)
				{
					draw_sprite_ext(spr_Menu_Indent, 0, MENU_SETTINGS_X + (_id.value ? -8 : 8), _id.y, 2, 2, 0, c_white, 1);
				}
			}
			break;
		
		case SETTINGS_TYPE.SLIDER_ZERO_ONE:
			#macro MENU_SETTINGS_SLIDER_SIZE 80
			
			_value = _setting.value;
			
			with (instance_create_layer(MENU_SETTINGS_X - MENU_SETTINGS_SLIDER_SIZE + (MENU_SETTINGS_SLIDER_SIZE * _value * 2), _y, "Settings", obj_Menu_Button))
			{
				sprite_index = spr_Menu_Button_Secondary;
				
				image_xscale = 1;
				image_yscale = 2;
				
				value = _value;
				
				category = _category;
				type = _name;
				
				on_hold = function()
				{
					x = clamp(mouse_x, MENU_SETTINGS_X - MENU_SETTINGS_SLIDER_SIZE, MENU_SETTINGS_X + MENU_SETTINGS_SLIDER_SIZE);
					
					value = normalize(x, MENU_SETTINGS_X - MENU_SETTINGS_SLIDER_SIZE, MENU_SETTINGS_X + MENU_SETTINGS_SLIDER_SIZE);
					global.settings[$ category][$ type].value = value;
					
					var _s = global.settings[$ category][$ type];
					var _o = _s.on_hold;
					
					if (_o != -1)
					{
						_o(_s);
					}
				}
				
				on_draw = function(_x, _y, _colour, _id)
				{
					with (_id)
					{
						draw_sprite_ext(spr_Menu_Indent, 0, MENU_SETTINGS_X, y, (MENU_SETTINGS_SLIDER_SIZE / 8) * 2, 2, 0, c_white, 1);
						draw_sprite_ext(sprite_index, image_index, _x, _y, image_xscale, image_yscale, 0, _colour, 1);
					}
				}
			}
			break;
		
		case SETTINGS_TYPE.HOTKEY:
			with (instance_create_layer(MENU_SETTINGS_X, _y, "Settings", obj_Menu_Button))
			{
				image_xscale = 2;
				image_yscale = 2;
				
				name = loca_translate($"settings.{_category}.{_name}.name");
				text = get_key_name(_setting.value);
				
				category = _category;
				type = _name;
				
				on_press = function()
				{
					global.is_popup = true;
					
					obj_Menu_Settings.hotkey = true;
					obj_Menu_Settings.category = category;
					obj_Menu_Settings.type = type;
					obj_Menu_Settings.inst = id;
					obj_Menu_Settings.name = name;
				}
			}
			break;
		
		case SETTINGS_TYPE.ARROW:
			_inst = instance_create_layer(MENU_SETTINGS_X, _y, "Settings", obj_Menu_Button);
			
			with (_inst)
			{
				text = _setting.values[_setting.value];
				
				image_xscale = 8;
				image_yscale = 2;
				
				category = _category;
				type = _name;
			}
			
			with (instance_create_layer(MENU_SETTINGS_X - MENU_SETTINGS_XOFFSET, _y, "Settings", obj_Menu_Button))
			{
				sprite_index = spr_Setting_Arrow_Left;
				
				category = _category;
				type = _name;
				
				inst = _inst;
				
				on_press = function()
				{
					
					
					var _category = inst.category;
					var _type = inst.type;
					
					var _value = --global.settings[$ _category][$ _type].value;
					var _settings = global.settings[$ _category];
					
					if (_value < 0)
					{
						_value = array_length(_settings[$ _type].values) - 1;
						global.settings[$ _category][$ _type].value = _value;
					}
					
					var _v = _settings[$ _type];
					var _o = _v.on_press;
					
					if (_o != -1)
					{
						_o(_v);
					}
					
					inst.text = _settings[$ _type].values[_value];
					
					if (_type == "language")
					{
						with (obj_Menu_Button)
						{
							if (variable_instance_exists(id, "loca"))
							{
								text = loca_translate(loca);
							}
						}
					}
				}
			}
			
			with (instance_create_layer(MENU_SETTINGS_X + MENU_SETTINGS_XOFFSET, _y, "Settings", obj_Menu_Button))
			{
				sprite_index = spr_Setting_Arrow_Right;
				
				category = _category;
				type = _name;
				
				inst = _inst;
				
				on_press = function()
				{
					
					
					var _category = inst.category;
					var _type = inst.type;
					
					var _value = ++global.settings[$ _category][$ _type].value;
					var _settings = global.settings[$ _category];
					
					if (_value >= array_length(_settings[$ _type].values))
					{
						_value = 0;
						global.settings[$ _category][$ _type].value = 0;
					}
					
					var _v = _settings[$ _type];
					var _o = _v.on_press;
					
					if (_o != -1)
					{
						_o(_v);
					}
					
					inst.text = _settings[$ _type].values[_value];
					
					if (_type == "language")
					{
						with (obj_Menu_Button)
						{
							if (variable_instance_exists(id, "loca"))
							{
								text = loca_translate(loca);
							}
						}
					}
				}
			}
			break;
		
		}
	}
}