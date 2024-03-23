enum ITEM_TYPE {
	DEFAULT           = 0,
	SOLID             = 1,
	UNTOUCHABLE       = 1 << 1,
	CONTAINER         = 1 << 2,
	PLANT             = 1 << 3,
	WALL              = 1 << 4,
	LIQUID            = 1 << 5,
	CLIMBABLE         = 1 << 6,
	DEPLOYABLE        = 1 << 7,
	CONSUMABLE        = 1 << 8,
	ARMOR_HELMET      = 1 << 9,
	ARMOR_BREASTPLATE = 1 << 10,
	ARMOR_LEGGINGS    = 1 << 11,
	ACCESSORY         = 1 << 12,
	THROWABLE         = 1 << 13,
	SWORD             = 1 << 14,
	PICKAXE           = 1 << 15,
	AXE               = 1 << 16,
	SHOVEL            = 1 << 17,
	HAMMER            = 1 << 18,
	BOW               = 1 << 19,
	FISHING_POLE      = 1 << 20,
	WHIP              = 1 << 21,
	TOOL              = 1 << 22,
	AMMO              = 1 << 23,
	MENU              = 1 << 24,
	CRAFTING_STATION  = 1 << 25
}

enum AMMO_TYPE {
	BOW,
	BULLET,
	EGG,
	SNOWBALL
}

enum TOOL_POWER {
	ALL,
	WOOD,
	COPPER,
	IRON,
	GOLD,
	PLATINUM
}

function ItemData(_sprite, _type = ITEM_TYPE.DEFAULT) constructor
{
	name = string_lower(string_delete(sprite_get_name(_sprite), 1, 5));
	sprite = _sprite;
	type = 0;
	
	var i = 1;
	
	repeat (argument_count - 1)
	{
		type = type | argument[i++];
	}
	
	#region Inventory
	
	// 0xffff_ff_ff_ff - first 16 bits are max amount, next 8 bits are scale, next 8 bits are min index, last 8 bits are max index
	inventory_max_scale_index = (999 << 24) | (15 << 16);
	
	static set_inventory_max = function(_max)
	{
		inventory_max_scale_index = (_max << 24) | (inventory_max_scale_index & 0x0000_ff_ff_ff);
		
		return self;
	}
	
	static get_inventory_max = function()
	{
		return inventory_max_scale_index >> 24;
	}
	
	static set_inventory_scale = function(_scale)
	{
		inventory_max_scale_index = ((_scale * 10) << 16) | (inventory_max_scale_index & 0xffff_00_ff_ff);
		
		return self;
	}
	
	static get_inventory_scale = function()
	{
		return ((inventory_max_scale_index >> 16) & 0xff) / 10;
	}
	
	static set_inventory_index = function(_min, _max)
	{
		inventory_max_scale_index = (inventory_max_scale_index & 0xffff_ff_00_00) | (_min << 8) | _max;
		
		return self;
	}
	
	static get_inventory_index = function()
	{
		return irandom_range((inventory_max_scale_index >> 8) & 0xff, inventory_max_scale_index & 0xff);
	}
	
	enum SLOT_TYPE {
		BASE              = 1,
		CONTAINER         = 1 << 1,
		CRAFTABLE         = 1 << 2,
		ARMOR_HELMET      = 1 << 3,
		ARMOR_BREASTPLATE = 1 << 4,
		ARMOR_LEGGINGS    = 1 << 5,
		ACCESSORY         = 1 << 6
	}
	
	// 0xff_ff_ff_ff_ff
	width_height_swing_speed_index_offset_slot_valid = (sprite_get_width(_sprite) << 32) | (sprite_get_height(_sprite) << 24) | (0 << 8) | (SLOT_TYPE.BASE | SLOT_TYPE.CONTAINER);
	
	static set_index_offset = function(_index)
	{
		width_height_swing_speed_index_offset_slot_valid = ((((_index < 0) << 7) | abs(_index)) << 8) | (width_height_swing_speed_index_offset_slot_valid & 0xffffff00ff);
		
		return self;
	}
	
	static get_index_offset = function()
	{
		var _index_offset = (width_height_swing_speed_index_offset_slot_valid >> 8) & 0xff;
		
		return ((_index_offset & 0x80) ? -(_index_offset & 0x7f) : (_index_offset & 0x7f));
	}
	
	static add_slot_valid = function(_slots)
	{
		width_height_swing_speed_index_offset_slot_valid = width_height_swing_speed_index_offset_slot_valid | _slots;
		
		return self;
	}
	
	static set_slot_valid = function(_slots)
	{
		width_height_swing_speed_index_offset_slot_valid = (width_height_swing_speed_index_offset_slot_valid & 0xffffffff00) | _slots;
		
		return self;
	}
	
	static get_slot_valid = function()
	{
		return width_height_swing_speed_index_offset_slot_valid & 0xff;
	}
	
	static set_swing_speed = function(_speed)
	{
		width_height_swing_speed_index_offset_slot_valid = (_speed << 16) | (width_height_swing_speed_index_offset_slot_valid & 0xffff00ffff);
		
		return self;
	}
	
	static get_swing_speed = function()
	{
		return (width_height_swing_speed_index_offset_slot_valid >> 16) & 0xff;
	}
	
	static get_sprite_width = function()
	{
		return width_height_swing_speed_index_offset_slot_valid >> 32;
	}
	
	static get_sprite_height = function()
	{
		return (width_height_swing_speed_index_offset_slot_valid >> 24) & 0xff;
	}
	
	#endregion
	
	enum DAMAGE_TYPE {
		DEFAULT,
		MELEE,
		RANGED,
		MAGIC,
		BLAST,
		FALL,
		FIRE
	}
	
	// 0xff_f_fff - first 8 bits are critical chance, second 4 bits are the damage type, last 12 bits are for damage
	damage = (5 << 16) | (DAMAGE_TYPE.DEFAULT << 8) | 1;
		
	static set_damage = function(_damage = -1, _damage_type = -1, _critical_chance = -1)
	{
		if (_damage != -1)
		{
			damage = (damage & 0xffff00) | _damage;
		}
		
		if (_damage_type != -1)
		{
			damage = (_damage_type << 8) | (damage & 0xff0fff);
		}
		
		if (_critical_chance != -1)
		{
			damage = (round(_critical_chance * 100) << 16) | (damage & 0x00ffff);
		}
		
		return self;
	}
		
	static get_damage = function()
	{
		return damage & 0xff;
	}
		
	static get_damage_type = function()
	{
		return (damage >> 8) & 0xff;
	}
		
	static get_damage_critical_chance = function()
	{
		return damage >> 16;
	}
	
	on_swing_interact = -1;
	
	static set_on_swing_interact = function(_function)
	{
		on_swing_interact = _function;
		
		return self;
	}
	
	on_swing_attack = -1;
	
	static set_on_swing_attack = function(_function)
	{
		on_swing_attack = _function;
		
		return self;
	}
	
	on_interaction_inventory = -1;
	
	static set_on_interaction_inventory = function(_function)
	{
		on_interaction_inventory = _function;
		
		return self;
	}
	
	variable = -1;
		
	static set_variable = function(_variable)
	{
		variable = _variable;
			
		return self;
	}
	
	if (type & (ITEM_TYPE.ARMOR_HELMET | ITEM_TYPE.ARMOR_BREASTPLATE | ITEM_TYPE.ARMOR_LEGGINGS | ITEM_TYPE.ACCESSORY))
	{
		inventory_max = 1;
		
		if (type & ITEM_TYPE.ARMOR_HELMET)
		{
			add_slot_valid(SLOT_TYPE.ARMOR_HELMET);
		}
		else if (type & ITEM_TYPE.ARMOR_BREASTPLATE)
		{
			add_slot_valid(SLOT_TYPE.ARMOR_BREASTPLATE);
		}
		else if (type & ITEM_TYPE.ARMOR_LEGGINGS)
		{
			add_slot_valid(SLOT_TYPE.ARMOR_LEGGINGS);
		}
		else if (type & ITEM_TYPE.ACCESSORY)
		{
			add_slot_valid(SLOT_TYPE.ACCESSORY);
		}
		
		buffs = {};
		
		static set_defense = function(_defense)
		{
			buffs.defense = _defense;
			
			return self;
		}
			
		static set_buff = function(_type, _val)
		{
			buffs[$ _type] = _val;
				
			// var _data = global.effect_data[$ _type];
				
			// description = $"{_data.icon}" + $"\{#40D93B\}" + $"{(_val >= 0 ? "+" : "-")}" + $"{(_data ? (string(abs(_val) * 100) + "%") : abs(_val))} {_data.name}\{#FFFFFF\}\n{description}";
				
			return self;
		}
	}
	
	static set_mining_stats = function(_v1 = undefined, _v2 = undefined, _v3 = undefined)
	{
		if (type & (ITEM_TYPE.PICKAXE | ITEM_TYPE.AXE | ITEM_TYPE.SHOVEL | ITEM_TYPE.HAMMER))
		{
			mining_stats = ((_v1 ?? TOOL_POWER.ALL) << 8) | (_v2 ?? 1);
		}
		else
		{
			mining_stats = ((_v1 ?? ITEM_TYPE.DEFAULT) << 24) | ((_v2 ?? TOOL_POWER.ALL) << 16) | round(GAME_FPS * (_v3 ?? 1));
		}
			
		return self;
	}
	
	static get_mining_amount = function()
	{
		return mining_stats & 0xffff;
	}
	
	static get_mining_speed = function()
	{
		return mining_stats & 0xff;
	}
	
	static get_mining_power = function()
	{
		if (type & (ITEM_TYPE.PICKAXE | ITEM_TYPE.AXE | ITEM_TYPE.SHOVEL | ITEM_TYPE.HAMMER))
		{
			return mining_stats >> 8;
		}
		
		return (mining_stats >> 16) & 0xff;
	}
	
	static get_mining_type = function()
	{
		return mining_stats >> 24;
	}
	
	if (type & (ITEM_TYPE.PICKAXE | ITEM_TYPE.AXE | ITEM_TYPE.SHOVEL | ITEM_TYPE.HAMMER))
	{
		// 0xff_ff - first 8 bits are mining power, last 8 bits are mining speed
		mining_stats = (TOOL_POWER.ALL << 8) | 1;
	}
	
	static set_durability = function(_durability)
	{
		acclimation_amount_max_durability = (acclimation_amount_max_durability & 0xffffffff0000) | _durability;
				
		return self;
	}
	
	static set_acclimation = function(_amount, _max)
	{
		acclimation_amount_max_durability = (_amount << 32) | (_max << 16) | (acclimation_amount_max_durability & 0xffff);
				
		return self;
	}
		
	static get_acclimation_amount = function()
	{
		return acclimation_amount_max_durability >> 32;
	}
		
	static get_acclimation_max = function()
	{
		return (acclimation_amount_max_durability >> 16) & 0xffff;
	}
		
	static get_durability = function()
	{
		return acclimation_amount_max_durability & 0xffff;
	}
	
	if (type & (ITEM_TYPE.SWORD | ITEM_TYPE.PICKAXE | ITEM_TYPE.AXE | ITEM_TYPE.SHOVEL | ITEM_TYPE.HAMMER | ITEM_TYPE.WHIP))
	{
		set_inventory_scale(1);
		set_inventory_max(1);
			
		set_damage(, DAMAGE_TYPE.MELEE);
		
		// 0xffff_ffff_ffff
		acclimation_amount_max_durability = 100;
	}
	
	if (type & ITEM_TYPE.BOW)
	{
		set_inventory_scale(1);
		set_inventory_max(1);
			
		set_damage(, DAMAGE_TYPE.RANGED);
		
		ammo_type_cooldown = (AMMO_TYPE.BOW << 8) | 12;
			
		static set_ammo_type = function(_type)
		{
			ammo_type_cooldown = (_type << 8) | (ammo_type_cooldown & 0xff);
				
			return self;
		}
			
		static get_ammo_type = function()
		{
			return ammo_type_cooldown >> 8;
		}
		
		static set_cooldown = function(_cooldown)
		{
			ammo_type_cooldown = (ammo_type_cooldown & 0xff00) | _cooldown;
			
			return self;
		}
		
		static get_cooldown = function()
		{
			return ammo_type_cooldown & 0xff;
		}
		
		acclimation_amount_max_durability = 100;
	}
	
	if (type & ITEM_TYPE.FISHING_POLE)
	{
		set_inventory_scale(1);
		set_inventory_max(1);
			
		fishing_power = 1;
		
		static set_fishing_power = function(_power)
		{
			fishing_power = _power;
			
			return self;
		}
		
		acclimation_amount_max_durability = 100;
	}
	
	if (type & ITEM_TYPE.AMMO)
	{
		ammo_type = AMMO_TYPE.BOW;
			
		static set_ammo_type = function(_type)
		{
			ammo_type = _type;
				
			return self;
		}
	}
	
	if (type & ITEM_TYPE.THROWABLE)
	{
		set_damage(, DAMAGE_TYPE.RANGED);
		
		max_throw_multiplier = 1;
			
		static set_max_throw_multiplier = function(_strength = 1)
		{
			max_throw_multiplier = _strength;
				
			return self;
		}
			
		gravity_strength = 1;
			
		static set_gravity_strength = function(_multiplier = 1)
		{
			gravity_strength = _multiplier;
				
			return self;
		}
		
		rotation = 0;
			
		static set_rotation = function(_min, _max)
		{
			rotation = ((((_min < 0) << 11) | abs(_min)) << 12) | (((_max < 0) << 11) | abs(_max));
				
			return self;
		}
		
		static get_rotation = function()
		{
			var _r1 = rotation >> 12;
			var _r2 = rotation & 0xfff;
			
			return irandom_range(((_r1 & 0x800) < 0 ? -(_r1 & 0x7ff) : (_r1 & 0x7ff)), ((_r2 & 0x800) < 0 ? -(_r2 & 0x7ff) : (_r2 & 0x7ff)));
		}
		
		static get_min_rotation = function()
		{
			var _r = rotation >> 12;
			
			return ((_r & 0x800) < 0 ? -(_r & 0x7ff) : (_r & 0x7ff));
		}
		
		static get_max_rotation = function()
		{
			var _r = rotation & 0xfff;
			
			return ((_r & 0x800) < 0 ? -(_r & 0x7ff) : (_r & 0x7ff));
		}
	}
	
	if (type & ITEM_TYPE.DEPLOYABLE)
	{
		tile = ITEM.EMPTY;
		z = CHUNK_DEPTH_DEFAULT;
		
		static set_tile = function(_z, _tile)
		{
			tile = _tile;
			z = _z;
				
			return self;
		}
		
		give_back = ITEM.EMPTY;
		
		static set_give_back = function(_give_back)
		{
			give_back = _give_back;
			
			return self;
		}
	}
	
	if (type & ITEM_TYPE.CONSUMABLE)
	{
		on_consume = -1;
		on_consume_return = ITEM.EMPTY;
		
		static set_on_consume = function(_func, _return = ITEM.EMPTY)
		{
			on_consume = _func;
			on_consume_return = _return;
			
			return self;
		}
	}
	
	is_material = false;
	
	if (type & (ITEM_TYPE.SOLID | ITEM_TYPE.UNTOUCHABLE | ITEM_TYPE.WALL | ITEM_TYPE.PLANT | ITEM_TYPE.CONTAINER | ITEM_TYPE.LIQUID))
	{
		if (type & ITEM_TYPE.SOLID)
		{
			obstructing = true;
		
			static set_obstructing = function(_obstructing)
			{
				obstructing = _obstructing;
			
				return self;
			}
		}
		else if (type & ITEM_TYPE.WALL)
		{
			obstructable = true;
		
			static set_obstructable = function(_obstructable)
			{
				obstructable = _obstructable;
			
				return self;
			}
		}
		else if (type & ITEM_TYPE.CONTAINER)
		{
			container_size = 40;
			
			static set_container_size = function(_size)
			{
				container_size = _size;
				
				return self;
			}
			
			var _slot = asset_get_index($"gui_Slot_{string_replace_all(name, " ", "_")}");
			
			container_sprite = (_slot > -1 ? _slot : gui_Slot_Container);
			
			static set_container_sprite = function(_sprite)
			{
				container_sprite = _sprite;
				
				return self;
			}
			
			slot_type = SLOT_TYPE.CONTAINER;
			
			static set_slot_type = function(_type)
			{
				slot_type = _type;
				
				return self;
			}
		}
		
		place_requirement = -1;
			
		static set_place_requirement = function(_requirement)
		{
			place_requirement = _requirement;
				
			return self;
		}
		
		flip_on_random_index = (1 << 8) | 1;
		
		static set_flip_on = function(_x = false, _y = false)
		{
			flip_on_random_index = (_x << 17) | (_y << 16) | (flip_on_random_index & 0xffff);
		
			return self;
		}
		
		static set_random_frame = function(_min = 1, _max = 1)
		{
			flip_on_random_index = (flip_on_random_index & 0xf0000) | (_min << 8) | _max;
		
			return self;
		}
			
		// 0xffffffff_ff_ffff - first 8 bits are mining power, last 16 bits are mining speed
		mining_stats = (ITEM_TYPE.DEFAULT << 24) | (TOOL_POWER.ALL << 16) | 1;
			
		drops = ITEM.EMPTY;
	
		static set_drops = function(_drop)
		{
			if (argument_count == 1)
			{
				drops = _drop;
			}
			else
			{
				var i = 0;
				
				repeat (argument_count)
				{
					drops[@ i] = argument[i];
					
					++i;
				}
			}
		
			return self;
		}
			
		sfx = SFX.EMPTY;
	
		static set_sfx = function(_sfx)
		{
			sfx = _sfx;
		
			return self;
		}
		
		enum ANIMATION_TYPE {
			NONE              = 1,
			INCREMENT         = 1 << 1,
			DECREMENT         = 1 << 2,
			RANDOM            = 1 << 3,
			CONNECTED         = 1 << 4,
			CONNECTED_TO_SELF = 1 << 5
		}
			
		animation_type_index = (ANIMATION_TYPE.NONE << 16) | (1 << 8) | (sprite_get_number(_sprite) - 1);
			
		static set_animation_type = function(_type)
		{
			animation_type_index = (_type << 16) | (animation_type_index & 0xffff);
				
			return self;
		}
		
		static set_animation_index = function(_min = 1, _max = 1)
		{
			animation_type_index = (animation_type_index & 0xff0000) | (_min << 8) | _max;
				
			return self;
		}
			
		colour_offset_bloom = -1;
			
		static set_colour_offset = function(_r = 0, _g = 0, _b = 0)
		{
			colour_offset_bloom = (light_get_offset(_r, _g, _b) << 24) | (colour_offset_bloom & 0xffffff);
				
			return self;
		}
			
		static set_bloom = function(_r = 0, _g = 0, _b = 0)
		{
			colour_offset_bloom = (colour_offset_bloom & 0xffffff000000) | ((_b << 16) | (_g << 8) | _r);
				
			return self;
		}
		
		// 0x_0_00000000000_0_00000000000_0_00000000000_0_00000000000
		var _cb_l = sprite_get_xoffset(_sprite);
		var _cb_t = sprite_get_yoffset(_sprite);
		var _cb_r = sprite_get_bbox_right(_sprite);
		var _cb_b = sprite_get_bbox_bottom(_sprite);
	
		collision_box[@ 0] = ((((_cb_l < 0) << 11) | abs(_cb_l)) << 36) | ((((_cb_t < 0) << 11) | abs(_cb_t)) << 24) | ((((_cb_r < 0) << 11) | abs(_cb_r)) << 12) | (((_cb_b < 0) << 11) | abs(_cb_b));
	
		collision_box_length = 1;
	
		static add_collision_box = function(_left, _top, _right, _bottom)
		{
			collision_box[@ collision_box_length++] = ((((_left < 0) << 11) | abs(_left)) << 36) | ((((_top < 0) << 11) | abs(_top)) << 24) | ((((_right < 0) << 11) | abs(_right)) << 12) | (((_bottom < 0) << 11) | abs(_bottom));
		
			return self;
		}
	
		static set_collision_box = function(_index, _left, _top, _right, _bottom)
		{
			collision_box[@ _index] = ((((_left < 0) << 11) | abs(_left)) << 36) | ((((_top < 0) << 11) | abs(_top)) << 24) | ((((_right < 0) << 11) | abs(_right)) << 12) | (((_bottom < 0) << 11) | abs(_bottom));
		
			return self;
		}
	
		static get_collision_box_left = function(_index)
		{
			var _v = collision_box[_index] >> 36;
		
			return (_v & 0x800) ? -(_v & 0x7ff) : (_v & 0x7ff);
		}
	
		static get_collision_box_top = function(_index)
		{
			var _v = (collision_box[_index] >> 24) & 0xfff;
		
			return (_v & 0x800) ? -(_v & 0x7ff) : (_v & 0x7ff);
		}
	
		static get_collision_box_right = function(_index)
		{
			var _v = (collision_box[_index] >> 12) & 0xfff;
		
			return (_v & 0x800) ? -(_v & 0x7ff) : (_v & 0x7ff);
		}
	
		static get_collision_box_bottom = function(_index)
		{
			var _v = collision_box[_index] & 0xfff;
		
			return (_v & 0x800) ? -(_v & 0x7ff) : (_v & 0x7ff);
		}
	
		alpha = 1;
	
		static set_alpha = function(_alpha)
		{
			alpha = _alpha;
		
			return self;
		}
			
		on_place = -1;
			
		static set_on_place = function(on)
		{
			on_place = on;
				
			return self;
		}
			
		on_destroy = -1;
			
		static set_on_destroy = function(on)
		{
			on_destroy = on;
				
			return self;
		}
			
		on_update = -1;
			
		static set_on_update = function(on)
		{
			on_update = on;
				
			return self;
		}
			
		on_interaction = -1;
			
		static set_on_interaction = function(on)
		{
			on_interaction = on;
				
			return self;
		}
			
		slipperiness = PHYSICS_GLOBAL_SLIPPERINESS;
			
		static set_slipperiness = function(_val)
		{
			slipperiness = _val;
				
			return self;
		}
			
		instance = -1;
			
		static set_instance = function(_instance)
		{
			instance = _instance;
				
			return self;
		}
		
		if (type & ITEM_TYPE.CRAFTING_STATION)
		{
			sfx_craft = -1;
			
			static set_sfx_craft = function(_sfx)
			{
				sfx_craft = _sfx;
				
				return self;
			}
		}
	}
	
	if (type & ITEM_TYPE.MENU)
	{
		menu = -1;
			
		static set_menu = function(_menu)
		{
			menu = _menu;
				
			return self;
		}
	}
}

