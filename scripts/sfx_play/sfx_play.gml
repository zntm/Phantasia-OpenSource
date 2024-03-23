function sfx_play(_x, _y, _id, _type, _pitch_offset = 0.1)
{
	
	
	static __init = false;
	static __sfx_effect_reverb = audio_effect_create(AudioEffectType.Reverb1);
	
	static __audio_emitter = audio_emitter_create();
	static __audio_bus = audio_bus_create();
	
	if (!__init)
	{
		__init = true;
		
		audio_emitter_bus(__audio_emitter, __audio_bus);
	}
	
	if (_id == SFX.EMPTY) exit;
	
	static __sfx_data = global.sfx_data;
	
	var _data = __sfx_data[_id];
	
	var _sfx = _data[$ _type];
	var _length = array_length(_sfx);
	
	if (_length <= 0) exit;
		
	if (!position_meeting(_x, _y, obj_Light_Sun))
	{
		global.sfx_fill_amount = 0;
		global.sfx_fill_depth = 0;
		
		sfx_fill_empty_count(round(_x / TILE_SIZE), round(_y / TILE_SIZE));
		
		if (global.sfx_fill_amount > 0)
		{
			__sfx_effect_reverb.mix = clamp(global.sfx_fill_amount / 100, 0, 1);
			__audio_bus.effects[@ 0] = __sfx_effect_reverb;
		}
	}
	else
	{
		__sfx_effect_reverb.mix = 0;
		__audio_bus.effects[@ 0] = __sfx_effect_reverb;
	}
		
	var _v;
	var _t = _data.type;
	
	if (_t == SFX_TYPE.TILE)
	{
		_v = global.settings.audio.blocks.value;
	}
	else if (_t == SFX_TYPE.PASSIVE)
	{
		_v = global.settings.audio.passive.value;
	}
	else if (_t == SFX_TYPE.HOSTILE)
	{
		_v = global.settings.audio.hostile.value;
	}
	else
	{
		_v = global.settings.audio.sfx.value;
	}
	
	audio_play_sound_on(
		__audio_emitter,
		_sfx[irandom(_length - 1)],
		false,
		0,
		clamp((1 - (point_distance(obj_Player.x, obj_Player.y, _x, _y) / (TILE_SIZE * 32))) * 1.25 * _v * global.settings.audio.master.value, 0, 1),
		0,
		random_range(1 - _pitch_offset, 1 + _pitch_offset)
	);
}