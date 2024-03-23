// Feather disable GM1063

if (obj_Control.is_paused) exit;

var _timer = global.timer;

if (immunity_frame == 0)
{
	var _inst = instance_place(x, y, obj_Creature);
	
	if (instance_exists(_inst))
	{
		var _data = global.creature_data[_inst.creature_id];
		
		if (_data.get_type() == CREATURE_HOSTILITY_TYPE.HOSTILE)
		{
			entity_damage((x > _inst.x ? 6 : -6), -3, round(global.difficulty_multiplier_damage[(global.world.environment.value >> 8) & 0xf] * _data.damage * accessory_get_buff(BUFF_STRENGTH, _inst) * random_range(0.9, 1.1) * (1 - (accessory_get_buff(BUFF_DEFENSE, obj_Player) / 80))), DAMAGE_TYPE.MELEE);
		}
	}
}

var _item_data = global.item_data;
var _delta_time = global.delta_time;

if (hp > 0)
{
	if (hp < hp_max) && (floor(_timer) % floor(60 / accessory_get_buff(BUFF_REGENERATION)) < _delta_time)
	{
		hp_add(obj_Player, round(_delta_time));
		
		obj_Control.surface_refresh_hp = true;
	}
	
	dead_timer = GAME_FPS * 3;
}
else
{
	if (dead_timer == GAME_FPS * 3)
	{
		audio_play_sound(sfx_Player_Death, 0, false, global.settings.audio.master.value * global.settings.audio.sfx.value);
		
		image_alpha = 0;
	}
	
	dead_timer -= _delta_time;
	
	if (dead_timer <= 0)
	{
		audio_play_sound(sfx_Player_Respawn, 0, false, global.settings.audio.master.value * global.settings.audio.sfx.value);
		
		image_alpha = 1;
		global.camera.shake = 2;
		
		hp = hp_max;
		dead_timer = 0;
		
		x = 0;
		
		var _y = global.sun_rays_y[$ "0"];
		
		if (_y != undefined)
		{
			y = _y * TILE_SIZE;
		}
		else
		{
			var _x = 0;
			var _break = false;
			
			while (true)
			{
				var i = 256;
				var _t;
		
				repeat (WORLD_HEIGHT - 256)
				{
					_t = tile_get(_x, i, CHUNK_DEPTH_DEFAULT, "all");
			
					if (_t != ITEM.EMPTY) && (_t.boolean & 1) && (_item_data[_t.item_id].type & ITEM_TYPE.SOLID)
					{
						y = i * TILE_SIZE;
						global.sun_rays_y[$ string(_x)] = i;
						
						_break = true;
				
						break;
					}
			
					++i;
				}
				
				if (_break) break;
				
				_x = (_x > 0 ? -_x : -_x + 4);
			}
		}
		
		ylast = y;
		
		var _camera = global.camera;
		
		var _x = x - (_camera.width  / 2);
		_y = y - (_camera.height / 2);
		
		global.camera.x = _x;
		global.camera.y = _y;
		
		global.camera.x_real = _x;
		global.camera.y_real = _y;
		
		obj_Control.surface_refresh_hp = true;
	}
	
	exit;
}

var _is_opened_chat = obj_Control.is_opened_chat;
var _is_opened_menu = obj_Control.is_opened_menu;

#region Player Physics

var _controls = global.settings.controls;

var _key_left    = false;
var _key_right   = false;

var _key_jump    = false;
var _key_sprint  = false;

var _mouse_left  = false;
var _mouse_right = false;

if (!_is_opened_chat) && (!_is_opened_menu)
{
	_key_left    = keyboard_check(_controls.left.value);
	_key_right   = keyboard_check(_controls.right.value);

	_key_jump    = keyboard_check(_controls.jump.value);
	_key_sprint  = keyboard_check(_controls.sprint.value);

	_mouse_left  = mouse_check_button(mb_left);
	_mouse_right = mouse_check_button(mb_right);
}

var _tile_on = tile_get(round(x / TILE_SIZE), round(y / TILE_SIZE), CHUNK_DEPTH_DEFAULT);

