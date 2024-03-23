placeholder = loca_translate("menu.create_player.enter_name");

randomize_text = function()
{
	text = choose("A", "E", "I", "O", "U") + (!irandom(9) ? choose("a", "e", "i", "o", "u") : "") + choose("d", "l", "m", "n", "s", "t", "c", "k", "sg", "sl", "mn", "pl", "st", "tr", "rr", "ck");
	
	var _repeat = (irandom(3) ? 1 : choose(2, 3));
	
	repeat (_repeat)
	{
		text += choose("a", "e", "i", "o", "u") + (!irandom(9) ? choose("a", "e", "i", "o", "u") : "") + choose("d", "l", "m", "n", "s", "t", "c", "k", "sg", "sl", "mn", "pl", "st", "tr", "rr", "ck");
	}
	
	if (!irandom(4))
	{
		text += choose("a", "e", "i", "o", "u") + choose(
			choose("th", "ny", "ly", "wy", "my"),
			choose("r", "n", "s") + "ie"
		);
	}
}

randomize_text();

while (string_length(text) > 24)
{
	randomize_text();
}