global.item_data = [];

array_push(global.item_data, new ItemData(item_Dirt, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(ITEM.DIRT)
	.set_sfx(SFX.DIRT));

array_push(global.item_data, new ItemData(item_Dirt_Wall, ITEM_TYPE.WALL)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 8)
	.set_drops(ITEM.DIRT_WALL)
	.set_sfx(SFX.DIRT));

array_push(global.item_data, new ItemData(item_Greenian_Grass_Block, ITEM_TYPE.SOLID)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(ITEM.DIRT)
	.set_sfx(SFX.LEAVES)
	.set_on_update(item_update_grass));

array_push(global.item_data, new ItemData(item_Oak_Wood, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 20)
	.set_drops(ITEM.OAK_WOOD)
	.set_sfx(SFX.WOOD));
  
array_push(global.item_data, new ItemData(item_Oak_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_drops(
		ITEM.EMPTY, 12,
		ITEM.APPLE, 2
	)
	.set_sfx(SFX.LEAVES)
	.set_on_update(function(_x, _y, _z) {
		item_update_leaves(_x, _y, prt_Oak_Leaves);
	}));

array_push(global.item_data, new ItemData(item_Bee_Nest, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.AXE,, 10)
	.set_drops(ITEM.EMPTY)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Beeswax));

array_push(global.item_data, new ItemData(item_Honeycomb, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 10);
		effect_set(BUFF_SPEED, 15, 1, _inst);
	}));

array_push(global.item_data, new ItemData(item_Birch_Wood, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 20)
	.set_drops(ITEM.BIRCH_WOOD)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Stone, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.STONE)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Stone_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.STONE_WALL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Emustone, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.COPPER, 94)
	.set_drops(ITEM.EMUSTONE)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Emustone_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER, TOOL_POWER.COPPER, 68)
	.set_drops(ITEM.EMUSTONE_WALL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Understone, ITEM_TYPE.SOLID));

array_push(global.item_data, new ItemData(item_Basalt, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 64)
	.set_drops(ITEM.BASALT)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Snow, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 11)
	.set_drops(ITEM.SNOW)
	.set_sfx(SFX.SNOW));

array_push(global.item_data, new ItemData(item_Birch_Planks, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BIRCH_PLANKS)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Birch_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_drops(
		ITEM.EMPTY, 9,
		ITEM.BIRCH_LEAVES, 1,
		ITEM.APPLE, 3,
		ITEM.ORANGE, 2
	)
	.set_sfx(SFX.LEAVES)
	.set_on_update(function(_x, _y, _z) {
		item_update_leaves(_x, _y, prt_Birch_Leaves);
	}));

array_push(global.item_data, new ItemData(item_Golden_Birch_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_drops(
		ITEM.EMPTY, 9,
		ITEM.BIRCH_LEAVES, 1,
		ITEM.APPLE, 3,
		ITEM.ORANGE, 2
	)
	.set_sfx(SFX.LEAVES)
	.set_on_update(function(_x, _y, _z) {
		item_update_leaves(_x, _y, prt_Golden_Birch_Leaves);
	}));

array_push(global.item_data, new ItemData(item_Golden_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(5, DAMAGE_TYPE.MELEE)
	.set_mining_stats(TOOL_POWER.GOLD, 8)
	.set_durability(616)
	.set_acclimation(530, 7));

array_push(global.item_data, new ItemData(item_Golden_Hammer, ITEM_TYPE.HAMMER)
	.set_damage(8, DAMAGE_TYPE.MELEE)
	.set_mining_stats(TOOL_POWER.GOLD, 8)
	.set_durability(410)
	.set_acclimation(530, 7));

array_push(global.item_data, new ItemData(item_Sapking_Shrine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 148)
	.set_on_destroy(function(_x, _y, _z)
	{
		spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, BOSS.SAPKING);
	}));

array_push(global.item_data, new ItemData(item_Daffodil, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.DAFFODIL));

array_push(global.item_data, new ItemData(item_Dandelion, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.DANDELION));

array_push(global.item_data, new ItemData(item_Puffball, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.PUFFBALL)
	.set_on_update(function(_x, _y, _z)
	{
		if (!chance(0.05)) exit;
		
		var _xvelocity = (global.world.environment.weather_wind - random_range(0.4, 0.6)) * 2;
		
		spawn_particle(_x * TILE_SIZE, _y * TILE_SIZE, CHUNK_DEPTH_DEFAULT, new Particle()
			.set_sprite(spr_Square)
			.set_speed([_xvelocity * 0.2, _xvelocity], [-0.5, -0.1])
			.set_scale(random_range(1, 3))
			.set_collision()
			.set_speed_on_collision(0, 0)
			.set_fade_out(), irandom_range(1, 3));
	}));

array_push(global.item_data, new ItemData(item_Nemesia, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.NEMESIA));

array_push(global.item_data, new ItemData(item_Brown_Mushroom, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.BROWN_MUSHROOM));

array_push(global.item_data, new ItemData(item_Larvelt_Shrine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.COPPER, 148)
	.set_on_destroy(function(_x, _y, _z)
	{
		spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, BOSS.LUMINOSO);
	}));

array_push(global.item_data, new ItemData(item_Heart_Pot, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false));

array_push(global.item_data, new ItemData(item_Heartbreak_Pot, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false));

array_push(global.item_data, new ItemData(item_Pot, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false));

array_push(global.item_data, new ItemData(item_Tube_Coral, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 10)
	.set_drops(ITEM.TUBE_CORAL));

array_push(global.item_data, new ItemData(item_Tube_Coral_Fan, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 9)
	.set_drops(ITEM.TUBE_CORAL_FAN));

array_push(global.item_data, new ItemData(item_Wavy_Coral, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 10)
	.set_drops(ITEM.WAVY_CORAL));

array_push(global.item_data, new ItemData(item_Wavy_Coral_Fan, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 9)
	.set_drops(ITEM.WAVY_CORAL_FAN));

array_push(global.item_data, new ItemData(item_Chrystal_Blade, ITEM_TYPE.SWORD)
	.set_damage(33));

array_push(global.item_data, new ItemData(item_Short_Greenian_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_drops(
		ITEM.EMPTY, 24,
		ITEM.WHEAT_SEEDS, 1,
		ITEM.CARROT_SEEDS, 1,
		ITEM.POTATO_SEEDS, 1
	));

array_push(global.item_data, new ItemData(item_Zombie_Arm, ITEM_TYPE.SWORD)
	.set_damage(19));

array_push(global.item_data, new ItemData(item_Tall_Greenian_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_drops(
		ITEM.EMPTY, 20,
		ITEM.WHEAT_SEEDS, 2,
		ITEM.CARROT_SEEDS, 1,
		ITEM.POTATO_SEEDS, 1
	));

array_push(global.item_data, new ItemData(item_Cherry_Wood, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 20)
	.set_drops(ITEM.CHERRY_WOOD)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Cherry_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_drops(
		ITEM.EMPTY, 19,
		ITEM.CHERRY, 1,
	)
	.set_sfx(SFX.LEAVES)
	.set_on_update(function(_x, _y, _z) {
		item_update_leaves(_x, _y, prt_Cherry_Leaves);
	}));
	
array_push(global.item_data, new ItemData(item_Petunia, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.PETUNIA));

array_push(global.item_data, new ItemData(item_Sweet_Pea, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.SWEET_PEA));

array_push(global.item_data, new ItemData(item_Pink_Amaryllis, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.PINK_AMARYLLIS));

array_push(global.item_data, new ItemData(item_Cherry_Planks, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.CHERRY_PLANKS)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Rose, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.ROSE));

array_push(global.item_data, new ItemData(item_Yellow_Growler, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.YELLOW_GROWLER));

array_push(global.item_data, new ItemData(item_Daisy, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.DAISY));

array_push(global.item_data, new ItemData(item_Blue_Bells, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.BLUE_BELLS));

array_push(global.item_data, new ItemData(item_Oak_Planks, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.OAK_PLANKS)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Snowball, ITEM_TYPE.THROWABLE, ITEM_TYPE.AMMO)
	.set_damage(2)
	.set_ammo_type(AMMO_TYPE.SNOWBALL));

array_push(global.item_data, new ItemData(item_Ice, ITEM_TYPE.SOLID)
	.set_slipperiness(0.95)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 8)
	.set_drops(ITEM.ICE));

array_push(global.item_data, new ItemData(item_Icelea, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.ICELEA));

array_push(global.item_data, new ItemData(item_Mangrove_Wood, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.AXE,, 20)
	.set_drops(ITEM.MANGROVE_WOOD)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Mangrove_Roots, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.AXE,, 20)
	.set_drops(ITEM.MANGROVE_ROOTS)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Mangrove_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, true)
	.set_animation_type(ANIMATION_TYPE.CONNECTED_TO_SELF)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_sfx(SFX.LEAVES));

array_push(global.item_data, new ItemData(item_High_Society, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.HIGH_SOCIETY));

array_push(global.item_data, new ItemData(item_Lotus_Flower, ITEM_TYPE.SOLID)
	.set_flip_on(true, false)
	.set_drops(ITEM.LOTUS_FLOWER));

array_push(global.item_data, new ItemData(item_Lily_Pad, ITEM_TYPE.SOLID)
	.set_flip_on(true, false)
	.set_drops(ITEM.LILY_PAD));

array_push(global.item_data, new ItemData(item_Sand, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 11)
	.set_drops(ITEM.SAND));

array_push(global.item_data, new ItemData(item_Sandstone, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 58)
	.set_drops(ITEM.SANDSTONE)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Sandstone_Pillar, ITEM_TYPE.UNTOUCHABLE)
	.set_random_frame(0, 6)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 50)
	.set_drops(ITEM.SANDSTONE_PILLAR));

array_push(global.item_data, new ItemData(item_Cactus, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE, 8, 16)
	.set_drops(ITEM.CACTUS));

array_push(global.item_data, new ItemData(item_Moss, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 11)
	.set_drops(ITEM.MOSS));

array_push(global.item_data, new ItemData(item_Arachnos_Shrine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.COPPER, 148)
	.set_on_destroy(function(_x, _y, _z)
	{
		spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, BOSS.ARACHNOS);
	}));

array_push(global.item_data, new ItemData(item_Iron_Fishing_Pole, ITEM_TYPE.FISHING_POLE)
	.set_durability(279));

array_push(global.item_data, new ItemData(item_Platinum_Fishing_Pole, ITEM_TYPE.FISHING_POLE)
	.set_durability(728));

array_push(global.item_data, new ItemData(item_Raw_Frog_Leg, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 4);
	}));

array_push(global.item_data, new ItemData(item_Cooked_Frog_Leg, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 18);
	}));

array_push(global.item_data, new ItemData(item_Apple, ITEM_TYPE.CONSUMABLE)
	.set_inventory_index(0, 2)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 12);
	}));

array_push(global.item_data, new ItemData(item_Orange, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 12);
	}));

array_push(global.item_data, new ItemData(item_Wheat));

array_push(global.item_data, new ItemData(item_Bread, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 24);
	}));

array_push(global.item_data, new ItemData(item_Toast, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 10);
	}));

array_push(global.item_data, new ItemData(item_Bloom_Chest, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CONTAINER)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BLOOM_CHEST));

array_push(global.item_data, new ItemData(item_Vicuz_Shrine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.COPPER, 148)
	.set_on_destroy(function(_x, _y, _z)
	{
		spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, BOSS.VICUZ);
	}));

array_push(global.item_data, new ItemData(item_Potato, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 8);
	}));

array_push(global.item_data, new ItemData(item_Bloom_Table, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BLOOM_TABLE));

array_push(global.item_data, new ItemData(item_Bloom_Chair, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BLOOM_CHAIR));

array_push(global.item_data, new ItemData(item_Bloom_Door, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BLOOM_DOOR));

