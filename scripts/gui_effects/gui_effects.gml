function gui_effects()
{
	static __effect_data = global.effect_data;

	static __effect_names = struct_get_names(__effect_data);
	static __effect_length = array_length(__effect_names);

	static __effect_width  = sprite_get_width(gui_Effect_Border);
	static __effect_height = sprite_get_height(gui_Effect_Border);

	array_sort(__effect_names, sort_alphabetical_descending);

	#macro GUI_EFFECT_XOFFSET 4
	#macro GUI_EFFECT_YOFFSET 12
	#macro GUI_EFFECT_SCALE 2
	#macro GUI_EFFECT_ROW 10
	#macro GUI_EFFECT_HOVER_OFFSET (8 * GUI_EFFECT_SCALE)

	#macro GUI_EFFECT_TEXT_XOFFSET 0
	#macro GUI_EFFECT_TEXT_YOFFSET 2
	#macro GUI_EFFECT_TEXT_SCALE 0.8
	
	draw_set_align(fa_center, fa_top);
	
	var _name;
	
	var _effect;
	var _effects = obj_Player.effects;
	
	var _x;
	var _y;
	
	var _timer;
	var _data;
	var _sprite;
	
	var _seconds;
	var _time;
	
	var _mx = global.gui_mouse_x;
	var _my = global.gui_mouse_y;
	
	var _tick = global.tick;
	
	var i = 0;
	var _index = 0;

	repeat (__effect_length)
	{
		_name = __effect_names[i++];
		_effect = _effects[$ _name];
	
		_timer = _effect.timer;
	
		if (_timer <= 0) continue;
		
		_x = GUI_SAFE_ZONE_X + (INVENTORY_SIZE.ROW * INVENTORY_SLOT_WIDTH * INVENTORY_SLOT_SCALE) + ((__effect_width + GUI_EFFECT_XOFFSET) * GUI_EFFECT_SCALE * (_index %  GUI_EFFECT_ROW)) + (GUI_EFFECT_XOFFSET * GUI_EFFECT_SCALE) + (__effect_width * GUI_EFFECT_SCALE / 2);
		_y = GUI_SAFE_ZONE_Y + (INVENTORY_SLOT_HEIGHT * INVENTORY_SLOT_SCALE / 2) + ((__effect_height + GUI_EFFECT_YOFFSET) * GUI_EFFECT_SCALE * floor(_index / GUI_EFFECT_ROW));
		
		++_index;
		
		#region Sprite
		
		_data = __effect_data[$ _name];
		
		draw_sprite_ext(gui_Effect_Border, !_data.positive, _x, _y, GUI_EFFECT_SCALE, GUI_EFFECT_SCALE, 0, c_white, 1);
		
		_sprite = _data.sprite;
		
		draw_sprite_ext(_sprite == -1 ? spr_Null : _sprite, 0, _x, _y, GUI_EFFECT_SCALE, GUI_EFFECT_SCALE, 0, c_white, 1);
		
		#endregion
		
		#region Draw Time
		
		_seconds = _timer / _tick;
		
		draw_set_halign(fa_center);
		
		_time = $"{floor(_seconds / 60)}:{ceil(_seconds % 60)}";
		
		draw_text_transformed(_x + GUI_EFFECT_TEXT_XOFFSET, _y + GUI_EFFECT_TEXT_YOFFSET + (__effect_height * GUI_EFFECT_SCALE / 2), _time, GUI_EFFECT_TEXT_SCALE, GUI_EFFECT_TEXT_SCALE, 0);
		
		if (point_in_rectangle(_mx, _my, _x - GUI_EFFECT_HOVER_OFFSET, _y - GUI_EFFECT_HOVER_OFFSET, _x + GUI_EFFECT_HOVER_OFFSET, _y + GUI_EFFECT_HOVER_OFFSET))
		{
			draw_set_halign(fa_left);
			
			draw_text(_mx, _my, $"{_data.name} {_effect.level} ({_time})");
		}
		
		#endregion
	}
}