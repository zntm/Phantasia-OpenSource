gml_pragma("forceinline");

function __ph_addon_playground_get_cave_biome(px, py, seed)
{
	static CAVE_BIOME_RANGE = 8;
	static CAVE_BIOME_RANGE_REQUIREMENT = 5;
	static CAVE_BIOME_OCTAVES = 128;
	
	if (py > global.ysurface[$ string(px)] + 32)
	{
		if (FORCE_CAVE_BIOME != noone)
		{
			return FORCE_CAVE_BIOME;
		}
		
		static length = array_length(global.playground_cave_biome_data);
		
		for (var i = 0; i < length; ++i)
		{
			if (perlin_noise(px, py + (i * WORLD_HEIGHT), CAVE_BIOME_RANGE, CAVE_BIOME_OCTAVES, seed) > CAVE_BIOME_RANGE_REQUIREMENT)
			{
				return i;
			}
		}
	}
	
	return undefined;
}