array_push(global.item_data, new ItemData(item_Mahogany_Wood, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 20)
	.set_drops(ITEM.MAHOGANY_WOOD)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Mahogany_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_sfx(SFX.LEAVES)
	.set_on_update(function(_x, _y, _z) {
		item_update_leaves(_x, _y, prt_Mahogany_Leaves);
	}));

array_push(global.item_data, new ItemData(item_Redberry_Bush, ITEM_TYPE.PLANT)
	.set_flip_on(true, false));

array_push(global.item_data, new ItemData(item_Redberry, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 10);
	}));

array_push(global.item_data, new ItemData(item_Blueberry_Bush, ITEM_TYPE.PLANT)
	.set_flip_on(true, false));

array_push(global.item_data, new ItemData(item_Blueberry, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 10);
	}));

array_push(global.item_data, new ItemData(item_Lumin_Moss, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 11)
	.set_drops(ITEM.LUMIN_MOSS));

array_push(global.item_data, new ItemData(item_Lumin_Shard));

array_push(global.item_data, new ItemData(item_Flint));

array_push(global.item_data, new ItemData(item_Coal));

array_push(global.item_data, new ItemData(item_Kelp, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(,, 8)
	.set_drops(ITEM.KELP));

array_push(global.item_data, new ItemData(item_Mud, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(ITEM.MUD));

array_push(global.item_data, new ItemData(item_Crab_Claw, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_BUILD_REACH, 3));

array_push(global.item_data, new ItemData(item_Unfertilizer, ITEM_TYPE.THROWABLE));

array_push(global.item_data, new ItemData(item_Samuraiahiru, ITEM_TYPE.TOOL)
	.set_on_swing_interact(function(_x, _y)
	{
		spawn_pet(_x, _y, PET.BUSHIDO);
	}));

array_push(global.item_data, new ItemData(item_Capstone, ITEM_TYPE.TOOL)
	.set_on_swing_interact(function(_x, _y)
	{
		spawn_pet(_x, _y, PET.CAPDUDE);
	}));

array_push(global.item_data, new ItemData(item_Anaglyph_Geode, ITEM_TYPE.TOOL)
	.set_on_swing_interact(function(_x, _y) 
	{
		spawn_pet(_x, _y, PET.CHROMA);
	}));

array_push(global.item_data, new ItemData(item_Ancient_Bueprint_Forge));

array_push(global.item_data, new ItemData(item_Ancient_Bueprint_Kiln));

array_push(global.item_data, new ItemData(item_Ancient_Bueprint_Sprinkler));

array_push(global.item_data, new ItemData(item_Wildbloom_Ore, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.SHOVEL, TOOL_POWER.GOLD, 16)
	.set_drops(ITEM.WILDBLOOM_ORE)
	.set_sfx(SFX.DIRT));

array_push(global.item_data, new ItemData(item_Wildbloom_Shard));

array_push(global.item_data, new ItemData(item_Gravel, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(
		ITEM.GRAVEL, 19,
		ITEM.FLINT, 1
	)
	.set_sfx(SFX.DIRT));

array_push(global.item_data, new ItemData(item_Raw_Copper));

array_push(global.item_data, new ItemData(item_Copper));

array_push(global.item_data, new ItemData(item_Rafflesia, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.RAFFLESIA));

array_push(global.item_data, new ItemData(item_Empty_Shrine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 148));

array_push(global.item_data, new ItemData(item_Bullet, ITEM_TYPE.AMMO)
	.set_damage(8)
	.set_ammo_type(AMMO_TYPE.BULLET));

array_push(global.item_data, new ItemData(item_Short_Amazonian_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_mining_stats(,, 0)
	.set_drops(
		ITEM.EMPTY, 24,
		ITEM.WATERMELON_SEEDS, 1,
		ITEM.PUMPKIN_SEEDS, 1
	));

array_push(global.item_data, new ItemData(item_Hearthstone_Cleaver, ITEM_TYPE.SWORD)
	.set_damage(41)
	.set_swing_speed(6)
	.set_on_swing_attack(function(_x, _y)
	{
		var _angle = point_direction(_x, _y, mouse_x, mouse_y);
		
		spawn_projectile(_x, _y, new Projectile(item_Dirt, irandom_range(8, 14))
			.set_speed(dcos(_angle) * 4, -dsin(_angle) * 8)
			.set_gravity(0)
			.set_collision(false)
			.set_life(15)
			.set_fade());
	}));

array_push(global.item_data, new ItemData(item_Tall_Amazonian_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_mining_stats(,, 0)
	.set_drops(
		ITEM.EMPTY, 20,
		ITEM.WATERMELON_SEEDS, 2,
		ITEM.PUMPKIN_SEEDS, 1
	));

array_push(global.item_data, new ItemData(item_Raw_Weathered_Copper));

array_push(global.item_data, new ItemData(item_Weathered_Copper));

array_push(global.item_data, new ItemData(item_Lumin_Bulb, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_colour_offset(-30, -127, 0)
	.set_bloom(0, 25, 60)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 11));

array_push(global.item_data, new ItemData(item_Lumin_Berry, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CONSUMABLE)
	.set_flip_on(true, false)
	.set_mining_stats(,, 8)
	.set_drops(ITEM.LUMIN_BERRY)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 12);
	}));

array_push(global.item_data, new ItemData(item_Raw_Tarnished_Copper));

array_push(global.item_data, new ItemData(item_Tarnished_Copper));

array_push(global.item_data, new ItemData(item_Raw_Iron));

array_push(global.item_data, new ItemData(item_Iron));

array_push(global.item_data, new ItemData(item_Block_Of_Coal, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 80)
	.set_drops(ITEM.BLOCK_OF_COAL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Block_Of_Iron, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 86)
	.set_drops(ITEM.BLOCK_OF_IRON)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Raw_Gold));

array_push(global.item_data, new ItemData(item_Gold));

array_push(global.item_data, new ItemData(item_Block_Of_Gold, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 92)
	.set_drops(ITEM.BLOCK_OF_GOLD)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Raw_Platinum));

array_push(global.item_data, new ItemData(item_Platinum));

array_push(global.item_data, new ItemData(item_Block_Of_Platinum, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 100)
	.set_drops(ITEM.BLOCK_OF_PLATINUM)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Block_Of_Copper, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 74)
	.set_drops(ITEM.BLOCK_OF_COPPER)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Dried_Mud, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 14)
	.set_drops(ITEM.DRIED_MUD)
	.set_sfx(SFX.DIRT));

array_push(global.item_data, new ItemData(item_Luminoso_Shrine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.COPPER, 148)
	.set_on_destroy(function(_x, _y, _z)
	{
		spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, BOSS.LUMINOSO);
	}));

array_push(global.item_data, new ItemData(item_Amazonian_Grass_Block, ITEM_TYPE.SOLID)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(ITEM.DIRT)
	.set_sfx(SFX.DIRT)
	.set_on_update(item_update_grass));

array_push(global.item_data, new ItemData(item_Weathered_Block_Of_Copper, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 74)
	.set_drops(ITEM.WEATHERED_BLOCK_OF_COPPER)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Yucca_Fruit, ITEM_TYPE.CONSUMABLE)
	.set_drops(ITEM.YUCCA_FRUIT)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 10);
	}));

array_push(global.item_data, new ItemData(item_Tarnished_Block_Of_Copper, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 74)
	.set_drops(ITEM.TARNISHED_BLOCK_OF_COPPER)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Magma, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 82)
	.set_drops(ITEM.MAGMA)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Snow_Bricks, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 52)
	.set_drops(ITEM.SNOW_BRICKS)
	.set_sfx(SFX.SNOW));

array_push(global.item_data, new ItemData(item_Snow_Bricks_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 44)
	.set_drops(ITEM.SNOW_BRICKS_WALL)
	.set_sfx(SFX.SNOW));

array_push(global.item_data, new ItemData(item_Ice_Bricks, ITEM_TYPE.SOLID)
	.set_slipperiness(0.85)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 52)
	.set_drops(ITEM.ICE_BRICKS)
	.set_sfx(SFX.GLASS));

array_push(global.item_data, new ItemData(item_Ice_Bricks_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 44)
	.set_drops(ITEM.ICE_BRICKS_WALL)
	.set_sfx(SFX.GLASS));

array_push(global.item_data, new ItemData(item_Blizzard_Wood, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 20)
	.set_drops(ITEM.BLIZZARD_WOOD)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Blizzard_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_sfx(SFX.LEAVES));

array_push(global.item_data, new ItemData(item_Rocks, ITEM_TYPE.THROWABLE, ITEM_TYPE.UNTOUCHABLE)
	.set_damage(3)
	.set_random_frame(1, 4)
	.set_flip_on(true, false)
	.set_mining_stats(,, 1)
	.set_drops(ITEM.ROCKS));

array_push(global.item_data, new ItemData(item_Dead_Bush, ITEM_TYPE.PLANT)
	.set_random_frame(0, 8)
	.set_flip_on(true, false));

array_push(global.item_data, new ItemData(item_Persian_Speedwell, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.PERSIAN_SPEEDWELL));

array_push(global.item_data, new ItemData(item_Purple_Dendrobium, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.PURPLE_DENDROBIUM));

array_push(global.item_data, new ItemData(item_Deadflower, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.DEADFLOWER));

array_push(global.item_data, new ItemData(item_Bamboo, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false)
	.set_mining_stats(,, 8)
	.set_drops(ITEM.BAMBOO));

array_push(global.item_data, new ItemData(item_Sandstone_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 46)
	.set_drops(ITEM.SANDSTONE_WALL));

array_push(global.item_data, new ItemData(item_Boreal_Grass_Block, ITEM_TYPE.SOLID)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(ITEM.DIRT)
	.set_sfx(SFX.DIRT)
	.set_on_update(item_update_grass));

array_push(global.item_data, new ItemData(item_Swampy_Grass_Block, ITEM_TYPE.SOLID)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(ITEM.DIRT)
	.set_sfx(SFX.DIRT)
	.set_on_update(item_update_grass));

array_push(global.item_data, new ItemData(item_Cattails, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.CATTAILS));

array_push(global.item_data, new ItemData(item_Rock_Path, ITEM_TYPE.SOLID)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(ITEM.DIRT)
	.set_sfx(SFX.DIRT));

array_push(global.item_data, new ItemData(item_Tent, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE, 0, 0)
	.set_drops(ITEM.TENT));

array_push(global.item_data, new ItemData(item_Copper_Bow, ITEM_TYPE.BOW)
	.set_damage(12)
	.set_durability(113)
	.set_acclimation(530, 5));

array_push(global.item_data, new ItemData(item_Weathered_Copper_Bow, ITEM_TYPE.BOW)
	.set_damage(10)
	.set_durability(95)
	.set_acclimation(530, 5));

array_push(global.item_data, new ItemData(item_Tarnished_Copper_Bow, ITEM_TYPE.BOW)
	.set_damage(8)
	.set_durability(80)
	.set_acclimation(530, 5));

array_push(global.item_data, new ItemData(item_Mixed_Orchids, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.MIXED_ORCHIDS));

array_push(global.item_data, new ItemData(item_Blizzard_Planks, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BLIZZARD_PLANKS)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Small_Sweet_Pea, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.SMALL_SWEET_PEA));

array_push(global.item_data, new ItemData(item_Lily_Of_The_Valley, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.LILY_OF_THE_VALLEY));

array_push(global.item_data, new ItemData(item_Sunflower, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.SUNFLOWER));

array_push(global.item_data, new ItemData(item_Desert_Waves, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.DESERT_WAVES));

array_push(global.item_data, new ItemData(item_Gray_Marble, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 68)
	.set_drops(ITEM.GRAY_MARBLE));

array_push(global.item_data, new ItemData(item_Fern, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.FERN));

array_push(global.item_data, new ItemData(item_Curly_Fern, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.CURLY_FERN));

array_push(global.item_data, new ItemData(item_Skull, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.ARMOR_HELMET)
	.set_flip_on(true, false)
	.set_mining_stats(,, 3)
	.set_drops(ITEM.BONE));

array_push(global.item_data, new ItemData(item_Dead_Tube_Coral, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 10)
	.set_drops(ITEM.DEAD_TUBE_CORAL));

array_push(global.item_data, new ItemData(item_Dead_Tube_Coral_Fan, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 9)
	.set_drops(ITEM.DEAD_TUBE_CORAL_FAN));

array_push(global.item_data, new ItemData(item_Dead_Wavy_Coral, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 10)
	.set_drops(ITEM.DEAD_WAVY_CORAL));

array_push(global.item_data, new ItemData(item_Dead_Wavy_Coral_Fan, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 9)
	.set_drops(ITEM.DEAD_WAVY_CORAL_FAN));

array_push(global.item_data, new ItemData(item_Fire_Coral, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 10)
	.set_drops(ITEM.FIRE_CORAL));

array_push(global.item_data, new ItemData(item_Fire_Coral_Fan, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 9)
	.set_drops(ITEM.FIRE_CORAL_FAN));

array_push(global.item_data, new ItemData(item_Dead_Fire_Coral, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 10)
	.set_drops(ITEM.DEAD_FIRE_CORAL));

array_push(global.item_data, new ItemData(item_Dead_Fire_Coral_Fan, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 9)
	.set_drops(ITEM.DEAD_FIRE_CORAL_FAN));

array_push(global.item_data, new ItemData(item_Phallic_Coral, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 10)
	.set_drops(ITEM.FIRE_CORAL));

array_push(global.item_data, new ItemData(item_Phallic_Coral_Fan, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 9)
	.set_drops(ITEM.FIRE_CORAL_FAN));

array_push(global.item_data, new ItemData(item_Dead_Phallic_Coral, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 10)
	.set_drops(ITEM.DEAD_FIRE_CORAL));

array_push(global.item_data, new ItemData(item_Dead_Phallic_Coral_Fan, ITEM_TYPE.SOLID)
	.set_mining_stats(,, 9)
	.set_drops(ITEM.DEAD_FIRE_CORAL_FAN));

array_push(global.item_data, new ItemData(item_Permafrost, ITEM_TYPE.SOLID)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(ITEM.DIRT_WALL)
	.set_sfx(SFX.DIRT));

array_push(global.item_data, new ItemData(item_Kyanite, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.KYANITE));

array_push(global.item_data, new ItemData(item_Pine_Wood, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 20)
	.set_drops(ITEM.PINE_WOOD)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Pine_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_sfx(SFX.LEAVES));

array_push(global.item_data, new ItemData(item_Biodagger, ITEM_TYPE.SWORD)
	.set_damage(16));

array_push(global.item_data, new ItemData(item_Short_Boreal_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_mining_stats(,, 0)
	.set_drops(
		ITEM.EMPTY, 24,
		ITEM.WATERMELON_SEEDS, 1
	));

array_push(global.item_data, new ItemData(item_Courange_Glaive, ITEM_TYPE.SWORD)
	.set_damage(33));

array_push(global.item_data, new ItemData(item_Tall_Boreal_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_mining_stats(,, 0)
	.set_drops(
		ITEM.EMPTY, 20,
		ITEM.CHILI_PEPPER_SEEDS, 2
	));

array_push(global.item_data, new ItemData(item_Palm_Wood, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 20)
	.set_drops(ITEM.PALM_WOOD)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Palm_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_sfx(SFX.LEAVES)
	.set_on_update(function(_x, _y, _z) {
		item_update_leaves(_x, _y, prt_Palm_Leaves);
	}));

array_push(global.item_data, new ItemData(item_White_Marble, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 68)
	.set_drops(ITEM.WHITE_MARBLE));

array_push(global.item_data, new ItemData(item_Rosehip, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.ROSEHIP));

array_push(global.item_data, new ItemData(item_Cyan_Rose, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.CYAN_ROSE));

array_push(global.item_data, new ItemData(item_Cattail, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(,, 8)
	.set_drops(ITEM.CATTAIL));

array_push(global.item_data, new ItemData(item_Paeonia, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.PAEONIA));

array_push(global.item_data, new ItemData(item_Peony, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.PEONY));

array_push(global.item_data, new ItemData(item_Violets, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.VIOLETS));

array_push(global.item_data, new ItemData(item_Red_Mushroom, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.RED_MUSHROOM));

array_push(global.item_data, new ItemData(item_Blue_Mushroom, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.BLUE_MUSHROOM));

array_push(global.item_data, new ItemData(item_Pine_Planks, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.PINE_PLANKS)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Palm_Planks, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.PALM_PLANKS)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Dry_Dirt, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(ITEM.DIRT_WALL)
	.set_sfx(SFX.DIRT));

array_push(global.item_data, new ItemData(item_Dry_Grass_Block, ITEM_TYPE.SOLID)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(ITEM.DRY_DIRT)
	.set_sfx(SFX.DIRT)
	.set_on_update(function(_x, _y, _z)
	{
		item_update_grass(_x, _y, _z, ITEM.DRY_DIRT, false);
	}));

array_push(global.item_data, new ItemData(item_Trident, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Short_Dry_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_drops(
		ITEM.EMPTY, 3,
		ITEM.WHEAT_SEEDS, 1
	));

array_push(global.item_data, new ItemData(item_Frosthaven, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Tall_Dry_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_drops(
		ITEM.EMPTY, 1,
		ITEM.WHEAT_SEEDS, 1
	));

array_push(global.item_data, new ItemData(item_Ashen_Wood, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 20)
	.set_drops(ITEM.ASHEN_WOOD)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Ashen_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_sfx(SFX.LEAVES));

array_push(global.item_data, new ItemData(item_Ashen_Planks, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.ASHEN_PLANKS)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Mushroom_Stem_Block, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.AXE,, 18));

array_push(global.item_data, new ItemData(item_Red_Mushroom_Block, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.RED_MUSHROOM));

array_push(global.item_data, new ItemData(item_Blue_Mushroom_Block, ITEM_TYPE.SOLID)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BLUE_MUSHROOM));

array_push(global.item_data, new ItemData(item_Brown_Mushroom_Block, ITEM_TYPE.SOLID)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BROWN_MUSHROOM));

array_push(global.item_data, new ItemData(item_Lava_Flow, ITEM_TYPE.BOW));

array_push(global.item_data, new ItemData(item_Short_Swampy_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_drops(
		ITEM.EMPTY, 3,
		ITEM.WHEAT_SEEDS, 1
	));

array_push(global.item_data, new ItemData(item_Void_Cutlass, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Tall_Swampy_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_drops(
		ITEM.EMPTY, 1,
		ITEM.WHEAT_SEEDS, 1
	));

array_push(global.item_data, new ItemData(item_Acacia_Wood, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 20)
	.set_drops(ITEM.ACACIA_WOOD)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Acacia_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_sfx(SFX.LEAVES));

array_push(global.item_data, new ItemData(item_Acacia_Planks, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.ACACIA_PLANKS)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Coal_Ore, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 64)
	.set_drops(ITEM.COAL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Iron_Ore, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.COPPER, 76)
	.set_drops(ITEM.RAW_IRON)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Strata, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.STRATA)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Strata_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.STRATA_WALL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Yucca, ITEM_TYPE.PLANT)
	.set_flip_on(true, false));

