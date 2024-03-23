function gui_boss_hp()
{
	var _camera = global.camera;
	
	var _gw = _camera.gui_width;
	var _gh = _camera.gui_height;
	
	if (!surface_exists(surface_boss))
	{
		surface_boss = surface_create(_gw, _gh);
	}
	
	surface_set_target(surface_boss);
	draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
	
	var _boss = instance_nearest(obj_Player.x, obj_Player.y, obj_Boss);
	var _hp = _boss.hp;
	
	if (_hp > 0)
	{
		static __boss_data = global.boss_data;
		
		var _data = __boss_data[_boss.boss_id];
		var _hp_max = _data.hp;
		
		// TODO: Update magic numbers
		var _xscale = lerp(0, 496, _hp / _hp_max);
		
		var _x = _gw / 2;
		var _y = _gh - 120;
		
		var _bar_colours = _data.bar_colours;
		var _bar_colours_length = array_length(_bar_colours);
		
		var i = _bar_colours_length - 1;
		
		repeat (_bar_colours_length)
		{
			draw_sprite_ext(spr_Square, 0, _x - (496 / 2), _y + 11, _xscale, 32 * ((i + 1) / _bar_colours_length), 0, _bar_colours[i], 1);
			
			--i;
		}
	
		draw_sprite_ext(gui_Boss_HP, 0, _x, _y, 1, 1, 0, c_white, 1);
	
		draw_set_halign(fa_center);
	
		draw_text(_x, _gh - 64, $"{_data.name} ({_hp}/{_hp_max})");
	}
	
	surface_reset_target();
	
	draw_surface_stretched(surface_boss, 0, 0, _gw, _gh);
}