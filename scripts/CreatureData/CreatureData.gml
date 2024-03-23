enum CREATURE_HOSTILITY_TYPE {
	PASSIVE,
	HOSTILE
}

enum CREATURE_MOVE_TYPE {
	DEFAULT,
	FLY,
	SWIM
}

function CreatureData(_name, _type, _hp) constructor
{
	name = _name;
	type = (_type << 4) | CREATURE_MOVE_TYPE.DEFAULT;
	
	static get_type = function()
	{
		return type >> 4;
	}
	
	hp = _hp;
	
	static set_move_type = function(_type)
	{
		type = (type & 0xf0) | _type;
		
		return self;
	}
	
	static get_move_type = function()
	{
		return type & 0xf;
	}
	
	#region Sprite Handler
	
	sprite_idle   = [];
	sprite_moving = [];
	
	var _sprite_name = $"crt_{string_replace_all(_name, " ", "_")}";
	var _idle = asset_get_index(_sprite_name + "_Idle");
	
	sprite_type = -1;
	
	if (_idle != -1)
	{
		sprite_idle[@ 0] = _idle;
		sprite_moving[@ 0] = asset_get_index(_sprite_name + "_Moving");
	}
	else
	{
		_idle = asset_get_index(_sprite_name + "_00_Idle");
		
		if (_idle != -1)
		{
			static set_sprite_type = function(_func)
			{
				sprite_type = _func;
				
				return self;
			}
			
			var i = 0;
			var _i;
		
			while (true)
			{
				if (i > 99)
				{
					throw $"{_name} can not have more than 99 sprite variation";
				}
				
				_i = (i < 10 ? "0" : "") + string(i);
			
				_idle = asset_get_index(_sprite_name + $"_{_i}_Idle");
			
				if (_idle == -1) break;
			
				sprite_idle[@ i] = _idle;
				sprite_moving[@ i] = asset_get_index(_sprite_name + $"_{_i}_Moving");
			
				++i;
			}
		}
		else
		{
			throw $"{_name} ({_sprite_name}) has an invalid sprite";
		}
	}
	
	#endregion
	
	physics = (1 << 24) | (1 << 16) | (1 << 8) | PHYSICS_PLAYER_JUMP_HEIGHT;
	
	static set_xspeed = function(_speed)
	{
		physics = (_speed << 16) | (physics & 0xf00ffff);
		
		return self;
	}
	
	static get_xspeed = function()
	{
		return (physics >> 16) & 0xff;
	}
	
	static set_yspeed = function(_speed)
	{
		physics = (_speed << 8) | (physics & 0xfff00ff);
		
		return self;
	}	
	
	static get_yspeed = function()
	{
		return (physics >> 8) & 0xff;
	}
	
	static set_jump_height = function(_speed)
	{
		physics = (physics & 0xfffff00) | _speed;
		
		return self;
	}
	
	static get_jump_height = function()
	{
		return physics & 0xff;
	}
	
	static set_can_jump = function(_can_jump = true)
	{
		physics = (_can_jump << 24) & 0x0ffffff;
		
		return self;
	}
	
	static get_can_jump = function(_can_jump = true)
	{
		return physics >> 24;
	}
	
	// colour_offset = 0b1_1111111_1_1111111_1_1111111;
	colour_offset = 0;
	
	static set_colour_offset = function(_r, _g, _b)
	{
		colour_offset = light_get_offset(_r, _g, _b);
				
		return self;
	}
	
	drops = [];
	
	static add_drop = function(_item, _min_amount, _max_amount, _chance)
	{
		array_push(drops, (_item << 24) | (_max_amount << 16) | (_max_amount << 8) | round(_chance * 100));
		
		return self;
	}
	
	sfx = SFX.EMPTY;
	
	static set_sfx = function(_sfx)
	{
		sfx = _sfx;
		
		return self;
	}
	
	on_draw = -1;
	
	static set_on_draw = function(_func)
	{
		on_draw = _func;
		
		return self;
	}
	
	if (_type == CREATURE_HOSTILITY_TYPE.HOSTILE)
	{
		damage = 4;
		
		static set_damage = function(_damage)
		{
			damage = _damage;
			
			return self;
		}
	}
}