array_push(global.item_data, new ItemData(item_Honey_Bricks, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 64)
	.set_drops(ITEM.HONEY_BRICKS));

array_push(global.item_data, new ItemData(item_Lumin_Stone, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.LUMIN_STONE)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Lumin_Ore, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 76)
	.set_drops(ITEM.LUMIN_SHARD)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Deadstone, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.DEADSTONE)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Block_Of_Bamboo, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BLOCK_OF_BAMBOO)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Block_Of_Dried_Bamboo, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BLOCK_OF_DRIED_BAMBOO)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Lumin_Nub, ITEM_TYPE.UNTOUCHABLE));

array_push(global.item_data, new ItemData(item_Jonathan, ITEM_TYPE.SWORD)
	.set_damage(5));

array_push(global.item_data, new ItemData(item_Short_Lumin_Growth, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false));

array_push(global.item_data, new ItemData(item_Spectrum_Glaive, ITEM_TYPE.PLANT)
	.set_damage(22));

array_push(global.item_data, new ItemData(item_Tall_Lumin_Growth, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false));

array_push(global.item_data, new ItemData(item_Dead_Dirt, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(ITEM.DIRT_WALL)
	.set_sfx(SFX.DIRT));

array_push(global.item_data, new ItemData(item_Dead_Grass_Block, ITEM_TYPE.SOLID)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(ITEM.DEAD_DIRT)
	.set_sfx(SFX.DIRT)
	.set_on_update(function(_x, _y, _z)
	{
		item_update_grass(_x, _y, _z, ITEM.DEAD_DIRT, false);
	}));

array_push(global.item_data, new ItemData(item_Structure_Block, ITEM_TYPE.SOLID, ITEM_TYPE.MENU)
	.set_menu("Structure_Block")
	.set_instance({
		xscale: 1,
		yscale: 1,
		
		on_draw: function(_x, _y, _id)
		{
			draw_rectangle_colour(_id.bbox_left, _id.bbox_top, _id.bbox_right, _id.bbox_bottom, #ff0000, #00ff00, #0000ff, #ffff00, true);
		}
	})
	.set_variable({
		file_name: "Structure",
		custom_id: -1,
		xoffset: 0,
		yoffset: 0,
		xsize: 0,
		ysize: 0
	}));

array_push(global.item_data, new ItemData(item_Short_Dead_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_drops(
		ITEM.EMPTY, 3,
		ITEM.WHEAT_SEEDS, 1
	));

array_push(global.item_data, new ItemData(item_Structure_Point, ITEM_TYPE.SOLID, ITEM_TYPE.MENU)
	.set_menu("Structure_Point")
	.set_variable({
		file_name: "Structure"
	}));

array_push(global.item_data, new ItemData(item_Tall_Dead_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_drops(
		ITEM.EMPTY, 1,
		ITEM.WHEAT_SEEDS, 1
	));

array_push(global.item_data, new ItemData(item_Bone, ITEM_TYPE.UNTOUCHABLE)
	.set_random_frame(1, 2));

array_push(global.item_data, new ItemData(item_Block_Of_Bone, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 68)
	.set_drops(ITEM.BLOCK_OF_BONE));

array_push(global.item_data, new ItemData(item_Dead_Rose, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.DEAD_ROSE));

array_push(global.item_data, new ItemData(item_Vine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(,, 8)
	.set_drops(ITEM.VINE));

array_push(global.item_data, new ItemData(item_Written_Book, ITEM_TYPE.MENU)
	.set_menu("Written_Book")
	.set_on_interaction_inventory(function()
	{
		obj_Control.is_opened_menu = true;
		global.menu_layer = "Menu_Written_Book";
							
		instance_activate_layer(global.menu_layer);
	}));

array_push(global.item_data, new ItemData(item_Granite, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.GRANITE));

array_push(global.item_data, new ItemData(item_Andesite, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.ANDESITE));

array_push(global.item_data, new ItemData(item_Aphide, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_drops(ITEM.APHIDE)
	.set_mining_stats(ITEM_TYPE.SHOVEL, 32, 72));

array_push(global.item_data, new ItemData(item_Poppin, ITEM_TYPE.BOW)
	.set_damage(19));

array_push(global.item_data, new ItemData(item_Short_Snowy_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_drops(
		ITEM.EMPTY, 3,
		ITEM.WHEAT_SEEDS, 1
	));

array_push(global.item_data, new ItemData(item_Botany, ITEM_TYPE.SWORD)
	.set_damage(23));

array_push(global.item_data, new ItemData(item_Tall_Snowy_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_drops(
		ITEM.EMPTY, 1,
		ITEM.WHEAT_SEEDS, 1
	));

array_push(global.item_data, new ItemData(item_Black_Marble, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 68)
	.set_drops(ITEM.BLACK_MARBLE));

array_push(global.item_data, new ItemData(item_Cocoon, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,,));

array_push(global.item_data, new ItemData(item_Cobweb, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true));

array_push(global.item_data, new ItemData(item_Pink_Amethyst, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.PINK_AMETHYST));

array_push(global.item_data, new ItemData(item_Red_Hot, ITEM_TYPE.SWORD)
	.set_damage(13));

array_push(global.item_data, new ItemData(item_Pink_Amethyst_Cluster, ITEM_TYPE.UNTOUCHABLE)
	.set_random_frame(0, 3)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.PICKAXE,,)
	.set_drops(ITEM.PINK_AMETHYST));

array_push(global.item_data, new ItemData(item_Ice_Cold, ITEM_TYPE.SWORD)
	.set_damage(22));

array_push(global.item_data, new ItemData(item_Ruby));

array_push(global.item_data, new ItemData(item_Emerald));

array_push(global.item_data, new ItemData(item_Wheat_Seeds, ITEM_TYPE.UNTOUCHABLE)
	.set_place_requirement(function(_x, _y, _z)
	{
		return (tile_get(_x, _y + 1, _z) == ITEM.DIRT);
	})
	.set_on_update(function(_x, _y, _z)
	{
		item_update_plant(_x, _y, _z, 0.005, 3);
	}));

array_push(global.item_data, new ItemData(item_Oak_Planks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 16)
	.set_drops(ITEM.OAK_PLANKS_WALL)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Sawdust));

array_push(global.item_data, new ItemData(item_Bricks, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.BRICKS)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Pinecone, ITEM_TYPE.THROWABLE));

array_push(global.item_data, new ItemData(item_Lumin_Lotus, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.LUMIN_LOTUS));

array_push(global.item_data, new ItemData(item_Lumin_Rock, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.PICKAXE,,)
	.set_drops(ITEM.LUMIN_SHARD));

array_push(global.item_data, new ItemData(item_Acacia_Chest, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CONTAINER)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.ACACIA_CHEST));

array_push(global.item_data, new ItemData(item_Lumin_Moss_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 8)
	.set_drops(ITEM.LUMIN_MOSS_WALL));

array_push(global.item_data, new ItemData(item_Lumin_Shroom, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.LUMIN_SHROOM));

array_push(global.item_data, new ItemData(item_Polished_Stone, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.POLISHED_STONE));

array_push(global.item_data, new ItemData(item_Moss_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 8)
	.set_drops(ITEM.MOSS_WALL));

array_push(global.item_data, new ItemData(item_Deadstone_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.DEADSTONE_WALL));

array_push(global.item_data, new ItemData(item_Polished_Granite, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.POLISHED_GRANITE));

array_push(global.item_data, new ItemData(item_Acacia_Table, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.ACACIA_TABLE));

array_push(global.item_data, new ItemData(item_Bloom_Wood, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 20)
	.set_drops(ITEM.BLOOM_WOOD)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Bloom_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_sfx(SFX.LEAVES));

array_push(global.item_data, new ItemData(item_Pine_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(73));

array_push(global.item_data, new ItemData(item_Bloom_Planks, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BLOOM_PLANKS)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Acacia_Chair, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.ACACIA_CHAIR));

array_push(global.item_data, new ItemData(item_Torch, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_type(ANIMATION_TYPE.INCREMENT)
	.set_animation_index(0, 5)
	.set_colour_offset(0, -12, -50)
	.set_place_requirement(function(_x, _y, _z)
	{
		var _item_data = global.item_data;
		
		var _tile = tile_get(_x - 1, _y, CHUNK_DEPTH_DEFAULT);
		
		if (_tile != ITEM.EMPTY) && (_item_data[_tile].type & ITEM_TYPE.SOLID)
		{
			return true;
		}
		
		_tile = tile_get(_x + 1, _y, CHUNK_DEPTH_DEFAULT);
		
		if (_tile != ITEM.EMPTY) && (_item_data[_tile].type & ITEM_TYPE.SOLID)
		{
			return true;
		}
		
		_tile = tile_get(_x, _y + 1, CHUNK_DEPTH_DEFAULT);
		
		if (_tile != ITEM.EMPTY) && (_item_data[_tile].type & ITEM_TYPE.SOLID)
		{
			return true;
		}
		
		_tile = tile_get(_x, _y, CHUNK_DEPTH_WALL);
		
		if (_tile != ITEM.EMPTY) && (_item_data[_tile].type & ITEM_TYPE.SOLID)
		{
			return true;
		}
		
		return false;
	})
	.set_on_update(function(_x, _y, _z)
	{
		var _item_data = global.item_data;
		
		var _tile = tile_get(_x - 1, _y, CHUNK_DEPTH_DEFAULT, "all");
		
		if (_tile != ITEM.EMPTY) && (_item_data[_tile.item_id].type & ITEM_TYPE.SOLID)
		{
			tile_set(_x, _y, _z, "flip_rotation_index", (_tile.flip_rotation_index & 0xfffffff00) | 12);
			
			exit;
		}
		
		_tile = tile_get(_x + 1, _y, CHUNK_DEPTH_DEFAULT, "all");
		
		if (_tile != ITEM.EMPTY) && (_item_data[_tile.item_id].type & ITEM_TYPE.SOLID)
		{
			tile_set(_x, _y, _z, "flip_rotation_index", (_tile.flip_rotation_index & 0xfffffff00) | 6);
		}
	}));

array_push(global.item_data, new ItemData(item_Campfire, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_type(ANIMATION_TYPE.INCREMENT)
	.set_colour_offset(0, -2, -28)
	.set_mining_stats(,, 8)
	.set_drops(ITEM.CAMPFIRE));

array_push(global.item_data, new ItemData(item_Cloud, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED_TO_SELF)
	.set_mining_stats(,, 14)
	.set_drops(ITEM.CLOUD));

array_push(global.item_data, new ItemData(item_Honey_Bricks_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.HONEY_BRICKS_WALL));

array_push(global.item_data, new ItemData(item_Aphide_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.APHIDE_WALL));

array_push(global.item_data, new ItemData(item_Arrow, ITEM_TYPE.AMMO)
	.set_ammo_type(AMMO_TYPE.BOW));

array_push(global.item_data, new ItemData(item_Chain));

array_push(global.item_data, new ItemData(item_Maurice_Staff, ITEM_TYPE.TOOL)
	.set_inventory_scale(1)
	.set_inventory_max(1)
	.set_on_swing_interact(function(_x, _y) {
		spawn_pet(_x, _y, choose(
			PET.MAURICE,
			PET.CUBER,
			PET.BAL,
			PET.SIHP,
			PET.UFOE,
			PET.ROBET,
			PET.SWIGN,
			PET.WAVEE
		));
	}));

array_push(global.item_data, new ItemData(item_Mahogany_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(73));

array_push(global.item_data, new ItemData(item_Egg, ITEM_TYPE.THROWABLE, ITEM_TYPE.AMMO)
	.set_damage(6)
	.set_ammo_type(AMMO_TYPE.EGG));

array_push(global.item_data, new ItemData(item_Acacia_Door, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.ACACIA_DOOR));

array_push(global.item_data, new ItemData(item_Watermelon, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 12);
	}));

array_push(global.item_data, new ItemData(item_Raw_Beef, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 4);
	}));

array_push(global.item_data, new ItemData(item_Cooked_Beef, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 28);
	}));

array_push(global.item_data, new ItemData(item_Bottle));

array_push(global.item_data, new ItemData(item_Bottle_Of_Water, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 10);
	}, ITEM.BOTTLE));

array_push(global.item_data, new ItemData(item_Bottle_Of_Milk, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 10);
		effect_set(BUFF_DEFENSE, 30, 1, _inst);
	}, ITEM.BOTTLE));

array_push(global.item_data, new ItemData(item_Bottle_Of_Orange_Juice, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 10);
	}, ITEM.BOTTLE));

array_push(global.item_data, new ItemData(item_Carrot, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 8);
	}));

array_push(global.item_data, new ItemData(item_Raw_Chicken, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 8);
		
		if (random(1) < 0.8)
		{
			effect_set(BUFF_POISON, 8, 1, _inst);
		}
	}));

array_push(global.item_data, new ItemData(item_Cooked_Chicken, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 28);
	}));

array_push(global.item_data, new ItemData(item_Cake, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 40);
	}));

array_push(global.item_data, new ItemData(item_Tomato, ITEM_TYPE.CONSUMABLE, ITEM_TYPE.THROWABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 8);
	}));

array_push(global.item_data, new ItemData(item_Raw_Cod, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 6);
	}));

array_push(global.item_data, new ItemData(item_Cooked_Cod, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 24);
	}));

array_push(global.item_data, new ItemData(item_Raw_Salmon, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 6);
	}));

array_push(global.item_data, new ItemData(item_Cooked_Salmon, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 24);
	}));

array_push(global.item_data, new ItemData(item_Raw_Bluefish, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 6);
	}));

array_push(global.item_data, new ItemData(item_Cooked_Bluefish, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 24);
	}));

array_push(global.item_data, new ItemData(item_Raw_Tuna, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 6);
	}));

array_push(global.item_data, new ItemData(item_Cooked_Tuna, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 24);
	}));

array_push(global.item_data, new ItemData(item_Pufferfish, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 6);
		effect_set(BUFF_POISON, 14, 3, _inst);
		effect_set(BUFF_SLOWNESS, 14, 3, _inst);
	}));

array_push(global.item_data, new ItemData(item_Clownfish, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 6);
	}));

array_push(global.item_data, new ItemData(item_Chili_Pepper, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 6);
		effect_set(BUFF_SPICY, 45, 1, _inst);
	}));

array_push(global.item_data, new ItemData(item_Pumpkin)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 10);
	}));

array_push(global.item_data, new ItemData(item_Banana_Peel, ITEM_TYPE.THROWABLE));

array_push(global.item_data, new ItemData(item_Pine_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(65));

array_push(global.item_data, new ItemData(item_Bowl));

array_push(global.item_data, new ItemData(item_Birch_Chest, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CONTAINER)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BIRCH_CHEST));

array_push(global.item_data, new ItemData(item_Birch_Table, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BIRCH_TABLE));

array_push(global.item_data, new ItemData(item_Birch_Door, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BIRCH_DOOR)
	.set_on_interaction(item_interaction_door));

array_push(global.item_data, new ItemData(item_Birch_Chair, ITEM_TYPE.CONSUMABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BIRCH_CHAIR));

array_push(global.item_data, new ItemData(item_Cookie, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 12);
	}));

array_push(global.item_data, new ItemData(item_Yucca_Chest, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CONTAINER)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.YUCCA_CHEST));

array_push(global.item_data, new ItemData(item_Apple_Pie, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 20);
	}));

array_push(global.item_data, new ItemData(item_Redberry_Pie, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 20);
	}));

