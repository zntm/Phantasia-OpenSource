function hp_set(_obj, _val, _type = DAMAGE_TYPE.DEFAULT)
{
	
	
	if (_obj == obj_Player) || (_obj == inst_78BF165C)
	{
		obj_Control.surface_refresh_hp = true;
	}
	
	_obj.hp = clamp(_val, 0, _obj.hp_max);
	_obj.damage_type = _type;
	
	if (_val <= 0) && (variable_instance_exists(_obj, "name"))
	{
		chat_add("", string_get_death(_obj));
	}
}