enum BOSS_STATE_CHANGE_TYPE {
	LINEAR,
	RANDOM
}

enum BOSS_TYPE {
	SKY,
	SURFACE,
	CAVE
}

function BossData(_name, _sprite, _type, _icon = undefined) constructor
{
	name = _name;
	sprite = _sprite;
	type = _type;
	icon = _icon ?? asset_get_index($"ico_" + string_replace_all(_name, " ", "_"));
	
	if (icon == -1)
	{
		throw $"Boss icon '{_name}' does not exist";
	}
	
	hp = 500;
	
	static set_hp = function(_hp)
	{
		hp = _hp;
		
		return self;
	}
	
	speed = 0;
	
	static set_speed = function(a, b)
	{
		speed = (a << 8) | b;
		
		return self;
	}
	
	static set_xspeed = function(_xvelocity)
	{
		speed = (speed << 8) | (speed & 0xff);
		
		return self;
	}
	
	static get_xspeed = function()
	{
		return speed >> 8;
	}
	
	static set_yspeed = function(_yvelocity)
	{
		speed = (speed & 0xff00) | speed;
		
		return self;
	}
	
	static get_yspeed = function(_yvelocity)
	{
		return speed & 0xff;
	}
	
	explosion = prt_Luminoso;
	
	static set_explosion = function(_hp)
	{
		explosion = _hp;
		
		return self;
	}
	
	states = [];
	
	static add_state = function(attack)
	{
		array_push(states, attack);
		
		return self;
	}
	
	state_change_type_chance = (BOSS_STATE_CHANGE_TYPE.LINEAR << 8) | 1;
	
	static set_state_change = function(_type = BOSS_STATE_CHANGE_TYPE.LINEAR, _chance = 1)
	{
		state_change_type_chance = (_type << 8) | _chance;
		
		return self;
	}
	
	gravity_strength = PHYSICS_GLOBAL_GRAVITY;
	
	static set_gravity = function(_gravity)
	{
		gravity_strength = _gravity;
		
		return self;
	}
	
	bar_colours = [];
	
	static set_bar_colours = function(array)
	{
		bar_colours = array;
		
		return self;
	}
	
	rpc_icon = "game_icon";
	
	static set_rpc_icon = function(rpc)
	{
		rpc_icon = rpc;
		
		return self;
	}
}

global.boss_data = [];

array_push(global.boss_data, new BossData("Luminoso", bs_Luminoso, BOSS_TYPE.CAVE, ico_Luminoso)
	.set_hp(550)
	.set_bar_colours([
		#E9F2FC,
		#C4DBF6,
		#88AEE0
	])
	.set_xspeed(6)
	.set_explosion(prt_Luminoso)
	.add_state(function(px, py, obj)
	{
		var _user = instance_nearest(px, py, obj_Player);
		
		var _direction = (px > _user.x ? -1 : 1);
		
		obj.image_xscale = _direction;
		
		if (abs(_user.x - px) < TILE_SIZE * 8)
		{
			obj.xdirection = -_direction;
			
			with (obj)
			{
				if (tile_meeting(px + -_direction, py)) && (tile_meeting(px, py + 1))
				{
					yvelocity = -8;
				}
			}
		}
		else
		{
			obj.xdirection = 0;
		}
		
		if (chance(0.03))
		{
			repeat (irandom_range(1, 4))
			{
				spawn_projectile(px, py - 16, new Projectile(item_Red_Dye, 8)
					.set_speed(round(_direction * 2) * random_range(0.5, 4), -random_range(6, 12))
					.set_rotation(_direction * -random_range(24, 30))
					.set_destroy_on_collision()
					.add_cant_damage(obj));
			}
		}
	}));

array_push(global.boss_data, new BossData("Sapking", bs_Sapking, BOSS_TYPE.SURFACE, ico_Luminoso)
	.set_hp(1100)
	.set_bar_colours([
		#33B826,
		#EBE3F9,
		#B75E35
	]));

