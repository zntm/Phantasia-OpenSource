function WorldData(_name, _type = WORLD_TYPE.DEFAULT) constructor
{
	name = _name;
	type = _type;
	
	surface_flatness_offset = (220 << 16) | (40 << 8) | 96;
	
	static set_surface = function(_flatness, _min, _max)
	{
		surface_flatness_offset = (_flatness << 16) | (_min << 8) | _max;
		
		return self;
	}
	
	// Used for perlin noise to check when to start allowing cave generation
	// 0xff_ff_ff_ff - Staff Offset, Length
	caves = [];
	caves_value = 16 << 8;
	
	static set_cave_ystart = function(_offset)
	{
		caves_value = (caves_value & 0x00ff) | (_offset << 8);
		
		return self;
	}
	
	static add_caves = function(_cave)
	{
		array_push(caves, _cave);
		
		caves_value = (caves_value & 0xff00) | array_length(caves);
		
		return self;
	}
	
	addon = -1;
	
	static set_addon = function(_addon)
	{
		addon = _addon;
		
		return self;
	}
	
	sky_biome = -1;
	
	static set_sky_biome = function(_function)
	{
		sky_biome = _function;
		
		return self;
	}
	
	surface_biome = SURFACE_BIOME.GREENIA;
	
	static set_surface_biome = function(_function)
	{
		surface_biome = _function;
		
		return self;
	}
	
	cave_biome = -1;
	
	static set_cave_biome = function(_function)
	{
		cave_biome = _function;
		
		return self;
	}
	
	rpc_seconds = 30;
	rpc = -1;
	
	static set_rpc = function(_seconds = 30, _function = -1)
	{
		rpc_seconds = _seconds;
		rpc = _function;
		
		return self;
	}
}

function WorldCave() constructor
{
	// 0xffff_ffff_ffff_ffff - Y Start, Y End, X Offset, Y Offset
	value = WORLD_HEIGHT << 32;
	
	static set_offset = function(_xoffset, _yoffset)
	{
		value = (value & 0xffffffff00000000) | (_xoffset << 16) | _yoffset;
		
		return self;
	}
	
	static set_range = function(_ystart, _yend)
	{
		value = (value & 0x00000000ffffffff) | (_ystart << 48) | (_yend << 32);
		
		return self;
	}
	
	// 0xf_f_ff_ff_ff_ff - Transition Octave, Transition Range, Size, Range, Requirement Min, Requirement Max
	value2 = (8 << 36) | (12 << 32) | (16 << 24) | (8 << 16) | (4 << 8) | 8;
	
	static set_noise = function(_octave, _amplitude)
	{
		value2 = (value2 & 0xff0000ffff) | (_octave << 24) | (_amplitude << 16);
		
		return self;
	}
	
	static set_required = function(_min, _max)
	{
		value2 = (value2 & 0xffffff0000) | (_min << 8) | _max;
		
		return self;
	}
	
	static set_transition = function(_octave, _amplitude)
	{
		value2 = (value2 & 0x00ffffffff) | (_octave << 36) | (_amplitude << 32);
		
		return self;
	}
}

enum WORLD {
	PLAYGROUND,
	HORIZON
}

global.world_data = [];

#macro CRUST_XOFFSET 0
#macro CRUST_YOFFSET 256

#macro EMUSTONE_HEIGHT 128
#macro EMUSTONE_TRANS_HEIGHT 8

#macro EMUSTONE_YSTART (WORLD_HEIGHT - EMUSTONE_HEIGHT)
#macro EMUSTONE_TRANS_YSTART (EMUSTONE_YSTART - EMUSTONE_TRANS_HEIGHT)