array_push(global.item_data, new ItemData(item_Blueberry_Pie, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 20);
	}));

array_push(global.item_data, new ItemData(item_Pumpkin_Pie, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 20);
	}));

array_push(global.item_data, new ItemData(item_Sugar));

array_push(global.item_data, new ItemData(item_Cherry_Chest, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CONTAINER)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.CHERRY_CHEST));

array_push(global.item_data, new ItemData(item_Banana, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 8);
	}, ITEM.BANANA_PEEL));

array_push(global.item_data, new ItemData(item_Cherry_Table, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.CHERRY_TABLE));

array_push(global.item_data, new ItemData(item_Raw_Rabbit, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 6);
	}));

array_push(global.item_data, new ItemData(item_Cooked_Rabbit, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 28);
	}));

array_push(global.item_data, new ItemData(item_Ashen_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(73));

array_push(global.item_data, new ItemData(item_Ashen_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(3)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(65));

array_push(global.item_data, new ItemData(item_Palm_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(73));

array_push(global.item_data, new ItemData(item_Palm_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(65));

array_push(global.item_data, new ItemData(item_Acacia_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(73));

array_push(global.item_data, new ItemData(item_Acacia_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(65));

array_push(global.item_data, new ItemData(item_Bloom_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(73));

array_push(global.item_data, new ItemData(item_Bloom_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(65));

array_push(global.item_data, new ItemData(item_Cherry_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(73));

array_push(global.item_data, new ItemData(item_Prickly_Pear_Fruit, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 8);
	}));

array_push(global.item_data, new ItemData(item_Yucca_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(73));

array_push(global.item_data, new ItemData(item_Yucca_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(65));

array_push(global.item_data, new ItemData(item_Wysteria_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(73));

array_push(global.item_data, new ItemData(item_Wysteria_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(65));

array_push(global.item_data, new ItemData(item_Coconut));

array_push(global.item_data, new ItemData(item_Raw_Bismuth));

array_push(global.item_data, new ItemData(item_Bismuth));

array_push(global.item_data, new ItemData(item_Diamond));

array_push(global.item_data, new ItemData(item_Brick, ITEM_TYPE.THROWABLE)
	.set_damage(4));

array_push(global.item_data, new ItemData(item_Amethyst));

array_push(global.item_data, new ItemData(item_Volcanite_Shard));

array_push(global.item_data, new ItemData(item_Sandstorm_Shard));

array_push(global.item_data, new ItemData(item_Ebonrich_Shard));

array_push(global.item_data, new ItemData(item_Raw_Liminite));

array_push(global.item_data, new ItemData(item_Liminite));

array_push(global.item_data, new ItemData(item_Cherry_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(3)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(65));

array_push(global.item_data, new ItemData(item_Fried_Egg, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 14);
	}));

array_push(global.item_data, new ItemData(item_Yucca_Wood, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_type(ANIMATION_TYPE.CONNECTED_TO_SELF)
	.set_mining_stats(ITEM_TYPE.AXE,, 20)
	.set_drops(ITEM.YUCCA_WOOD)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Yucca_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_sfx(SFX.LEAVES));

array_push(global.item_data, new ItemData(item_Yucca_Planks, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.YUCCA_PLANKS)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Silk));

array_push(global.item_data, new ItemData(item_Feather));

array_push(global.item_data, new ItemData(item_Leather));

array_push(global.item_data, new ItemData(item_Rabbit_Hide));

array_push(global.item_data, new ItemData(item_Rabbit_Foot, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_LUCK, 0.2));

array_push(global.item_data, new ItemData(item_Mummy_Wrap));

array_push(global.item_data, new ItemData(item_Cherry_Chair, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.CHERRY_CHAIR));

array_push(global.item_data, new ItemData(item_Anvil, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CRAFTING_STATION)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.COPPER, 22)
	.set_drops(ITEM.ANVIL)
	.set_sfx(SFX.METAL)
	.set_sfx_craft(sfx_Craft_Anvil));

array_push(global.item_data, new ItemData(item_Workbench, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CRAFTING_STATION)
	.set_mining_stats(ITEM_TYPE.AXE,, 22)
	.set_drops(ITEM.WORKBENCH)
	.set_sfx(SFX.WOOD)
	.set_sfx_craft(sfx_Craft_Workbench));

array_push(global.item_data, new ItemData(item_Furnace, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CRAFTING_STATION)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 22)
	.set_drops(ITEM.FURNACE)
	.set_sfx(SFX.STONE)
	.set_sfx_craft(sfx_Craft_Furnace));

array_push(global.item_data, new ItemData(item_Yucca_Table, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.YUCCA_TABLE));

array_push(global.item_data, new ItemData(item_Block_Of_Lumin, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 74)
	.set_drops(ITEM.BLOCK_OF_LUMIN));

array_push(global.item_data, new ItemData(item_Block_Of_Ebonrich, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 74)
	.set_drops(ITEM.BLOCK_OF_EBONRICH));

array_push(global.item_data, new ItemData(item_Block_Of_Wildbloom, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 74)
	.set_drops(ITEM.BLOCK_OF_WILDBLOOM));

array_push(global.item_data, new ItemData(item_Block_Of_Sandstorm, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 74)
	.set_drops(ITEM.BLOCK_OF_SANDSTORM));

array_push(global.item_data, new ItemData(item_Block_Of_Volcanite, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 74)
	.set_drops(ITEM.BLOCK_OF_VOLCANITE));

array_push(global.item_data, new ItemData(item_Block_Of_Diamond, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 74)
	.set_drops(ITEM.BLOCK_OF_DIAMOND));

array_push(global.item_data, new ItemData(item_Block_Of_Ruby, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 74)
	.set_drops(ITEM.BLOCK_OF_RUBY));

array_push(global.item_data, new ItemData(item_Block_Of_Emerald, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 74)
	.set_drops(ITEM.BLOCK_OF_EMERALD));

array_push(global.item_data, new ItemData(item_Block_Of_Amethyst, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 74)
	.set_drops(ITEM.BLOCK_OF_AMETHYST));

array_push(global.item_data, new ItemData(item_Block_Of_Liminite, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.PLATINUM, 74)
	.set_drops(ITEM.BLOCK_OF_LIMINITE)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Block_Of_Bismuth, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 74)
	.set_drops(ITEM.BLOCK_OF_BISMUTH)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Copper_Ore, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.WOOD, 70)
	.set_drops(ITEM.RAW_COPPER)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Weathered_Copper_Ore, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.WOOD, 70)
	.set_drops(ITEM.RAW_WEATHERED_COPPER));

array_push(global.item_data, new ItemData(item_Tarnished_Copper_Ore, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.WOOD, 70)
	.set_drops(ITEM.RAW_TARNISHED_COPPER)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Gold_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 82)
	.set_drops(ITEM.RAW_GOLD)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Seagrass, ITEM_TYPE.PLANT));

array_push(global.item_data, new ItemData(item_Tall_Seagrass, ITEM_TYPE.PLANT));

array_push(global.item_data, new ItemData(item_Heart_Locket, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_REGENERATION, 0.15));

array_push(global.item_data, new ItemData(item_Golden_Heart_Locket, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_REGENERATION, 0.25));

array_push(global.item_data, new ItemData(item_Swordfish, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Blazebringer, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Gales_Of_The_Sahara, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Shimmers_Echo, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Necropolis, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Trumpet, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Triangle, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Stone_Bricks, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.STONE_BRICKS)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Golden_Sword, ITEM_TYPE.SWORD)
	.set_damage(17)
	.set_durability(410)
	.set_acclimation(530, 7));

array_push(global.item_data, new ItemData(item_Golden_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(5, DAMAGE_TYPE.MELEE)
	.set_mining_stats(TOOL_POWER.GOLD, 8)
	.set_durability(695)
	.set_acclimation(530, 7));

array_push(global.item_data, new ItemData(item_Golden_Axe, ITEM_TYPE.AXE)
	.set_damage(5, DAMAGE_TYPE.MELEE)
	.set_mining_stats(TOOL_POWER.GOLD, 8)
	.set_durability(653)
	.set_acclimation(530, 7));

array_push(global.item_data, new ItemData(item_Golden_Bow, ITEM_TYPE.BOW)
	.set_damage(17)
	.set_durability(555)
	.set_acclimation(530, 7));

array_push(global.item_data, new ItemData(item_Golden_Fishing_Pole, ITEM_TYPE.FISHING_POLE)
	.set_durability(470));

array_push(global.item_data, new ItemData(item_Flail, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Bucket));

array_push(global.item_data, new ItemData(item_Telescope));

array_push(global.item_data, new ItemData(item_Platinum_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 90)
	.set_drops(ITEM.RAW_PLATINUM)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Ruby_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 70)
	.set_drops(ITEM.RUBY));

array_push(global.item_data, new ItemData(item_Amber_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 70)
	.set_drops(ITEM.AMBER));

array_push(global.item_data, new ItemData(item_Topaz_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 70)
	.set_drops(ITEM.TOPAZ));

array_push(global.item_data, new ItemData(item_Emerald_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 70)
	.set_drops(ITEM.EMERALD));

array_push(global.item_data, new ItemData(item_Jade_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 70)
	.set_drops(ITEM.JADE));

array_push(global.item_data, new ItemData(item_Diamond_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 70)
	.set_drops(ITEM.DIAMOND));

array_push(global.item_data, new ItemData(item_Sapphire_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 70)
	.set_drops(ITEM.SAPPHIRE));

array_push(global.item_data, new ItemData(item_Amethyst_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 70)
	.set_drops(ITEM.AMETHYST));

array_push(global.item_data, new ItemData(item_Kunzite_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 70)
	.set_drops(ITEM.KUNZITE));

array_push(global.item_data, new ItemData(item_Moonstone_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 70)
	.set_drops(ITEM.MOONSTONE));

array_push(global.item_data, new ItemData(item_Onyx_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 70)
	.set_drops(ITEM.ONYX));

array_push(global.item_data, new ItemData(item_Emustone_Coal_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 84)
	.set_drops(ITEM.COAL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Emustone_Copper_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.WOOD, 90)
	.set_drops(ITEM.RAW_COPPER)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Emustone_Weathered_Copper_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.WOOD, 90)
	.set_drops(ITEM.RAW_WEATHERED_COPPER)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Emustone_Tarnished_Copper_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.WOOD, 90)
	.set_drops(ITEM.RAW_TARNISHED_COPPER)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Emustone_Iron_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.COPPER, 96)
	.set_drops(ITEM.RAW_IRON)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Emustone_Gold_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 102)
	.set_drops(ITEM.RAW_GOLD)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Emustone_Platinum_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 110)
	.set_drops(ITEM.RAW_PLATINUM)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Emustone_Ruby_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 100)
	.set_drops(ITEM.KUNZITE));

array_push(global.item_data, new ItemData(item_Emustone_Amber_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 100)
	.set_drops(ITEM.AMBER));

array_push(global.item_data, new ItemData(item_Emustone_Topaz_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 100)
	.set_drops(ITEM.TOPAZ));

array_push(global.item_data, new ItemData(item_Emustone_Emerald_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 100)
	.set_drops(ITEM.EMERALD));

array_push(global.item_data, new ItemData(item_Emustone_Jade_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 100)
	.set_drops(ITEM.JADE));

array_push(global.item_data, new ItemData(item_Emustone_Diamond_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 100)
	.set_drops(ITEM.DIAMOND));

array_push(global.item_data, new ItemData(item_Emustone_Sapphire_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 100)
	.set_drops(ITEM.SAPPHIRE));

array_push(global.item_data, new ItemData(item_Emustone_Amethyst_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 100)
	.set_drops(ITEM.AMETHYST));

array_push(global.item_data, new ItemData(item_Emustone_Kunzite_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 100)
	.set_drops(ITEM.KUNZITE));

array_push(global.item_data, new ItemData(item_Emustone_Moonstone_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 100)
	.set_drops(ITEM.MOONSTONE));

array_push(global.item_data, new ItemData(item_Emustone_Onyx_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 100)
	.set_drops(ITEM.ONYX));

array_push(global.item_data, new ItemData(item_Amber));

array_push(global.item_data, new ItemData(item_Topaz));

array_push(global.item_data, new ItemData(item_Jade));

array_push(global.item_data, new ItemData(item_Sapphire));

array_push(global.item_data, new ItemData(item_Kunzite));

array_push(global.item_data, new ItemData(item_Moonstone));

array_push(global.item_data, new ItemData(item_Onyx));

array_push(global.item_data, new ItemData(item_Arid_Shrine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 148)
	.set_on_destroy(function(_x, _y, _z)
	{
		spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, BOSS.ARID);
	}));

array_push(global.item_data, new ItemData(item_Toadtor_Shrine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 148)
	.set_on_destroy(function(_x, _y, _z)
	{
		spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, BOSS.TOADTOR);
	}));

array_push(global.item_data, new ItemData(item_Mummys_Blade, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Coal_Inlaid_Block_Of_Bone, ITEM_TYPE.SOLID));

array_push(global.item_data, new ItemData(item_Diamond_Inlaid_Block_Of_Bone, ITEM_TYPE.SOLID));

array_push(global.item_data, new ItemData(item_Dead_Sunflower, ITEM_TYPE.PLANT)
	.set_flip_on(true, false));

array_push(global.item_data, new ItemData(item_Swamp_Fogpod, ITEM_TYPE.PLANT)
	.set_flip_on(true, false));

array_push(global.item_data, new ItemData(item_Swamp_Lilybell, ITEM_TYPE.PLANT)
	.set_flip_on(true, false));

array_push(global.item_data, new ItemData(item_Large_Cocoon, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false));

array_push(global.item_data, new ItemData(item_Jasper));

array_push(global.item_data, new ItemData(item_Jasper_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 70)
	.set_drops(ITEM.JASPER));

array_push(global.item_data, new ItemData(item_Emustone_Jasper_Ore, ITEM_TYPE.SOLID)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 100)
	.set_drops(ITEM.JASPER));