array_push(global.boss_data, new BossData("Toadtor", bs_Toadtor, BOSS_TYPE.SURFACE, ico_Luminoso)
	.set_hp(900)
	.set_bar_colours([
		#2FAF31,
		#256D38,
		#241935
	])
	.set_xspeed(8)
	.set_explosion(prt_Luminoso)
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (tile_meeting(px, py + 1))
			{
				if (chance(0.03))
				{
					var _inst = instance_nearest(px, py, obj_Player);
					
					var _direction = (point_distance(px, py, _inst.x, _inst.y) < TILE_SIZE * 16 ? choose(-1, 1) : (px > _inst.x ? -1 : 1));
					
					xdirection = _direction;
					yvelocity = -12;
				}
				else
				{
					xdirection = 0;
				}
			}
		}
	})
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (chance(0.03))
			{
				var _inst = instance_nearest(px, py, obj_Player);
				
				var _direction = (px > _inst.x ? -1 : 1);
				
				repeat (irandom_range(1, 3))
				{
					spawn_projectile(px, py - 16, new Projectile(proj_Toadtor_Bubble, 8)
						.set_speed(irandom_range(4, 10) * _direction, 0)
						.set_gravity(-random_range(0, 0.1))
						.set_destroy_on_collision()
						.set_life(irandom_range(30, 90))
						.add_cant_damage(obj));
				}
			}
		}
	}));

array_push(global.boss_data, new BossData("Revenant", bs_Revenant, BOSS_TYPE.CAVE)
	.set_hp(450)
	.set_bar_colours([
		#E9F2FC,
		#C4DBF6,
		#88AEE0
	])
	.set_xspeed(4)
	.set_explosion(prt_Luminoso)
	.add_state(function(px, py, obj)
	{
		var _user = instance_nearest(px, py, obj_Player);
		var _user_x = _user.x;
		
		var _direction = (px > _user_x ? -1 : 1);
		
		obj.image_xscale = _direction;
		
		if (abs(_user_x - px) < TILE_SIZE * 8)
		{
			obj.xdirection = -_direction;
		
			with (obj)
			{
				if (tile_meeting(px - _direction, py)) && (tile_meeting(px, py + 1))
				{
					yvelocity = -8;
				}
			}
		}
		else
		{
			obj.xdirection = 0;
		}
		
		if (chance(0.03))
		{
			spawn_projectile(px, py - 16, new Projectile(prt_Necropolis, 8)
				.set_speed(_direction * 3, 0)
				.set_gravity(0)
				.set_rotation(_direction * -3)
				.set_life(120)
				.set_collision(false)
				.add_cant_damage(obj));
		}
	}));

array_push(global.boss_data, new BossData("Arachnos", bs_Arachnos, BOSS_TYPE.CAVE,)
	.set_hp(450)
	.set_bar_colours([
		#E9F2FC,
		#C4DBF6,
		#88AEE0
	])
	.set_explosion(prt_Luminoso)
	.set_gravity(0)
	.add_state(function(px, py, obj)
	{
		var _user = instance_nearest(px, py, obj_Player);
		var _user_x = _user.x;
		var _user_y = _user.y;
		
		if (abs(px - _user_x) < TILE_SIZE * 6)
		{
			obj.x += (px > _user_x ? 6 : -6);
		}
		
		if (abs(py - _user_y) < TILE_SIZE * 6)
		{
			obj.y += (py > _user_y ? 6 : -6);
		}
	})
	.add_state(function(px, py, obj)
	{
		var _user = instance_nearest(px, py, obj_Player);
		var _user_x = _user.x;
		var _user_y = _user.y;
		
		if (chance(0.03))
		{
			var _xdirection = (px > _user_x ? -8 : 8);
			var _ydirection = (py > _user_y ? -8 : 8);
			
			repeat (irandom_range(2, 6))
			{
				spawn_projectile(px, py - 16, new Projectile(item_Red_Dye, irandom_range(4, 8))
					.set_speed(_xdirection * random_range(0.8, 1.2), _ydirection * random_range(0.8, 1.2))
					.set_life(30, 60)
					.set_destroy_on_collision()
					.add_cant_damage(obj));
			}
		}
		
		/*
		var _direction = (px > _user_x ? -1 : 1);
		
		obj.image_xscale = _direction;
		
		if (abs(_user_x - px) < TILE_SIZE * 4)
		{
			obj.xdirection = -_direction;
			
			with (obj)
			{
				if (tile_meeting(px + -_direction, py)) && (tile_meeting(px, py + 1))
				{
					yvelocity = -8;
				}
			}
		}
		else
		{
			obj.xdirection = 0;
		}
		
		if (chance(0.03))
		{
			repeat (irandom_range(1, 4))
			{
				spawn_projectile(px, py - 16, new Projectile(item_Red_Dye, 8)
					.set_speed(round(_direction * 2) * random_range(0.5, 4), -random_range(6, 12))
					.set_rotation(_direction * -random_range(24, 30))
					.set_destroy_on_collision()
					.add_cant_damage(obj));
			}
		}
		*/
	}));

