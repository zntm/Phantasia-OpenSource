image_alpha += value * global.delta_time;

if (value > 0) && (image_alpha >= 1)
{
	room_goto(goto_room);
		
	exit;
}
else if (image_alpha <= 0)
{
	instance_destroy();
		
	exit;
}

draw_sprite_ext(spr_Square, 0, 0, 0, display_get_width(), display_get_height(), 0, c_black, image_alpha);