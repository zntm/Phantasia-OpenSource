var _splash = global.splash_text;

randomize();

text = _splash[irandom(array_length(_splash) - 1)];

halign = fa_left;
valign = fa_middle;

colour = #FFB818;

on_draw = function(_x, _y)
{
	var _val = (1 + ((cos((0.0174533 * current_time / 6)) + 1) / 4)) * min(0.5, 256 / string_width(text));
	
	xscale = _val;
	yscale = _val;
}