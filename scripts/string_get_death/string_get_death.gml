function string_get_death(_inst)
{
	var _type = _inst.damage_type;
	
	if (_type == DAMAGE_TYPE.BLAST)
	{
		return string(loca_translate("gui.death_reason.blast"), _inst.name);
	}
	
	if (_type == DAMAGE_TYPE.FALL)
	{
		return string(loca_translate("gui.death_reason.fall"), _inst.name);
	}
	
	if (_type == DAMAGE_TYPE.FIRE)
	{
		return string(loca_translate("gui.death_reason.fire"), _inst.name);
	}
	
	if (_type == DAMAGE_TYPE.MAGIC)
	{
		return string(loca_translate("gui.death_reason.magic"), _inst.name);
	}
	
	if (_type == DAMAGE_TYPE.MELEE)
	{
		return string(loca_translate("gui.death_reason.melee"), _inst.name);
	}
	
	if (_type == DAMAGE_TYPE.RANGED)
	{
		return string(loca_translate("gui.death_reason.ranged"), _inst.name);
	}
	
	return string(loca_translate("gui.death_reason.default"), _inst.name);
}