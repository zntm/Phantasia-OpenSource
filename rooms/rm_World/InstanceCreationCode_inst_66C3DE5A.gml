placeholder = loca_translate("menu.item.structure_block.y_size");

on_update = function()
{
	var _digits = string_digits(text);
	var _scale = (string_length(_digits) > 0 && (text == _digits || text == "-" + _digits) ? real(text) : 1);
	
	with (global.menu_inst)
	{
		image_yscale = _scale;
		
		y = (position_y * TILE_SIZE) + (_scale * TILE_SIZE / 2) - (TILE_SIZE / 2);
	}
	
	var _tile = global.menu_tile;
	
	tile_set(_tile.x, _tile.y, _tile.z, "variable.ysize", _scale);
}