#region 0-49

global.creature_data = [];

array_push(global.creature_data, new CreatureData("Chicken", CREATURE_HOSTILITY_TYPE.PASSIVE, 4)
	.add_drop(ITEM.RAW_CHICKEN, 1, 1, 1)
	.add_drop(ITEM.FEATHER, 1, 3, 1)
	.set_sfx(SFX.CHICKEN));

array_push(global.creature_data, new CreatureData("Fox", CREATURE_HOSTILITY_TYPE.PASSIVE, 12));

array_push(global.creature_data, new CreatureData("Dragonfly", CREATURE_HOSTILITY_TYPE.PASSIVE, 4)
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2));

array_push(global.creature_data, new CreatureData("Cod", CREATURE_HOSTILITY_TYPE.PASSIVE, 6)
	.set_move_type(CREATURE_MOVE_TYPE.SWIM)
	.set_xspeed(3)
	.add_drop(ITEM.RAW_COD, 1, 3, 1));

array_push(global.creature_data, new CreatureData("Rabbit", CREATURE_HOSTILITY_TYPE.PASSIVE, 10)
	.add_drop(ITEM.RAW_RABBIT, 1, 1, 1)
	.add_drop(ITEM.RABBIT_FOOT, 1, 1, 0.05)
	.add_drop(ITEM.RABBIT_HIDE, 1, 4, 0.8));

array_push(global.creature_data, new CreatureData("Bee", CREATURE_HOSTILITY_TYPE.PASSIVE, 4)
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(1)
	.set_yspeed(2));

array_push(global.creature_data, new CreatureData("Chick", CREATURE_HOSTILITY_TYPE.PASSIVE, 2));

array_push(global.creature_data, new CreatureData("Snail", CREATURE_HOSTILITY_TYPE.PASSIVE, 2)
	.set_xspeed(1)
	.set_can_jump(false));

array_push(global.creature_data, new CreatureData("Bird", CREATURE_HOSTILITY_TYPE.PASSIVE, 4)
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2)
	.set_yspeed(1)
	.add_drop(ITEM.FEATHER, 1, 3, 1));

array_push(global.creature_data, new CreatureData("Cow", CREATURE_HOSTILITY_TYPE.PASSIVE, 24)
	.add_drop(ITEM.RAW_BEEF, 1, 2, 1)
	.add_drop(ITEM.LEATHER, 1, 3, 0.9));

array_push(global.creature_data, new CreatureData("Frog", CREATURE_HOSTILITY_TYPE.PASSIVE, 12)
	.add_drop(ITEM.RAW_FROG_LEG, 1, 1, 1));

array_push(global.creature_data, new CreatureData("Toad", CREATURE_HOSTILITY_TYPE.PASSIVE, 10));

array_push(global.creature_data, new CreatureData("Raccoon", CREATURE_HOSTILITY_TYPE.PASSIVE, 10));

array_push(global.creature_data, new CreatureData("Capybara", CREATURE_HOSTILITY_TYPE.PASSIVE, 12));

array_push(global.creature_data, new CreatureData("Nightwalker", CREATURE_HOSTILITY_TYPE.PASSIVE, 20));

array_push(global.creature_data, new CreatureData("Camel", CREATURE_HOSTILITY_TYPE.PASSIVE, 24));

array_push(global.creature_data, new CreatureData("Duck", CREATURE_HOSTILITY_TYPE.PASSIVE, 12)
	.add_drop(ITEM.FEATHER, 1, 3, 1));

array_push(global.creature_data, new CreatureData("Turkey", CREATURE_HOSTILITY_TYPE.PASSIVE, 8)
	.set_xspeed(5)
	.add_drop(ITEM.FEATHER, 1, 4, 1)
	.add_drop(ITEM.RAW_WHOLE_TURKEY, 1, 1, 1));

