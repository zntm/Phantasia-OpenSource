enum DIFFICULTY_TYPE {
	PEACEFUL,
	EASY,
	NORMAL,
	HARD
}

text = loca_translate("menu.create_world.difficulty.normal");

on_press = function()
{
	var _value = global.world.environment.value;
	var _v = (_value >> 12) & 0xf;
	
	if (_v = DIFFICULTY_TYPE.PEACEFUL)
	{
		text = loca_translate("menu.create_world.difficulty.easy");
		global.world.environment.value = (_value & 0xf0fff) | (DIFFICULTY_TYPE.EASY << 12);
	}
	else if (_v == DIFFICULTY_TYPE.EASY)
	{
		text = loca_translate("menu.create_world.difficulty.normal");
		global.world.environment.value = (_value & 0xf0fff) | (DIFFICULTY_TYPE.NORMAL << 12);
	}
	else if (_v == DIFFICULTY_TYPE.NORMAL)
	{
		text = loca_translate("menu.create_world.difficulty.hard");
		global.world.environment.value = (_value & 0xf0fff) | (DIFFICULTY_TYPE.HARD << 12);
	}
	else if (_v == DIFFICULTY_TYPE.HARD)
	{
		text = loca_translate("menu.create_world.difficulty.peaceful");
		global.world.environment.value = (_value & 0xf0fff) | (DIFFICULTY_TYPE.PEACEFUL << 12);
	}
}