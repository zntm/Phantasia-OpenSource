function menu_player_create_update()
{
	
	
	var _menu_player_create = global.menu_player_create;
	
	inst_7D770A8D.text = loca_translate($"menu.create_player.attire.{_menu_player_create}");
	
	var _depth = layer_get_depth(layer_get_id("Selection"));
	
	with (all)
	{
		if (depth == _depth)
		{
			instance_destroy();
		}
	}
	
	#macro MENU_PLAYERS_CREATE_ATTIRE_WIDTH 3
	#macro MENU_PLAYERS_CREATE_ATTIRE_HEIGHT 4
	
	var i = 0;
	var j;
	var l = global.menu_player_create_page_attire * MENU_PLAYERS_CREATE_ATTIRE_WIDTH * MENU_PLAYERS_CREATE_ATTIRE_HEIGHT;
	
	var _xstart;
	var _ystart;
	
	var _y;
	
	var _break = false;
	
	#region Attire
	
	if (_menu_player_create != "base_body")
	{
		inst_6B3CE1D1.visible_button = true;
		inst_1B81DBB7.visible_button = true;
		
		inst_6B3CE1D1.volume = 1;
		inst_1B81DBB7.volume = 1;
		
		var _attire;
		var _attire_data = global.attire_data;
		var _attires = _attire_data[$ _menu_player_create];
		var _attire_length = array_length(_attires);
	
		_xstart = inst_44DA3BF0.x;
		_ystart = inst_44DA3BF0.y;
	
		repeat (MENU_PLAYERS_CREATE_ATTIRE_HEIGHT)
		{
			_y = _ystart + (i * 48);
			
			j = 0;
		
			repeat (MENU_PLAYERS_CREATE_ATTIRE_WIDTH)
			{
				if (l >= _attire_length)
				{
					_break = true;
				
					break;
				}
				
				_attire = _attires[l];
			
				with (instance_create_layer(_xstart + (j * 48), _y, "Selection", obj_Menu_Button))
				{
					image_xscale = 3;
					image_yscale = 3;
					
					index = l;
					
					if (_attire != -1)
					{
						surface = -1;
						surface2 = -1;
						
						if (_menu_player_create == "shirt") || (_menu_player_create == "undershirt")
						{
							type = "shirt";
							type2 = "undershirt";
						}
						else
						{
							type = _menu_player_create;
							type2 = -1;
						}
				
						on_draw = function(_x, _y, _colour)
						{
							var _attire_data = global.attire_data;
							var _colour_data = global.colour_data;
							var _menu_player_create_attire = global.menu_player_create_attire;
								
							var _match = global.shader_colour_replace_match;
							var _replace = global.shader_colour_replace_replace;
							var _amount  = global.shader_colour_replace_amount;
							
							if (!surface_exists(surface))
							{
								surface = surface_create(22, 32);
								
								surface_set_target(surface);
								draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
				
								shader_set(shd_Colour_Replace);
								shader_set_uniform_i_array(_match, _colour_data[8]);
								shader_set_uniform_i_array(_replace, _colour_data[_menu_player_create_attire[$ type].colour]);
								shader_set_uniform_i(_amount, PLAYER_COLOUR_MAP_BASE_AMOUNT + PLAYER_COLOUR_MAP_OUTLINE_AMOUNT);
	
								if (type == "base_body")
								{
									draw_sprite(att_Base_Arm_Right, 0, 11, 24);
									draw_sprite(att_Base_Body, 0, 11, 24);
									draw_sprite(att_Base_Arm_Left, 0, 11, 24);
									draw_sprite(att_Base_Legs, 0, 11, 24);
								}
								else
								{
									var _attire = _attire_data[$ type][index];
									
									if (_attire != -1)
									{
										draw_sprite(_attire.colour, 0, 11, 24);
									}
								}
								
								shader_reset();
	
								surface_reset_target();
							}
							
							draw_surface_ext(surface, _x - (11 * 2), _y - (24 * 2), 2, 2, 0, c_white, 1);
	
							if (type != "base_body")
							{
								var _attire_white = _attire_data[$ type][index];
								
								if (_attire_white != -1)
								{
									_attire_white = _attire_white.white;
		
									if (_attire_white != -1)
									{
										draw_sprite_ext(_attire_white, 0, _x, _y, 2, 2, 0, c_white, 1);
									}
								}
							}
							
							if (type2 == -1) exit;
							
							if (!surface_exists(surface2))
							{
								surface2 = surface_create(22, 32);
								
								surface_set_target(surface2);
								draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
				
								shader_set(shd_Colour_Replace);
								shader_set_uniform_i_array(_match, _colour_data[8]);
								shader_set_uniform_i_array(_replace, _colour_data[_menu_player_create_attire[$ type2].colour]);
								shader_set_uniform_i(_amount, PLAYER_COLOUR_MAP_BASE_AMOUNT + PLAYER_COLOUR_MAP_OUTLINE_AMOUNT);
	
								var _attire = _attire_data[$ type2][index];
									
								if (_attire != -1)
								{
									draw_sprite(_attire.colour, 0, 11, 24);
								}
								
								shader_reset();
	
								surface_reset_target();
							}
							
							draw_surface_ext(surface2, _x - (11 * 2), _y - (24 * 2), 2, 2, 0, c_white, 1);
	
							if (type2 != "base_body")
							{
								var _attire_white = _attire_data[$ type2][index];
								
								if (_attire_white)
								{
									_attire_white = _attire_white.white;
									
									if (_attire_white != -1)
									{
										draw_sprite_ext(_attire_white, 0, _x, _y, 2, 2, 0, c_white, 1);
									}
								}
							}
						}
						
						on_destroy = function()
						{
							surface_free_existing(surface);
							surface_free_existing(surface2);
						}
					
						on_press = function()
						{
							global.menu_player_create_attire[$ type].index = index;
							obj_Menu_Players_Create.refresh[$ type] = true;
							
							if (type2 != -1)
							{
								global.menu_player_create_attire[$ type2].index = index;
								obj_Menu_Players_Create.refresh[$ type2] = true;
							}
						}
					}
				}
			
				if (++l >= _attire_length)
				{
					_break = true;
				
					break;
				}
			
				++j;
			}
		
			if (_break) break;
		
			++i;
		}
	}
	else
	{
		inst_6B3CE1D1.visible_button = false;
		inst_1B81DBB7.visible_button = false;
		
		inst_6B3CE1D1.volume = 0;
		inst_1B81DBB7.volume = 0;
	}
	
	#endregion
	
	#region Colors
	
	var _colour_data = global.colour_data;
	var _colour_length = array_length(_colour_data);
	
	_xstart = inst_2A66492F.x;
	_ystart = inst_2A66492F.y;
	
	#macro MENU_PLAYERS_CREATE_COLOUR_WIDTH 3
	#macro MENU_PLAYERS_CREATE_COLOUR_HEIGHT 4
	
	i = 0;
	l = global.menu_player_create_page_colour * MENU_PLAYERS_CREATE_COLOUR_WIDTH * MENU_PLAYERS_CREATE_COLOUR_HEIGHT;
	
	_break = false;
	
	repeat (MENU_PLAYERS_CREATE_COLOUR_HEIGHT)
	{
		_y = _ystart + (i * 48);
		
		j = 0;
		
		repeat (MENU_PLAYERS_CREATE_COLOUR_WIDTH)
		{
			if (l >= _colour_length)
			{
				_break = true;
				
				break;
			}
			
			with (instance_create_layer(_xstart + (j * 48), _y, "Selection", obj_Menu_Button))
			{
				index = l;
				
				image_xscale = 3;
				image_yscale = 3;
				
				on_draw = function(_x, _y, _colour)
				{
					#macro MENU_PLAYER_CREATE_COLOUR_WIDTH 32
					#macro MENU_PLAYER_CREATE_COLOUR_HEIGHT 32
					
					#macro MENU_PLAYER_CREATE_COLOUR_OUTLINE_WIDTH 2
					#macro MENU_PLAYER_CREATE_COLOUR_OUTLINE_HEIGHT 2
					
					var _offset;
					
					var _base_x = _x - (MENU_PLAYER_CREATE_COLOUR_WIDTH / 2);
					var _base_y = _y - (MENU_PLAYER_CREATE_COLOUR_HEIGHT / 2);
					
					var _outline_x = _base_x - MENU_PLAYER_CREATE_COLOUR_OUTLINE_WIDTH;
					var _outline_y = _base_y - MENU_PLAYER_CREATE_COLOUR_OUTLINE_HEIGHT;
					
					var i = 0;
					
					var _player_colour = global.colour_data[index];
					
					repeat (PLAYER_COLOUR_MAP_OUTLINE_AMOUNT)
					{
						_offset = i * (MENU_PLAYER_CREATE_COLOUR_WIDTH / PLAYER_COLOUR_MAP_OUTLINE_AMOUNT);
						
						draw_sprite_ext(spr_Square, 0, _outline_x, _outline_y + _offset, MENU_PLAYER_CREATE_COLOUR_WIDTH + (MENU_PLAYER_CREATE_COLOUR_OUTLINE_WIDTH * 2), MENU_PLAYER_CREATE_COLOUR_HEIGHT + (MENU_PLAYER_CREATE_COLOUR_OUTLINE_HEIGHT * 2) - _offset, 0, _player_colour[PLAYER_COLOUR_MAP_BASE_AMOUNT + i], 1);
						
						++i;
					}
					
					i = 0;
					
					repeat (PLAYER_COLOUR_MAP_BASE_AMOUNT)
					{ 
						_offset = i * (MENU_PLAYER_CREATE_COLOUR_WIDTH / PLAYER_COLOUR_MAP_BASE_AMOUNT);
						
						draw_sprite_ext(spr_Square, 0, _base_x, _base_y + _offset, MENU_PLAYER_CREATE_COLOUR_WIDTH, MENU_PLAYER_CREATE_COLOUR_HEIGHT - _offset, 0, _player_colour[i], 1);
						
						++i;
					}
				}
				
				on_press = function()
				{
					var _menu_player_create = global.menu_player_create;
					
					global.menu_player_create_attire[$ _menu_player_create].colour = index;
					obj_Menu_Players_Create.refresh[$ _menu_player_create] = true;
				}
			}
			
			if (++l >= _colour_length)
			{
				_break = true;
				
				break;
			}
			
			++j;
		}
		
		if (_break) break;
		
		++i;
	}
	
	#endregion
}