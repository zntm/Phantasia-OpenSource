function effect_set(_type, _time, _level = 1, _object = id)
{
	var _current;
	
	with (_object)
	{
		_current = effects[$ _type];
	
		effects[$ _type] = {
			timer: _time * GAME_FPS,
			level: max(_current.level, _level)
		};
	}
}