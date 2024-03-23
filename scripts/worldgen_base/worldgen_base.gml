#macro WORLD_HEIGHT 1024
#macro WORLD_HEIGHT_CONSTANT round(WORLD_HEIGHT / 2)

function worldgen_base(px, py, pz, seed, attributes, _attributes_addon, _chunk_data, ysurface, surface_biome_data = global.surface_biome_data, cave_biome_data = global.cave_biome_data, sky_biome_data = global.sky_biome_data, _foliage = false)
{
	if (_attributes_addon != -1) && (py >= ysurface)
	{
		if (_foliage)
		{
			if (pz == CHUNK_SIZE_Z - 1)
			{
				_attributes_addon(px, py, pz, seed, attributes, _chunk_data, ysurface, surface_biome_data, cave_biome_data, true);
			}
		}
		else if (pz == CHUNK_DEPTH_WALL) || (pz == CHUNK_DEPTH_DEFAULT && ((_chunk_data & 1) == 0))
		{
			return _attributes_addon(px, py, pz, seed, attributes, _chunk_data, ysurface, surface_biome_data, cave_biome_data, false);
		}
	}
	
	return ITEM.EMPTY;
}