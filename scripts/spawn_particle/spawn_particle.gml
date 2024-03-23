#macro PARTICLE_COLLISION_EMPTY -2048

function Particle() constructor
{
	
	
	sprite = item_Dirt;
	
	static set_sprite = function(_sprite)
	{
		if (argument_count == 1)
		{
			sprite = _sprite;
			
			return self;
		}
		
		var i = 0;
		
		repeat (argument_count)
		{
			sprite[@ i] = argument[i];
			
			++i;
		}
		
		return self;
	}
	
	index = 0;
	
	static set_index = function(_index)
	{
		index = _index;
		
		return self;
	}
	
	xvelocity = 0;
	yvelocity = 0;
	
	static set_speed = function(_xvelocity, _yvelocity)
	{
		xvelocity = _xvelocity;
		yvelocity = _yvelocity;
		
		return self;
	}
	
	static set_xvelocity = function(_xvelocity = 0)
	{
		xvelocity = _xvelocity;
		
		return self;
	}
	
	static set_yvelocity = function(_yvelocity = 0)
	{
		yvelocity = _yvelocity;
		
		return self;
	}
	
	scale = 1;
	
	static set_scale = function(_scale = 1)
	{
		scale = _scale;
		
		return self;
	}
	
	collision = false;
	
	static set_collision = function(_collision = true)
	{
		collision = _collision;
		
		return self;
	}
	
	collision_xvelocity = PARTICLE_COLLISION_EMPTY;
	collision_yvelocity = PARTICLE_COLLISION_EMPTY;
	
	static set_speed_on_collision = function(_xvelocity = 0, _yvelocity = 0)
	{
		collision_xvelocity = _xvelocity;
		collision_yvelocity = _yvelocity;
		
		return self;
	}
	
	rotation = 0;
	
	static set_rotation = function(_min = 0, _max = 0)
	{
		var _i = ((_min < 0) << 11) | abs(_min);
		var _a = ((_max < 0) << 11) | abs(_max);
		
		rotation = (_i << 12) | _a;
		
		return self;
	}
	
	angle = 0;
	
	static set_angle = function(_angle)
	{
		angle = _angle;
		
		return self;
	}
	
	life = (100 << 8) | 100;
	
	static set_life = function(_min = 0, _max = 0)
	{
		life = (_min << 8) | _max;
		
		return self;
	}
	
	// destroy on collision, fade out, additive
	boolean = 0;
	
	static set_destroy_on_collision = function()
	{
		boolean = (1 << 2) & (boolean & 0b11);
		
		return self;
	}
	
	static set_fade_out = function()
	{
		boolean = (1 << 1) | (boolean & 0b101);
		
		return self;
	}
	
	static set_additive = function()
	{
		boolean = (boolean & 0b110) | 1;
		
		return self;
	}
}

function spawn_particle(_x, _y, _z, _particle, _amount = 1)
{
	var _sprite = _particle.sprite;
	// var _length = array_length(_sprite);
	
	var _scale = _particle.scale;
	var _s;
	
	var _index = _particle.index;
	var _angle = _particle.angle;
	
	var _rotation = _particle.rotation;
	var _rotation_min = _rotation >> 12;
		_rotation_min = ((_rotation & 0x800) ? -(_rotation_min & 0x7ff) : (_rotation_min & 0x7ff));
	
	var _rotation_max = _rotation & 0xfff;
		_rotation_max = ((_rotation_max & 0x800) ? -(_rotation_max & 0x7ff) : (_rotation_max & 0x7ff));
	
	var _xvelocity = _particle.xvelocity;
	var _yvelocity = _particle.yvelocity;
	
	var _collision = _particle.collision;
	var _collision_xvelocity = _particle.collision_xvelocity;
	var _collision_yvelocity = _particle.collision_yvelocity;
	
	var _life = _particle.life;
	var _life_min = _life >> 8;
	var _life_max = _life & 0xff;
	
	var _boolean = _particle.boolean;
	
	repeat (_amount)
	{
		_s = is_array_random(_scale);
		
		instance_create_layer(_x, _y, "Instances", obj_Particle, {
			z: _z,
			
			sprite_index: is_array_choose(_sprite),
			
			image_xscale: _s,
			image_yscale: _s,
			
			image_index: is_array_random(_index),
			image_angle: is_array_random(_angle),
			
			rotation: random_range(_rotation_min, _rotation_max),
			
			xvelocity: is_array_random(_xvelocity),
			yvelocity: is_array_random(_yvelocity),
			
			collision: _collision,
			collision_xvelocity: _collision_xvelocity,
			collision_yvelocity: _collision_yvelocity,
			
			life: random_range(_life_min, _life_max),
			
			boolean: _boolean
		});
	}
}