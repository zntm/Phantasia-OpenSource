function toast_biome()
{
	var _i = obj_Background.in_biome;
	var _t = _i.type;
	
	if (_t == BIOME_TYPE.SURFACE)
	{
		var _b = loca_translate($"biome.surface.{global.surface_biome_data[_i.biome].name}");
		
		draw_text(120, 120, $"Entering surface biome: {_b}");
	}
	else if (_t == BIOME_TYPE.CAVE)
	{
		var _b = loca_translate($"biome.cave.{global.surface_biome_data[_i.biome].name}");
		
		draw_text(120, 120, $"Entering cave biome: {_b}");
	}
	else if (_t == BIOME_TYPE.SKY)
	{
		var _b = loca_translate($"biome.sky.{global.sky_biome_data[_i.biome].name}");
		
		draw_text(120, 120, $"Entering sky biome: {_b}");
	}
}