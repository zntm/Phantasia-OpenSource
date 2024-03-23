placeholder = loca_translate("menu.item.structure_block.structure_x_offset");

on_update = function()
{
	var _digits = string_digits(text);
	var _offset = (string_length(_digits) > 0 && (text == _digits || text == "-" + _digits) ? real(text) : 0);
	
	if (string_length(_digits) > 0)
	{
		text = string(_offset);
	}
	
	with (global.menu_inst)
	{
		x = (position_x * TILE_SIZE) + (image_xscale * TILE_SIZE / 2) - (TILE_SIZE / 2) + (_offset * TILE_SIZE);
	}
	
	var _tile = global.menu_tile;
	
	tile_set(_tile.x, _tile.y, _tile.z, "variable.xoffset", _offset);
}