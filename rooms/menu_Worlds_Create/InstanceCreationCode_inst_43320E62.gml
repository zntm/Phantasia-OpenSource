sprite_index = spr_Menu_Button_Secondary;

value = true;
x += 8;

on_press = function()
{
	value = !value;
	global.world.environment.value = (global.world.environment.value & 0xdfff) | (value << 17);
	x = xstart + (value ? 8 : -8);
}
				
on_draw = function(_x, _y, _colour, _id)
{
	draw_sprite_ext(spr_Menu_Indent, 0, xstart + (_id.value ? -8 : 8), _id.y, 2, 2, 0, c_white, 1);
}