array_push(global.world_data, new WorldData("Playground", WORLD_TYPE.DEFAULT)
	.set_surface(220, 40, 96)
	.set_cave_ystart(16)
	// Cheese Caves
	.add_caves(new WorldCave()
		.set_offset(0, 1024)
		.set_range(0, WORLD_HEIGHT)
		.set_noise(64, 8)
		.set_required(4, 8)
		.set_transition(8, 12))
	// Spaghetti Caves
	.add_caves(new WorldCave()
		.set_offset(0, 0)
		.set_range(0, EMUSTONE_YSTART + 32)
		.set_noise(80, 4)
		.set_required(2, 4)
		.set_transition(4, 8))
	// Noodle Caves
	.add_caves(new WorldCave()
		.set_offset(1024, 0)
		.set_range(0, WORLD_HEIGHT)
		.set_noise(64, 4)
		.set_required(2, 4)
		.set_transition(4, 8))
	.set_addon(function(px, py, pz, seed, attributes, _chunk_data, ysurface, surface_biome_data, cave_biome_data, _z_last)
	{
		static __get_ore = function(px, py, seed, is_in_emustone_layer)
		{
			if (perlin_noise(px + 2048, py, 8, 16, seed) > 6)
			{
				#region Metals
	
				// Noise used for randomness
				// Normalize used to increase chance of spawning, 1 - n is decreasing and just none of it is increasing
				static __get_metal = function(_x, _y, _seed, _val, _threshold)
				{
					return (8 * _val > _threshold) || (perlin_noise(_x, _y, 8, 2, _seed) * _val > _threshold);
				}
		
				if (__get_metal(px, py, seed, 1 - normalize(py, 512, 768), 4.7))
				{
					return (is_in_emustone_layer ? ITEM.EMUSTONE_COAL_ORE : ITEM.COAL_ORE);
				}
		
				if (__get_metal(px + 512, py, seed, 1 - normalize(py, 512, 800), 5.05))
				{
					return (is_in_emustone_layer ? choose(ITEM.EMUSTONE_COPPER_ORE, ITEM.EMUSTONE_WEATHERED_COPPER_ORE, ITEM.EMUSTONE_TARNISHED_COPPER_ORE) : choose(ITEM.COPPER_ORE, ITEM.WEATHERED_COPPER_ORE, ITEM.TARNISHED_COPPER_ORE));
				}
		
				if (__get_metal(px + 1024, py, seed, normalize(py, 560, 640), 5.2))
				{
					return (is_in_emustone_layer ? ITEM.EMUSTONE_IRON_ORE: ITEM.IRON_ORE);
				}
				
				/*
				if (__get_metal(px + 2048, py, seed, normalize(py, 600, 740), 5.4))
				{
					return (is_in_emustone_layer ? ITEM.EMUSTONE_GOLD_ORE : ITEM.GOLD_ORE);
				}
		
				if (__get_metal(px + 4096, py, seed, normalize(py, 880, WORLD_HEIGHT), 5.8))
				{
					return (is_in_emustone_layer ? ITEM.EMUSTONE_PLATINUM_ORE : ITEM.PLATINUM_ORE);
				}
				*/
		
				#endregion
				
				/*
				#region Gems
		
				#macro WORLDGEN_ORE_GEMS_NOISE_OCTAVES 2
		
				// Emerald
				if (py > 600) && (py < 668) && (perlin_noise(px - 256, py, 8, WORLDGEN_ORE_GEMS_NOISE_OCTAVES, seed) > 5.4)
				{
					return is_in_emustone_layer ? ITEM.EMUSTONE_EMERALD_ORE : ITEM.EMERALD_ORE;
				}
	
				// Sapphire
				if (py > 670) && (py < 720) && (perlin_noise(px - 512, py, 8, WORLDGEN_ORE_GEMS_NOISE_OCTAVES, seed) > 5.5)
				{
					return is_in_emustone_layer ? ITEM.EMUSTONE_SAPPHIRE_ORE : ITEM.SAPPHIRE_ORE;
				}
	
				// Kunzite
				if (py > 720) && (py < 800) && (perlin_noise(px - 768, py, 8, WORLDGEN_ORE_GEMS_NOISE_OCTAVES, seed) > 5.4)
				{
					return is_in_emustone_layer ? ITEM.EMUSTONE_KUNZITE_ORE : ITEM.KUNZITE_ORE;
				}
	
				// Ruby
				if (py > 760) && (py < 820) && (perlin_noise(px - 1024, py, 8, WORLDGEN_ORE_GEMS_NOISE_OCTAVES, seed) > 5.3)
				{
					return is_in_emustone_layer ? ITEM.EMUSTONE_RUBY_ORE : ITEM.RUBY_ORE;
				}
	
				// Amethyst
				if (py > 800) && (py < 860) && (perlin_noise(px - 1280, py, 8, WORLDGEN_ORE_GEMS_NOISE_OCTAVES, seed) > 5.3)
				{
					return is_in_emustone_layer ? ITEM.EMUSTONE_RUBY_ORE : ITEM.RUBY_ORE;
				}
	
				// Jasper
				if (py > 800) && (py < 860) && (perlin_noise(px - 1280 - 256, py, 8, WORLDGEN_ORE_GEMS_NOISE_OCTAVES, seed) > 5.4)
				{
					return is_in_emustone_layer ? ITEM.EMUSTONE_JASPER_ORE : ITEM.JASPER_ORE;
				}
	
				// Topaz
				if (py > 840) && (py < 880) && (perlin_noise(px - 1280 - 512, py, 8, WORLDGEN_ORE_GEMS_NOISE_OCTAVES, seed) > 4.9)
				{
					return is_in_emustone_layer ? ITEM.EMUSTONE_TOPAZ_ORE : ITEM.TOPAZ_ORE;
				}
	
				// Diamond
				if (py > 880) && (py < 900) && (perlin_noise(px - 1280 - 768, py, 8, WORLDGEN_ORE_GEMS_NOISE_OCTAVES, seed) > 5.6)
				{
					return is_in_emustone_layer ? ITEM.EMUSTONE_DIAMOND_ORE : ITEM.DIAMOND_ORE;
				}
	
				// Moonstone
				if (py > 900) && (py < 960) && (perlin_noise(px - 1280 - 1024, py, 8, WORLDGEN_ORE_GEMS_NOISE_OCTAVES, seed) > 5.3)
				{
					return is_in_emustone_layer ? ITEM.EMUSTONE_MOONSTONE_ORE : ITEM.MOONSTONE_ORE;
				}
	
				// Amber2
				if (py > 920) && (py < 970) && (perlin_noise(px - 1280 - 1280, py, 8, WORLDGEN_ORE_GEMS_NOISE_OCTAVES, seed) > 5.2)
				{
					return is_in_emustone_layer ? ITEM.EMUSTONE_AMBER_ORE : ITEM.AMBER_ORE;
				}
	
				// Jade
				if (py > 960) && (py < 1000) && (perlin_noise(px - 1280 - 1280 - 256, py, 8, WORLDGEN_ORE_GEMS_NOISE_OCTAVES, seed) > 5.5)
				{
					return is_in_emustone_layer ? ITEM.EMUSTONE_JADE_ORE : ITEM.JADE_ORE;
				}
	
				// Onyx
				if (py > 960) && (py < WORLD_HEIGHT) && (perlin_noise(px - 1280 - 1280 - 512, py, 8, WORLDGEN_ORE_GEMS_NOISE_OCTAVES, seed) > 5.4)
				{
					return is_in_emustone_layer ? ITEM.EMUSTONE_ONYX_ORE : ITEM.ONYX_ORE;
				}
		
				#endregion
				*/
			}
			
			var _v = perlin_noise(px + 4096, py, 32, 32, seed);
		
			/*
			if (_v > 11) && (_v < 14)
			{
				return ITEM.ANDESITE;
			}
			*/
		
			if (is_in_emustone_layer)
			{
				/*
				if (_v > 4.5) && (_v < 5.5)
				{
					return ITEM.ANDESITE;
				}
				*/
				
				return ITEM.EMUSTONE;
			}
			
			/*
			if (_v > 17) && (_v < 29)
			{
				return ITEM.GRANITE;
			}
			
			if (_v > 22) && (_v < 24)
			{
				return ITEM.DIRT;
			}
			*/
			
			return ITEM.STONE;
		}
	
		var _val = px * py;
		random_set_seed((_val == 0 ? (px | py) : _val) + seed);
	
		var is_in_emustone_layer = (py >= EMUSTONE_TRANS_YSTART) && ((py > EMUSTONE_YSTART) || (irandom(py - EMUSTONE_TRANS_YSTART) >= 2));
		
		var _cave_biome = (_chunk_data >> 9) & 0xff;
		
		if (_cave_biome != 0xff)
		{
			var _biome = cave_biome_data[_cave_biome];
		
			if (_z_last)
			{
				var _foliage = (tile_get(px, py, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY ? _biome.foliage : _biome.cave_foliage);
					
				if (_foliage != -1)
				{
					_foliage(px, py, pz, seed);
				}
					
				exit;
			}
			
			if (pz != CHUNK_DEPTH_WALL)
			{
				var _solid = _biome.tile >> 16;
			
				return (_solid != 0xffff ? _solid : __get_ore(px, py, seed, is_in_emustone_layer));
			}
			
			var _wall = _biome.tile & 0xffff;
		
			return (_wall != 0xffff ? _wall : (is_in_emustone_layer ? ITEM.EMUSTONE_WALL : ITEM.STONE_WALL));
		}
		
		var _ylowest = ysurface + 12;
		
		if (py <= ysurface + 8) || (py <= _ylowest + perlin_noise(px + CRUST_XOFFSET, py + CRUST_YOFFSET, 8, 4, seed))
		{
			var _biome = surface_biome_data[_chunk_data >> 17];
		
			if (_z_last)
			{
				var _natural = _biome.natural;
			
				if (_natural != -1)
				{
					_natural(px, py, pz, seed);
				}
			}
			
			var _tiles = _biome.tiles;
		
			// Check if top crust layer (creation for grass blocks, etc.)
			if (py <= ysurface)
			{
				if (_z_last)
				{
					var _foliage = _biome.foliage;
				
					if (_foliage != -1)
					{
						_foliage(px, py, pz, seed);
					}
					
					exit;
				}
				
				var _c = _tiles.crust_top;
				
				return (pz != CHUNK_DEPTH_WALL ? ((_c & 0x80000000) ? ITEM.EMPTY : (_c >> 16)) : ((_c & 0x8000) ? ITEM.EMPTY : (_c & 0xffff)));
			}
		
			if (py <= _ylowest)
			{
				var _c = _tiles.crust_bottom;
				
				return (pz != CHUNK_DEPTH_WALL ? ((_c & 0x80000000) ? ITEM.EMPTY : (_c >> 16)) : ((_c & 0x8000) ? ITEM.EMPTY : (_c & 0xffff)));
			}
			
			var _c = _tiles.stone;
			
			return (pz != CHUNK_DEPTH_WALL ? ((_c & 0x80000000) ? ITEM.EMPTY : (_c >> 16)) : ((_c & 0x8000) ? ITEM.EMPTY : (_c & 0xffff)));
		}
	
		return (pz != CHUNK_DEPTH_WALL ? __get_ore(px, py, seed, is_in_emustone_layer) : (is_in_emustone_layer ? ITEM.EMUSTONE_WALL : ITEM.STONE_WALL));
	})
	/*.set_sky_biome(function(_x, _y, _seed, _data = global.sky_biome_data, _length = array_length(global.sky_biome_data))
	{
		var _biome;
	
		var _start_end_range;
		var _ystart;
		var _yend;
	
		var _offset;
		var _val;
	
		var i = 0;
	
		repeat (_length)
		{
			_biome = _data[i];
		
			_start_end_range = _biome.start_end_range;
			_ystart = _start_end_range >> 16;
		
			if (_y >= _ystart)
			{
				_yend = (_start_end_range >> 8) & 0xff;
			
				if (_y <= _yend)
				{
					#macro WORLDGEN_BIOME_SKY_MOISE_OCTAVES 8
				
					_val = perlin_noise(_x, _y, _start_end_range & 0xff, WORLDGEN_BIOME_SKY_MOISE_OCTAVES, _seed);
				
					if (_y >= _ystart + _val) && (_y <= _yend - _val)
					{
						return i;
					}
				}
			}
		
			++i;
		}
	
		return -1;
	})*/
	.set_surface_biome(function(_x, _y, _seed, _ysurface = 0)
	{
		static __init = false;
		static __map = [];
	
		if (!__init)
		{
			__init = true;
		
			var i = 0;
			var j;
			var l;
		
			#macro BIOME_COLOUR_MAP_WIDTH 32
			#macro BIOME_COLOUR_MAP_HEIGHT 32
		
			var _surface = surface_create(BIOME_COLOUR_MAP_WIDTH, BIOME_COLOUR_MAP_HEIGHT);
			var _colour;
		
			surface_set_target(_surface);
		
			draw_sprite(map_Biome_Colour, 0, 0, 0);
		
			surface_reset_target();
		
			var _biome_data = global.surface_biome_data;
			var _biome_data_length = array_length(_biome_data);
	
			repeat (BIOME_COLOUR_MAP_WIDTH)
			{
				j = 0;
		
				repeat (BIOME_COLOUR_MAP_HEIGHT)
				{
					_colour = surface_getpixel(_surface, i, j);
		
					l = 0;
			
					repeat (_biome_data_length)
					{
						if (_biome_data[l].map_colour != _colour)
						{
							__map[@ i + (j * BIOME_COLOUR_MAP_WIDTH)] = l;
					
							break;
						}
						
						++l;
					}
			
					++j;
				}
		
				++i;
			}
		
			surface_free(_surface);
		}
	
		if (FORCE_SURFACE_BIOME != -1)
		{
			return FORCE_SURFACE_BIOME;
		}
	
		_y = max(0, _y - _ysurface - 8);
	
		#macro WORLDGEN_SURFACE_NOISE_XOFFSET 256
		#macro WORLDGEN_SURFACE_NOISE_YOFFSET 256
	
		// Heat - Cold -> Hot
		#macro WORLDGEN_SURFACE_NOISE_OCTAVE_HEAT 120
	
		// Humidity - Dry -> Wet
		#macro WORLDGEN_SURFACE_NOISE_OCTAVE_HUMIDITY 188
	
		return __map[round(perlin_noise(_x + WORLDGEN_SURFACE_NOISE_XOFFSET, _y + WORLDGEN_SURFACE_NOISE_YOFFSET, 31, WORLDGEN_SURFACE_NOISE_OCTAVE_HUMIDITY, _seed)) + (round(perlin_noise(_x - WORLDGEN_SURFACE_NOISE_XOFFSET, _y - WORLDGEN_SURFACE_NOISE_YOFFSET, 31, WORLDGEN_SURFACE_NOISE_OCTAVE_HEAT, _seed)) * 32)];
	})
	.set_cave_biome(function(_x, _y, _seed, _data = global.cave_biome_data, _length = array_length(global.cave_biome_data), _ysurface = 0)
	{
		#macro WORLDGEN_BIOME_CAVE_NOISE_RANGE 8
		#macro WORLDGEN_BIOME_CAVE_NOISE_OCTAVES 88
		#macro WORLDGEN_BIOME_CAVE_NOISE_REQUIREMENT 5
	
		if (_ysurface == 0)
		{
			_ysurface = worldgen_get_ysurface(_x, _seed, global.world_data[global.world.environment.value & 0xf]);
		}
	
		if (_y <= _ysurface + 32)
		{
			return -1;
		}
	
		/*
		if (FORCE_CAVE_BIOME != -1)
		{
			return FORCE_CAVE_BIOME;
		}
	
		var i = 0;
	
		repeat (_length)
		{
			if (perlin_noise(_x, _y + (i * 1024), WORLDGEN_BIOME_CAVE_NOISE_OCTAVES, WORLDGEN_BIOME_CAVE_NOISE_RANGE, _seed) > WORLDGEN_BIOME_CAVE_NOISE_REQUIREMENT)
			{
				return i;
			}
		
			++i;
		}
	
		return (_y >= EMUSTONE_YSTART ? CAVE_BIOME.EMUSTONE : CAVE_BIOME.STONE);
		*/
		
		return CAVE_BIOME.STONE;
	})
	.set_rpc(, function()
	{
		if (!instance_exists(obj_Player))
		{
			time_source_destroy(global.time_source_rpc);
			
			exit;
		}
		
		var _x = round(obj_Player.x / TILE_SIZE);
		var _y = round(obj_Player.y / TILE_SIZE);
		
		var _inst = instance_nearest(_x, _y, obj_Boss);
		
		if (instance_exists(_inst))
		{
			var _data = global.boss_data[_inst.boss_id];
			var _type = _data.type;
			
			if (_data == BOSS_TYPE.SKY)
			{
				np_setpresence($"rpc.biome.sky.{_data.name}", global.world.info.name, _data.rpc_icon, "");
			}
			else if (_data == BOSS_TYPE.SURFACE)
			{
				np_setpresence($"rpc.biome.surface.{_data.name}", global.world.info.name, _data.rpc_icon, "");
			}
			else if (_data == BOSS_TYPE.CAVE)
			{
				np_setpresence($"rpc.biome.cave.{_data.name}", global.world.info.name, _data.rpc_icon, "");
			}
			
			exit;
		}
		
		var _world = global.world;
		var _info = _world.info;
		var _seed = _info.seed;
		
		static __sky = global.world_data[WORLD.PLAYGROUND].sky_biome;
		
		if (__sky != -1)
		{
			var _sky = __sky(_x, _y, _seed);
			
			if (_sky != -1)
			{
				var _data = global.sky_biome_data[_sky];
				
				np_setpresence(loca_translate($"rpc.biome.sky.{_data.name}"), _info.name, _data.rpc_icon, "");
				
				exit;
			}
		}
		
		static __cave = global.world_data[WORLD.PLAYGROUND].cave_biome;
		
		if (__cave != -1)
		{
			var _cave = __cave(_x, _y, _seed);
				
			if (_cave != -1)
			{
				var _data = global.cave_biome_data[_cave];
					
				np_setpresence(loca_translate($"rpc.biome.cave.{_data.name}"), _info.name, _data.rpc_icon, "");
				
				exit;
			}
		}
		
		static __surface = global.world_data[WORLD.PLAYGROUND].surface_biome;
		var _data = global.surface_biome_data[__surface(_x, _y, _seed)];
					
		np_setpresence(loca_translate($"rpc.biome.surface.{_data.name}"), _info.name, _data.rpc_icon, "");
	}));

array_push(global.world_data, new WorldData("Horizon", WORLD_TYPE.FLAT)
	.set_addon(function(px, py, pz, seed, attributes, _chunk_data, ysurface, surface_biome_data, cave_biome_data, generate_foliage, _z_last = false)
	{
		var is_in_emustone_layer = (py > EMUSTONE_YSTART);
		
		var _ylowest = ysurface + 12;
		
		if (py <= _ylowest + 8) || (py <= _ylowest + perlin_noise(px + CRUST_XOFFSET, py + CRUST_YOFFSET, 8, 4, seed))
		{
			var _biome = surface_biome_data[_chunk_data >> 17];
		
			if (_z_last)
			{
				var _natural = _biome.natural;
			
				if (_natural != -1)
				{
					_natural(px, py, pz, seed);
				}
			}
			
			var _tiles = _biome.tiles;
		
			// Check if top crust layer (creation for grass blocks, etc.)
			if (py <= ysurface)
			{
				var _c = _tiles.crust_top;
				
				return (pz != CHUNK_DEPTH_WALL ? ((_c & 0x80000000) ? ITEM.EMPTY : (_c >> 16)) : ((_c & 0x8000) ? ITEM.EMPTY : (_c & 0xffff)));
			}
		
			if (py <= _ylowest)
			{
				var _c = _tiles.crust_bottom;
				
				return (pz != CHUNK_DEPTH_WALL ? ((_c & 0x80000000) ? ITEM.EMPTY : (_c >> 16)) : ((_c & 0x8000) ? ITEM.EMPTY : (_c & 0xffff)));
			}
			
			var _c = _tiles.stone;
			
			return (pz != CHUNK_DEPTH_WALL ? ((_c & 0x80000000) ? ITEM.EMPTY : (_c >> 16)) : ((_c & 0x8000) ? ITEM.EMPTY : (_c & 0xffff)));
		}
	
		return (pz != CHUNK_DEPTH_WALL ? ITEM.EMUSTONE : (is_in_emustone_layer ? ITEM.EMUSTONE_WALL : ITEM.STONE_WALL));
	}));