array_push(global.creature_data, new CreatureData("Ostrich", CREATURE_HOSTILITY_TYPE.PASSIVE, 24)
	.add_drop(ITEM.FEATHER, 1, 3, 1));

array_push(global.creature_data, new CreatureData("Squirrel", CREATURE_HOSTILITY_TYPE.PASSIVE, 12));

array_push(global.creature_data, new CreatureData("Penguin", CREATURE_HOSTILITY_TYPE.PASSIVE, 12)
	.add_drop(ITEM.FEATHER, 1, 2, 0.8));

array_push(global.creature_data, new CreatureData("Zombie", CREATURE_HOSTILITY_TYPE.HOSTILE, 12)
	.set_xspeed(2)
	.add_drop(ITEM.ZOMBIE_FLESH, 1, 4, 1)
	.set_damage(6));

array_push(global.creature_data, new CreatureData("Rat", CREATURE_HOSTILITY_TYPE.PASSIVE, 6)
	.set_xspeed(5)
	.set_sfx(SFX.RAT));

array_push(global.creature_data, new CreatureData("Mummy", CREATURE_HOSTILITY_TYPE.HOSTILE, 12)
	.add_drop(ITEM.ZOMBIE_FLESH, 1, 3, 1)
	.add_drop(ITEM.MUMMY_WRAP, 1, 1, 0.2)
	.set_damage(8));

array_push(global.creature_data, new CreatureData("Toucan", CREATURE_HOSTILITY_TYPE.PASSIVE, 6)
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2)
	.set_yspeed(1)
	.add_drop(ITEM.FEATHER, 1, 3, 1));

array_push(global.creature_data, new CreatureData("Parrot", CREATURE_HOSTILITY_TYPE.PASSIVE, 6)
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2)
	.set_yspeed(1)
	.add_drop(ITEM.FEATHER, 1, 3, 1));

array_push(global.creature_data, new CreatureData("Red Panda", CREATURE_HOSTILITY_TYPE.PASSIVE, 14));

array_push(global.creature_data, new CreatureData("Horse", CREATURE_HOSTILITY_TYPE.PASSIVE, 30)
	.add_drop(ITEM.LEATHER, 1, 3, 0.9));

array_push(global.creature_data, new CreatureData("Meerkat", CREATURE_HOSTILITY_TYPE.PASSIVE, 12));

array_push(global.creature_data, new CreatureData("Miner Zombie", CREATURE_HOSTILITY_TYPE.HOSTILE, 20)
	.add_drop(ITEM.ZOMBIE_FLESH, 1, 3, 1)
	.add_drop(ITEM.TORCH, 2, 8, 1)
	.add_drop(ITEM.COAL, 1, 2, 0.6)
	.add_drop(ITEM.RAW_WEATHERED_COPPER, 1, 2, 0.3)
	.add_drop(ITEM.RAW_IRON, 1, 2, 0.15)
	.set_damage(8));

array_push(global.creature_data, new CreatureData("Owl", CREATURE_HOSTILITY_TYPE.PASSIVE, 8)
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2)
	.set_yspeed(3)
	.add_drop(ITEM.FEATHER, 1, 3, 1));

array_push(global.creature_data, new CreatureData("Crab", CREATURE_HOSTILITY_TYPE.PASSIVE, 10)
	.add_drop(ITEM.RAW_CRAB, 1, 2, 0.8)
	.add_drop(ITEM.CRAB_CLAW, 1, 1, 0.04));

array_push(global.creature_data, new CreatureData("Vulture", CREATURE_HOSTILITY_TYPE.PASSIVE, 14)
	.set_move_type(CREATURE_MOVE_TYPE.FLY));

array_push(global.creature_data, new CreatureData("Tortoise", CREATURE_HOSTILITY_TYPE.PASSIVE, 36)
	.add_drop(ITEM.TURTLE_SHELL, 1, 2, 0.75));

array_push(global.creature_data, new CreatureData("Platypus", CREATURE_HOSTILITY_TYPE.PASSIVE, 14));

array_push(global.creature_data, new CreatureData("Ghost", CREATURE_HOSTILITY_TYPE.HOSTILE, 24)
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2)
	.set_yspeed(1)
	.set_damage(10));

