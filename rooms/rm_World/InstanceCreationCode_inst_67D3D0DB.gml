sprite_index = spr_Menu_Button_Danger;

value = false;

xs = xstart;
xstart -= 8;

on_press = function()
{
	value = !value;
	xstart = xs + (value ? 8 : -8);
	
	sprite_index = (value ? spr_Menu_Button_Success : spr_Menu_Button_Danger);
}
				
on_draw = function(_x, _y, _colour, _id)
{
	draw_sprite_ext(spr_Menu_Indent, 0, _id.xs + (_id.value ? -8 : 8), _id.y, 2, 2, 0, c_white, 1);
}