array_push(global.item_data, new ItemData(item_Clay, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(ITEM.JASPER)
	.set_sfx(SFX.DIRT));

array_push(global.item_data, new ItemData(item_Wysteria_Wood, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 20)
	.set_drops(ITEM.WISTERIA_WOOD)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Wysteria_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_sfx(SFX.LEAVES));

array_push(global.item_data, new ItemData(item_Blizzard_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(73));

array_push(global.item_data, new ItemData(item_Blizzard_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(65));

array_push(global.item_data, new ItemData(item_Wysteria_Planks, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.WISTERIA_PLANKS)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Red_Dye));

array_push(global.item_data, new ItemData(item_Orange_Dye));

array_push(global.item_data, new ItemData(item_Yellow_Dye));

array_push(global.item_data, new ItemData(item_Lime_Dye));

array_push(global.item_data, new ItemData(item_Green_Dye));

array_push(global.item_data, new ItemData(item_Cyan_Dye));

array_push(global.item_data, new ItemData(item_Blue_Dye));

array_push(global.item_data, new ItemData(item_Purple_Dye));

array_push(global.item_data, new ItemData(item_Pink_Dye));

array_push(global.item_data, new ItemData(item_White_Dye));

array_push(global.item_data, new ItemData(item_Brown_Dye));

array_push(global.item_data, new ItemData(item_Black_Dye));

array_push(global.item_data, new ItemData(item_Blonde_Cherry_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_drops(
		ITEM.EMPTY, 19,
		ITEM.CHERRY, 1
	));

array_push(global.item_data, new ItemData(item_Snow_Pile, ITEM_TYPE.PLANT)
	.set_random_frame(0, 5)
	.set_flip_on(true, false)
	.set_mining_stats(,, 2)
	.set_sfx(SFX.SNOW));

array_push(global.item_data, new ItemData(item_Birds_Nest, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_mining_stats(,, 1)
	.set_drops(ITEM.TWIG));

array_push(global.item_data, new ItemData(item_Forget_Me_Not, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.FORGET_ME_NOT));

array_push(global.item_data, new ItemData(item_Anemone, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.ANEMONE));

array_push(global.item_data, new ItemData(item_Harebell, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.HAREBELL));

array_push(global.item_data, new ItemData(item_Candle, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_index(1, 6)
	.set_flip_on(true, false)
	.set_drops(ITEM.CANDLE));

array_push(global.item_data, new ItemData(item_Red_Candle, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_index(1, 6)
	.set_flip_on(true, false)
	.set_drops(ITEM.RED_CANDLE));

array_push(global.item_data, new ItemData(item_Orange_Candle, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_index(1, 6)
	.set_flip_on(true, false)
	.set_drops(ITEM.ORANGE_CANDLE));

array_push(global.item_data, new ItemData(item_Yellow_Candle, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_index(1, 6)
	.set_flip_on(true, false)
	.set_drops(ITEM.YELLOW_CANDLE));

array_push(global.item_data, new ItemData(item_Lime_Candle, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_index(1, 6)
	.set_flip_on(true, false)
	.set_drops(ITEM.LIME_CANDLE));

array_push(global.item_data, new ItemData(item_Green_Candle, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_index(1, 6)
	.set_flip_on(true, false)
	.set_drops(ITEM.GREEN_CANDLE));

array_push(global.item_data, new ItemData(item_Cyan_Candle, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_index(1, 6)
	.set_flip_on(true, false)
	.set_drops(ITEM.CYAN_CANDLE));

array_push(global.item_data, new ItemData(item_Blue_Candle, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_index(1, 6)
	.set_flip_on(true, false)
	.set_drops(ITEM.BLUE_CANDLE));

array_push(global.item_data, new ItemData(item_Purple_Candle, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_index(1, 6)
	.set_flip_on(true, false)
	.set_drops(ITEM.PURPLE_CANDLE));

array_push(global.item_data, new ItemData(item_Pink_Candle, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_index(1, 6)
	.set_flip_on(true, false)
	.set_drops(ITEM.PINK_CANDLE));

array_push(global.item_data, new ItemData(item_White_Candle, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_index(1, 6)
	.set_flip_on(true, false)
	.set_drops(ITEM.WHITE_CANDLE));

array_push(global.item_data, new ItemData(item_Brown_Candle, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_index(1, 6)
	.set_flip_on(true, false)
	.set_drops(ITEM.BROWN_CANDLE));

array_push(global.item_data, new ItemData(item_Black_Candle, ITEM_TYPE.UNTOUCHABLE)
	.set_animation_index(1, 6)
	.set_flip_on(true, false)
	.set_drops(ITEM.BLACK_CANDLE));

array_push(global.item_data, new ItemData(item_Stone_Bricks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.STONE_BRICKS_WALL)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Pencil, ITEM_TYPE.SWORD)
	.set_damage(14, DAMAGE_TYPE.MELEE));

array_push(global.item_data, new ItemData(item_Mahogany_Planks, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.MAHOGANY_PLANKS)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Mangrove_Planks, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.MANGROVE_PLANKS)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Copper_Sword, ITEM_TYPE.SWORD)
	.set_damage(11)
	.set_swing_speed(6)
	.set_durability(162));

array_push(global.item_data, new ItemData(item_Copper_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(7)
	.set_swing_speed(6)
	.set_mining_stats(TOOL_POWER.COPPER, 4)
	.set_durability(141));

array_push(global.item_data, new ItemData(item_Copper_Axe, ITEM_TYPE.AXE)
	.set_damage(8)
	.set_swing_speed(6)
	.set_mining_stats(TOOL_POWER.COPPER, 4)
	.set_durability(133));

array_push(global.item_data, new ItemData(item_Copper_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(6)
	.set_swing_speed(6)
	.set_mining_stats(TOOL_POWER.COPPER, 4)
	.set_durability(125));

array_push(global.item_data, new ItemData(item_Copper_Hammer, ITEM_TYPE.HAMMER)
	.set_damage(8)
	.set_swing_speed(6)
	.set_mining_stats(TOOL_POWER.COPPER, 4)
	.set_durability(104));

array_push(global.item_data, new ItemData(item_Copper_Fishing_Pole, ITEM_TYPE.FISHING_POLE)
	.set_durability(95));

array_push(global.item_data, new ItemData(item_Weathered_Copper_Sword, ITEM_TYPE.SWORD)
	.set_damage(11)
	.set_swing_speed(4)
	.set_durability(136));

array_push(global.item_data, new ItemData(item_Weathered_Copper_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(7)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.COPPER, 4)
	.set_durability(119));

array_push(global.item_data, new ItemData(item_Weathered_Copper_Axe, ITEM_TYPE.AXE)
	.set_damage(8)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.COPPER, 4)
	.set_durability(111));

array_push(global.item_data, new ItemData(item_Weathered_Copper_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(6)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.COPPER, 4)
	.set_durability(105));

array_push(global.item_data, new ItemData(item_Weathered_Copper_Hammer, ITEM_TYPE.HAMMER)
	.set_damage(8)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.COPPER, 4)
	.set_durability(87));

array_push(global.item_data, new ItemData(item_Weathered_Copper_Fishing_Pole, ITEM_TYPE.FISHING_POLE)
	.set_durability(80));

array_push(global.item_data, new ItemData(item_Tarnished_Copper_Sword, ITEM_TYPE.SWORD)
	.set_damage(11)
	.set_swing_speed(3)
	.set_durability(115));

array_push(global.item_data, new ItemData(item_Tarnished_Copper_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(7)
	.set_swing_speed(3)
	.set_mining_stats(TOOL_POWER.COPPER, 4)
	.set_durability(100));

array_push(global.item_data, new ItemData(item_Tarnished_Copper_Axe, ITEM_TYPE.AXE)
	.set_damage(8)
	.set_swing_speed(3)
	.set_mining_stats(TOOL_POWER.COPPER, 4)
	.set_durability(94));

array_push(global.item_data, new ItemData(item_Tarnished_Copper_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(6)
	.set_swing_speed(3)
	.set_mining_stats(TOOL_POWER.COPPER, 4)
	.set_durability(89));

array_push(global.item_data, new ItemData(item_Tarnished_Copper_Hammer, ITEM_TYPE.HAMMER)
	.set_damage(8)
	.set_swing_speed(3)
	.set_mining_stats(TOOL_POWER.COPPER, 4)
	.set_durability(80));

array_push(global.item_data, new ItemData(item_Tarnished_Copper_Fishing_Pole, ITEM_TYPE.FISHING_POLE)
	.set_durability(68));

array_push(global.item_data, new ItemData(item_Tall_Puffball, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.TALL_PUFFBALL)
	.set_on_update(function(_x, _y, _z)
	{
		if (!chance(0.1)) exit;
		
		var _xvelocity = (global.world.environment.weather_wind - random_range(0.4, 0.6)) * 3;
		
		spawn_particle(_x * TILE_SIZE, _y * TILE_SIZE, CHUNK_DEPTH_DEFAULT, new Particle()
			.set_sprite(spr_Square)
			.set_speed([_xvelocity * 0.2, _xvelocity], [-1, -0.2])
			.set_scale(random_range(1, 3))
			.set_collision()
			.set_speed_on_collision(0, 0)
			.set_fade_out(), irandom_range(1, 3));
	}));

array_push(global.item_data, new ItemData(item_Blue_Phlox, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.BLUE_PHLOX));

array_push(global.item_data, new ItemData(item_Red_Shelf_Fungus, ITEM_TYPE.PLANT)
	.set_random_frame(0, 3)
	.set_flip_on(true, false)
	.set_drops(ITEM.RED_MUSHROOM));

array_push(global.item_data, new ItemData(item_Blue_Shelf_Fungus, ITEM_TYPE.PLANT)
	.set_random_frame(0, 3)
	.set_flip_on(true, false)
	.set_drops(ITEM.BLUE_MUSHROOM));

array_push(global.item_data, new ItemData(item_Brown_Shelf_Fungus, ITEM_TYPE.PLANT)
	.set_random_frame(0, 3)
	.set_flip_on(true, false)
	.set_drops(ITEM.BROWN_MUSHROOM));

array_push(global.item_data, new ItemData(item_Podzol, ITEM_TYPE.SOLID)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.SHOVEL,, 12)
	.set_drops(ITEM.DIRT)
	.set_sfx(SFX.DIRT)
	.set_on_update(item_update_grass));

array_push(global.item_data, new ItemData(item_Polished_Andesite, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.POLISHED_ANDESITE));

array_push(global.item_data, new ItemData(item_Polished_Emustone, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.POLISHED_EMUSTONE));

array_push(global.item_data, new ItemData(item_Polished_Basalt, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.POLISHED_BASALT));

array_push(global.item_data, new ItemData(item_Polished_Deadstone, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.POLISHED_DEADSTONE));

array_push(global.item_data, new ItemData(item_Buzzdrop, ITEM_TYPE.THROWABLE));

array_push(global.item_data, new ItemData(item_Revolve, ITEM_TYPE.BOW));

array_push(global.item_data, new ItemData(item_Iridescence, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Dark_Blade, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Nuclear_Terrorizer, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Prometheus, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Artemis, ITEM_TYPE.BOW));

array_push(global.item_data, new ItemData(item_Staff_Of_The_Pharoah_God, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Emustone_Bricks, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.COPPER, 94)
	.set_drops(ITEM.EMUSTONE)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Emustone_Bricks_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER, TOOL_POWER.COPPER, 68)
	.set_drops(ITEM.EMUSTONE_WALL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Pink_Hibiscus, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.PINK_HIBISCUS));

array_push(global.item_data, new ItemData(item_Red_Hibiscus, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.RED_HIBISCUS));

array_push(global.item_data, new ItemData(item_Yellow_Hibiscus, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.YELLOW_HIBISCUS));

array_push(global.item_data, new ItemData(item_Blue_Hibiscus, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.BLUE_HIBISCUS));

array_push(global.item_data, new ItemData(item_Papyrus, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.PAPYRUS));

array_push(global.item_data, new ItemData(item_Paper));

array_push(global.item_data, new ItemData(item_Book));

array_push(global.item_data, new ItemData(item_Mahogany_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(65));

array_push(global.item_data, new ItemData(item_Block_Of_Amber, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 74)
	.set_drops(ITEM.BLOCK_OF_AMBER));

array_push(global.item_data, new ItemData(item_Block_Of_Topaz, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 74)
	.set_drops(ITEM.BLOCK_OF_TOPAZ));

array_push(global.item_data, new ItemData(item_Block_Of_Kunzite, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 74)
	.set_drops(ITEM.BLOCK_OF_KUNZITE));

array_push(global.item_data, new ItemData(item_Block_Of_Jade, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 74)
	.set_drops(ITEM.BLOCK_OF_JADE));

array_push(global.item_data, new ItemData(item_Block_Of_Sapphire, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 74)
	.set_drops(ITEM.BLOCK_OF_SAPPHIRE));

array_push(global.item_data, new ItemData(item_Block_Of_Moonstone, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 74)
	.set_drops(ITEM.BLOCK_OF_MOONSTONE));

array_push(global.item_data, new ItemData(item_Block_Of_Jasper, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 74)
	.set_drops(ITEM.BLOCK_OF_JASPER));

array_push(global.item_data, new ItemData(item_Block_Of_Onyx, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.IRON, 74)
	.set_drops(ITEM.BLOCK_OF_ONYX));

array_push(global.item_data, new ItemData(item_Cloudflower, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.CLOUDFLOWER));

array_push(global.item_data, new ItemData(item_Block_Of_Rainbow, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 28)
	.set_drops(ITEM.BLOCK_OF_RAINBOW));

array_push(global.item_data, new ItemData(item_Barnacle, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 4)
	.set_drops(ITEM.BARNACLE));

array_push(global.item_data, new ItemData(item_Sea_Urchin, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 4)
	.set_drops(ITEM.SEA_URCHIN));

array_push(global.item_data, new ItemData(item_Sargassum, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 4)
	.set_drops(ITEM.SARGASSUM));

array_push(global.item_data, new ItemData(item_Algae, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 4)
	.set_drops(ITEM.ALGAE));

array_push(global.item_data, new ItemData(item_Duckweed, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 4)
	.set_drops(ITEM.DUCKWEED));

array_push(global.item_data, new ItemData(item_Water, ITEM_TYPE.LIQUID)
	.set_animation_type(ANIMATION_TYPE.INCREMENT)
	.set_animation_index(0, 7)
	.set_alpha(1)
	.set_on_update(function(_x, _y, _z)
	{
		item_update_liquid_flow(_x, _y, _z, ITEM.WATER, 8);
	}));

array_push(global.item_data, new ItemData(item_Heliconia, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.HELICONIA));

array_push(global.item_data, new ItemData(item_Venus_Fly_Trap, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.VENUS_FLY_TRAP));

array_push(global.item_data, new ItemData(item_Tumbleweed, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.TUMBLEWEED));

array_push(global.item_data, new ItemData(item_Creep_Pot, ITEM_TYPE.UNTOUCHABLE));

array_push(global.item_data, new ItemData(item_Angler_Pot, ITEM_TYPE.UNTOUCHABLE));

array_push(global.item_data, new ItemData(item_Familiar_Pot, ITEM_TYPE.UNTOUCHABLE));

array_push(global.item_data, new ItemData(item_Deep_Pot, ITEM_TYPE.UNTOUCHABLE));

array_push(global.item_data, new ItemData(item_Burn_Pot, ITEM_TYPE.UNTOUCHABLE));

array_push(global.item_data, new ItemData(item_Storm_Pot, ITEM_TYPE.UNTOUCHABLE));

array_push(global.item_data, new ItemData(item_Oracle_Pot, ITEM_TYPE.UNTOUCHABLE));

array_push(global.item_data, new ItemData(item_Flora_Pot, ITEM_TYPE.UNTOUCHABLE));

array_push(global.item_data, new ItemData(item_Fauna_Pot, ITEM_TYPE.UNTOUCHABLE));

array_push(global.item_data, new ItemData(item_Lookout_Pot, ITEM_TYPE.UNTOUCHABLE));

array_push(global.item_data, new ItemData(item_Block_Of_Salt, ITEM_TYPE.SOLID)
	.set_flip_on(true, false)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 22)
	.set_drops(ITEM.BLOCK_OF_SALT));

array_push(global.item_data, new ItemData(item_Golden_Cherry_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_drops(
		ITEM.EMPTY, 19,
		ITEM.CHERRY, 1,
	));

array_push(global.item_data, new ItemData(item_Azure_Cherry_Leaves, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.AXE,, 11)
	.set_drops(
		ITEM.EMPTY, 19,
		ITEM.CHERRY, 1,
	));

array_push(global.item_data, new ItemData(item_Birch_Planks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 16)
	.set_drops(ITEM.BIRCH_PLANKS_WALL)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Cherry_Planks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 16)
	.set_drops(ITEM.CHERRY_PLANKS_WALL)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Blizzard_Planks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 16)
	.set_drops(ITEM.BLIZZARD_PLANKS_WALL)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Pine_Planks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 16)
	.set_drops(ITEM.PINE_PLANKS_WALL)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Palm_Planks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 16)
	.set_drops(ITEM.PALM_PLANKS_WALL)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Ashen_Planks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 16)
	.set_drops(ITEM.ASHEN_PLANKS_WALL)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Acacia_Planks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 16)
	.set_drops(ITEM.ACACIA_PLANKS_WALL)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Bloom_Planks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 16)
	.set_drops(ITEM.BLOOM_PLANKS_WALL)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Bunny_Head, ITEM_TYPE.ARMOR_HELMET));

array_push(global.item_data, new ItemData(item_Bunny_Shirt, ITEM_TYPE.ARMOR_BREASTPLATE));

array_push(global.item_data, new ItemData(item_Bunny_Pants, ITEM_TYPE.ARMOR_LEGGINGS));

array_push(global.item_data, new ItemData(item_Flower_Crown, ITEM_TYPE.ARMOR_HELMET));

array_push(global.item_data, new ItemData(item_Lucky_Clover, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_LUCK, 2));

array_push(global.item_data, new ItemData(item_Raw_Whole_Turkey, ITEM_TYPE.ARMOR_HELMET));

array_push(global.item_data, new ItemData(item_Cooked_Whole_Turkey, ITEM_TYPE.ARMOR_HELMET));

array_push(global.item_data, new ItemData(item_Raw_Turkey, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 3);
	}));

array_push(global.item_data, new ItemData(item_Cooked_Turkey, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 12);
	}));

array_push(global.item_data, new ItemData(item_Flamethrower, ITEM_TYPE.BOW));

array_push(global.item_data, new ItemData(item_Raw_Crab, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 8);
	}));

array_push(global.item_data, new ItemData(item_Cooked_Crab, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 28);
	}));

array_push(global.item_data, new ItemData(item_Yucca_Planks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 16)
	.set_drops(ITEM.YUCCA_PLANKS_WALL)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Wysteria_Planks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 16)
	.set_drops(ITEM.WISTERIA_PLANKS_WALL)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Mahogany_Planks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 16)
	.set_drops(ITEM.MAHOGANY_PLANKS_WALL)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Mangrove_Planks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 16)
	.set_drops(ITEM.MANGROVE_PLANKS_WALL)
	.set_sfx(SFX.WOOD));

array_push(global.item_data, new ItemData(item_Cherry_Door, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.CHERRY_DOOR)
	.set_on_interaction(item_interaction_door));

array_push(global.item_data, new ItemData(item_Glass, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED_TO_SELF)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 8)
	.set_drops(ITEM.GLASS)
	.set_sfx(SFX.GLASS)
	.set_obstructing(false));

array_push(global.item_data, new ItemData(item_Aloe_Vera, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.ALOE_VERA));

array_push(global.item_data, new ItemData(item_Hatchet, ITEM_TYPE.AXE)
	.set_damage(1)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD)
	.set_durability(68));

array_push(global.item_data, new ItemData(item_Twig, ITEM_TYPE.UNTOUCHABLE)
	.set_random_frame(1, 1)
	.set_flip_on(true, false)
	.set_mining_stats(,, 1)
	.set_drops(ITEM.TWIG));

array_push(global.item_data, new ItemData(item_Floral_Fury, ITEM_TYPE.SWORD));

