// Feather disable GM1014
// Feather disable GM1021
// Feather disable GM1044

if (is_exiting) exit;

gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);

var _timer = global.timer;
var _delta_time = global.delta_time;

var _camera = global.camera;

var _camera_x = _camera.x;
var _camera_y = _camera.y;

var _camera_width  = _camera.width;
var _camera_height = _camera.height;

var _refresh_value     = false;
var _refresh_on_update = false;
var _refresh_surface   = false;

if (!is_paused)
{
	_refresh_value     = (_timer % refresh_time_chunk);
	_refresh_on_update = (_timer % 4 == 0);
	_refresh_surface   = (_refresh_value == 0);
}

var _bounding_box_x = _camera_x - (TILE_SIZE * 8);
var _bounding_box_y = _camera_y - (TILE_SIZE * 8);
var _bounding_box_width  = _camera_x + _camera_width  + (TILE_SIZE * 8);
var _bounding_box_height = _camera_y + _camera_height + (TILE_SIZE * 8);

var _lights_updated = (global.light_updated_sun) || (obj_Player.xvelocity != 0 || obj_Player.yvelocity != 0);

with (obj_Creature)
{
	if (xvelocity != 0 || yvelocity != 0) && (x >= _bounding_box_x) && (x < _bounding_box_width) && (y >= _bounding_box_width) && (y < _bounding_box_height)
	{
		_lights_updated = true;
			
		break;
	}
}

var _lights_length = 0;

var _s;
var _d;
var _q;
var _w;

with (obj_Parent_Light)
{
	if (!rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, _bounding_box_x, _bounding_box_y, _bounding_box_width, _bounding_box_height)) continue;
	
	_s = floor(bbox_left);
	_d = floor(bbox_top);
	
	_q = floor(bbox_right);
	_w = floor(bbox_bottom);
	
	obj_Control.lights[@ _lights_length++] = [
		_s,
		_d,
		_q,
		_w,
		colour_offset
	];
}

var _lights = lights;
var _enable_lighting = global.local_settings.enable_lighting;

var _item_data = global.item_data;
var _creature_data = global.creature_data;

var _chunk_cache_lighting = global.chunk_cache_lighting;

var _boolean, _on_update;
var _update_surface;
var _lighting_left, _lighting_right;
var _inst;
var i, j, l, px, py, pz;
var _a, _b, _c;
var _x, _y, _g, _l, _t, _v, _u, _r;
var _f;
var _draw_y;
var _index_y, _index_z, _index_xy, _index_yz, _index_xyz;
var _tile_x, _tile_y, _tile_index;
var _xscale, _yscale;
var _tile, _tile_data;
var _default_tile, _default_tile_data;
var _data;
var _sprite, _index, _type, _width, _height, _skew, _x1, _y1;
var _skew_to;
var _surface_data;
var _offset, _flip_on, _animation_index;
var _colour;
var _animation_type;
var _z;
var _offset_z;
var _colour2;
var _colour3;

var _coloured_lighting = global.settings.graphics.coloured_lighting.value;

#macro DRAW_SKEW_AMOUNT 12
#macro DRAW_SKEW_SPEED 0.1

randomize();

var _skew_update = (random(1) < 0.1 * _delta_time);
var _skew_wind = global.world.environment.weather_wind - random_range(0.4, 0.6);
var _skew_strength = _skew_wind * DRAW_SKEW_AMOUNT;

