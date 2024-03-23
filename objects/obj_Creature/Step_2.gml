if (obj_Control.is_paused) exit;

var _camera = global.camera;

var _camera_x = _camera.x;
var _camera_y = _camera.y;

if (rectangle_distance(x, y, _camera_x, _camera_y, _camera_x + _camera.width, _camera_y + _camera.height) > TILE_SIZE * 8)
{
	instance_destroy();
	
	exit;
}

// var _item_data = global.item_data;

#macro CREATURE_PASSIVE_PANIC_SECONDS 3
#macro CREATURE_HOSTILE_SEARCH_DISTANCE 8

var _data = global.creature_data[creature_id];

var _type = _data.get_type();
var _move_type = _data.get_move_type();

var _sfx = _data.sfx;

var _delta_time = global.delta_time;

if (chance(0.03 * _delta_time))
{
	sfx_play(x, y, _sfx, (_type == CREATURE_HOSTILITY_TYPE.PASSIVE && panic_time > 0 ? "panic" : "idle"));
}

#region Damage Handler

if (panic_time > 0)
{
	panic_time -= _delta_time;
}

if (immunity_frame > 0)
{
	immunity_frame += _delta_time;
	
	if (immunity_frame >= IMMUNITY_FRAME_MAX)
	{
		immunity_frame = 0;
	}
}

if (immunity_frame == 0)
{
	var _damager = instance_place(x, y, obj_Tool);
	
	var _damage = 0;
	var _damage_type = undefined;
	
	var _is_projectile = false;
	
	if (_damager)
	{
		_damage = _damager.damage;
		_damage_type = _damager.damage_type;
	}
	else
	{
		_damager = instance_place(x - obj_Player.x, y - obj_Player.y - 512, obj_Whip);
		
		if (_damager)
		{
			_damage = obj_Player.whip_damage;
			_damage_type = DAMAGE_TYPE.MELEE;
		}
	}
	
	if (_damager)
	{
		_damage = round(_damage * accessory_get_buff(BUFF_STRENGTH, obj_Player) * random_range(0.9, 1.1));
		
		if (_damage > 0)
		{
			hp_add(id, -_damage, _damage_type);
			
			if (_type == CREATURE_HOSTILITY_TYPE.PASSIVE)
			{
				panic_time = GAME_FPS * CREATURE_PASSIVE_PANIC_SECONDS;
			}
			
			yvelocity = -3;
			immunity_frame = 1;
			
			sfx_play(x, y, _sfx, "damage");
		}
		
		if (_is_projectile) && (_damager.destroy_on_collision)
		{
			instance_destroy(_damager);
		}
	}
}

if (hp <= 0)
{
	randomize();
	
	var _drop;
	var _drops = _data.drops;
	var _drops_length = array_length(_drops);
	
	var i = 0;
	
	repeat (_drops_length)
	{
		_drop = _drops[i++];
		
		if (irandom(99) < (_drop & 0xff))
		{
			spawn_drop(x, y, _drop >> 24, irandom_range((_drop >> 16) & 0xff, (_drop >> 8) & 0xff), random(2), irandom_range(-1, 1));
		}
	}
	
	spawn_particle(x, y, CHUNK_DEPTH_DEFAULT + 1, new Particle()
		.set_sprite(prt_Creature_Death_00, prt_Creature_Death_01)
		.set_speed([-0.5, 0.5], [-0.5, -0.3])
		.set_rotation(-5, 5)
		.set_life(10, 25)
		.set_fade_out(), irandom_range(6, 10));
	
	instance_destroy();
	
	// TODO: Fix Bestiary
	// ++global.bestiary.creature[creature_id];
	
	exit;
}

#endregion

#region X Movement

var _x = round(x / TILE_SIZE) + xdirection;
var _y = round(y / TILE_SIZE);
	
var _fall_amount = 0;

#macro CREATURE_AI_FALL_CHECK 6
#macro CREATURE_AI_FALL_SWITCH_X_CHANCE 0.25

var i = 1;

repeat (CREATURE_AI_FALL_CHECK)
{
	if (tile_get(_x, _y + i, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY) break;
	
	++_fall_amount;
	++i;
}

if (panic_time <= 0)
{
	/*
	if (fall_time == 0)
	{
		var _use_random_direction = true;
		var _hostile_check = true;
		
		if (_fall_amount > 5)
		{
			if (_move_type == CREATURE_MOVE_TYPE.DEFAULT)
			{
				xdirection = (random(_delta_time) > CREATURE_AI_FALL_SWITCH_X_CHANCE * _delta_time ? -xdirection : 0);
			}
			
			_use_random_direction = false;
			_hostile_check = false;
		}
		
		if (_hostile_check) && (_type == CREATURE_HOSTILITY_TYPE.HOSTILE)
		{
			searching = instance_nearest(x, y, obj_Player);
			
			if (searching)
			{
				var _sx = searching.x;
				
				if (point_distance(x, y, _sx, searching.y) < TILE_SIZE * CREATURE_HOSTILE_SEARCH_DISTANCE)
				{
					xdirection = (_sx > x ? 1 : -1);
					
					_use_random_direction = false;
				}
			}
		}
		
		if (_use_random_direction) && (chance(0.01 * _delta_time))
		{
			xdirection = choose(-1, 0, 0, 0, 1);
		}
		
		if (xdirection != 0)
		{
			sprite_index = _data.sprite_moving[index];
			image_xscale = xdirection;
		}
		else
		{
			sprite_index = _data.sprite_idle[index];
		}
	}
	*/
}
else
{
	xdirection = (obj_Player.x > x ? -1 : 1);

	sprite_index = _data.sprite_moving[index];
	image_xscale = xdirection;
}

var xvelocity_sign = sign(xvelocity);

#endregion

#region Y Movement

physics_bury();

if (_move_type == CREATURE_MOVE_TYPE.DEFAULT)
{
	physics_y();
	if /*(_data.get_can_jump() && fall_time < 3) && */(_type != CREATURE_HOSTILITY_TYPE.HOSTILE || (instance_exists(searching) && y > searching.y)) && (tile_meeting(x + xvelocity_sign, y)) && (!tile_meeting(x + xvelocity_sign, y - TILE_SIZE)) && (!tile_meeting(x + xvelocity_sign, y - (TILE_SIZE * 2)))
	{
		yvelocity = -_data.get_jump_height();
	}
	
	if (tile_meeting(x, y + 1))
	{
		entity_fall();
	}
}
else if (_move_type == CREATURE_MOVE_TYPE.FLY) || (_move_type == CREATURE_MOVE_TYPE.SWIM && tile_meeting(x, y, CHUNK_SIZE_Z - 1, ITEM_TYPE.LIQUID))
{
	image_angle = lerp_delta(image_angle, (xdirection != 0 ? xdirection * -12 : 0), 0.1);
	
	if (_fall_amount > 4)
	{
		if (chance(0.04 * _delta_time))
		{
			ydirection = choose(-1, 0);
		}
		else
		{
			var _left = tile_meeting(x - 1, y);
			var _right = tile_meeting(x + 1, y);
			
			if (_left != _right)
			{
				if (_right)
				{
					xdirection = -1;
				}
				else if (_left)
				{
					xdirection = 1;
				}
			}
		}
		
		physics_y();
	}
	else
	{
		ydirection = -1;
		
		physics_y(, 0);
	}
	
	yvelocity = lerp_delta(yvelocity, ydirection * _data.get_yspeed(), 0.2);
}

#endregion

physics_x(xdirection, _data.get_xspeed());