array_push(global.boss_data, new BossData("Larvelt", bs_Larvelt, BOSS_TYPE.CAVE, ico_Luminoso)
	.set_hp(450)
	.set_bar_colours([
		#E9F2FC,
		#C4DBF6,
		#88AEE0
	])
	.set_xspeed(6)
	.set_explosion(prt_Luminoso)
	.add_state(function(px, py, obj)
	{
		var _user = instance_nearest(px, py, obj_Player);
		
		var _direction = (px > _user.x ? -1 : 1);
		
		obj.image_xscale = _direction;
		
		if (abs(_user.x - px) < TILE_SIZE * 8)
		{
			obj.xdirection = -_direction;
			
			with (obj)
			{
				if (tile_meeting(px + -_direction, py)) && (tile_meeting(px, py + 1))
				{
					yvelocity = -8;
				}
			}
		}
		else
		{
			obj.xdirection = 0;
		}
		
		if (chance(0.03))
		{
			repeat (irandom_range(1, 4))
			{
				spawn_projectile(px, py - 16, new Projectile(item_Red_Dye, 8)
					.set_speed(round(_direction * 2) * random_range(0.5, 4), -random_range(6, 12))
					.set_rotation(_direction * -random_range(24, 30))
					.set_destroy_on_collision()
					.add_cant_damage(obj));
			}
		}
	}));

array_push(global.boss_data, new BossData("Vicuz", bs_Vicuz, BOSS_TYPE.CAVE, ico_Luminoso)
	.set_hp(450)
	.set_bar_colours([
		#E9F2FC,
		#C4DBF6,
		#88AEE0
	])
	.set_xspeed(6)
	.set_explosion(prt_Luminoso)
	.add_state(function(px, py, obj)
	{
		var _user = instance_nearest(px, py, obj_Player);
		
		var _direction = (px > _user.x ? -1 : 1);
		
		obj.image_xscale = _direction;
		
		if (abs(_user.x - px) < TILE_SIZE * 8)
		{
			obj.xdirection = -_direction;
			
			with (obj)
			{
				if (tile_meeting(px + -_direction, py)) && (tile_meeting(px, py + 1))
				{
					yvelocity = -8;
				}
			}
		}
		else
		{
			obj.xdirection = 0;
		}
		
		if (chance(0.03))
		{
			repeat (irandom_range(1, 4))
			{
				spawn_projectile(px, py - 16, new Projectile(item_Red_Dye, 8)
					.set_speed(round(_direction * 2) * random_range(0.5, 4), -random_range(6, 12))
					.set_rotation(_direction * -random_range(24, 30))
					.set_destroy_on_collision()
					.add_cant_damage(obj));
			}
		}
	}));

array_push(global.boss_data, new BossData("Arid", bs_Toadtor, BOSS_TYPE.SURFACE, ico_Luminoso)
	.set_hp(900)
	.set_bar_colours([
		#2FAF31,
		#256D38,
		#241935
	])
	.set_xspeed(8)
	.set_explosion(prt_Luminoso)
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (tile_meeting(px, py + 1))
			{
				if (chance(0.03))
				{
					var _inst = instance_nearest(px, py, obj_Player);
					
					var _direction = (point_distance(px, py, _inst.x, _inst.y) < TILE_SIZE * 16 ? choose(-1, 1) : (px > _inst.x ? -1 : 1));
					
					xdirection = _direction;
					yvelocity = -12;
				}
				else
				{
					xdirection = 0;
				}
			}
		}
	})
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (chance(0.03))
			{
				var _inst = instance_nearest(px, py, obj_Player);
				
				var _direction = (px > _inst.x ? -1 : 1);
				
				repeat (irandom_range(1, 3))
				{
					spawn_projectile(px, py - 16, new Projectile(proj_Toadtor_Bubble, 8)
						.set_speed(irandom_range(4, 10) * _direction, 0)
						.set_gravity(-random_range(0, 0.1))
						.set_destroy_on_collision()
						.set_life(irandom_range(30, 90))
						.add_cant_damage(obj));
				}
			}
		}
	}));

