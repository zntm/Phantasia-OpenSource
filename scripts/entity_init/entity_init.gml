function entity_init(_hp, _hp_max, _colour_offset = light_get_offset(0, 0, 0))
{
	xvelocity = 0;
	yvelocity = 0;
	
	hp = _hp ?? _hp_max;
	hp_max = _hp_max;
	
	#macro IMMUNITY_FRAME_MAX 60
	
	immunity_frame = 0;
	
	damage_type = DAMAGE_TYPE.DEFAULT;
	colour_offset = _colour_offset;
	
	effect_init();
}