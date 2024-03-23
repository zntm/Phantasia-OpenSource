function achievement_unlock(_obj, _id)
{
	var _uuid = _obj.uuid;
	
	if (!global.achievement_unlocks[$ _uuid][_id])
	{
		// TODO: Add toast notification
		global.achievement_unlocks[$ _uuid][@ _id] = true;
	}
}