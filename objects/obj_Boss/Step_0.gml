if (obj_Control.is_paused) exit;

var _camera = global.camera;

var _camera_x = _camera.x;
var _camera_y = _camera.y;

if (rectangle_distance(x, y, _camera_x, _camera_y, _camera_x + _camera.width, _camera_y + _camera.height) > TILE_SIZE * 8)
{
	instance_destroy();
	
	exit;
}

var _delta_time = global.delta_time;

var _data = global.boss_data[boss_id];

if (hp <= 0)
{
	global.camera.shake = 8;
	
	var _speed = 3;
	var _rotation = 4;
	
	var _explosion = _data.explosion;
	var _explosion_length = sprite_get_number(_explosion) - 1;
		
	var _p1 = new Particle()
		.set_sprite(spr_Glow)
		.set_speed([-8, 8], [-8, 8])
		.set_rotation(-_rotation, _rotation)
		.set_scale([0.25, 0.4])
		.set_life(2, 16)
		.set_fade_out();
		
	var _p2 = new Particle()
		.set_sprite(_explosion)
		.set_index(0, _explosion_length)
		.set_speed([-_speed, _speed], [-_speed, _speed])
		.set_rotation(-_rotation, _rotation)
		.set_life(16, 48)
		.set_fade_out();
	
	if (!dead)
	{
		dead = true;
		image_alpha = 0;
	
		randomize();
		
		#region Spawn Explosions
		
		var _repeat = irandom_range(6, 12);
		
		repeat (_repeat)
		{
			array_push(explosion, {
				x,
				y,
				xvelocity: random_range(-2, 2),
				yvelocity: random_range(-2, 2),
				sprite: _explosion,
				index: irandom(_explosion_length),
				timer: irandom_range(30, 90),
				exploded: false
			});
		}
		
		spawn_particle(x, y, CHUNK_SIZE_Z - 1, _p1, irandom_range(2, 6));
		spawn_particle(x, y, CHUNK_SIZE_Z - 1, _p2, irandom_range(2, 6));
		
		#endregion
		
		audio_play_sound(mus_One_Step_Closer, 0, false);
		audio_play_sound(choose(sfx_Explosion_00, sfx_Explosion_01, sfx_Explosion_02, sfx_Explosion_03), 0, false, global.settings.audio.master.value * global.settings.audio.sfx.value, 0, random_range(0.8, 1.2));
		
		var _handle = call_later(90, time_source_units_frames, later_destroy_whip);
		
		// TODO: Fix Bestiary
		// ++global.bestiary.boss[boss_id];
	}
	
	var _x;
	var _y;
	
	var _timer;
	
	var i = 0;
	var _length = array_length(explosion);
	
	repeat (_length)
	{
		_explosion = explosion[i];
		
		_x = _explosion.x;
		_y = _explosion.y;
		
		_timer = _explosion.timer;
		
		if (_timer > 0)
		{
			explosion[@ i].x = _x + (_explosion.xvelocity * _delta_time);
			explosion[@ i].y = _y + (_explosion.yvelocity * _delta_time);
			explosion[@ i].timer = _timer - _delta_time;
		}
		else if (!_explosion.exploded)
		{
			audio_play_sound(choose(sfx_Explosion_00, sfx_Explosion_01, sfx_Explosion_02, sfx_Explosion_03), 0, false, global.settings.audio.master.value * global.settings.audio.sfx.value, 0, random_range(0.8, 1.2));
			
			spawn_particle(x, y, CHUNK_SIZE_Z - 1, _p1, irandom_range(2, 6));
			spawn_particle(x, y, CHUNK_SIZE_Z - 1, _p2, irandom_range(2, 6));
				
			explosion[@ i].timer = -1;
			explosion[@ i].exploded = true;
		}
		
		++i;
	}
	
	exit;
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
			
			immunity_frame = 1;
			
			sfx_play(x, y, _data.sfx, "damage");
		}
		
		if (_is_projectile) && (_damager.destroy_on_collision)
		{
			instance_destroy(_damager);
		}
	}
}

var _states = _data.states;
var _length = array_length(_states);

if (_length > 0)
{
	var _s = _data.state_change_type_chance;
	
	if (irandom(99) < (_s & 0xff) * _delta_time)
	{	
		var _t = _s >> 8;
		
		if (_t == BOSS_STATE_CHANGE_TYPE.LINEAR)
		{
			state = (state + 1) % _length;
		}
		else if (_t == BOSS_STATE_CHANGE_TYPE.RANDOM)
		{
			state = irandom(_length - 1);
		}
	}
	
	if (state > -1)
	{
		_states[state](x, y, id);
	}
}

physics_x(xdirection, _data.get_xspeed());
physics_y(, _data.gravity_strength);