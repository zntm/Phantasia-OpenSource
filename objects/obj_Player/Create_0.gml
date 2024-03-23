whip_damage = 0;
whip_sprite = -1;

animation_frame = 0;

var _player = global.player;
var _uuid = _player.uuid;

name = _player.name;
uuid = _uuid;

entity_init(_player.hp, _player.hp_max, light_get_offset(-74, -82, -90));

moved = false;

dead_timer = 0;

jump_count   = 0;
jump_pressed = 0;

dash_timer  = 0;
dash_facing = 0;
dash_speed  = 0;

coyote_time = 0;

mining_current = 0;
mining_current_fixed = 0;

mine_position_x = 0;
mine_position_y = 0;
mine_position_z = 0;

is_mining = false;
is_climbing = false;

#macro COOLDOWN_MAX_BUILD 8
#macro COOLDOWN_MAX_DASH 16

global.sequence_whips = -1;

cooldown_build = 0;
cooldown_projectile = 0;

parts = {};

array_foreach(global.attire_elements, function(_value, _index)
{
	#region Setup Data
	
	var _data = global.player.parts[$ _value];
	
	if (_value == "base_body")
	{
		var _colour = _data.colour;
		
		parts.base_body = {
			colour: _colour,
			sprite_colour: att_Base_Body,
			sprite_white: -1,
			surface: -1
		};
	
		parts.base_left_arm = {
			colour: _colour,
			sprite_colour: att_Base_Arm_Left,
			sprite_white: -1,
			surface: -1
		};
		
		parts.base_right_arm = {
			colour: _colour,
			sprite_colour: att_Base_Arm_Right,
			sprite_white: -1,
			surface: -1
		};
		
		parts.base_legs = {
			colour: _colour,
			sprite_colour: att_Base_Legs,
			sprite_white: -1,
			surface: -1
		};
		
		exit;
	}
	
	if (_data == -1)
	{
		parts[$ _value] = -1;
			
		exit;
	}
		
	var _attire = global.attire_data[$ _value][_data.index];
		
	parts[$ _value] = (_attire == -1 ? -1 : {
		index: _data.index,
		colour: _data.colour,
		sprite_colour: _attire.colour,
		sprite_white: _attire.white,
		surface: -1,
	});
			
	var i = _attire[$ "colour2"];
			
	if (i != undefined)
	{
		parts[$ _value].sprite_colour2 = i;
	}
			
	i = _attire[$ "colour3"];
			
	if (i != undefined)
	{
		parts[$ _value].sprite_colour3 = i;
	}
	
	#endregion
});

#region Inventory

global.inventory = {
	base:              array_create(INVENTORY_SIZE.BASE, INVENTORY_EMPTY),
	armor_helmet:      array_create(1, INVENTORY_EMPTY),
	armor_breastplate: array_create(1, INVENTORY_EMPTY),
	armor_leggings:    array_create(1, INVENTORY_EMPTY),
	accessory:         array_create(INVENTORY_SIZE.ACCESSORIES, INVENTORY_EMPTY),
	container:         [],
	craftable:         []
};

if (directory_exists($"{DIRECTORY_DATA_PLAYER}/{_uuid}/Inventory"))
{
	var _inventory = global.inventory;
	var _item_data = global.item_data;
	
	var _name;
	
	var _buffer;
	var _buffer2;
	
	var i = 0;
	
	var _u;
	var _v;
	
	var _item_id;
	var _index;
	var _index_offset;
	
	var _type;
	
	var _file = file_find_first($"{DIRECTORY_DATA_PLAYER}/{_uuid}/Inventory/*", fa_directory);
	
	while (_file != "")
	{
		_name = string_replace(_file, ".dat", "");
		
		_buffer = buffer_load($"{DIRECTORY_DATA_PLAYER}/{_uuid}/Inventory/{_file}");
		_buffer2 = buffer_decompress(_buffer);
		
		_u = array_length(_inventory[$ _name]);
		
		i = 0;
		
		repeat (_u)
		{
			_v = buffer_read(_buffer2, buffer_u64);
			
			if (_v == 0xffff)
			{
				global.inventory[$ _name][@ i++] = INVENTORY_EMPTY;
				
				continue;
			}
			
			_item_id = _v & 0xffff;
			_index = (_v >> 40) & 0xff;
			_index_offset = (_v >> 32) & 0xff;
			
			_type = _item_data[_item_id].type;
			
			global.inventory[$ _name][@ i] = {
				item_id: _v & 0xffff,
				amount: (_v >> 16) & 0xffff,
				index: ((_index & 0x80) ? -(_index & 0x7f) : (_index & 0x7f)),
				index_offset: ((_index_offset & 0x80) ? -(_index_offset & 0x7f) : (_index_offset & 0x7f))
			};
			
			if (_type & (ITEM_TYPE.SWORD | ITEM_TYPE.PICKAXE | ITEM_TYPE.AXE | ITEM_TYPE.SHOVEL | ITEM_TYPE.HAMMER | ITEM_TYPE.WHIP | ITEM_TYPE.BOW | ITEM_TYPE.FISHING_POLE))
			{
				global.inventory[$ _name][@ i].durability = _v >> 48;
			}
			
			if (_type & (ITEM_TYPE.SWORD | ITEM_TYPE.PICKAXE | ITEM_TYPE.AXE | ITEM_TYPE.SHOVEL | ITEM_TYPE.HAMMER | ITEM_TYPE.WHIP | ITEM_TYPE.BOW))
			{
				global.inventory[$ _name][@ i].acclimation = buffer_read(_buffer2, buffer_u16);
			}
			
			++i;
		}
		
		buffer_delete(_buffer);
		buffer_delete(_buffer2);
		
		_file = file_find_next();
	}
}

#endregion