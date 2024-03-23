global.effect_entities = [];

function ctrl_effects()
{
	var _names = struct_get_names(global.effect_data);
	var _length = array_length(_names);
	
	var _entities = global.effect_entities;
	var _entities_length = array_length(_entities);
	
	var i = 0;
	var j;
	
	var _name;
	var _time = global.delta_time;
	
	repeat (_length)
	{
		_name = _names[i++];
		
		j = 0;
		
		repeat (_entities_length)
		{
			with (_entities[j++])
			{
				if (effects[$ _name].timer > 0)
				{
					effects[$ _name].timer -= _time;
				}
				
				if (effects[$ _name].timer <= 0)
				{
					effects[$ _name].timer = 0;
					effects[$ _name].level = 0;
				}
			}
		}
	}
}