with (obj_Chunk)
{
	if (!is_generated) || (!is_in_view) || (!surface_display) continue;
	
	_inst = instance_nearest(x, y, obj_Parent_Light);
	
	if (instance_exists(_inst)) && (rectangle_distance(xcenter, ycenter, _inst.bbox_left, _inst.bbox_top, _inst.bbox_right, _inst.bbox_bottom) >= (CHUNK_SIZE_WIDTH) * 1.5) continue;
	
	if (_refresh_on_update)
	{
		// _f = current_time;
		
		_z = 0;
		
		repeat (CHUNK_SIZE_Z)
		{
			if ((surface_display & (1 << _z)) == 0)
			{
				++_z;
				
				continue;
			}
			
			i = _z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT);
				
			j = i;
		
			repeat (CHUNK_SIZE_X * CHUNK_SIZE_Y)
			{
				_tile = chunk[j];
			
				if (_tile != ITEM.EMPTY)
				{
					chunk[@ j].boolean = _tile.boolean & 1;
				}
			
				++j;
			}
				
			_y = 0;
				
			repeat (CHUNK_SIZE_Y)
			{
				_index_yz = (_y << CHUNK_SIZE_X_BIT) | i;
				
				_a = chunk_ystart + _y++;
				_x = 0;
					
				repeat (CHUNK_SIZE_X)
				{
					_b = chunk_xstart + _x;
					_index_xyz = _x++ | _index_yz;
					
					_tile = chunk[_index_xyz];
						
					if (_tile == ITEM.EMPTY) continue;
					
					_boolean = _tile.boolean;
						
					if (_boolean & 2) continue;
					
					chunk[@ _index_xyz].boolean = _boolean | 2;
					
					_on_update = _item_data[_tile.item_id].on_update;
					
					if (_on_update != -1)
					{
						_on_update(_b, _a, _z);
					}
				}
			}
			
			++_z;
		}
		
		// show_debug_message($"({floor(x / CHUNK_SIZE_WIDTH)}, {floor(y / CHUNK_SIZE_WIDTH)}) - Render, On Update: {current_time - _f}ms");
	}
	
	if (!is_refresh) && (_refresh_value != refresh_value) continue;
	
	is_refresh = false;
	
	// _f = current_time;
		
	lighting = variable_clone(_chunk_cache_lighting);
		
	#region Calulcate Colors
		
	i = 0;
		
	repeat (CHUNK_SIZE_X)
	{
		if (i & 1 != 0) && (i != CHUNK_SIZE_X - 1)
		{
			++i;
				
			continue;
		}
				
		_tile_x = x + (i << TILE_SIZE_BIT);
			
		if (_tile_x >= _bounding_box_width) break;
			
		if (_tile_x < _bounding_box_x)
		{
			++i;
				
			continue;
		}
				
		j = 0;
			
		repeat (CHUNK_SIZE_Y)
		{
			_tile_y = y + (j << TILE_SIZE_BIT);
				
			if (_tile_y >= _bounding_box_height) break;
				
			if (_tile_y < _bounding_box_y)
			{
				++j;
					
				continue;
			}
					
			_index_xy = i | (j << CHUNK_SIZE_X_BIT);
				
			l = 0;
				
			repeat (CHUNK_SIZE_Z)
			{
				if (chunk[_index_xy | (l << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] == ITEM.EMPTY)
				{
					++l;
						
					continue;
				}
					
				if (light_get_distance(_tile_x, _tile_y, _lights, _lights_length, _enable_lighting))
				{
					lighting[@ _index_xy] = (1 << 24) | (_coloured_lighting ? light_get_value_colour(_tile_x, _tile_y, _lights, _lights_length, _enable_lighting) : light_get_value_white(_tile_x, _tile_y, _lights, _lights_length, _enable_lighting));
				}
					
				break;
			}
				
			++j;
		}
			
		++i;
	}
			
	#endregion
		
	// show_debug_message($"({floor(x / CHUNK_SIZE_WIDTH)}, {floor(y / CHUNK_SIZE_WIDTH)}) - Render, Lighting - Calculated: {current_time - _f}ms");
		
	// _f = current_time;
		
	#region Interpolate Colors
		
	i = 0;
		
	repeat (CHUNK_SIZE_X - 1)
	{
		if (i & 1 == 0)
		{
			++i;
				
			continue;
		}
				
		_tile_x = x + (i << TILE_SIZE_BIT);
			
		if (_tile_x >= _bounding_box_width) break;
			
		if (_tile_x < _bounding_box_x)
		{
			++i;
				
			continue;
		}
				
		j = 0;
			
		repeat (CHUNK_SIZE_Y)
		{
			_tile_y = y + (j << TILE_SIZE_BIT);
				
			if (_tile_y >= _bounding_box_height) break;
				
			if (_tile_y < _bounding_box_y)
			{
				++j;
					
				continue;
			}
					
			_index_xy = i | (j << CHUNK_SIZE_X_BIT);
				
			l = 0;
				
			repeat (CHUNK_SIZE_Z)
			{
				if (chunk[_index_xy | (l << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] == ITEM.EMPTY)
				{
					++l;
						
					continue;
				}
					
				_lighting_left  = lighting[_index_xy - 1];
				_lighting_right = lighting[_index_xy + 1];
					
				if (_lighting_left & 0xf000000)
				{
					// Mix colours from left and right, else get colour from left
					lighting[@ _index_xy] = ((_lighting_right & 0xf000000) ? ((1 << 24) | (((_lighting_left & 0xffffff) + (_lighting_right & 0xffffff)) >> 1)) : _lighting_left);
				}
				// Get colour from right
				else if (_lighting_right & 0xf000000)
				{
					lighting[@ _index_xy] = _lighting_right;
				}
				// Proper calculation
				else if (light_get_distance(_tile_x, _tile_y, _lights, _lights_length, _enable_lighting))
				{
					lighting[@ _index_xy] = (1 << 24) | (_coloured_lighting ? light_get_value_colour(_tile_x, _tile_y, _lights, _lights_length, _enable_lighting) : light_get_value_white(_tile_x, _tile_y, _lights, _lights_length, _enable_lighting));
				}
						
				break;
			}
				
			++j;
		}
			
		++i;
	}
			
	#endregion
		
	// show_debug_message($"({floor(x / CHUNK_SIZE_WIDTH)}, {floor(y / CHUNK_SIZE_WIDTH)}) - Render, Lighting - Interpolated: {current_time - _f}ms");
	
	pz = 0;
	
	repeat (CHUNK_SIZE_Z)
	{
		if ((surface_display & (1 << pz)) == 0)
		{
			++pz;
			
			continue;
		}
		
		// _f = current_time;
			
		if (!surface_exists(surface[pz]))
		{
			surface[@ pz] = surface_create(DRAW_SURFACE_WIDTH, DRAW_SURFACE_HEIGHT);
		}
			
		surface_set_target(surface[pz]);
		draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
			
		_index_z = pz << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT);
			
		py = 0;
			
		repeat (CHUNK_SIZE_Y)
		{
			_draw_y = (py << TILE_SIZE_BIT) + DRAW_SURFACE_OFFSET;
			_index_y = py << CHUNK_SIZE_X_BIT;
				
			px = 0;
				
			repeat (CHUNK_SIZE_X)
			{
				_index_xy = px | _index_y;
					
				_l = lighting[_index_xy];
					
				if ((_l & 0x1000000) == 0)
				{
					++px;
						
					continue;
				}
					
				_index_xyz = _index_xy | _index_z;
					
				_tile = chunk[_index_xyz];
			
				if (_tile == ITEM.EMPTY)
				{
					++px;
						
					continue;
				}
			
				_tile_data = _item_data[_tile.item_id];
					
				_type = _tile_data.type;
					
				if (_type & ITEM_TYPE.WALL) && (_tile_data.obstructable)
				{
					_default_tile = chunk[_index_xy | (CHUNK_DEPTH_DEFAULT * CHUNK_SIZE_X * CHUNK_SIZE_Y)];
				
					if (_default_tile != ITEM.EMPTY)
					{
						_default_tile_data = _item_data[_default_tile.item_id];
							
						if (((_default_tile_data.animation_type_index >> 16) & (ANIMATION_TYPE.CONNECTED | ANIMATION_TYPE.CONNECTED_TO_SELF)) ? (((_default_tile.flip_rotation_index >> 8) & 0xff) == 16) : true) && (_default_tile_data.type & ITEM_TYPE.SOLID) && (_default_tile_data.obstructing)
						{
							++px;
								
							continue;
						}
					}
				}
					
				_g = _tile.flip_rotation_index;
				_tile_index = ((_g & 0x8000) ? -((_g >> 8) & 0x7f) : ((_g >> 8) & 0x7f));
					
				_u = _tile_data.animation_type_index;
				_animation_type = _u >> 16;
					
				// Fix scaling if animation type is connected and can flip sprite
				if (_animation_type & (ANIMATION_TYPE.CONNECTED | ANIMATION_TYPE.CONNECTED_TO_SELF))
				{
					_flip_on = _tile_data.flip_on_random_index;
					_t = 1 << _tile_index;
						
					// 0x5414 = 0b0101010000010100
					_xscale = (((_flip_on & 0x20000) && ((_t & 0x5414) == 0)) ? 1 : (((_g & 0x200000000) ? -1 : 1)));
					// 0xa828 = 0b1010100000101000
					_yscale = (((_flip_on & 0x10000) && ((_t & 0xa828) == 0)) ? 1 : (((_g & 0x100000000) ? -1 : 1)));
				}
				else
				{
					_xscale = ((_g & 0x200000000) ? -1 : 1);
					_yscale = ((_g & 0x100000000) ? -1 : 1);
					
					if (_animation_type == ANIMATION_TYPE.INCREMENT)
					{
						if (++_tile_index > (_u & 0xff))
						{
							_tile_index = (_u >> 8) & 0xff;
						}
						
						chunk[@ _index_xyz].flip_rotation_index = (_tile_index << 8) | (_g & 0xfff00ff);
					}
					else if (_animation_type == ANIMATION_TYPE.DECREMENT)
					{
						if (--_tile_index < ((_u >> 8) & 0xff))
						{
							_tile_index = _u & 0xff;
						}
						
						chunk[@ _index_xyz].flip_rotation_index = (_tile_index << 8) | (_g & 0xfff00ff);
					}
					else if (_animation_type == ANIMATION_TYPE.RANDOM)
					{
						_tile_index = irandom_range((_u >> 8) & 0xff, _u & 0xff);
						
						chunk[@ _index_xyz].flip_rotation_index = (_tile_index << 8) | (_g & 0xfff00ff);
					}
				}
					
				_offset = _tile.offset;
					
				if (_type & ITEM_TYPE.PLANT)
				{
					_v = _tile_data.collision_box[0];
						
					_w = _v >> 36;
					_x1 = (px << TILE_SIZE_BIT) + DRAW_SURFACE_OFFSET + ((_offset & 0x80) ? -((_offset >> 4) & 0x7) : ((_offset >> 4) & 0x7)) - ((_w & 0x800) ? -(_w & 0x7ff) : (_w & 0x7ff));
						
					_w = (_v >> 24) & 0xfff;
					_y1 = _draw_y + ((_offset & 0x8) ? -(_offset & 0x7) : (_offset & 0x7)) - ((_w & 0x800) ? -(_w & 0x7ff) : (_w & 0x7ff));
						
					_skew = _tile.skew;
					_skew_to = _tile.skew_to;
						
					_a = _camera_x + _x1;
					_b = _camera_y + _y1;
						
					if (_skew_update) && (position_meeting(_a, _b, obj_Light_Sun))
					{
						_skew_to = random(_skew_strength);
							
						chunk[@ _index_xyz].skew_to = _skew_to;
					}
						
					if (_skew != _skew_to)
					{
						_skew = lerp_delta(_skew, _skew_to, DRAW_SKEW_SPEED, _delta_time);
								
						chunk[@ _index_xyz].skew = _skew;
					}
						
					_t = _tile_data.width_height_swing_speed_index_offset_slot_valid;
					_width = _t >> 32;
						
					_x = _x1 + _skew;
					_y = _y1 + ((_t >> 24) & 0xff);
						
					draw_sprite_pos_fixed(_tile_data.sprite, _tile_index + (_g & 0x80 ? -(_g & 0x7f) : (_g & 0x7f)), _x, _y1, _x + _width, _y1, _x1 + _width, _y, _x1, _y, _l & 0x0ffffff, _tile_data.alpha);
				}
				else
				{
					_r = _g >> 16;
						
					draw_sprite_ext(_tile_data.sprite, _tile_index + (_g & 0x80 ? -(_g & 0x7f) : (_g & 0x7f)), (px << TILE_SIZE_BIT) + DRAW_SURFACE_OFFSET + ((_offset & 0x80) ? -((_offset >> 4) & 0x7) : ((_offset >> 4) & 0x7)), _draw_y + ((_offset & 0x8) ? -(_offset & 0x7) : (_offset & 0x7)), _xscale, _yscale, ((_r & 0x8000) ? -(_r & 0x7fff) : (_r & 0x7fff)), _l & 0x0ffffff, _tile_data.alpha);
				}
					
				++px;
			}
				
			++py;
		}
	
		surface_reset_target();
			
		// show_debug_message($"({floor(x / CHUNK_SIZE_WIDTH)}, {floor(y / CHUNK_SIZE_WIDTH)}) - Render, Surface Update ({pz}): {current_time - _f}ms");
		
		++pz;
	}
}

