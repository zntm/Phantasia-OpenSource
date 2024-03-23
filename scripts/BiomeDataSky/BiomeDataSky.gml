function BiomeDataSky(_name) : BiomeData(_name) constructor
{
	tiles = ITEM.CLOUD;
	
	static set_tiles = function(_tiles)
	{
		tiles = _tiles;
		
		return self;
	}
	
	start_end_range = (0 << 16) | (255 << 8) | 0;
	
	static set_range = function(_start, _end, _offset_range)
	{
		start_end_range = (_start << 16) | (_end << 8) | _offset_range;
		
		return self;
	}
	
	/*
	natural = noone;
	
	static set_natural = function(_natural)
	{
		natural = _natural;
		
		return self;
	}
	
	foliage = noone;
	
	static set_foliage = function(_foliage)
	{
		foliage = _foliage;
		
		return self;
	}
	
	// Used for air
	cave_foliage = noone;
	
	static set_cave_foliage = function(_foliage)
	{
		cave_foliage = _foliage;
		
		return self;
	}
	
	
	passive_creatures = [];
	
	static set_passive_creatures = function(_creatures)
	{
		passive_creatures = _creatures;
		
		return self;
	}
	*/
	
	noise_xoffset = 0;
	noise_yoffset = 0;
	noise_xmultiplier = 0.5;
	noise_ymultiplier = 1;
	noise_range = 8;
	noise_octaves = 32;
	noise_requirement = 3;
	
	static set_noise_offset = function(_xoffset, _yoffset)
	{
		noise_xoffset = _xoffset;
		noise_yoffset = _yoffset;
		
		return self;
	}
	
	static set_noise_multiplier = function(_xmultiplier, _ymultiplier)
	{
		noise_xmultiplier = _xmultiplier;
		noise_ymultiplier = _ymultiplier;
		
		return self;
	}
	
	static set_noise_values = function(_range, _octaves, _requirement)
	{
		noise_range = _range;
		noise_octaves = _octaves;
		noise_requirement = _requirement;
		
		return self;
	}
	
	sky_colour = new BiomeSkyColour();
	
	static set_sky_colour = function(_colour)
	{
		sky_colour = _colour;
	
		return self;
	}
}

global.sky_biome_data = [];

array_push(global.sky_biome_data, new BiomeDataSky("Marestail")
	.set_range(180, 255, 16)
	.set_tiles(ITEM.CLOUD));

array_push(global.sky_biome_data, new BiomeDataSky("Goldilocks")
	.set_range(90, 174, 16)
	.set_tiles(ITEM.CLOUD));

array_push(global.sky_biome_data, new BiomeDataSky("Finis")
	.set_range(0, 86, 16)
	.set_tiles(ITEM.CLOUD));