array_push(global.item_data, new ItemData(item_Birch_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(73));

array_push(global.item_data, new ItemData(item_Oak_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_swing_speed(4)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(73));

array_push(global.item_data, new ItemData(item_Birch_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(65));

array_push(global.item_data, new ItemData(item_Oak_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(65));

array_push(global.item_data, new ItemData(item_Wysteria_Chest, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CONTAINER)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.WYSTERIA_CHEST));

array_push(global.item_data, new ItemData(item_Wysteria_Table, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.WYSTERIA_TABLE));

array_push(global.item_data, new ItemData(item_Iron_Sword, ITEM_TYPE.SWORD)
	.set_damage(13)
	.set_durability(474)
	.set_acclimation(530, 5));

array_push(global.item_data, new ItemData(item_Iron_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(2)
	.set_mining_stats(TOOL_POWER.IRON, 6)
	.set_durability(413)
	.set_acclimation(530, 5));

array_push(global.item_data, new ItemData(item_Iron_Axe, ITEM_TYPE.AXE)
	.set_damage(2)
	.set_mining_stats(TOOL_POWER.IRON, 6)
	.set_durability(387)
	.set_acclimation(530, 5));

array_push(global.item_data, new ItemData(item_Iron_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(2)
	.set_mining_stats(TOOL_POWER.IRON, 6)
	.set_durability(366)
	.set_acclimation(530, 5));

array_push(global.item_data, new ItemData(item_Iron_Hammer, ITEM_TYPE.HAMMER)
	.set_damage(2)
	.set_mining_stats(TOOL_POWER.IRON, 6)
	.set_durability(304)
	.set_acclimation(530, 5));

array_push(global.item_data, new ItemData(item_Iron_Bow, ITEM_TYPE.BOW)
	.set_damage(13)
	.set_durability(329)
	.set_acclimation(530, 5));

array_push(global.item_data, new ItemData(item_Platinum_Sword, ITEM_TYPE.SWORD)
	.set_damage(22)
	.set_mining_stats(TOOL_POWER.PLATINUM, 9)
	.set_durability(1239)
	.set_acclimation(880, 11));

array_push(global.item_data, new ItemData(item_Platinum_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(2)
	.set_mining_stats(TOOL_POWER.PLATINUM, 9)
	.set_durability(1078)
	.set_acclimation(880, 11));

array_push(global.item_data, new ItemData(item_Platinum_Axe, ITEM_TYPE.AXE)
	.set_damage(2)
	.set_mining_stats(TOOL_POWER.PLATINUM, 9)
	.set_durability(1012)
	.set_acclimation(880, 11));

array_push(global.item_data, new ItemData(item_Platinum_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(2)
	.set_mining_stats(TOOL_POWER.PLATINUM, 9)
	.set_durability(955)
	.set_acclimation(880, 11));

array_push(global.item_data, new ItemData(item_Platinum_Hammer, ITEM_TYPE.HAMMER)
	.set_damage(2)
	.set_mining_stats(TOOL_POWER.PLATINUM, 9)
	.set_durability(795)
	.set_acclimation(880, 11));

array_push(global.item_data, new ItemData(item_Platinum_Bow, ITEM_TYPE.BOW)
	.set_damage(22)
	.set_durability(861));

array_push(global.item_data, new ItemData(item_Mangrove_Pickaxe, ITEM_TYPE.PICKAXE)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(73));

array_push(global.item_data, new ItemData(item_Mangrove_Shovel, ITEM_TYPE.SHOVEL)
	.set_damage(3)
	.set_swing_speed(4)
	.set_mining_stats(TOOL_POWER.WOOD, 2)
	.set_durability(65));

array_push(global.item_data, new ItemData(item_Honey_Apple, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 10);
		effect_set(BUFF_SPEED, 15, 1, _inst);
	}));

array_push(global.item_data, new ItemData(item_Grilled_Cheese, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 16);
	}));

array_push(global.item_data, new ItemData(item_Lush_Shard));

array_push(global.item_data, new ItemData(item_Cherry, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 8);
	}));

array_push(global.item_data, new ItemData(item_Revenant_Shrine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.COPPER, 148)
	.set_on_destroy(function(_x, _y, _z)
	{
		spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, BOSS.REVENANT);
	}));

array_push(global.item_data, new ItemData(item_Snail_Shell));

array_push(global.item_data, new ItemData(item_Passionfruit, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 8);
	}));

array_push(global.item_data, new ItemData(item_Yucca_Chair, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.YUCCA_CHAIR));

array_push(global.item_data, new ItemData(item_Stove, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CRAFTING_STATION)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 22)
	.set_drops(ITEM.STOVE)
	.set_sfx(SFX.STONE)
	.set_sfx_craft(sfx_Craft_Furnace));

array_push(global.item_data, new ItemData(item_Yucca_Door, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.YUCCA_DOOR));

array_push(global.item_data, new ItemData(item_Zombie_Flesh, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 4);
		effect_set(BUFF_BARING, 14, 3, _inst);
	}));

array_push(global.item_data, new ItemData(item_Turtle_Shell));

array_push(global.item_data, new ItemData(item_Cotton));

array_push(global.item_data, new ItemData(item_Gold_Inlaid_Dried_Mud, ITEM_TYPE.SOLID));

array_push(global.item_data, new ItemData(item_Paper_Lantern, ITEM_TYPE.UNTOUCHABLE));

array_push(global.item_data, new ItemData(item_Wysteria_Chair, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.WYSTERIA_CHAIR));

array_push(global.item_data, new ItemData(item_Oak_Table, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.OAK_TABLE));

array_push(global.item_data, new ItemData(item_Oak_Chair, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.OAK_CHAIR));

array_push(global.item_data, new ItemData(item_Wysteria_Door, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.WYSTERIA_DOOR));

array_push(global.item_data, new ItemData(item_Oak_Door, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.OAK_DOOR)
	.set_on_interaction(item_interaction_door));

array_push(global.item_data, new ItemData(item_Oak_Sign, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.OAK_SIGN));

array_push(global.item_data, new ItemData(item_Oak_Chest, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CONTAINER)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.OAK_CHEST));

array_push(global.item_data, new ItemData(item_Salt, ITEM_TYPE.THROWABLE));

array_push(global.item_data, new ItemData(item_Salt_Bricks, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 60)
	.set_drops(ITEM.SALT_BRICKS)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Salt_Bricks_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 42)
	.set_drops(ITEM.SALT_BRICKS_WALL)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Pie_Crust, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 8);
	}));

array_push(global.item_data, new ItemData(item_Dark_Bamboo, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false)
	.set_mining_stats(,, 8)
	.set_drops(ITEM.DARK_BAMBOO));

array_push(global.item_data, new ItemData(item_Block_Of_Dark_Bamboo, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BLOCK_OF_DARK_BAMBOO));

array_push(global.item_data, new ItemData(item_Bundle_Of_Rope, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BUNDLE_OF_ROPE));

array_push(global.item_data, new ItemData(item_Mud_Bricks, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 50)
	.set_drops(ITEM.MUD_BRICKS)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Mud_Bricks_Wall, ITEM_TYPE.WALL)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 32)
	.set_drops(ITEM.MUD_BRICKS_WALL)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Salt_Lamp, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(,, 3)
	.set_drops(ITEM.BLOCK_OF_DARK_BAMBOO));

array_push(global.item_data, new ItemData(item_Sandstone_Bricks, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 58)
	.set_drops(ITEM.SANDSTONE_BRICKS)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Sandstone_Bricks_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 46)
	.set_drops(ITEM.SANDSTONE_BRICKS_WALL)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Desert_Grass, ITEM_TYPE.PLANT)
	.set_random_frame(0, 1)
	.set_flip_on(true, false));

array_push(global.item_data, new ItemData(item_Yarrow, ITEM_TYPE.PLANT)
	.set_flip_on(true, false)
	.set_drops(ITEM.YARROW));

array_push(global.item_data, new ItemData(item_Magma_Bricks, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.MAGMA_BRICKS)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Magma_Bricks_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.MAGMA_BRICKS_WALL)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Worm));

array_push(global.item_data, new ItemData(item_Grub));

array_push(global.item_data, new ItemData(item_Bait));

array_push(global.item_data, new ItemData(item_Chili_Pepper_Seeds)
	.set_place_requirement(function(_x, _y, _z)
	{
		return (tile_get(_x, _y + 1, _z) == ITEM.DIRT);
	})
	.set_on_update(function(_x, _y, _z)
	{
		item_update_plant(_x, _y, _z, 0.005, 3);
	}));

array_push(global.item_data, new ItemData(item_Pumpkin_Seeds)
	.set_place_requirement(function(_x, _y, _z)
	{
		return (tile_get(_x, _y + 1, _z) == ITEM.DIRT);
	})
	.set_on_update(function(_x, _y, _z)
	{
		item_update_plant(_x, _y, _z, 0.005, 3);
	}));

array_push(global.item_data, new ItemData(item_Watermelon_Seeds)
	.set_place_requirement(function(_x, _y, _z)
	{
		return (tile_get(_x, _y + 1, _z) == ITEM.DIRT);
	})
	.set_on_update(function(_x, _y, _z)
	{
		item_update_plant(_x, _y, _z, 0.005, 3);
	}));

array_push(global.item_data, new ItemData(item_Rice_Seeds)
	.set_place_requirement(function(_x, _y, _z)
	{
		return (tile_get(_x, _y + 1, _z) == ITEM.DIRT);
	})
	.set_on_update(function(_x, _y, _z)
	{
		item_update_plant(_x, _y, _z, 0.005, 3);
	}));

array_push(global.item_data, new ItemData(item_Lettuce_Seeds)
	.set_place_requirement(function(_x, _y, _z)
	{
		return (tile_get(_x, _y + 1, _z) == ITEM.DIRT);
	})
	.set_on_update(function(_x, _y, _z)
	{
		item_update_plant(_x, _y, _z, 0.005, 3);
	}));

array_push(global.item_data, new ItemData(item_Soap));

array_push(global.item_data, new ItemData(item_Valentine_Ring, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_REGENERATION, 0.3));

array_push(global.item_data, new ItemData(item_Heart_Balloon));

array_push(global.item_data, new ItemData(item_Chocolate, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		hp_add(_inst, 10);
		effect_set(BUFF_SPEED, 8, 1, _inst);
	}));

array_push(global.item_data, new ItemData(item_Cupids_Bow, ITEM_TYPE.BOW)
	.set_damage(19));

array_push(global.item_data, new ItemData(item_Teddy_Bear, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false)
	.set_drops(ITEM.TEDDY_BEAR));

array_push(global.item_data, new ItemData(item_Love_Letter, ITEM_TYPE.THROWABLE)
	.set_damage(18));

array_push(global.item_data, new ItemData(item_Jack_O_Lantern, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.ARMOR_HELMET)
	.set_flip_on(true, false)
	.set_drops(ITEM.JACK_O_LANTERN));

array_push(global.item_data, new ItemData(item_Witchs_Broom, ITEM_TYPE.SWORD)
	.set_damage(19));

array_push(global.item_data, new ItemData(item_Vampire_Cape, ITEM_TYPE.ARMOR_BREASTPLATE));

array_push(global.item_data, new ItemData(item_Gravestone, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false)
	.set_drops(ITEM.GRAVESTONE));

array_push(global.item_data, new ItemData(item_Wreath, ITEM_TYPE.THROWABLE)
	.set_damage(55));

array_push(global.item_data, new ItemData(item_Snow_Globe, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false)
	.set_drops(ITEM.SNOW_GLOBE));

array_push(global.item_data, new ItemData(item_Snowball_Launcher, ITEM_TYPE.BOW)
	.set_damage(14)
	.set_ammo_type(AMMO_TYPE.SNOWBALL));

array_push(global.item_data, new ItemData(item_Santa_Cap, ITEM_TYPE.ARMOR_HELMET));

array_push(global.item_data, new ItemData(item_Santa_Suit, ITEM_TYPE.ARMOR_BREASTPLATE));

array_push(global.item_data, new ItemData(item_Santa_Pants, ITEM_TYPE.ARMOR_LEGGINGS));

array_push(global.item_data, new ItemData(item_Present_Hat, ITEM_TYPE.ARMOR_HELMET));

array_push(global.item_data, new ItemData(item_Candy_Cane, ITEM_TYPE.SWORD)
	.set_damage(33));

array_push(global.item_data, new ItemData(item_Ornament, ITEM_TYPE.THROWABLE));

array_push(global.item_data, new ItemData(item_Easter_Egg, ITEM_TYPE.UNTOUCHABLE)
	.set_flip_on(true, false)
	.set_drops(ITEM.EASTER_EGG));

array_push(global.item_data, new ItemData(item_Eggnade, ITEM_TYPE.THROWABLE)
	.set_damage(66));

array_push(global.item_data, new ItemData(item_Egg_Cannon, ITEM_TYPE.BOW)
	.set_damage(21)
	.set_ammo_type(AMMO_TYPE.EGG));

array_push(global.item_data, new ItemData(item_Carrot_Cutlass, ITEM_TYPE.SWORD)
	.set_damage(24));

array_push(global.item_data, new ItemData(item_Sawmill, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CRAFTING_STATION)
	.set_mining_stats(ITEM_TYPE.AXE,, 22)
	.set_drops(ITEM.SAWMILL)
	.set_sfx(SFX.WOOD)
	.set_sfx_craft(sfx_Craft_Workbench));

array_push(global.item_data, new ItemData(item_Stonecutter, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CRAFTING_STATION)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 22)
	.set_drops(ITEM.STONECUTTER)
	.set_sfx(SFX.STONE)
	.set_sfx_craft(sfx_Craft_Furnace));

array_push(global.item_data, new ItemData(item_Sliced_Block_Of_Copper, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 74)
	.set_drops(ITEM.SLICED_BLOCK_OF_COPPER)
	.set_index_offset(-1)
	.set_on_interaction_inventory(function(_type, _index)
	{
		var _val = (global.inventory[$ _type][_index].index + 1) % 3;
		
		global.inventory[$ _type][_index].index = _val;
		global.inventory[$ _type][_index].index_offset = _val - 1;
	}));

array_push(global.item_data, new ItemData(item_Sliced_Weathered_Block_Of_Copper, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 74)
	.set_drops(ITEM.SLICED_WEATHERED_BLOCK_OF_COPPER)
	.set_index_offset(-1)
	.set_on_interaction_inventory(function(_type, _index)
	{
		var _val = (global.inventory[$ _type][_index].index + 1) % 3;
		
		global.inventory[$ _type][_index].index = _val;
		global.inventory[$ _type][_index].index_offset = _val - 1;
	}));

array_push(global.item_data, new ItemData(item_Sliced_Tarnished_Block_Of_Copper, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 74)
	.set_drops(ITEM.SLICED_TARNISHED_BLOCK_OF_COPPER)
	.set_index_offset(-1)
	.set_on_interaction_inventory(function(_type, _index)
	{
		var _val = (global.inventory[$ _type][_index].index + 1) % 3;
		
		global.inventory[$ _type][_index].index = _val;
		global.inventory[$ _type][_index].index_offset = _val - 1;
	}));

array_push(global.item_data, new ItemData(item_Brass));

array_push(global.item_data, new ItemData(item_Brass_Knuckles, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_STRENGTH, 0.2));

array_push(global.item_data, new ItemData(item_Wooden_Cane, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_SPEED, 0.03)
	.set_buff(BUFF_BUILD_REACH, 2));

array_push(global.item_data, new ItemData(item_Balloon, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_GRAVITY, -0.2));

array_push(global.item_data, new ItemData(item_Magic_Pearl, ITEM_TYPE.ACCESSORY));

array_push(global.item_data, new ItemData(item_Froggy_Hat, ITEM_TYPE.ARMOR_HELMET, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_JUMPING, 0.15));

array_push(global.item_data, new ItemData(item_Sheep_Ram, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_MOVE_DASH, 12));

array_push(global.item_data, new ItemData(item_Carpenters_Glove, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_BUILD_REACH, 6)
	.set_buff(BUFF_ITEM_REACH, 2)
	.set_buff(BUFF_BUILD_COOLDOWN, -0.2));

array_push(global.item_data, new ItemData(item_Bandage, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_REGENERATION, 0.1));

array_push(global.item_data, new ItemData(item_Magnet, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_ITEM_REACH, 3));

array_push(global.item_data, new ItemData(item_Thorned_Pendant, ITEM_TYPE.ACCESSORY));

array_push(global.item_data, new ItemData(item_Lucky_Horseshoe, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_LUCK, 0.2));

array_push(global.item_data, new ItemData(item_Old_Shoe, ITEM_TYPE.THROWABLE)
	.set_rotation(1, 6));

array_push(global.item_data, new ItemData(item_Molotov_Cocktail, ITEM_TYPE.THROWABLE)
	.set_rotation(6, 12));

array_push(global.item_data, new ItemData(item_Penny, ITEM_TYPE.THROWABLE));

array_push(global.item_data, new ItemData(item_Bomb, ITEM_TYPE.THROWABLE)
	.set_rotation(1, 10));

array_push(global.item_data, new ItemData(item_Mining_Helmet, ITEM_TYPE.ARMOR_HELMET, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_BUILD_COOLDOWN, -0.1));

array_push(global.item_data, new ItemData(item_Structure_Void, ITEM_TYPE.UNTOUCHABLE));

array_push(global.item_data, new ItemData(item_Technocrown, ITEM_TYPE.ACCESSORY));

array_push(global.item_data, new ItemData(item_Grenade, ITEM_TYPE.THROWABLE)
	.set_rotation(1, 10));

