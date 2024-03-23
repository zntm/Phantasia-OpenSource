placeholder = loca_translate("menu.item.structure_block.file_name");

on_update = function()
{	
	var _tile = global.menu_tile;
	
	tile_set(_tile.x, _tile.y, _tile.z, "variable.file_name", text);
}