function tile_instance_create(_x, _y, _z, _tile)
{
	var _item_id = _tile.item_id;
	var _data    = global.item_data[_item_id];
	
	var _colour_offset_bloom = _data.colour_offset_bloom;
		
	if (_colour_offset_bloom != -1)
	{
		with (instance_create_layer(_x * TILE_SIZE, _y * TILE_SIZE, "Instances", obj_Tile_Light))
		{
			sprite_index = _data.sprite;
			
			position_x = _x;
			position_y = _y;
			position_z = _z;
			
			colour_offset = _colour_offset_bloom >> 24;
			bloom = _colour_offset_bloom & 0xffffff;
		}
	}
	
	if (array_contains(global.item_stations, _item_id))
	{
		with (instance_create_layer(_x * TILE_SIZE, _y * TILE_SIZE, "Instances", obj_Tile_Station))
		{
			sprite_index = _data.sprite;
			
			position_x = _x;
			position_y = _y;
			position_z = _z;
			
			item_id = _item_id;
		}
	}
		
	var _instance = _data.instance;
		
	if (_instance != -1)
	{
		with (instance_create_layer(_x * TILE_SIZE, _y * TILE_SIZE, "Instances", obj_Tile_Instance))
		{
			sprite_index = _data.sprite;
			
			position_x = _x;
			position_y = _y;
			position_z = _z;
			
			on_draw = _instance.on_draw;
		}
	}
		
	if (_data.type & ITEM_TYPE.CONTAINER)
	{
		with (instance_create_layer(_x * TILE_SIZE, _y * TILE_SIZE, "Instances", obj_Tile_Container))
		{
			sprite_index = _data.sprite;
			
			position_x = _x;
			position_y = _y;
			position_z = _z;
			
			item_id = _item_id;
		}
	}
}