if (is_climbing)
{
	if (_key_jump) || (_tile_on == ITEM.EMPTY) || ((_item_data[_tile_on].type & ITEM_TYPE.CLIMBABLE) == 0)
	{
		is_climbing = false;
	}
	else if (_key_left) || (_key_right)
	{
		if (physics_climb_x(_key_left, _key_right, _delta_time))
		{
			refresh_craftables(_timer % 32 < _delta_time);
			chunk_refresh(x, y);
		
			obj_Control.refresh_sun_ray = true;
		}
	}
	else
	{
		var _key_up = keyboard_check(_controls.climb_up.value);
		var _key_down = keyboard_check(_controls.climb_down.value);
			
		if (_key_up != _key_down) && (physics_climb_y(_key_up, _key_down, _delta_time))
		{
			refresh_craftables(_timer % 32 < _delta_time);
			chunk_refresh(x, y);
		
			obj_Control.refresh_sun_ray = true;
		}
	}
}
else if (global.local_settings.enable_physics)
{
	if (keyboard_check_pressed(_controls.climb_up.value) || keyboard_check_pressed(_controls.climb_down.value)) && (_tile_on != ITEM.EMPTY) && (_item_data[_tile_on].type & ITEM_TYPE.CLIMBABLE)
	{
		is_climbing = true;
	}
	else
	{
		physics_y(accessory_get_buff(BUFF_GRAVITY), PHYSICS_GLOBAL_GRAVITY);
		
		var _dash = accessory_get_buff(BUFF_MOVE_DASH);
		
		physics_dash(_key_left, _key_right, _dash, _delta_time);
		
		if (dash_speed > 0) && (_dash > 0)
		{
			physics_x(dash_facing, ((PHYSICS_PLAYER_WALK_SPEED + (_key_sprint * PHYSICS_PLAYER_RUN_MULTIPLIER)) + dash_speed) * accessory_get_buff(BUFF_SPEED));
		}
		else
		{
			physics_x(_key_right - _key_left, (PHYSICS_PLAYER_WALK_SPEED + (_key_sprint * PHYSICS_PLAYER_RUN_MULTIPLIER)) * accessory_get_buff(BUFF_SPEED));
		}
	
		physics_bury(, _item_data);
	
		if (!tile_meeting(x, y + 1))
		{
			if (!_key_jump)
			{
				coyote_time += _delta_time;
			}
		}
		else
		{
			entity_fall(global.difficulty_multiplier_damage[(global.world.environment.value >> 8) & 0xf]);
		
			jump_pressed = 0;
			jump_count = 0;
			
			coyote_time = 0;
		}
	
		#region Jump Manager
	
		if (_key_jump)
		{
			if (keyboard_check_pressed(_controls.jump.value))
			{
				jump_pressed = 0;
		
				++jump_count;
			}
		
			if (jump_count < PHYSICS_PLAYER_JUMP_AMOUNT_MAX || (jump_count < PHYSICS_PLAYER_JUMP_AMOUNT_MAX && coyote_time <= PHYSICS_PLAYER_THRESHOLD_COYOTE)) && (jump_pressed < PHYSICS_PLAYER_JUMP_HEIGHT)
			{
				yvelocity = -PHYSICS_PLAYER_JUMP_HEIGHT * accessory_get_buff(BUFF_JUMPING);
	
				jump_pressed += _delta_time;
			}
		}
	
		#endregion
	
		if (xvelocity != 0) || (yvelocity != 0)
		{
			moved = true;
			
			obj_Control.refresh_sun_ray = true;
			
			refresh_craftables(_timer % 32 < _delta_time);
		}
		else if (moved)
		{
			moved = false;
			
			obj_Control.refresh_sun_ray = true;
		
			refresh_craftables();
			chunk_refresh(x, y);
		}
	}
}
else if (!_is_opened_chat) && (!_is_opened_menu)
{
	physics_sandbox(_key_left, _key_right, _delta_time);
}

// Clamp y position between world height
y = clamp(y, 0, WORLD_HEIGHT_TILE_SIZE - TILE_SIZE);

#endregion

var _inventory_base = global.inventory.base;

var _inventory_selected_hotbar = global.inventory_selected_hotbar;

var _mouse_on_slot = position_meeting(mouse_x, mouse_y, obj_Inventory);

#region Item Swinging

