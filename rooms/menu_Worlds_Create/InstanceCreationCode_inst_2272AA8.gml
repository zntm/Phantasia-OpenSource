enum GAMEMODE_TYPE {
	ADVENTURE,
	SANDBOX
}

text = loca_translate("menu.create_world.gamemode.adventure");

on_press = function()
{
	var _value = global.world.environment.value;
	var _v = (_value >> 12) & 0xf;
	
	if (_v == GAMEMODE_TYPE.ADVENTURE)
	{
		text = loca_translate("menu.create_world.gamemode.sandbox");
		global.world.environment.value = (_value & 0xff0ff) | (GAMEMODE_TYPE.SANDBOX << 12);
	}
	else if (_v == GAMEMODE_TYPE.SANDBOX)
	{
		text = loca_translate("menu.create_world.gamemode.adventure");
		global.world.environment.value = (_value & 0xff0ff) | (GAMEMODE_TYPE.ADVENTURE << 12);
	}
}