var _immunity_alpha = 0.75 + (cos(_timer / 6) * 0.25);

var _surface;
var _on_draw;

var _particle_additive = false;
var _particle_exists = instance_exists(obj_Particle);

pz = 0;

repeat (CHUNK_SIZE_Z)
{
	if (_particle_exists)
	{
		with (obj_Particle)
		{
			if (pz != z) continue;
			
			if (boolean & 1)
			{
				_particle_additive = true;
				
				continue;
			}
			
			if (_lights_updated)
			{
				image_blend = (_coloured_lighting ? light_get_value_colour(round(x), round(y), _lights, _lights_length, _enable_lighting) : light_get_value_white(round(x), round(y), _lights, _lights_length, _enable_lighting));
			}
			
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		}
		
		if (_particle_additive)
		{
			gpu_set_blendmode(bm_add);

			with (obj_Particle)
			{
				if ((boolean & 1) == 0) continue;
		
				if (_lights_updated)
				{
					image_blend = (_coloured_lighting ? light_get_value_colour(round(x), round(y), _lights, _lights_length, _enable_lighting) : light_get_value_white(round(x), round(y), _lights, _lights_length, _enable_lighting));
				}
			
				draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
			}
	
			gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
		}
	}
	
	if (pz == CHUNK_DEPTH_DEFAULT)
	{
		with (obj_Item_Drop)
		{
			if (_lights_updated)
			{
				image_blend = (_coloured_lighting ? light_get_value_colour(round(x), round(y), _lights, _lights_length, _enable_lighting) : light_get_value_white(round(x), round(y), _lights, _lights_length, _enable_lighting));
			}
			
			draw_sprite_ext(sprite_index, image_index, x, (xvelocity == 0 && yvelocity == 0 ? (y - (cos((x + y + life) / 16) * 2)) : y), image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		}
		
		with (obj_Pet)
		{
			if (_lights_updated)
			{
				image_blend = (_coloured_lighting ? light_get_value_colour(round(x), round(y), _lights, _lights_length, _enable_lighting) : light_get_value_white(round(x), round(y), _lights, _lights_length, _enable_lighting));
			}
			
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		}
		
		var _alpha;
		
		with (obj_Creature)
		{
			if (_lights_updated)
			{
				image_blend = (_coloured_lighting ? light_get_value_colour(round(x), round(y), _lights, _lights_length, _enable_lighting) : light_get_value_white(round(x), round(y), _lights, _lights_length, _enable_lighting));
			}
			
			_alpha = (immunity_frame != 0 ? _immunity_alpha : 1);
			
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, _alpha);
			
			_on_draw = _creature_data[creature_id].on_draw;
			
			if (_on_draw != -1)
			{
				_on_draw(x, y, image_xscale, image_yscale, image_angle, image_blend, _alpha);
			}
		}
		
		var _length;
		var _piece;
		
		with (obj_Boss)
		{
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, immunity_frame != 0 ? _immunity_alpha : 1);
			
			i = 0;
			_length = array_length(explosion);
			
			repeat (_length)
			{
				_piece = explosion[i++];
				
				if (_piece.timer > 0)
				{
					draw_sprite_ext(_piece.sprite, _piece.index, _piece.x, _piece.y, 1, 1, 0, image_blend, 1);
				}
			}
		}
		
		with (obj_Projectile)
		{
			if (_lights_updated)
			{
				image_blend = (_coloured_lighting ? light_get_value_colour(round(x), round(y), _lights, _lights_length, _enable_lighting) : light_get_value_white(round(x), round(y), _lights, _lights_length, _enable_lighting));
			}
			
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		}
		
		var _inventory = global.inventory;
		
		var _attire = global.attire_elements_ordered;
		var _attire_length = array_length(_attire);
		
		var _match = global.shader_colour_replace_match;
		var _replace = global.shader_colour_replace_replace;
		var _amount = global.shader_colour_replace_amount;
		
		var _colour_data = global.colour_data;
		var _colour_white = _colour_data[8];
		
		with (obj_Player)
		{
			if (_lights_updated)
			{
				image_blend = (_coloured_lighting ? light_get_value_colour(round(x), round(y), _lights, _lights_length, _enable_lighting) : light_get_value_white(round(x), round(y), _lights, _lights_length, _enable_lighting));
			}
			
			var _image_blend = image_blend;
			        
			with (obj_Tool)
			{
				draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, _image_blend, image_alpha);
			}
			
			_alpha = image_alpha * (immunity_frame != 0 ? _immunity_alpha : 1);
			
			var _name;
			var _helmet = _inventory.armor_helmet[0];
			var _breastplate = _inventory.armor_breastplate[0];
			var _leggings = _inventory.armor_leggings[0];
			var _part;
			var _part_x;
			var _part_y;
			var _white;
			
			i = 0;
			
			repeat (_attire_length)
			{
				_name = _attire[i++];
				
				/*
				if (_name == "hair") && (_helmet != INVENTORY_EMPTY)
				{
					#macro PLAYER_ARMOR_HELMET_XOFFSET 0
					#macro PLAYER_ARMOR_HELMET_YOFFSET -15
					
					draw_sprite_ext(_item_data[_helmet.item_id].sprite, 1, x + PLAYER_ARMOR_HELMET_XOFFSET, y + PLAYER_ARMOR_HELMET_YOFFSET, image_xscale, image_yscale, image_angle, image_blend, _alpha);
					
					continue;
				}
				
				if (_breastplate != INVENTORY_EMPTY)
				{
					if (_name == "undershirt") continue;
					
					if (_name == "shirt")
					{
						#macro PLAYER_ARMOR_BREASTPLATE_XOFFSET 0
						#macro PLAYER_ARMOR_BREASTPLATE_YOFFSET -5
						
						_sprite = _item_data[_breastplate.item_id].sprite;
						
						_part_x = x + PLAYER_ARMOR_BREASTPLATE_XOFFSET;
						_part_y = y + PLAYER_ARMOR_BREASTPLATE_YOFFSET;
					
						draw_sprite_ext(_sprite, 1, _part_x, _part_y, image_xscale, image_yscale, image_angle, image_blend, _alpha);
						draw_sprite_ext(_sprite, 2, _part_x, _part_y, image_xscale, image_yscale, image_angle, image_blend, _alpha);
						draw_sprite_ext(_sprite, 3, _part_x, _part_y, image_xscale, image_yscale, image_angle, image_blend, _alpha);
					
						continue;
					}
				}
				
				if (_leggings != INVENTORY_EMPTY)
				{
					if (_name == "footwear") continue;
					
					if (_name == "pants")
					{
						#macro PLAYER_ARMOR_LEGGINGS_XOFFSET 0
						#macro PLAYER_ARMOR_LEGGINGS_YOFFSET 1
						
						_sprite = _item_data[_leggings.item_id].sprite;
						
						_part_x = x + PLAYER_ARMOR_LEGGINGS_XOFFSET;
						_part_y = y + PLAYER_ARMOR_LEGGINGS_YOFFSET;
					
						draw_sprite_ext(_sprite, 1, _part_x, _part_y, image_xscale, image_yscale, image_angle, image_blend, _alpha);
						draw_sprite_ext(_sprite, 2, _part_x, _part_y, image_xscale, image_yscale, image_angle, image_blend, _alpha);
					
						continue;
					}
				}
				*/
				
				_part = parts[$ _name];
				
				if (_part != -1)
				{
					shader_set(shd_Colour_Replace);
					shader_set_uniform_i_array(_match, _colour_white);
					shader_set_uniform_i_array(_replace, _colour_data[_part.colour]);
					shader_set_uniform_i(_amount, PLAYER_COLOUR_MAP_BASE_AMOUNT + PLAYER_COLOUR_MAP_OUTLINE_AMOUNT);
					
					draw_sprite_ext(_part.sprite_colour, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, _alpha);
					
					_colour2 = _part[$ "sprite_colour2"];
					
					if (_colour2 != undefined)
					{
						draw_sprite_ext(_colour2, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, _alpha);
					}
					
					_colour3 = _part[$ "sprite_colour3"];
					
					if (_colour3 != undefined)
					{
						draw_sprite_ext(_colour3, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, _alpha);
					}
					
					shader_reset();
					
					_white = _part.sprite_white;
				
					if (_white != -1)
					{
						draw_sprite_ext(_white, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, _alpha);
					}
				}
			}
			
			if (instance_exists(obj_Whip))
			{
				var _whip_sprite = whip_sprite;
				var _wy = _y + 512;
				
				with (obj_Whip)
				{
					draw_sprite_ext(_whip_sprite, image_index, _x + x, _wy + y, image_xscale, image_yscale, image_angle, _image_blend, 1);
				}
			}
			
			with (obj_Fishing_Hook)
			{
				_x = owner.x;
				
				if (x < _x)
				{
					_xscale = 1;
					
					draw_curve(x, y, _x, owner.y, 0, 8, c_black);
				}
				else
				{
					_xscale = -1;
					
					draw_curve(x, y, _x, owner.y, 180, 8, c_black);
				}
				
				draw_sprite_ext(sprite_index, image_index, x, y, _xscale, image_yscale, (xvelocity != 0 && yvelocity != 0 ? (point_direction(x, y, x + abs(xvelocity), y + yvelocity) * _xscale) : 0), _image_blend, 1);
			}
		}
	}
	
	with (obj_Chunk)
	{
		if (!is_generated) || (!is_in_view) || ((surface_display & (1 << pz)) == 0) continue;
		
		_g = surface[pz];
			
		if (surface_exists(_g))
		{
			draw_surface_ext(_g, x - DRAW_SURFACE_OFFSET, y - DRAW_SURFACE_OFFSET, 1, 1, 0, c_white, 1);
		}
	}
	
	++pz;
}

