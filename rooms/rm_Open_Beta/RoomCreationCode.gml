var _f = global.settings.graphics.fullscreen.value;

window_set_fullscreen(_f);
window_set_showborder(!global.settings.graphics.borderless.value);

if (!_f)
{
	var _window_size = global.settings.graphics.window_size;
	var _size = string_split(_window_size.values[_window_size.value], "x");

	window_set_size(real(_size[0]), real(_size[1]));
	window_center();
}