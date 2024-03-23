function Projectile(_sprite, _damage) constructor
{
	
	
	sprite = _sprite;
	damage = _damage;
	
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
	
	rotation = 0;
	
	static set_rotation = function(_rotation)
	{
		
		
		rotation = _rotation;
		
		return self;
	}
	
	gravity_strength = PHYSICS_GLOBAL_GRAVITY;
	
	static set_gravity = function(_gravity)
	{
		
		
		gravity_strength = _gravity;
		
		return self;
	}
	
	destroy_on_collision = false;
	
	static set_destroy_on_collision = function()
	{
		
		
		destroy_on_collision = true;
		
		return self;
	}
	
	collision = true;
	
	static set_collision = function(_collision)
	{
		
		
		collision = _collision;
		
		return self;
	}	
	
	life = -1;
	
	static set_life = function(_life)
	{
		
		
		life = _life;
		
		return self;
	}
	
	point = false;
	
	static set_point = function()
	{
		
		
		point = true;
		
		return self;
	}
	
	fade = false;
	
	static set_fade = function()
	{
		
		
		fade = true;
		
		return self;
	}
	
	cant_damage = [];
	
	static add_cant_damage = function()
	{
		
		
		var i = 0;
		
		repeat (argument_count)
		{
			array_push(cant_damage, argument[i++]);
		}
		
		return self;
	}
}

function spawn_projectile(_x, _y, _projectile)
{
	
	
	instance_create_layer(_x, _y, "Instances", obj_Projectile, {
		sprite_index: _projectile.sprite,
		image_index: _projectile.index,
		
		damage: _projectile.damage,
		
		xvelocity: _projectile.xvelocity,
		yvelocity: _projectile.yvelocity,
		rotation: _projectile.rotation,
		
		gravity_strength: _projectile.gravity_strength,
		destroy_on_collision: _projectile.destroy_on_collision,
		collision: _projectile.collision,
		point: _projectile.point,
		cant_damage: _projectile.cant_damage,
		
		life: _projectile.life,
		fade: _projectile.fade
	});
}