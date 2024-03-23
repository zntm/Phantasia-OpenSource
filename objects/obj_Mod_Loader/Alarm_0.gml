/*
if (index >= array_length(mods))
{
	room_goto(global.settings.general.skip_warning.value ? menu_Main : rm_Warning);
	
	exit;
}

var _items = [];
var _creatures = [];

var _mod = mods[index];

// show_debug_message($"Loading Mod: '{_mod}'");

var _location;

var _file;
var _data;
var _string;

var _json;

var _item_type;
var _item_types;

var _type;
var _type_current;

var _creature_type;

#region Items

try
{
	var _items_location = $"{DIRECTORY_DATA_ADDON}/{_mod}/Items";
	
	var _item = file_find_first($"{_items_location}/*", fa_directory);
	var _item_length = 0;
	
	while (_item != "")
	{
		_location = $"{_items_location}/{_item}";
		
		#region Load data.json
		
		_file = file_text_open_read($"{_location}/data.json");
		_data = "";
		_string = -1;
		
		while (_string != "")
		{
			_string = file_text_read_string(_file);
			
			_data += _string;
			
			file_text_readln(_file);
		}
		
		_json = json_parse(_data);
		
		file_text_close(_file);
		
		#endregion
		
		#region Item Types
		
		_type = _json.type;
		
		if (typeof(_type) != "array")
		{
			_type = [ _type ];
		}
		
		_item_type = 0;
		
		var j = 0;
		
		var _length = array_length(_type);
		
		repeat (_length)
		{
			_type_current = _type[j++];
			
			switch (string_lower(_type_current))
			{
				
			case "default":
				_item_type = _item_type | ITEM_TYPE.DEFAULT;
				break;
					
			case "accessory":
				_item_type = _item_type | ITEM_TYPE.ACCESSORY;
				break;
				
			case "armor_helmet":
				_item_type = _item_type | ITEM_TYPE.ARMOR_HELMET;
				break;
				
			case "armor_breastplate":
				_item_type = _item_type | ITEM_TYPE.ARMOR_BREASTPLATE;
				break;
				
			case "armor_leggings":
				_item_type = _item_type | ITEM_TYPE.ARMOR_LEGGINGS;
				break;
				
			case "axe":
				_item_type = _item_type | ITEM_TYPE.AXE;
				break;
				
			case "bow":
				_item_type = _item_type | ITEM_TYPE.BOW;
				break;
				
			case "container":
				_item_type = _item_type | ITEM_TYPE.CONTAINER;
				break;
				
			case "deployable":
				_item_type = _item_type | ITEM_TYPE.DEPLOYABLE;
				break;
				
			case "fishing_pole":
				_item_type = _item_type | ITEM_TYPE.FISHING_POLE;
				break;
				
			case "consumable":
				_item_type = _item_type | ITEM_TYPE.CONSUMABLE;
				break;
				
			case "hammer":
				_item_type = _item_type | ITEM_TYPE.HAMMER;
				break;
				
			case "liquid":
				_item_type = _item_type | ITEM_TYPE.LIQUID;
				break;
				
			case "pickaxe":
				_item_type = _item_type | ITEM_TYPE.PICKAXE;
				break;
				
			case "plant":
				_item_type = _item_type | ITEM_TYPE.PLANT;
				break;
				
			case "shovel":
				_item_type = _item_type | ITEM_TYPE.SHOVEL;
				break;
				
			case "solid":
				_item_type = _item_type | ITEM_TYPE.SOLID;
				break;
				
			case "sword":
				_item_type = _item_type | ITEM_TYPE.SWORD;
				break;
				
			case "throwable":
				_item_type = _item_type | ITEM_TYPE.THROWABLE;
				break;
				
			case "tool":
				_item_type = _item_type | ITEM_TYPE.TOOL;
				break;
				
			case "untouchable":
				_item_type = _item_type | ITEM_TYPE.UNTOUCHABLE;
				break;
				
			case "wall":
				_item_type = _item_type | ITEM_TYPE.WALL;
				break;
				
			case "whip":
				_item_type = _item_type | ITEM_TYPE.WHIP;
				break;
			
			default:
				throw $"Item '{_json.name}' has an invalid item type ({_type_current})";
				
			}
		}
		
		#endregion
		
		var _sprite = _json.sprite;
		var _sprite_location = $"{_location}/sprite.png";
		
		var _origin = _sprite.origin;
		
		var _item_data = new ItemData(_item, (file_exists(_sprite_location) ? sprite_add(_sprite_location, _sprite.frame_amount, false, false, _origin[0], _origin[1]) : spr_Null), _item_types)
			.set_description(_json.description ?? "")
			.set_damage(_json.damage ?? 1);
		
		_item_data.type = _item_type;
	
		if (_json.inventory_max != undefined)
		{
			_item_data.set_inventory_max(_json.inventory_max);
		}
	
		if (_json.inventory_scale != undefined)
		{
			_item_data.set_inventory_max(_json.inventory_scale);
		}
		
		if (_item_types & ITEM_TYPE.CONTAINER)
		{
			var _container_size = _json.container_size;
			
			if (_container_size != undefined)
			{
				_item_data.set_container_size(min(2, floor(real(_container_size))));
			}
		}
	
		array_push(_items, _item_data);
	
		// show_debug_message($"- Item Loaded: '{_item}'\nData: {_item_data}");
	
		_item = file_find_next();
		
		++_item_length;
	}

	file_find_close();

	#endregion

	#region Creatures
	
	var _creatures_location = $"{DIRECTORY_DATA_ADDON}/{_mod}/Creatures";
	
	var _creature = file_find_first($"{_creatures_location}/*", fa_directory);
	var _creature_length = 0;
	
	while (_creature != "")
	{
		_location = $"{_creatures_location}/{_creature}";
		
		#region Load data.json
		
		_file = file_text_open_read($"{_location}/data.json");
		_data = "";
		_string = -1;
		
		while (_string != "")
		{
			_string = file_text_read_string(_file);
			
			_data += _string;
			
			file_text_readln(_file);
		}
		
		_json = json_parse(_data);
		
		file_text_close(_file);
		
		#endregion
	
		_type = _json.type;
	
		switch (string_lower(_type))
		{
	
		case "passive":
			_creature_type = CREATURE_HOSTILITY_TYPE.PASSIVE;
			break;
	
		case "hostile":
			_creature_type = CREATURE_HOSTILITY_TYPE.HOSTILE;
			break;
		
		default:
			throw $"Creature '{_json.name}' does not have a valid type ({_type})";
	
		}
		
		var _creature_data = new CreatureData(_creature, _creature_type, _json.hp);
		
		var _idle_location = $"{_location}/sprite_idle.png";
		var _moving_location = $"{_location}/sprite_moving.png";
		
		if (file_exists(_idle_location)) && (file_exists(_moving_location))
		{
			var _idle = _json.sprite.idle;
			var _idle_origin = _idle.origin;
			var _idle_sprite = sprite_add(_idle_location, _idle.frame_amount, false, false, _idle_origin[0], _idle_origin[1]);
		
			var _moving = _json.sprite.moving;
			var _moving_origin = _moving.origin;
			var _moving_sprite = sprite_add(_moving_location, _moving.frame_amount, false, false, _moving_origin[0], _moving_origin[1]);
		
			_creature_data.set_sprite(_idle_sprite, _moving_sprite);
		}
		else
		{
			_creature_data.set_sprite(spr_Null, spr_Null);
		}
	
		array_push(_creatures, _creature_data);
	
		// show_debug_message($"- Creature Loaded: '{_creature}'\nData:{_creature_data}");
		
		_creature = file_find_next();
		
		++_creature_length;
	}
	
	// show_debug_message($"Pushing Mod: '{_mod}'");
	
	var i = 0;
	
	repeat (_item_length)
	{
		array_push(global.item_data, _items[i++]);
	}
	
	i = 0;

	repeat (_creature_length)
	{
		array_push(global.creature_data, _creatures[i++]);
	}
	
	// show_debug_message($"Finished Loading Mod: '{_mod}'\n- {_item_length} Items Loaded\n- {_creature_length} Creatures Loaded");
}
catch (error)
{
	// show_debug_message($"Error Loading Mod: '{_mod}'\nError: {error}");
}

file_find_close();

#endregion

++index;

alarm[0] = 1;