array_push(global.boss_data, new BossData("Terra", bs_Toadtor, BOSS_TYPE.SURFACE, ico_Luminoso)
	.set_hp(900)
	.set_bar_colours([
		#2FAF31,
		#256D38,
		#241935
	])
	.set_xspeed(8)
	.set_explosion(prt_Luminoso)
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (tile_meeting(px, py + 1))
			{
				if (chance(0.03))
				{
					var _inst = instance_nearest(px, py, obj_Player);
					
					var _direction = (point_distance(px, py, _inst.x, _inst.y) < TILE_SIZE * 16 ? choose(-1, 1) : (px > _inst.x ? -1 : 1));
					
					xdirection = _direction;
					yvelocity = -12;
				}
				else
				{
					xdirection = 0;
				}
			}
		}
	})
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (chance(0.03))
			{
				var _inst = instance_nearest(px, py, obj_Player);
				
				var _direction = (px > _inst.x ? -1 : 1);
				
				repeat (irandom_range(1, 3))
				{
					spawn_projectile(px, py - 16, new Projectile(proj_Toadtor_Bubble, 8)
						.set_speed(irandom_range(4, 10) * _direction, 0)
						.set_gravity(-random_range(0, 0.1))
						.set_destroy_on_collision()
						.set_life(irandom_range(30, 90))
						.add_cant_damage(obj));
				}
			}
		}
	}));

array_push(global.boss_data, global.boss_data, new BossData("Flora", bs_Toadtor, BOSS_TYPE.SURFACE, ico_Luminoso)
	.set_hp(900)
	.set_bar_colours([
		#2FAF31,
		#256D38,
		#241935
	])
	.set_xspeed(8)
	.set_explosion(prt_Luminoso)
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (tile_meeting(px, py + 1))
			{
				if (chance(0.03))
				{
					var _inst = instance_nearest(px, py, obj_Player);
					
					var _direction = (point_distance(px, py, _inst.x, _inst.y) < TILE_SIZE * 16 ? choose(-1, 1) : (px > _inst.x ? -1 : 1));
					
					xdirection = _direction;
					yvelocity = -12;
				}
				else
				{
					xdirection = 0;
				}
			}
		}
	})
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (chance(0.03))
			{
				var _inst = instance_nearest(px, py, obj_Player);
				
				var _direction = (px > _inst.x ? -1 : 1);
				
				repeat (irandom_range(1, 3))
				{
					spawn_projectile(px, py - 16, new Projectile(proj_Toadtor_Bubble, 8)
						.set_speed(irandom_range(4, 10) * _direction, 0)
						.set_gravity(-random_range(0, 0.1))
						.set_destroy_on_collision()
						.set_life(irandom_range(30, 90))
						.add_cant_damage(obj));
				}
			}
		}
	}));

array_push(global.boss_data, new BossData("Fauna", bs_Toadtor, BOSS_TYPE.SURFACE, ico_Luminoso)
	.set_hp(900)
	.set_bar_colours([
		#2FAF31,
		#256D38,
		#241935
	])
	.set_xspeed(8)
	.set_explosion(prt_Luminoso)
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (tile_meeting(px, py + 1))
			{
				if (chance(0.03))
				{
					var _inst = instance_nearest(px, py, obj_Player);
					
					var _direction = (point_distance(px, py, _inst.x, _inst.y) < TILE_SIZE * 16 ? choose(-1, 1) : (px > _inst.x ? -1 : 1));
					
					xdirection = _direction;
					yvelocity = -12;
				}
				else
				{
					xdirection = 0;
				}
			}
		}
	})
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (chance(0.03))
			{
				var _inst = instance_nearest(px, py, obj_Player);
				
				var _direction = (px > _inst.x ? -1 : 1);
				
				repeat (irandom_range(1, 3))
				{
					spawn_projectile(px, py - 16, new Projectile(proj_Toadtor_Bubble, 8)
						.set_speed(irandom_range(4, 10) * _direction, 0)
						.set_gravity(-random_range(0, 0.1))
						.set_destroy_on_collision()
						.set_life(irandom_range(30, 90))
						.add_cant_damage(obj));
				}
			}
		}
	}));

