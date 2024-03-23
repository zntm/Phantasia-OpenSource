text = loca_translate("menu.create_world.world.playground");

on_press = function()
{
	var _value = global.world.environment.value;
	var _v = _value & 0xf;
	
	if (_v == WORLD.PLAYGROUND)
	{
		text = loca_translate($"menu.create_world.world.{global.world_data[WORLD.HORIZON].name}");
		global.world.environment.value = (_value & 0xffff0) | WORLD.HORIZON;
	}
	else if (_v == WORLD.HORIZON)
	{
		text = loca_translate($"menu.create_world.world.{global.world_data[WORLD.PLAYGROUND].name}");
		global.world.environment.value = (_value & 0xffff0) | WORLD.PLAYGROUND;
	}
}