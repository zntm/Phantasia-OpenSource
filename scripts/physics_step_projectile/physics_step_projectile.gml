function physics_step_projectile(_x, _y, _id)
{
	static __inst = [ obj_Creature, obj_Boss ];
	
	var _inst = instance_place(_x, _y, __inst);
	
	if (!_inst) || (_inst.immunity_frame > 0)
	{
		return false;
	}
	
	var _damage = round(_id.damage * random_range(0.9, 1.1));
	
	if (_damage <= 0) && (!array_contains(_id.cant_damage, object_index))
	{
		return false;
	}
	
	hp_add(_inst, -_damage, DAMAGE_TYPE.RANGED);
	
	var _obj = _inst.object_index;
	
	if (_obj == obj_Creature)
	{
		var _data = global.creature_data[_inst.creature_id];
		
		if (_data.get_type() == CREATURE_HOSTILITY_TYPE.PASSIVE)
		{
			_inst.panic_time = GAME_FPS * CREATURE_PASSIVE_PANIC_SECONDS;
		}
		
		sfx_play(x, y, _data.sfx, "damage");
	}
	else if (_obj == obj_Boss)
	{
		var _data = global.boss_data[_inst.boss_id];
		
		if (_data.get_type() == CREATURE_HOSTILITY_TYPE.PASSIVE)
		{
			_inst.panic_time = GAME_FPS * CREATURE_PASSIVE_PANIC_SECONDS;
		}
		
		sfx_play(x, y, _data.sfx, "damage");
	}
	
	_inst.yvelocity = -3;
	_inst.immunity_frame = 1;
	
	if (_id.destroy_on_collision)
	{
		instance_destroy(_id);
		
		return true;
	}
	
	return false;
}