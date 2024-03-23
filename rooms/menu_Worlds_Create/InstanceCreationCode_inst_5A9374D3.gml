placeholder = loca_translate("menu.create_world.enter_seed");

randomize_text = function()
{
	randomize();
	
	text = string(irandom_range(-(2 << 24), (2 << 24)));
}

randomize_text();