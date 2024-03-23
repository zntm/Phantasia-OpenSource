is_generated = false;
is_in_view   = false;
is_refresh   = false;

surface = array_create(CHUNK_SIZE_Z, -1);
surface_display = 0;

chunk_xstart = floor(x / TILE_SIZE);
chunk_ystart = floor(y / TILE_SIZE);

xcenter = x + (CHUNK_SIZE_WIDTH  / 2);
ycenter = y + (CHUNK_SIZE_HEIGHT / 2);

#macro REFRESH_TIME_CHUNK_DEFAULT 255
#macro REFRESH_TIME_CHUNK_FAST 4

refresh_value = irandom_range(1, REFRESH_TIME_CHUNK_FAST - 1);

lighting = variable_clone(global.chunk_cache_lighting);

var _sky_biome     = global.sky_biome_data;
var _surface_biome = global.surface_biome_data;
var _cave_biome    = global.cave_biome_data;

var _item_data = global.item_data;

var _world = global.world;
var _world_value = _world.environment.value;

var _seed = _world.info.seed;
var _attributes = global.world_data[_world_value & 0xf];
var _attributes_addon = _attributes.addon;

var _biome_sky = _attributes.sky_biome;
var _biome_surface = _attributes.surface_biome;
var _biome_cave = _attributes.cave_biome;

var _biome_function_sky = is_method(_biome_sky);
var _biome_function_surface = is_method(_biome_surface);
var _biome_function_cave = is_method(_biome_cave);

var _cave_length = array_length(_cave_biome);
var _sky_length  = array_length(_sky_biome);

var _xpos;
var _ypos;

var _x = 0;
var _y;
var _z;

var _ys;

var _index_xy;
var _index_xyz;

var _carve;
var _cave;
var _surface;
var _sky;

var _index;

var _tile;

var _f = current_time;

var _directory = $"{global.directory}/{_attributes.name}/{chunk_xstart} {chunk_ystart}.dat";

