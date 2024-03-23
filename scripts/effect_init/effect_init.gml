function effect_init(_object = id)
{
	var _object_index = _object.object_index;
	
	if (!array_contains(global.effect_entities, _object_index))
	{
		array_push(global.effect_entities, _object_index);
	}
	
	_object.effects = {};

	var _names = struct_get_names(global.effect_data);
	var _length = array_length(_names);
	
	var i = 0;
	
	repeat (_length)
	{
		_object.effects[$ _names[i++]] = {
			timer: 0,
			level: 0
		};
	}
}