if (_mouse_left) || (_mouse_right)
{
	var _mouse_pressed_left  = mouse_check_button_pressed(mb_left);
	var _mouse_pressed_right = mouse_check_button_pressed(mb_right);
	
	var _item = _inventory_base[_inventory_selected_hotbar];
	
	if (_item != INVENTORY_EMPTY) && (!_mouse_on_slot)
	{
		var _data = _item_data[_item.item_id];
		var _type = _data.type;
		
		var _damage;
		
		if (_type & ITEM_TYPE.WHIP)
		{
			if (global.sequence_whips == -1)
			{
				global.sequence_whips = layer_sequence_create("Instances", 0, -512, sq_Whip_Default);
				
				// TODO: ADD CRIT CHANCE
				whip_damage = _data.get_damage();
				whip_sprite = _data.sprite;
				
				var _angle = point_direction(x, y, mouse_x, mouse_y);
				
				if (_angle > 90) && (_angle < 270)
				{
					layer_sequence_xscale(global.sequence_whips, -1);
					layer_sequence_angle(global.sequence_whips, abs(180 - _angle));
				}
				else
				{
					layer_sequence_xscale(global.sequence_whips, 1);
					layer_sequence_angle(global.sequence_whips, _angle);
				}
				
				var _handle = call_later(30, time_source_units_frames, later_destroy_whip);
			}
		}
		else if (_type & ITEM_TYPE.BOW)
		{
			if (cooldown_projectile <= 0)
			{
				var _inventory = global.inventory.base;
			
				var _inventory_item;
				var _inventory_data;
			
				var i = 0;
				var _length = array_length(_inventory);
			
				repeat (_length)
				{
					_inventory_item = _inventory[i];
				
					if (_inventory_item != INVENTORY_EMPTY)
					{
						_inventory_data = _item_data[_inventory_item.item_id];
					
						if (_inventory_data.type & ITEM_TYPE.AMMO) && (_data.get_ammo_type() == _inventory_data.ammo_type)
						{
							cooldown_projectile = _data.get_cooldown();
						
							if (--global.inventory.base[i].amount <= 0)
							{
								global.inventory.base[@ i] = INVENTORY_EMPTY;
							}
		
							var _x_direction = (x <= mouse_x ? 1 : -1);
							var _y_direction = (y <= mouse_y ? 1 : -1);
				
							var _xvelocity = clamp(abs(x - mouse_x) / TILE_SIZE * _x_direction,     -12, 12);
							var _yvelocity = clamp(abs(y - mouse_y) / TILE_SIZE * _y_direction * 2, -16, 16);
				
							spawn_projectile(x, y, new Projectile(_inventory_data.sprite, _data.get_damage() + _inventory_data.get_damage())
								.set_speed(round(_xvelocity), round(_yvelocity))
								.set_destroy_on_collision());
						
							break;
						}
					}
				
					++i;
				}
			}
		}
		else if (_type & ITEM_TYPE.FISHING_POLE)
		{
			if (_mouse_pressed_right)
			{
				if (!instance_exists(obj_Fishing_Hook))
				{
					instance_create_layer(x, y, "Instances", obj_Fishing_Hook, {
						item_id: _item.item_id,
						
						xvelocity: round(clamp(abs(x - mouse_x) / TILE_SIZE * (x <= mouse_x ? 1 : -1), -12, 16)),
						yvelocity: round(clamp(abs(y - mouse_y) / TILE_SIZE * (y <= mouse_y ? 2 : -2), -12, 16)),
						
						owner: id
					});
				}
				else
				{
					var _caught = obj_Fishing_Hook.caught;
					
					if (_caught != ITEM.EMPTY)
					{
						spawn_drop(obj_Fishing_Hook.x, obj_Fishing_Hook.y, _caught.item_id, is_array_irandom(_caught.amount), 0, 0);
					}
					
					instance_destroy(obj_Fishing_Hook);
				}
			}
		}
		else if (_type & ITEM_TYPE.CONSUMABLE)
		{
			if (_mouse_pressed_left)
			{
				var _on_consume = _data.on_consume;
				
				if (_on_consume != -1)
				{
					_on_consume(id);
					
					var _on_consume_return = _data.on_consume_return;
					
					if (_on_consume_return != ITEM.EMPTY)
					{
						spawn_drop(x, y, _on_consume_return, 1, 0, 0,, 0, false);
					}
				}
				
				if (--global.inventory.base[_inventory_selected_hotbar].amount <= 0)
				{
					global.inventory.base[@ _inventory_selected_hotbar] = INVENTORY_EMPTY;
				}
				
				audio_play_sound(choose(sfx_Consume_00, sfx_Consume_01, sfx_Consume_02, sfx_Consume_03), 0, false, global.settings.audio.sfx.value);
			}
		}
		else if (!instance_exists(obj_Tool))
		{
			audio_play_sound(sfx_Tool_Swing, 0, false, 1, 0, random_range(0.8, 1.2));
			
			_damage = _data.get_damage();
			
			if (_data.type & (ITEM_TYPE.SWORD | ITEM_TYPE.PICKAXE | ITEM_TYPE.AXE | ITEM_TYPE.SHOVEL | ITEM_TYPE.HAMMER | ITEM_TYPE.WHIP | ITEM_TYPE.BOW))
			{
				_damage += round((real(_item.acclimation) / _data.get_acclimation_amount()) * _data.get_acclimation_max());
			}
			
			var _damage_critical;
			
			if (irandom(99) < _data.get_damage_critical_chance())
			{
				_damage *= 1.5;
				_damage_critical = true;
			}
			else
			{
				_damage_critical = false;
			}
			
			instance_create_layer(0, -512, "Instances", obj_Tool, {
				item_id: _item.item_id,
				damage: _damage,
				damage_type: _data.get_damage_type(),
				damage_critical: _damage_critical,
				angle: 0,
				swing_speed: _data.get_swing_speed(),
				owner: id,
				
				sprite_index: _data.sprite
			});
			
			if (_mouse_left)
			{
				var _interact = _data.on_swing_attack;
			
				if (_interact != -1)
				{
					_interact(x, y);
				}
			}
			else if (_mouse_right)
			{
				var _interact = _data.on_swing_interact;
			
				if (_interact != -1)
				{
					_interact(x, y);
				}
			}
			
			if (_mouse_right) && (_data.type & ITEM_TYPE.THROWABLE)
			{
				if (--global.inventory.base[_inventory_selected_hotbar].amount <= 0)
				{
					global.inventory.base[@ _inventory_selected_hotbar] = INVENTORY_EMPTY;
				}
			
				var _multiplier = _data.max_throw_multiplier * accessory_get_buff(BUFF_ATTACK_REACH);
				var _max_throw_x = 12 * _multiplier;
				var _max_throw_y = 16 * _multiplier;
			
				var _x_direction = (x <= mouse_x ? 1 : -1);
				var _y_direction = (y <= mouse_y ? 1 : -1);
				
				var _xvelocity = clamp(abs(x - mouse_x) / TILE_SIZE * _x_direction,     -_max_throw_x, _max_throw_x);
				var _yvelocity = clamp(abs(y - mouse_y) / TILE_SIZE * _y_direction * 2, -_max_throw_y, _max_throw_y);
				
				spawn_projectile(x, y, new Projectile(_data.sprite, _data.damage)
					.set_speed(round(_xvelocity), round(_yvelocity))
					.set_rotation(is_array_random(_data.get_rotation()) * -_x_direction)
					.set_gravity(_data.gravity_strength)
					.set_destroy_on_collision());
			}
		}
	}
}

