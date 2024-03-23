function ctrl_pets()
{
	global.pet_max = 1 + accessory_get_buff(BUFF_PET_MAX, obj_Player);

	if (!instance_exists(obj_Pet)) exit;
	
	var _pets = global.pets;
	var _length = array_length(_pets);

	while (global.pet_max < _length)
	{
		instance_destroy(_pets[--_length]);
	
		array_pop(global.pets);
	}
}