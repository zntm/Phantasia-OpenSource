#macro MENU_BACKGROUND_PARALLAX_AMOUNT 2
#macro MENU_BACKGROUND_SCALE 1

var _data = global.surface_biome_data[biome];

draw_sprite_ext(spr_Square, 0, 0, 0, room_width, room_height, 0, _data.sky_colour.solid[DIURNAL.DAY], 1);

if (!DEV_DRAW_BACKGROUND) || (!global.settings.graphics.background.value) exit;

if (type == MENU_BACKGROUND_TYPE.DEFAULT)
{
	var _backgrounds = _data.background;
	var _length = array_length(_backgrounds);
	
	var i = 0;
	
	repeat (_length)
	{
		var _background = _backgrounds[i];
			
		var _width = sprite_get_width(_background);
		var _offset = (timer / 10 * i++) % _width;
			
		var j = -MENU_BACKGROUND_PARALLAX_AMOUNT;
			
		repeat ((MENU_BACKGROUND_PARALLAX_AMOUNT * 2) + 1)
		{
			draw_sprite_ext(_background, 0, ((j++ * _width) + _offset) * MENU_BACKGROUND_SCALE, room_height, MENU_BACKGROUND_SCALE, MENU_BACKGROUND_SCALE, 0, c_white, 1);
		}
	}
}
else if (type == MENU_BACKGROUND_TYPE.SCROLLING)
{
	#macro MENU_BACKGROUND_SCROLLING_SCALE 2
	#macro MENU_BACKGROUND_SCROLLING_TILE_SCALE (TILE_SIZE * MENU_BACKGROUND_SCROLLING_SCALE)
	
	var _yoffset = (timer * 0.1) % MENU_BACKGROUND_SCROLLING_TILE_SCALE;
	
	var i = -1;
	
	repeat (40 / MENU_BACKGROUND_SCROLLING_SCALE)
	{
		var _y = _yoffset + (i * MENU_BACKGROUND_SCROLLING_TILE_SCALE);
		
		var j = 0;
		
		repeat (64 / MENU_BACKGROUND_SCROLLING_SCALE)
		{
			draw_sprite_ext(spr_Menu_Background, 16, j * MENU_BACKGROUND_SCROLLING_TILE_SCALE, _y, MENU_BACKGROUND_SCROLLING_SCALE, MENU_BACKGROUND_SCROLLING_SCALE, 0, #222222, 1);
			
			++j;
		}
		
		++i;
	}
}

timer += global.delta_time;