#endregion

#region Placing & Mining

if (keyboard_check_pressed(_controls.drop.value))
{
	inventory_drop();
}
else if (!_mouse_on_slot) && (rectangle_distance(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom) <= PLAYER_REACH_MAX + (accessory_get_buff(BUFF_BUILD_REACH) * TILE_SIZE))
{
	var _holding = _inventory_base[_inventory_selected_hotbar];
	
	if (_mouse_right) && (cooldown_build <= 0) && (_holding != INVENTORY_EMPTY)
	{
		player_place(round(mouse_x / TILE_SIZE), round(mouse_y / TILE_SIZE), _item_data);
	}
	else if (_mouse_left) && (player_mine(round(mouse_x / TILE_SIZE), round(mouse_y / TILE_SIZE), _holding, _delta_time, _item_data))
	{
		is_mining = false;
	
		mining_current = 0;
		mining_current_fixed = 0;
	
		mine_position = -1;
	}
}
else
{
	is_mining = false;
	
	mining_current = 0;
	mining_current_fixed = 0;
	
	mine_position = -1;
}

#endregion
/*
if (!_is_opened_chat) && (!_is_opened_menu)
{
	if (keyboard_check_pressed(ord("M")))
	{
		structure_bamboo(round(x / TILE_SIZE), round(y / TILE_SIZE), global.world.info.seed);
	}
	
	if (keyboard_check_pressed(ord("N")))
	{
		structure_cattail(round(x / TILE_SIZE), round(y / TILE_SIZE), global.world.info.seed);
	}
}
*/
if (cooldown_build > 0)
{
	cooldown_build = clamp(cooldown_build - clamp(1 * accessory_get_buff(BUFF_BUILD_COOLDOWN) * _delta_time, 1, COOLDOWN_MAX_BUILD), 0, COOLDOWN_MAX_BUILD);
}

if (cooldown_projectile > 0)
{
	cooldown_projectile -= _delta_time;
}

if (immunity_frame > 0)
{
	immunity_frame += _delta_time;
	
	if (immunity_frame >= IMMUNITY_FRAME_MAX)
	{
		immunity_frame = 0;
	}
}

#region Animation

if (yvelocity != 0)
{
	animation_frame = 0;
	image_index = 1;
}
else if (xvelocity != 0) && (_key_left || _key_right)
{
	animation_frame += _delta_time;
	// animation_frame = (animation_frame + (8 * _delta_time)) % 6;
	image_index = 1 + ((animation_frame / 8) % 6);
}
else
{
	animation_frame = 0;
	image_index = 0;
}

#endregion