if (obj_Player.is_mining)
{
	var _mining_current = obj_Player.mining_current;
	
	if (_mining_current > 0)
	{
		if (!surface_exists(surface_mine))
		{
			surface_mine = surface_create(_camera_width, _camera_height);
		}
		
		surface_set_target(surface_mine);
		draw_clear_alpha(DRAW_CLEAR_ALPHA, DRAW_CLEAR_COLOUR);
		
		#region Tile Shaking
		
		var _mine_position_x = obj_Player.mine_position_x;
		var _mine_position_y = obj_Player.mine_position_y;
		
		var _light_x = _mine_position_x * TILE_SIZE;
		var _light_y = _mine_position_y * TILE_SIZE;
		
		_tile = tile_get(_mine_position_x, _mine_position_y, obj_Player.mine_position_z, "all");
		_data = _item_data[_tile.item_id];
		
		var _progress = normalize(_mining_current, 0, _data.get_mining_amount());
		
		#macro DRAW_MINE_OFFSET 2
		
		_offset = DRAW_MINE_OFFSET * _progress;
		
		var _xstart = _light_x - _camera_x + random_range(-_offset, _offset);
		var _ystart = _light_y - _camera_y + random_range(-_offset, _offset);
		
		var _flip_rotation_index = _tile.flip_rotation_index;
		
		_colour = (_coloured_lighting ? light_get_value_colour(_light_x, _light_y, _lights, _lights_length, true) : light_get_value_white(_light_x, _light_y, _lights, _lights_length, true));
		
		draw_sprite_ext(_data.sprite, ((_flip_rotation_index >> 8) & 0xff) + (_flip_rotation_index & 0x80 ? -(_flip_rotation_index & 0x7f) : (_flip_rotation_index & 0x7f)), _xstart, _ystart, (_flip_rotation_index & 0x200000000 ? -1 : 1), (_flip_rotation_index & 0x100000000 ? -1 : 1), 0, _colour, 1);
		
		#endregion
		
		#region Mining Animation
		
		gpu_set_colorwriteenable(true, true, true, false);
		
		_index = round(_progress * (sprite_get_number(spr_Animation_Mine) - 1));
	
		_width  = ceil(_data.get_sprite_width()  / TILE_SIZE);
		_height = ceil(_data.get_sprite_height() / TILE_SIZE);
		
		var _xrepeat = (_width  * 2) + 1;
		var _yrepeat = (_height * 2) + 1;
	
		#macro DRAW_MINE_AMOUNT 3
	
		i = -_width;
	
		repeat (_xrepeat)
		{
			_x = _xstart + (i++ * TILE_SIZE);
		
			j = -_height;
		
			repeat (_yrepeat)
			{
				draw_sprite_ext(spr_Animation_Mine, _index, _x, _ystart + (j++ * TILE_SIZE), 1, 1, 0, c_white, 1);
			}
		}
		
		gpu_set_colorwriteenable(true, true, true, true);
		
		#endregion
		
		surface_reset_target();
		
		draw_surface(surface_mine, _camera_x, _camera_y);
	}
}