array_push(global.boss_data, new BossData("Monolithos", bs_Toadtor, BOSS_TYPE.SURFACE, ico_Luminoso)
	.set_hp(900)
	.set_bar_colours([
		#2FAF31,
		#256D38,
		#241935
	])
	.set_xspeed(8)
	.set_explosion(prt_Luminoso)
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (tile_meeting(px, py + 1))
			{
				if (chance(0.03))
				{
					var _inst = instance_nearest(px, py, obj_Player);
					
					var _direction = (point_distance(px, py, _inst.x, _inst.y) < TILE_SIZE * 16 ? choose(-1, 1) : (px > _inst.x ? -1 : 1));
					
					xdirection = _direction;
					yvelocity = -12;
				}
				else
				{
					xdirection = 0;
				}
			}
		}
	})
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (chance(0.03))
			{
				var _inst = instance_nearest(px, py, obj_Player);
				
				var _direction = (px > _inst.x ? -1 : 1);
				
				repeat (irandom_range(1, 3))
				{
					spawn_projectile(px, py - 16, new Projectile(proj_Toadtor_Bubble, 8)
						.set_speed(irandom_range(4, 10) * _direction, 0)
						.set_gravity(-random_range(0, 0.1))
						.set_destroy_on_collision()
						.set_life(irandom_range(30, 90))
						.add_cant_damage(obj));
				}
			}
		}
	}));

array_push(global.boss_data, new BossData("Glacia", bs_Toadtor, BOSS_TYPE.SURFACE, ico_Luminoso)
	.set_hp(1500)
	.set_bar_colours([
		#2FAF31,
		#256D38,
		#241935
	])
	.set_xspeed(8)
	.set_explosion(prt_Luminoso)
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (tile_meeting(px, py + 1))
			{
				if (chance(0.03))
				{
					var _inst = instance_nearest(px, py, obj_Player);
					
					var _direction = (point_distance(px, py, _inst.x, _inst.y) < TILE_SIZE * 16 ? choose(-1, 1) : (px > _inst.x ? -1 : 1));
					
					xdirection = _direction;
					yvelocity = -12;
				}
				else
				{
					xdirection = 0;
				}
			}
		}
	})
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (chance(0.03))
			{
				var _inst = instance_nearest(px, py, obj_Player);
				
				var _direction = (px > _inst.x ? -1 : 1);
				
				repeat (irandom_range(1, 3))
				{
					spawn_projectile(px, py - 16, new Projectile(proj_Toadtor_Bubble, 8)
						.set_speed(irandom_range(4, 10) * _direction, 0)
						.set_gravity(-random_range(0, 0.1))
						.set_destroy_on_collision()
						.set_life(irandom_range(30, 90))
						.add_cant_damage(obj));
				}
			}
		}
	}));

array_push(global.boss_data, new BossData("Fantasia", bs_Toadtor, BOSS_TYPE.SKY, ico_Luminoso)
	.set_hp(4000)
	.set_bar_colours([
		#2FAF31,
		#256D38,
		#241935
	])
	.set_xspeed(8)
	.set_explosion(prt_Luminoso)
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (tile_meeting(px, py + 1))
			{
				if (chance(0.03))
				{
					var _inst = instance_nearest(px, py, obj_Player);
					
					var _direction = (point_distance(px, py, _inst.x, _inst.y) < TILE_SIZE * 16 ? choose(-1, 1) : (px > _inst.x ? -1 : 1));
					
					xdirection = _direction;
					yvelocity = -12;
				}
				else
				{
					xdirection = 0;
				}
			}
		}
	})
	.add_state(function(px, py, obj)
	{
		with (obj)
		{
			if (chance(0.03))
			{
				var _inst = instance_nearest(px, py, obj_Player);
				
				var _direction = (px > _inst.x ? -1 : 1);
				
				repeat (irandom_range(1, 3))
				{
					spawn_projectile(px, py - 16, new Projectile(proj_Toadtor_Bubble, 8)
						.set_speed(irandom_range(4, 10) * _direction, 0)
						.set_gravity(-random_range(0, 0.1))
						.set_destroy_on_collision()
						.set_life(irandom_range(30, 90))
						.add_cant_damage(obj));
				}
			}
		}
	}));