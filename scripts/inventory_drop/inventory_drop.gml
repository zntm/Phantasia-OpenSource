#macro INVENTORY_DROP_XVELOCITY 6
#macro INVENTORY_DROP_YVELOCITY 3

function inventory_drop()
{
	var _inventory_selected_hotbar = global.inventory_selected_hotbar;
	var _holding = global.inventory.base[_inventory_selected_hotbar];
	
	if (_holding == INVENTORY_EMPTY) exit;
	
	if (keyboard_check(vk_shift))
	{
		spawn_drop(x, y - TILE_SIZE, _holding.item_id, _holding.amount, image_xscale * INVENTORY_DROP_XVELOCITY, sign(image_xscale), -INVENTORY_DROP_YVELOCITY, 180,, _holding.index, _holding.index_offset, _holding[$ "durability"], _holding[$ "acclimation"]);
			
		global.inventory.base[@ _inventory_selected_hotbar] = INVENTORY_EMPTY;
			
		exit;
	}
		
	spawn_drop(x, y - TILE_SIZE, _holding.item_id, 1, image_xscale * INVENTORY_DROP_XVELOCITY, sign(image_xscale), -INVENTORY_DROP_YVELOCITY,,, _holding.index, _holding.index_offset, _holding[$ "durability"], _holding[$ "acclimation"]);
			
	if (--global.inventory.base[_inventory_selected_hotbar].amount <= 0)
	{
		global.inventory.base[@ _inventory_selected_hotbar] = INVENTORY_EMPTY;
	}
}