global.pets = [];
global.pet_max = 1;

function spawn_pet(_x, _y, _id)
{
	
	
	var _pet_data = global.pet_data;
	var _data = _pet_data[_id];
	
	var _length = array_length(global.pets);
	
	if (_length >= global.pet_max)
	{
		var _length_last = _length - 1;
		var _pet = global.pets[_length_last];
		
		audio_play_sound(_pet_data[_pet.pet_id].sfx_off, 0, false, global.settings.audio.master.value * global.settings.audio.sfx.value);
		instance_destroy(_pet);
		array_delete(global.pets, _length_last, 1);
	}
	
	audio_play_sound(_data.sfx_on, 0, false);
	
	var _sprite_idle = _data.sprite_idle;
	var _sprite_moving = _data.sprite_moving;
	
	if (typeof(_sprite_idle) == "array")
	{
		_sprite_idle = array_choose(_sprite_idle);
	}
	
	if (typeof(_sprite_moving) == "array")
	{
		_sprite_moving = array_choose(_sprite_moving);
	}
	
	array_insert(global.pets, 0, instance_create_layer(_x, _y, "Instances", obj_Pet, {
		type: _data.type,
		
		sprite_index: _sprite_idle,
		
		sprite_idle:   _sprite_idle,
		sprite_moving: _sprite_moving,
		
		pet_id: _id,
	}));
}