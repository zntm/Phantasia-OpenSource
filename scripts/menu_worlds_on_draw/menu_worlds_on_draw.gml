function menu_worlds_on_draw(_x, _y, _colour, _inst)
{
	draw_set_align(fa_left, fa_top);
	
	var _data = _inst.data;
	
	var _size = bbox_right - bbox_left - 64;
	var _i = _data.info;
			
	var _name = _i.name;
	var _scale_name = min(1, _size / string_width(_name));
			
	var _seed = string(_i.seed);
	var _scale_seed = min(1, _size / string_width(_seed)) * 0.8;
			
	var _a = _data.activity;
			
	var _last_played = date_datetime_string(_a.date);
	var _scale_last_played = min(1, _size / string_width(_last_played)) * 0.8;
			
	// _x = bbox_left + 8;
	// _y = bbox_top + 8;
	
	_x += -(16 * image_xscale / 2) + 8;
	_y += -(16 * image_yscale / 2) + 8;
			
	var _x_icon = _x + 8;
	var _y_icon = _y + 8;
			
	_x += 16 + 4;
			
	draw_sprite_ext(ico_Name, 0, _x_icon, _y_icon, 1, 1, 0, _colour, 1);
	draw_sprite_ext(ico_Seed, 0, _x_icon, _y_icon + 20, 1, 1, 0, _colour, 1);
	draw_sprite_ext(ico_Last_Played, 0, _x_icon, _y_icon + 40, 1, 1, 0, _colour, 1);
			
	draw_text_transformed_colour(_x, _y, _name, _scale_name, _scale_name, 0, _colour, _colour, _colour, _colour, 1);
	draw_text_transformed_colour(_x, _y + 20, _seed, _scale_seed, _scale_seed, 0, _colour, _colour, _colour, _colour, 1);
	draw_text_transformed_colour(_x, _y + 40, _last_played, _scale_last_played, _scale_last_played, 0, _colour, _colour, _colour, _colour, 1);
}