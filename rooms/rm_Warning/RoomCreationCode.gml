var _f = global.settings.graphics.fullscreen.value;
var _b = global.settings.graphics.borderless.value;

if (_f)
{
	if (_b)
	{
		window_enable_borderless_fullscreen(true);
	}
	
	window_set_fullscreen(true);
}
else
{
	window_set_showborder(!_b);
	
	var _window_size = global.settings.graphics.window_size;
	var _size = string_split(_window_size.values[_window_size.value], "x");

	window_set_size(real(_size[0]), real(_size[1]));
	window_center();
}