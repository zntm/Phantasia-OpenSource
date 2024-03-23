enum DIURNAL {
	DAWN,
	DAY,
	DUSK,
	NIGHT
}

function bg_time_update(_time_current, _time_from, _time_to, _value_start, _value_end)
{
	if (_time_current < _value_start) || (_time_current >= _value_end) exit;
	
	obj_Control.refresh_time_chunk = REFRESH_TIME_CHUNK_FAST;
	
	var _lerp_amount = (_time_current - _value_start) / (_value_end - _value_start);
	var _lerp2 = in_biome_transition.lerp_value;
	
	var _sky = in_biome.sky_colour;
	var _in_biome_transition = in_biome_transition.sky_colour;
	
	var _in_solid = _sky.solid;
	var _trans_solid = _in_biome_transition.solid;
	
	var _colour_sky_solid = merge_colour(
		merge_colour(_in_solid[_time_from], _in_solid[_time_to], _lerp_amount),
		merge_colour(_trans_solid[_time_from], _trans_solid[_time_to], _lerp_amount),
		_lerp2
	);
	
	if (colour_sky_solid != _colour_sky_solid)
	{
		colour_sky_solid = _colour_sky_solid;
		global.light_updated_sun = true;
	}
	
	var _in_gradient = _sky.gradient;
	var _trans_gradient = _in_biome_transition.gradient;
	
	var _colour_sky_gradient = merge_colour(
		merge_colour(_in_gradient[_time_from], _in_gradient[_time_to], _lerp_amount),
		merge_colour(_trans_gradient[_time_from], _trans_gradient[_time_to], _lerp_amount),
		_lerp2
	);
		
	if (colour_sky_gradient != _colour_sky_gradient)
	{
		colour_sky_gradient = _colour_sky_gradient;
		global.light_updated_sun = true;
	}
	
	var _biome_data_from;
	
	if (in_biome.type == BIOME_TYPE.SKY)
	{
		_biome_data_from = global.sky_biome_data;
	}
	else if (in_biome.type == BIOME_TYPE.CAVE)
	{
		_biome_data_from = global.cave_biome_data;
	}
	else
	{
		_biome_data_from = global.surface_biome_data;
	}
	
	var _biome_data_to;
	
	if (in_biome_transition.type == BIOME_TYPE.SKY)
	{
		_biome_data_to = global.sky_biome_data;
	}
	else if (in_biome_transition.type == BIOME_TYPE.CAVE)
	{
		_biome_data_to = global.cave_biome_data;
	}
	else
	{
		_biome_data_to = global.surface_biome_data;
	}
	
	var _colour_offset_from = _biome_data_from[in_biome.biome].colour_offset;
	var _offset_from_from = _colour_offset_from[_time_from];
	var _offset_from_to   = _colour_offset_from[_time_to];
	
	var _a00 = _offset_from_from >> 16;
	var _a01 = (_offset_from_from >> 8) & 0xff;
	var _a02 = _offset_from_from & 0xff;
	
	var _a10 = _offset_from_to >> 16;
	var _a11 = (_offset_from_to >> 8) & 0xff;
	var _a12 = _offset_from_to & 0xff;
	
	var _colour_offset_to = _biome_data_to[in_biome_transition.biome].colour_offset;
	var _offset_to_from = _colour_offset_to[_time_from];
	var _offset_to_to   = _colour_offset_to[_time_to];
	
	var _b00 = _offset_to_from >> 16;
	var _b01 = (_offset_to_from >> 8) & 0xff;
	var _b02 = _offset_to_from & 0xff;
	
	var _b10 = _offset_to_to >> 16;
	var _b11 = (_offset_to_to >> 8) & 0xff;
	var _b12 = _offset_to_to & 0xff;
	
	colour_offset = light_get_offset(
		lerp(lerp(((_a00 & 0x80) ? -(_a00 & 0x7f) : (_a00 & 0x7f)), ((_b00 & 0x80) ? -(_b00 & 0x7f) : (_b00 & 0x7f)), _lerp2), lerp(((_a10 & 0x80) ? -(_a10 & 0x7f) : (_a10 & 0x7f)), ((_b10 & 0x80) ? -(_b10 & 0x7f) : (_b10 & 0x7f)), _lerp2), _lerp_amount),
		lerp(lerp(((_a01 & 0x80) ? -(_a01 & 0x7f) : (_a01 & 0x7f)), ((_b01 & 0x80) ? -(_b01 & 0x7f) : (_b01 & 0x7f)), _lerp2), lerp(((_a11 & 0x80) ? -(_a11 & 0x7f) : (_a11 & 0x7f)), ((_b11 & 0x80) ? -(_b11 & 0x7f) : (_b11 & 0x7f)), _lerp2), _lerp_amount),
		lerp(lerp(((_a02 & 0x80) ? -(_a02 & 0x7f) : (_a02 & 0x7f)), ((_b02 & 0x80) ? -(_b02 & 0x7f) : (_b02 & 0x7f)), _lerp2), lerp(((_a12 & 0x80) ? -(_a12 & 0x7f) : (_a12 & 0x7f)), ((_b12 & 0x80) ? -(_b12 & 0x7f) : (_b12 & 0x7f)), _lerp2), _lerp_amount)
	);
}