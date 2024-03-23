function load_inventory()
{
	global.inventory_instances = {
		base:              array_create(INVENTORY_SIZE.BASE, INVENTORY_EMPTY),
		armor_helmet:      array_create(1, INVENTORY_EMPTY),
		armor_breastplate: array_create(1, INVENTORY_EMPTY),
		armor_leggings:    array_create(1, INVENTORY_EMPTY),
		accessory:         array_create(INVENTORY_SIZE.ACCESSORIES, INVENTORY_EMPTY),
		container:         [],
		craftable:         []
	};
	
	var _inventory_instances = global.inventory_instances;

	var _camera = global.camera;

	var _gui_width  = _camera.gui_width;
	var _gui_height = _camera.gui_height;

	var _inventory = global.inventory;
	var _i;

	var _inventory_name;
	var _inventory_names = struct_get_names(_inventory);
	var _inventory_names_length = array_length(_inventory_names);

	var _inventory_length;

	var _inst;
	var _xoffset;
	var _yoffset;
	var _index;
	var _slot_type;

	var i = 0;
	var j;

	repeat (_inventory_names_length)
	{
		_inventory_name = _inventory_names[i++];
		_i = _inventory_instances[$ _inventory_name];
		
		_inventory_length = array_length(_i);
	
		j = 0;
	
		repeat (_inventory_length)
		{
			_xoffset = 0;
			_yoffset = 0;
		
			_index = 0;
		
			if (_inventory_name == "base")
			{
				_xoffset = GUI_SAFE_ZONE_X + ((j % INVENTORY_SIZE.ROW) * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_WIDTH);
				_yoffset = GUI_SAFE_ZONE_Y + (floor(j / INVENTORY_SIZE.ROW) * INVENTORY_SLOT_SCALE * INVENTORY_SLOT_HEIGHT);
	
				if (j >= INVENTORY_SIZE.ROW)
				{
					#macro INVENTORY_BACKPACK_XOFFSET 0
					#macro INVENTORY_BACKPACK_YOFFSET 16
		
					_xoffset += INVENTORY_BACKPACK_XOFFSET;
					_yoffset += INVENTORY_BACKPACK_YOFFSET;
				}
			
				_index = 2;
				_slot_type = SLOT_TYPE.BASE;
			}
			else if (_inventory_name == "armor_helmet")
			{
				_xoffset = _gui_width  - GUI_SAFE_ZONE_X - (INVENTORY_SLOT_WIDTH  * INVENTORY_SLOT_SCALE * 2) - (1 * INVENTORY_SLOT_SCALE);
				_yoffset = _gui_height - GUI_SAFE_ZONE_Y - (INVENTORY_SLOT_HEIGHT * INVENTORY_SLOT_SCALE * 3);
			
				_index = 3;
				_slot_type = SLOT_TYPE.ARMOR_HELMET;
			}
			else if (_inventory_name == "armor_breastplate")
			{
				_xoffset = _gui_width  - GUI_SAFE_ZONE_X - (INVENTORY_SLOT_WIDTH  * INVENTORY_SLOT_SCALE * 2) - (1 * INVENTORY_SLOT_SCALE);
				_yoffset = _gui_height - GUI_SAFE_ZONE_Y - (INVENTORY_SLOT_HEIGHT * INVENTORY_SLOT_SCALE * 2);
			
				_index = 4;
				_slot_type = SLOT_TYPE.ARMOR_BREASTPLATE;
		
			}
			else if (_inventory_name == "armor_leggings")
			{
				_xoffset = _gui_width  - GUI_SAFE_ZONE_X - (INVENTORY_SLOT_WIDTH  * INVENTORY_SLOT_SCALE * 2) - (1 * INVENTORY_SLOT_SCALE);
				_yoffset = _gui_height - GUI_SAFE_ZONE_Y - (INVENTORY_SLOT_HEIGHT * INVENTORY_SLOT_SCALE * 1);
			
				_index = 5;
				_slot_type = SLOT_TYPE.ARMOR_LEGGINGS;
			}
			else if (_inventory_name == "accessory")
			{
				_xoffset = _gui_width  - GUI_SAFE_ZONE_X - (INVENTORY_SLOT_WIDTH  * INVENTORY_SLOT_SCALE);
				_yoffset = _gui_height - GUI_SAFE_ZONE_Y - (INVENTORY_SLOT_HEIGHT * INVENTORY_SLOT_SCALE * (j + 1));
			
				_index = 6;
				_slot_type = SLOT_TYPE.ACCESSORY;
			}
		
			_inst = instance_create_layer(0, 0, "Instances", obj_Inventory, {
				xoffset: _xoffset,
				yoffset: _yoffset,
				
				inventory_placement: j,
			
				type: _inventory_name,
				slot_type: _slot_type,
			
				sprite: gui_Slot_Inventory,
			
				background_index: _index,
				background_alpha: 0.95
			});
		
			global.inventory_instances[$ _inventory_name][@ j] = _inst;
		
			instance_deactivate_object(_inst);
		
			++j;
		}
	}
}