if (instance_exists(obj_Floating_Text))
{
	draw_set_align(fa_center, fa_middle);
	
	with (obj_Floating_Text)
	{
		draw_text_ext_transformed_color(x, y, text, 0, 100_000, 0.5, 0.5, 0, colour, colour, colour, colour, image_alpha);
	}
}

if (_enable_lighting) && (_camera_x != _camera.x_real || _camera_y != _camera.y_real)
{
	if (!surface_exists(surface_lighting))
	{
		surface_lighting = surface_create(_camera_width, _camera_height);
	}
	
	surface_set_target(surface_lighting);
	gpu_set_blendmode(bm_add);

	with (obj_Tile_Light)
	{
		if (bloom == c_black) continue;
		
		draw_sprite_ext(spr_Glow, 0, x - _camera_x, y - _camera_y, 1, 1, 0, bloom, 1);
	}
	
	gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
	draw_sprite_ext(spr_Square, 0, 0, 0, _camera_width, _camera_height, 0, c_black, 1);
	gpu_set_blendmode(bm_subtract);
	
	with (obj_Parent_Light)
	{
		if (object_index != obj_Light_Sun)
		{
			draw_sprite_ext(spr_Glow, 0, x - _camera_x, y - _camera_y, 1, 1, 0, c_white, 1);
			
			continue;
		}
		
		_x = x - _camera_x + ((image_xscale / 2) * -TILE_SIZE);
		_y = y - _camera_y;
		
		repeat (image_xscale)
		{
			_x += TILE_SIZE;
				
			draw_sprite_ext(spr_Glow_Half, 0, _x, _y, 1, 1, 0, c_white, 1);
			draw_sprite_ext(spr_Glow_Stretch, 0, _x, _y, 1, WORLD_HEIGHT_TILE_SIZE, 0, c_white, 1);
		}
	}

	gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
	surface_reset_target();
}

with (obj_Tile_Instance)
{
	if (on_draw == -1) continue;

	on_draw(x, y, id);
}