text = loca_translate("menu.create_world.command_level.none");

on_press = function()
{
	var _value = global.world.environment.value;
	var _v = (_value >> 4) & 0xf;
	
	if (_v = CHAT_COMMAND_LEVEL.NONE)
	{
		text = loca_translate("menu.create_world.command_level.moderator");
		global.world.environment.value = (_value & 0xfff0f) | (CHAT_COMMAND_LEVEL.MODERATOR << 4);
	}
	else if (_v == CHAT_COMMAND_LEVEL.MODERATOR)
	{
		text = loca_translate("menu.create_world.command_level.owner");
		global.world.environment.value = (_value & 0xfff0f) | (CHAT_COMMAND_LEVEL.OWNER << 4);
	}
	else if (_v == CHAT_COMMAND_LEVEL.OWNER)
	{
		text = loca_translate("menu.create_world.command_level.none");
		global.world.environment.value = (_value & 0xfff0f) | (CHAT_COMMAND_LEVEL.NONE << 4);
	}
}