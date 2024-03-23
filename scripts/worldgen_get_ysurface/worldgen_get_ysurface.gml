enum WORLD_TYPE {
	DEFAULT,
	FULL,
	FLAT
}

// global.animcurve_ocean = animcurve_get_channel(ac_Ocean, "y");

// function worldgen_get_ysurface(px, seed, _biome_data = global.surface_biome_data, _attributes = global.world_data[global.world.environment.value & 0xf], _animcurve_ocean = global.animcurve_ocean)
function worldgen_get_ysurface(px, seed, _attributes = global.world_data[global.world.environment.value & 0xf])
{
	#macro YSURFACE_NOISE_XOFFSET 16384
	#macro YSURFACE_NOISE_YOFFSET 16384
	
	var _v = _attributes.type;
	
	if (_v == WORLD_TYPE.DEFAULT)
	{
		var _surface = _attributes.surface_flatness_offset;
		var _min = (_surface >> 8) & 0xff;
		
		return WORLD_HEIGHT_CONSTANT + _min - (perlin_noise(px + YSURFACE_NOISE_XOFFSET, YSURFACE_NOISE_YOFFSET, _min + (_surface & 0xff), _surface >> 16, seed) << 0);
	}
	
	if (_v == WORLD_TYPE.FULL)
	{
		return 0;
	}
	
	if (_v == WORLD_TYPE.FLAT)
	{
		return WORLD_HEIGHT_CONSTANT;
	}
	
	throw $"World {_attributes.name} does not have a valid world type!";
}