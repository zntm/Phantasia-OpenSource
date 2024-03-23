#macro SPAWN_CREATURE_MAX 200

function spawn_creature(_x, _y, _id, _amount = 1)
{
	if (instance_number(obj_Creature) > SPAWN_CREATURE_MAX) exit;
	
	var _data = global.creature_data[_id];
	
	var _sprite = _data.sprite_idle;
	var _sprite_type = _data.sprite_type;
	
	var _index;
	
	if (_sprite_type != -1)
	{
		_index = _sprite_type(floor(_x / CHUNK_SIZE_WIDTH), floor(_y / CHUNK_SIZE_HEIGHT));
		_sprite = _sprite[_index];
		
		repeat (_amount)
		{		
			with (instance_create_layer(_x, _y, "Instances", obj_Creature))
			{
				sprite_index = _sprite;
				image_alpha = 0;
				
				creature_id = _id;
				index = _index;
				
				xdirection = choose(-1, 0, 1);
				ydirection = choose(-1, 1);

				panic_time = 0;
				ylast = y;

				entity_init(, round(_data.hp * global.difficulty_multiplier_hp[(global.world.environment.value >> 8) & 0xf]), _data.colour_offset);

				searching = noone;
			}
		}
		
		exit;
	}
	
	var _sprite_length = array_length(_sprite) - 1;
	
	repeat (_amount)
	{
		_index = irandom(_sprite_length);
		
		with (instance_create_layer(_x, _y, "Instances", obj_Creature))
		{
			sprite_index = _sprite[_index];
			image_alpha = 0;
				
			creature_id = _id;
			index = _index;
				
			xdirection = choose(-1, 0, 1);
			ydirection = choose(-1, 1);

			panic_time = 0;
			ylast = y;

			entity_init(, round(_data.hp * global.difficulty_multiplier_hp[(global.world.environment.value >> 8) & 0xf]), _data.colour_offset);

			searching = noone;
		}
	}
}