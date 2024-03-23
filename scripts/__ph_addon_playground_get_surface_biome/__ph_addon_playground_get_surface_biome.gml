gml_pragma("forceinline");

function __ph_addon_playground_get_surface_biome(px, py, seed)
{
	static BIOME_SELECTION_XOFFSET			= 1024;
	static BIOME_SELECTION_YOFFSET			= 1024;

	static BIOME_SELECTION_OCTAVES_HEAT		= 512;
	static BIOME_SELECTION_OCTAVES_HUMIDITY	= 256;

	if (FORCE_SURFACE_BIOME != noone)
	{
		return FORCE_SURFACE_BIOME;
	}
	
	//  Heat     - Cold -> Hot
	var heat = round(perlin_noise(px, py, BIOME_COLOUR_MAP_WIDTH - 1, BIOME_SELECTION_OCTAVES_HEAT, seed));
	
	//  Humidity - Dry -> Wet
	var humidity = round(perlin_noise(px, py, BIOME_COLOUR_MAP_HEIGHT - 1, BIOME_SELECTION_OCTAVES_HUMIDITY, seed));
	
	static biome_map = global.biome_map;
	
	return biome_map[humidity + (heat * BIOME_COLOUR_MAP_WIDTH)];
}
