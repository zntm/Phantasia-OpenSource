function ctrl_chunk_generate()
{
	var _item_data  = global.item_data;
	var _sun_rays_y = global.sun_rays_y;
	
	var _world = global.world;
	var _seed  = _world.info.seed;
	
	var _attributes = global.world_data[_world.environment.value & 0xf];
	var _attributes_addon = _attributes.addon;
	
	var _sky_biome     = global.sky_biome_data;
	var _surface_biome = global.surface_biome_data;
	var _cave_biome    = global.cave_biome_data;
	
	var _camera = global.camera;
	
	var _camera_width  = _camera.width  / 2;
	var _camera_height = _camera.height / 2;

	var _refresh_x = ceil(_camera_width  / CHUNK_SIZE_WIDTH)  + 2;
	var _refresh_y = ceil(_camera_height / CHUNK_SIZE_HEIGHT) + 2;
	
	var _center_x = floor((_camera.x + (_camera_width  / 2)) / CHUNK_SIZE_WIDTH)  * CHUNK_SIZE_WIDTH;
	var _center_y = floor((_camera.y + (_camera_height / 2)) / CHUNK_SIZE_HEIGHT) * CHUNK_SIZE_HEIGHT;
	
	var _repeat_x = _refresh_x * 2;
	var _repeat_y = _refresh_y * 2;
	
	var _xoffset = -_refresh_x;
	var _yoffset;
	
	var _x, _y, _z, _xpos, _ypos, _tile;
	var _index, _index_y, _index_z, _index_data;
	var _chunk_data, _ae;
	
	var _cx;
	var _cy;
	var _inst;
	
	var _animation_type;
	var _buffer;
	var _buffer2;
	var _json;
	var _a;
	var _r;
	var _q;
	
	var _index_x;
	var _index_xy;
	var _index_yz;
	var _index_xyz;
	var _item_id;
	
	var _xstart;
	var _ystart;
	
	var _u;
	var _i;
	
	var _f;
	var _v;
	var _w;
	var _1;
	var _2;
	var _3;
	var _4;
	
	var _edge_x;
	var _edge_y;

	repeat (_repeat_x)
	{
		_cx = _center_x + (_xoffset * CHUNK_SIZE_WIDTH);
		_edge_x = (abs(_xoffset++) != _refresh_x);
		
		_xstart = floor(_cx / CHUNK_SIZE_WIDTH);
		
		_yoffset = -_refresh_y;
	
		repeat (_repeat_y)
		{
			_cy = _center_y + (_yoffset * CHUNK_SIZE_HEIGHT);
			_edge_y = (abs(_yoffset++) != _refresh_y);
			
			_ystart = floor(_cy / CHUNK_SIZE_HEIGHT);
		
			if (_cy < 0) || (_cy > WORLD_HEIGHT_TILE_SIZE - CHUNK_SIZE_HEIGHT) continue;
		
			_inst = instance_position(_cx, _cy, obj_Chunk);
			
			if (!instance_exists(_inst))
			{
				_inst = instance_create_layer(_cx, _cy, "Instances", obj_Chunk);
			}
		
			with (_inst)
			{
				if (is_generated)
				{
					if (_edge_x) && (_edge_y) && (surface_display)
					{
						is_in_view = true;
					}
				
					break;
				}
			
				is_generated = true;
				
				obj_Control.refresh_sun_ray = true;
				
				// _f = current_time;
					
				_x = 0;
				_xpos = chunk_xstart;
						
				repeat (CHUNK_SIZE_X)
				{
					_ae = chunk_data[(CHUNK_SIZE_X * CHUNK_SIZE_Y) + _x];
						
					_r = string(_xpos);
					_q = _sun_rays_y[$ _r];
						
					_y = 0;
					_ypos = chunk_ystart;
						
					repeat (CHUNK_SIZE_Y)
					{
						_index_data = _x | (_y++ << CHUNK_SIZE_X_BIT);
						
						_tile = chunk[_index_data | (CHUNK_DEPTH_DEFAULT << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))];
							
						if (_tile != ITEM.EMPTY) && (_ypos < _q) && (_tile.boolean & 1) && (_item_data[_tile.item_id].type & ITEM_TYPE.SOLID)
						{
							_q = _ypos;
						}
							
						_chunk_data = chunk_data[_index_data];
							
						_z = 0;
							
						repeat (CHUNK_SIZE_Z)
						{
							if (chunk[_index_data | (_z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] != ITEM.EMPTY)
							{
								is_in_view = true;
								surface_display = surface_display | (1 << _z);
							}
							
							worldgen_base(_xpos, _ypos, _z++, _seed, _attributes, _attributes_addon, _chunk_data, _ae, _surface_biome, _cave_biome, _sky_biome, true);
						}
						
						++_ypos;
					}
						
					global.sun_rays_y[$ _r] = _q;
						
					++_x;
					++_xpos;
				}
					
				// show_debug_message($"({floor(x / CHUNK_SIZE_WIDTH)}, {floor(y / CHUNK_SIZE_WIDTH)}) - World Generation, Init Transfer: {current_time - _f}ms");
					
				// _f = current_time;
		
				#region Update Chunk Data
				
				_z = 0;
				
				repeat (CHUNK_SIZE_Z)
				{
					if ((surface_display & (1 << _z)) == 0)
					{
						++_z;
						
						continue;
					}
					
					_ypos = chunk_ystart - 1;
					
					repeat (CHUNK_SIZE_Y + 2)
					{
						_xpos = chunk_xstart - 1;
						
						repeat (CHUNK_SIZE_X + 2)
						{
							if (tile_get(_xpos, _ypos, _z) != ITEM.EMPTY)
							{
								tile_update(_xpos, _ypos, _z);
							}
								
							++_xpos;
						}
							
						++_ypos;
					}
					
					++_z;
				}
					
				#endregion
					
				// show_debug_message($"({floor(x / CHUNK_SIZE_WIDTH)}, {floor(y / CHUNK_SIZE_WIDTH)}) - World Generation, Tile Update: {current_time - _f}ms");
				
				chunk_data = undefined;
			}
		}
	}
}