array_push(global.item_data, new ItemData(item_Throwing_Knife, ITEM_TYPE.THROWABLE));

array_push(global.item_data, new ItemData(item_Lava, ITEM_TYPE.LIQUID)
	.set_animation_type(ANIMATION_TYPE.INCREMENT)
	.set_animation_index(0, 3)
	.set_on_update(function(_x, _y, _z)
	{
		item_update_liquid_flow(_x, _y, _z, ITEM.LAVA, 4);
		item_update_liquid_combine(_x, _y, _z, ITEM.WATER, ITEM.OBSIDIAN, 4);
	}));

array_push(global.item_data, new ItemData(item_Obsidian, ITEM_TYPE.SOLID));

array_push(global.item_data, new ItemData(item_Carrot_Seeds, ITEM_TYPE.UNTOUCHABLE)
	.set_place_requirement(function(_x, _y, _z)
	{
		return (tile_get(_x, _y + 1, _z) == ITEM.DIRT);
	})
	.set_on_update(function(_x, _y, _z)
	{
		item_update_plant(_x, _y, _z, 0.005, 3);
	}));

array_push(global.item_data, new ItemData(item_Potato_Seeds, ITEM_TYPE.UNTOUCHABLE)
	.set_place_requirement(function(_x, _y, _z)
	{
		return (tile_get(_x, _y + 1, _z) == ITEM.DIRT);
	})
	.set_on_update(function(_x, _y, _z)
	{
		item_update_plant(_x, _y, _z, 0.005, 3);
	}));

array_push(global.item_data, new ItemData(item_Bucket_Of_Water, ITEM_TYPE.DEPLOYABLE)
	.set_inventory_max(1)
	.set_give_back(ITEM.BUCKET)
	.set_tile(CHUNK_DEPTH_LIQUID, new Tile(ITEM.WATER)
		.set_state(0)
		.set_index_offset(0)));

array_push(global.item_data, new ItemData(item_Bucket_Of_Lava, ITEM_TYPE.DEPLOYABLE)
	.set_inventory_max(1)
	.set_give_back(ITEM.BUCKET)
	.set_tile(CHUNK_DEPTH_LIQUID, new Tile(ITEM.LAVA)
		.set_state(0)
		.set_index_offset(0)));

array_push(global.item_data, new ItemData(item_Ink, ITEM_TYPE.LIQUID)
	.set_animation_type(ANIMATION_TYPE.INCREMENT)
	.set_animation_index(0, 3)
	.set_on_update(function(_x, _y, _z)
	{
		item_update_liquid_flow(_x, _y, _z, ITEM.INK, 4);
		item_update_liquid_combine(_x, _y, _z, ITEM.WATER, ITEM.OBSIDIAN, 4);
	}));

array_push(global.item_data, new ItemData(item_Bucket_Of_Ink, ITEM_TYPE.DEPLOYABLE)
	.set_inventory_max(1)
	.set_give_back(ITEM.BUCKET)
	.set_tile(CHUNK_DEPTH_LIQUID, new Tile(ITEM.INK)
		.set_state(0)
		.set_index_offset(0)));

array_push(global.item_data, new ItemData(item_Toadtor_Jr, ITEM_TYPE.WHIP)
	.set_damage(58, DAMAGE_TYPE.MELEE));

array_push(global.item_data, new ItemData(item_Rope_Whip, ITEM_TYPE.WHIP)
	.set_damage(12, DAMAGE_TYPE.MELEE));

array_push(global.item_data, new ItemData(item_Bubble, ITEM_TYPE.SOLID));

array_push(global.item_data, new ItemData(item_Bubble_Wand, ITEM_TYPE.DEPLOYABLE)
	.set_inventory_scale(1)
	.set_inventory_max(1)
	.set_give_back(ITEM.BUBBLE_WAND)
	.set_tile(CHUNK_DEPTH_DEFAULT, new Tile(ITEM.BUBBLE)));

array_push(global.item_data, new ItemData(item_Chain_Whip, ITEM_TYPE.WHIP)
	.set_damage(17));

array_push(global.item_data, new ItemData(item_Rope, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CLIMBABLE));

array_push(global.item_data, new ItemData(item_Neon_Shell, ITEM_TYPE.TOOL)
	.set_on_swing_interact(function(_x, _y) {
		spawn_pet(_x, _y, PET.SHELLY);
	}));

array_push(global.item_data, new ItemData(item_Kerchief, ITEM_TYPE.TOOL)
	.set_on_swing_interact(function(_x, _y) {
		spawn_pet(_x, _y, PET.KIKO);
	}));

array_push(global.item_data, new ItemData(item_Ball_Of_Yarn, ITEM_TYPE.TOOL)
	.set_on_swing_interact(function(_x, _y) {
		spawn_pet(_x, _y, PET.AIRI);
	}));

array_push(global.item_data, new ItemData(item_Tomato_Seeds, ITEM_TYPE.UNTOUCHABLE)
	.set_place_requirement(function(_x, _y, _z)
	{
		return (tile_get(_x, _y + 1, _z) == ITEM.DIRT);
	})
	.set_on_update(function(_x, _y, _z)
	{
		item_update_plant(_x, _y, _z, 0.005, 3);
	}));

array_push(global.item_data, new ItemData(item_Rosetta_Strike, ITEM_TYPE.WHIP)
	.set_damage(28, DAMAGE_TYPE.MELEE));

array_push(global.item_data, new ItemData(item_Serpents_Embrace, ITEM_TYPE.WHIP)
	.set_damage(33, DAMAGE_TYPE.MELEE));

array_push(global.item_data, new ItemData(item_Leather_Whip, ITEM_TYPE.WHIP)
	.set_damage(14, DAMAGE_TYPE.MELEE));

array_push(global.item_data, new ItemData(item_Heartbreak, ITEM_TYPE.WHIP)
	.set_damage(47, DAMAGE_TYPE.MELEE));

array_push(global.item_data, new ItemData(item_Maelstrom, ITEM_TYPE.WHIP)
	.set_damage(38, DAMAGE_TYPE.MELEE));

array_push(global.item_data, new ItemData(item_Rocket_Boots, ITEM_TYPE.ACCESSORY));

array_push(global.item_data, new ItemData(item_Spring_Loaded_Boots, ITEM_TYPE.ACCESSORY));

array_push(global.item_data, new ItemData(item_Companion_Collar, ITEM_TYPE.ACCESSORY)
	.set_buff(BUFF_PET_MAX, 2));

array_push(global.item_data, new ItemData(item_Steadfast_Quiver, ITEM_TYPE.ACCESSORY));

array_push(global.item_data, new ItemData(item_Mudball, ITEM_TYPE.ACCESSORY));

array_push(global.item_data, new ItemData(item_Farmers_Journal, ITEM_TYPE.ACCESSORY));

array_push(global.item_data, new ItemData(item_Fertilizer, ITEM_TYPE.THROWABLE));

array_push(global.item_data, new ItemData(item_Caltrops, ITEM_TYPE.THROWABLE));

array_push(global.item_data, new ItemData(item_Boomerang, ITEM_TYPE.THROWABLE));

array_push(global.item_data, new ItemData(item_Piggy_Bank, ITEM_TYPE.CONTAINER)
	.set_container_size(5));

array_push(global.item_data, new ItemData(item_Copper_Helmet, ITEM_TYPE.ARMOR_HELMET)
	.set_defense(3));

array_push(global.item_data, new ItemData(item_Copper_Breastplate, ITEM_TYPE.ARMOR_BREASTPLATE)
	.set_defense(5));

array_push(global.item_data, new ItemData(item_Copper_Leggings, ITEM_TYPE.ARMOR_LEGGINGS)
	.set_defense(4));

array_push(global.item_data, new ItemData(item_Weathered_Copper_Helmet, ITEM_TYPE.ARMOR_HELMET)
	.set_defense(2));

array_push(global.item_data, new ItemData(item_Weathered_Copper_Breastplate, ITEM_TYPE.ARMOR_BREASTPLATE)
	.set_defense(4));

array_push(global.item_data, new ItemData(item_Weathered_Copper_Leggings, ITEM_TYPE.ARMOR_LEGGINGS)
	.set_defense(3));

array_push(global.item_data, new ItemData(item_Tarnished_Copper_Helmet, ITEM_TYPE.ARMOR_HELMET)
	.set_defense(1));

array_push(global.item_data, new ItemData(item_Tarnished_Copper_Breastplate, ITEM_TYPE.ARMOR_BREASTPLATE)
	.set_defense(3));

array_push(global.item_data, new ItemData(item_Tarnished_Copper_Leggings, ITEM_TYPE.ARMOR_LEGGINGS)
	.set_defense(2));

array_push(global.item_data, new ItemData(item_Iron_Helmet, ITEM_TYPE.ARMOR_HELMET)
	.set_defense(5));

array_push(global.item_data, new ItemData(item_Iron_Breastplate, ITEM_TYPE.ARMOR_BREASTPLATE)
	.set_defense(7));

array_push(global.item_data, new ItemData(item_Iron_Leggings, ITEM_TYPE.ARMOR_LEGGINGS)
	.set_defense(6));

array_push(global.item_data, new ItemData(item_Golden_Helmet, ITEM_TYPE.ARMOR_HELMET)
	.set_defense(7));

array_push(global.item_data, new ItemData(item_Golden_Breastplate, ITEM_TYPE.ARMOR_BREASTPLATE)
	.set_defense(10));

array_push(global.item_data, new ItemData(item_Golden_Leggings, ITEM_TYPE.ARMOR_LEGGINGS)
	.set_defense(8));

array_push(global.item_data, new ItemData(item_Platinum_Helmet, ITEM_TYPE.ARMOR_HELMET)
	.set_defense(9));

array_push(global.item_data, new ItemData(item_Platinum_Breastplate, ITEM_TYPE.ARMOR_BREASTPLATE)
	.set_defense(14));

array_push(global.item_data, new ItemData(item_Platinum_Leggings, ITEM_TYPE.ARMOR_LEGGINGS)
	.set_defense(11));

array_push(global.item_data, new ItemData(item_Rotten_Potato, ITEM_TYPE.CONSUMABLE)
	.set_on_consume(function(_inst)
	{
		effect_set(BUFF_POISON, 10, 1, _inst);
	}));

array_push(global.item_data, new ItemData(item_Polished_Strata, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.POLISHED_STRATA)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Polished_Lumin_Stone, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.POLISHED_LUMIN_STONE)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Polished_Stone_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.POLISHED_STONE_WALL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Polished_Granite_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.POLISHED_GRANITE_WALL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Polished_Andesite_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.POLISHED_ANDESITE_WALL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Polished_Emustone_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.POLISHED_EMUSTONE_WALL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Polished_Basalt_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.POLISHED_BASALT_WALL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Polished_Strata_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.POLISHED_STRATA_WALL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Polished_Deadstone_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.POLISHED_DEADSTONE_WALL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Polished_Lumin_Stone_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.POLISHED_LUMIN_STONE_WALL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Granite_Bricks, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.GRANITE_BRICKS)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Andesite_Bricks, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.ANDESITE_BRICKS)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Strata_Bricks, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.STRATA_BRICKS)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Bricks_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 52)
	.set_drops(ITEM.BRICKS_WALL)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Granite_Bricks_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 52)
	.set_drops(ITEM.GRANITE_BRICKS_WALL)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Andesite_Bricks_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 52)
	.set_drops(ITEM.ANDESITE_BRICKS_WALL)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Strata_Bricks_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 52)
	.set_drops(ITEM.STRATA_BRICKS_WALL)
	.set_sfx(SFX.BRICKS));

array_push(global.item_data, new ItemData(item_Lantern, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 52)
	.set_drops(ITEM.LANTERN)
	.set_sfx(SFX.METAL));

array_push(global.item_data, new ItemData(item_Monolithos_Shrine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 148)
	.set_on_destroy(function(_x, _y, _z)
	{
		spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, BOSS.MONOLITHOS);
	}));

array_push(global.item_data, new ItemData(item_Flora_And_Fauna_Shrine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 148)
	.set_on_destroy(function(_x, _y, _z)
	{
		spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, BOSS.FLORA);
		spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, BOSS.FAUNA);
	}));

array_push(global.item_data, new ItemData(item_Glacia_Shrine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 148)
	.set_on_destroy(function(_x, _y, _z)
	{
		spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, BOSS.GLACIA);
	}));

array_push(global.item_data, new ItemData(item_Terra_Shrine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.GOLD, 148)
	.set_on_destroy(function(_x, _y, _z)
	{
		spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, BOSS.TERRA);
	}));
	
array_push(global.item_data, new ItemData(item_Fantasia_Shrine, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.PICKAXE, TOOL_POWER.PLATINUM, 148)
	.set_on_destroy(function(_x, _y, _z)
	{
		spawn_boss(_x * TILE_SIZE, _y * TILE_SIZE, BOSS.TERRA);
	}));

array_push(global.item_data, new ItemData(item_Brown_And_Sticky, ITEM_TYPE.SWORD)
	.set_damage(33));

array_push(global.item_data, new ItemData(item_Adventure_Is_Out_There, ITEM_TYPE.SWORD)
	.set_damage(33));

array_push(global.item_data, new ItemData(item_Inferno, ITEM_TYPE.BOW)
	.set_damage(33));

array_push(global.item_data, new ItemData(item_Rain_Bow, ITEM_TYPE.BOW)
	.set_damage(33));

array_push(global.item_data, new ItemData(item_Emerald_Prismatic_Gauntlet, ITEM_TYPE.SWORD)
	.set_damage(33));

array_push(global.item_data, new ItemData(item_Hoarders_Bane, ITEM_TYPE.SWORD)
	.set_damage(33));

array_push(global.item_data, new ItemData(item_Hoarders_Bane, ITEM_TYPE.SWORD)
	.set_damage(33));

array_push(global.item_data, new ItemData(item_Air_Sword, ITEM_TYPE.SWORD)
	.set_damage(33));

array_push(global.item_data, new ItemData(item_Hardened_Aphide, ITEM_TYPE.SOLID)
	.set_animation_type(ANIMATION_TYPE.CONNECTED)
	.set_flip_on(true, true)
	.set_mining_stats(ITEM_TYPE.PICKAXE,, 70)
	.set_drops(ITEM.HARDENED_APHIDE)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Hardened_Aphide_Wall, ITEM_TYPE.WALL)
	.set_mining_stats(ITEM_TYPE.HAMMER,, 52)
	.set_drops(ITEM.HARDENED_APHIDE_WALL)
	.set_sfx(SFX.STONE));

array_push(global.item_data, new ItemData(item_Mangrove_Chest, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CONTAINER)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.MANGROVE_CHEST));

array_push(global.item_data, new ItemData(item_Mangrove_Table, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.MANGROVE_TABLE));

array_push(global.item_data, new ItemData(item_Mangrove_Chair, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.MANGROVE_CHAIR));

array_push(global.item_data, new ItemData(item_Mangrove_Door, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.MANGROVE_DOOR));

array_push(global.item_data, new ItemData(item_Mahogany_Chest, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CONTAINER)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.MAHOGANY_CHEST));

array_push(global.item_data, new ItemData(item_Mahogany_Table, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.MAHOGANY_TABLE));

array_push(global.item_data, new ItemData(item_Mahogany_Chair, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.MAHOGANY_CHAIR));

array_push(global.item_data, new ItemData(item_Mahogany_Door, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.MAHOGANY_DOOR));

array_push(global.item_data, new ItemData(item_Blizzard_Chest, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CONTAINER)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BLIZZARD_CHEST));

array_push(global.item_data, new ItemData(item_Blizzard_Table, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BLIZZARD_TABLE));

array_push(global.item_data, new ItemData(item_Blizzard_Chair, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BLIZZARD_CHAIR));

array_push(global.item_data, new ItemData(item_Blizzard_Door, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.BLIZZARD_DOOR));

array_push(global.item_data, new ItemData(item_Pine_Chest, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CONTAINER)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.PINE_CHEST));

array_push(global.item_data, new ItemData(item_Pine_Table, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.PINE_TABLE));

array_push(global.item_data, new ItemData(item_Pine_Chair, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.PINE_CHAIR));

array_push(global.item_data, new ItemData(item_Pine_Door, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.PINE_DOOR));

array_push(global.item_data, new ItemData(item_Palm_Chest, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CONTAINER)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.PALM_CHEST));

array_push(global.item_data, new ItemData(item_Palm_Table, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.PALM_TABLE));

array_push(global.item_data, new ItemData(item_Palm_Chair, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.PALM_CHAIR));

array_push(global.item_data, new ItemData(item_Palm_Door, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.PALM_DOOR));

array_push(global.item_data, new ItemData(item_Ashen_Chest, ITEM_TYPE.UNTOUCHABLE, ITEM_TYPE.CONTAINER)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.ASHEN_CHEST));

array_push(global.item_data, new ItemData(item_Ashen_Table, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.ASHEN_TABLE));

array_push(global.item_data, new ItemData(item_Ashen_Chair, ITEM_TYPE.UNTOUCHABLE)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.ASHEN_CHAIR));

array_push(global.item_data, new ItemData(item_Ashen_Door, ITEM_TYPE.SOLID)
	.set_mining_stats(ITEM_TYPE.AXE,, 18)
	.set_drops(ITEM.ASHEN_DOOR));