if (file_exists(_directory))
{
	var _sun_rays_y = global.sun_rays_y;
	
	var _index_x;
	var _index_y;
	var _index_z;
	
	var _item_id;

	var i;
	var _v;
	var _b;
	var a;
	var g;
	var f;
	var q;
	var w;
	var e;
	var r;
	
	var _r;
	var _q;
	var _type;
	var _t;
	
	var _buffer = buffer_load(_directory);
	var _buffer2 = buffer_decompress(_buffer);
	
	is_generated = buffer_read(_buffer2, buffer_bool);
	
	i = 0;
	
	repeat (CHUNK_SIZE_X * CHUNK_SIZE_Y * CHUNK_SIZE_Z)
	{
		_v = buffer_read(_buffer2, buffer_u64);
		
		if (_v == 0xffff)
		{
			chunk[@ i++] = ITEM.EMPTY;
			
			continue;
		}
		
		_item_id = _v & 0xffff;
		
		_t = {
			item_id: _item_id,
			offset: (_v >> 16) & 0xff,
			boolean: (_v >> 24) & 0xff,
			state_id: _v >> 32,
			flip_rotation_index: buffer_read(_buffer2, buffer_u64),
		};
		
		chunk[@ i] = _t;
		
		tile_instance_create(chunk_xstart + (i & (CHUNK_SIZE_X - 1)), chunk_ystart + ((i >> CHUNK_SIZE_X_BIT) & (CHUNK_SIZE_Y - 1)), i >> (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT), _t);
		
		_type = _item_data[_item_id].type;
		
		if (_type & ITEM_TYPE.PLANT)
		{
			chunk[@ i].skew = 0;
			chunk[@ i].skew_to = 0;
		}
		else if (_type & ITEM_TYPE.CONTAINER)
		{
			chunk[@ i].inventory = [];
			
			a = buffer_read(_buffer2, buffer_u8);
			
			g = 0;
			
			repeat (a)
			{
				f = buffer_read(_buffer2, buffer_u64);
				
				if (f == 0xffff)
				{
					chunk[@ i].inventory[@ g++] = INVENTORY_EMPTY;
					
					continue;
				}
				
				q = (f >> 40) & 0xff;
				w = (f >> 32) & 0xff;
				
				chunk[@ i].inventory[@ g] = {
					item_id: f & 0xffff,
					amount: (f >> 16) & 0xffff,
					index: ((q & 0x80) ? -(q & 0x7f) : (q & 0x7f)),
					index_offset: ((w & 0x80) ? -(w & 0x7f) : (w & 0x7f)),
				};
				
				e = f >> 48;
				
				if (e > 0)
				{
					chunk[@ i].inventory[@ g].durability = e;
				}
				
				r = buffer_read(_buffer2, buffer_u16);
				
				if (r != 0xffff)
				{
					chunk[@ i].inventory[@ g].acclimation = r;
				}
				
				++g;
			}
		}
		
		++i;
	}
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
	
	_x = 0;
	
	repeat (CHUNK_SIZE_X)
	{
		_y = 0;
		
		_r = string(chunk_xstart + _x);
		_q = _sun_rays_y[$ _r] ?? WORLD_HEIGHT;
		
		repeat (CHUNK_SIZE_Y)
		{
			_index_y = _y << CHUNK_SIZE_X_BIT;
			_index_xy = _x | _index_y;
			
			_ypos = chunk_ystart + _y;
			
			_z = 0;
			
			repeat (CHUNK_SIZE_Z)
			{
				_tile = chunk[_index_xy | (_z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))];
				
				if (_tile != ITEM.EMPTY)
				{
					surface_display = surface_display | (1 << _z);
					
					_t = chunk_ystart + _y;
					
					if (_t < _q) && (_tile.boolean & 1) && (_item_data[_tile.item_id].type & ITEM_TYPE.SOLID)
					{
						_q = _t;
					}
				}
				
				++_z;
			}
			
			++_y;
		}
		
		global.sun_rays_y[$ _r] = _q;
		
		++_x;
	}
	
	if (!is_generated)
	{
		_x = 0;
		
		repeat (CHUNK_SIZE_X)
		{
			_xpos = chunk_xstart + _x;
	
			_ys = worldgen_get_ysurface(_xpos, _seed, _attributes);
			chunk_data[@ (CHUNK_SIZE_X * CHUNK_SIZE_Y) + _x] = _ys;
	
			_y = 0;
	
			repeat (CHUNK_SIZE_Y)
			{
				_ypos = chunk_ystart + _y;
		
				_cave = (_biome_function_cave ? _biome_cave(_xpos, _ypos, _seed, _cave_biome, _cave_length, _ys) : (_biome_cave != -1 ? _biome_cave : (_y > EMUSTONE_YSTART ? CAVE_BIOME.EMUSTONE : CAVE_BIOME.STONE)));
				_sky = (_biome_function_sky ? _biome_sky(_xpos, _ypos, _seed, _sky_biome, _sky_length) : _biome_sky);
	
				chunk_data[@ _x | (_y << CHUNK_SIZE_X_BIT)] = ((_biome_function_surface ? _biome_surface(_xpos, _ypos, _seed, _ys) : _biome_surface) << 17) | ((_cave == -1 ? 0xff : _cave) << 9) | ((_sky == -1 ? 0xff : _sky) << 1) | worldgen_carve_cave(_xpos, _ypos, _seed, _attributes, _ys);
		
				++_y;
			}
	
			++_x;
		}
	}
	
	// show_debug_message($"({floor(x / CHUNK_SIZE_WIDTH)}, {floor(y / CHUNK_SIZE_WIDTH)}) - World Generation, Chunk Load: {current_time - _f}ms");
	
	exit;
}

var _item_id;
var _data;

var _inst;
var _inst_id;
var _inst_xscale;
var _inst_rectangle;
var _inst_rectangle_z;

var _chunk_data;

var _a;
var _b;
var _c;

var _structure_data = global.structure_data;
var _t;

var _generate = _world_value & (1 << 16);

