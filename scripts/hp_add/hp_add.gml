#macro HP_COLOUR_HEAL #30DB49
#macro HP_COLOUR_DAMAGE #E1122D

function hp_add(_obj, _val, _type = DAMAGE_TYPE.DEFAULT, _show_text = true)
{
	
	
	if (_val < 0.5) && (_val > -0.5) exit;
	
	_val = round(_val);
	
	if (_val == 0) exit;
	
	if (_obj == obj_Player) || (_obj == inst_78BF165C)
	{
		obj_Control.surface_refresh_hp = true;
	}
	
	_obj.hp = clamp(_obj.hp + _val, 0, _obj.hp_max);
	_obj.damage_type = _type;
	
	if (_show_text)
	{
		spawn_text(_obj.x, _obj.y, new FloatingText(abs(_val))
			.set_yvelocity(-8)
			.set_colour(_val >= 0 ? HP_COLOUR_HEAL : HP_COLOUR_DAMAGE));
	}
	
	if (_obj.hp <= 0) && (variable_instance_exists(_obj, "name"))
	{
		chat_add("", string_get_death(_obj));
	}
}