array_push(global.creature_data, new CreatureData("Scorpion", CREATURE_HOSTILITY_TYPE.HOSTILE, 10)
	.set_damage(6));

array_push(global.creature_data, new CreatureData("Beetle", CREATURE_HOSTILITY_TYPE.PASSIVE, 4));

array_push(global.creature_data, new CreatureData("Turtle", CREATURE_HOSTILITY_TYPE.PASSIVE, 24)
	.add_drop(ITEM.TURTLE_SHELL, 2, 4, 1));

array_push(global.creature_data, new CreatureData("Anubis", CREATURE_HOSTILITY_TYPE.HOSTILE, 50)
	.add_drop(ITEM.MUMMY_WRAP, 1, 1, 0.1)
	.set_damage(14));

array_push(global.creature_data, new CreatureData("Weasel", CREATURE_HOSTILITY_TYPE.PASSIVE, 8));

array_push(global.creature_data, new CreatureData("Zebra", CREATURE_HOSTILITY_TYPE.PASSIVE, 12)
	.add_drop(ITEM.LEATHER, 1, 3, 0.9));

array_push(global.creature_data, new CreatureData("Lumin Bat", CREATURE_HOSTILITY_TYPE.HOSTILE, 24)
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2)
	.add_drop(ITEM.ZOMBIE_FLESH, 1, 3, 1)
	.set_damage(9)
	.set_sfx(SFX.RAT));

array_push(global.creature_data, new CreatureData("Goat", CREATURE_HOSTILITY_TYPE.PASSIVE, 12));

array_push(global.creature_data, new CreatureData("Skeleton", CREATURE_HOSTILITY_TYPE.HOSTILE, 24)
	.add_drop(ITEM.BONE, 2, 6, 1)
	.set_damage(6));

array_push(global.creature_data, new CreatureData("Ladybug", CREATURE_HOSTILITY_TYPE.PASSIVE, 4)
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(1)
	.set_yspeed(2));

array_push(global.creature_data, new CreatureData("Butterfly", CREATURE_HOSTILITY_TYPE.PASSIVE, 4)
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(1)
	.set_yspeed(2));

array_push(global.creature_data, new CreatureData("Spider", CREATURE_HOSTILITY_TYPE.HOSTILE, 30)
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(1)
	.set_yspeed(2)
	.set_damage(5));

array_push(global.creature_data, new CreatureData("Wraith", CREATURE_HOSTILITY_TYPE.HOSTILE, 32)
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(1)
	.set_yspeed(2)
	.set_damage(8));

array_push(global.creature_data, new CreatureData("Bat", CREATURE_HOSTILITY_TYPE.HOSTILE, 12)
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(3)
	.set_yspeed(4)
	.set_sfx(SFX.RAT));

#endregion

#region 50-99

array_push(global.creature_data, new CreatureData("Firefly", CREATURE_HOSTILITY_TYPE.PASSIVE, 2)
	.set_move_type(CREATURE_MOVE_TYPE.FLY)
	.set_xspeed(2)
	.set_yspeed(3)
	.set_on_draw(function(_x, _y, _xscale, _yscale, _angle, _colour, _alpha)
	{
		draw_sprite_ext(crt_Firefly_Light, 0, _x, _y, _xscale, _yscale, _angle, c_white, _alpha);
	}));

array_push(global.creature_data, new CreatureData("Lumin Golem", CREATURE_HOSTILITY_TYPE.HOSTILE, 40)
	.set_xspeed(2)
	.add_drop(ITEM.LUMIN_SHARD, 1, 3, 1)
	.set_damage(9));

array_push(global.creature_data, new CreatureData("Beetlite", CREATURE_HOSTILITY_TYPE.HOSTILE, 14)
	.set_xspeed(2)
	.set_damage(4));

array_push(global.creature_data, new CreatureData("Slime", CREATURE_HOSTILITY_TYPE.HOSTILE, 8)
	.set_xspeed(3)
	.set_damage(6));

#endregion