repeat (CHUNK_SIZE_X)
{
	_xpos = chunk_xstart + _x;
	
	_ys = worldgen_get_ysurface(_xpos, _seed, _attributes);
	chunk_data[@ (CHUNK_SIZE_X * CHUNK_SIZE_Y) + _x] = _ys;
	
	_index = string(_xpos);
	
	global.sun_rays_y[$ _index] = _ys;
	
	_y = 0;
	
	repeat (CHUNK_SIZE_Y)
	{
		_ypos = chunk_ystart + _y;
		
		_surface = (_biome_function_surface ? _biome_surface(_xpos, _ypos, _seed, _ys) : _biome_surface);
		_cave    = (_biome_function_cave ? _biome_cave(_x, _y, _seed, _cave_biome, _cave_length, _ys) : (_biome_cave != -1 ? _biome_cave : (_y > EMUSTONE_YSTART ? CAVE_BIOME.EMUSTONE : CAVE_BIOME.STONE)));
		_sky     = (_biome_function_sky ? _biome_sky(_xpos, _ypos, _seed, _sky_biome, _sky_length) : _biome_sky);
		_carve   = worldgen_carve_cave(_xpos, _ypos, _seed, _attributes, _ys);
	
		_index_xy = _x | (_y << CHUNK_SIZE_X_BIT);
		
		_chunk_data = (_surface << 17) | ((_cave == -1 ? 0xff : _cave) << 9) | ((_sky == -1 ? 0xff : _sky) << 1) | _carve;
		chunk_data[@ _index_xy] = _chunk_data;
		
		_z = 0;
		
		if (!_generate)
		{
			repeat (CHUNK_SIZE_Z)
			{
				_tile = worldgen_base(_xpos, _ypos, _z, _seed, _attributes, _attributes_addon, _chunk_data, _ys, _surface_biome, _cave_biome, _sky_biome);
			
				if (_tile != ITEM.EMPTY)
				{
					chunk[@ _index_xy | (_z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = new Tile(_tile, _item_data);
					surface_display = surface_display | (1 << _z++);
					
					continue;
				}
				
				chunk[@ _index_xy | (_z++ << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = ITEM.EMPTY;
			}
		
			++_y;
		
			continue;
		}
		
		_inst = instance_position(_xpos * TILE_SIZE, _ypos * TILE_SIZE, obj_Structure);
		
		if (!instance_exists(_inst))
		{
			repeat (CHUNK_SIZE_Z)
			{
				_tile = worldgen_base(_xpos, _ypos, _z, _seed, _attributes, _attributes_addon, _chunk_data, _ys, _surface_biome, _cave_biome, _sky_biome);
			
				if (_tile != ITEM.EMPTY)
				{
					chunk[@ _index_xy | (_z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = new Tile(_tile, _item_data);
					surface_display = surface_display | (1 << _z++);
					
					continue;
				}
				
				chunk[@ _index_xy | (_z++ << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = ITEM.EMPTY;
			}
		
			++_y;
		
			continue;
		}
		
		_inst_xscale = _inst.image_xscale;
		_inst_id = _inst.structure_id;
			
		_inst_rectangle = _inst_xscale * _inst.image_yscale;
		_inst_rectangle_z = _inst_rectangle * CHUNK_SIZE_Z;
			
		_data = _structure_data[$ _inst.structure].data;
		
		_a = (_xpos - round((_inst.bbox_left + 8) / TILE_SIZE)) + ((_ypos - round((_inst.bbox_top + 8) / TILE_SIZE)) * _inst_xscale);
		
		repeat (CHUNK_SIZE_Z)
		{
			_tile = _data[_a + (_z * _inst_rectangle)];
			
			if (_tile == ITEM.EMPTY)
			{
				chunk[@ _index_xy | (_z++ << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = ITEM.EMPTY;
				
				continue;
			}
			
			if (_tile == ITEM.STRUCTURE_VOID)
			{
				_tile = worldgen_base(_xpos, _ypos, _z, _seed, _attributes, _attributes_addon, _chunk_data, _ys, _surface_biome, _cave_biome, _sky_biome);
			
				if (_tile != ITEM.EMPTY)
				{
					chunk[@ _index_xy | (_z++ << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = new Tile(_tile, _item_data);
					surface_display = surface_display | (1 << _z++);
				}
				else
				{
					chunk[@ _index_xy | (_z++ << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = ITEM.EMPTY;
				}
				
				continue;
			}
			
			_item_id = _tile.item_id;
			_index_xyz = _index_xy | (_z++ << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT));
			
			_tile.state_id = (_tile.state_id & 0xff0000) | _inst_id;
			
			chunk[@ _index_xyz] = _tile;
						
			if (_item_data[_item_id].type & ITEM_TYPE.PLANT)
			{
				chunk[@ _index_xyz].skew = 0;
				chunk[@ _index_xyz].skew_to = 0;
			}
		}
			
		++_y;
	}
	
	++_x;
}

// show_debug_message($"({floor(x / CHUNK_SIZE_WIDTH)}, {floor(y / CHUNK_SIZE_WIDTH)}) - World Generation, Init Generation: {current_time - _f}ms");