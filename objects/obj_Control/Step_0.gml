if (is_exiting)
{
	if (instance_exists(obj_Structure))
	{
		save_structures();
		
		instance_destroy(obj_Structure);
	}
	
	if (instance_exists(obj_Particle))
	{
		instance_destroy(obj_Particle);
	}
	
	var i;
	
	with (obj_Chunk)
	{
		save_chunk(id);
	
		i = 0;
	
		repeat (CHUNK_SIZE_Z)
		{
			surface_free_existing(surface[i++]);
		}
		
		instance_destroy();
		
		break;
	}
	
	if (instance_exists(obj_Chunk))
	{
		++chunk_count;
		
		exit;
	}

	surface_free_existing(surface_background);
	surface_free_existing(surface_boss);
	surface_free_existing(surface_chat);
	surface_free_existing(surface_colourblind);
	surface_free_existing(surface_hp);
	surface_free_existing(surface_inventory);
	surface_free_existing(surface_lighting);
	surface_free_existing(surface_mine);

	var _part;

	var _element;
	var _elements = global.attire_elements_ordered;
	var _elements_length = array_length(_elements);

	i = 0;

	repeat (_elements_length)
	{
		_element = _elements[i++];
	
		with (obj_Player)
		{
			_part = parts[$ _element];
		
			if (_part == -1) continue;
		
			surface_free_existing(_part.surface);
		}
	}

	save_info();
	save_player(global.player.uuid, obj_Player.name, obj_Player.hp, obj_Player.hp_max, global.inventory_selected_hotbar, obj_Player.parts);
	save_values();
	save_entity_item();

	if (time_source_exists(global.time_source_rpc))
	{
		time_source_destroy(global.time_source_rpc);
	}
	
	delete global.world;
	delete global.player;
		
	room_goto(menu_Main);
	
	exit;
}

var _delta_time = global.tick * (delta_time / 1_000_000);

global.delta_time = _delta_time;

if (keyboard_check_pressed(vk_escape))
{
	if (is_opened_menu)
	{
		with (obj_Menu_Button)
		{
			selected = false;
		}
		
		with (obj_Menu_Textbox)
		{
			selected = false;
		}
		
		instance_deactivate_layer(global.menu_layer);
		
		is_opened_menu = false;
		
		global.menu_layer = -1;
		global.menu_inst = noone;
	}
	else if (!is_opened_chat)
	{
		is_paused = !is_paused;
		
		if (is_paused)
		{
			is_opened_inventory = false;
			
			with (obj_Inventory)
			{
				if (type == "container") continue;
				
				instance_deactivate_object(id);
			}
			
			inventory_container_close();
		}
	}
	
	chat_disable();
}

if (is_paused)
{
	if (keyboard_check_pressed(vk_enter))
	{
		instance_activate_object(obj_Chunk);
		
		chunk_count = 0;
		chunk_count_max = instance_number(obj_Chunk);
		
		global.menu_main_fade = true;
		is_exiting = true;
	}
	else
	{
		with (obj_Item_Drop)
		{
			move_towards_point(x, y, 0);
		}
	}
	
	exit;
}

++global.timer;

var _world_value = global.world.environment.value;

if (_world_value & (1 << 18))
{
	global.world.environment.time = 0;
}
else
{
	global.world.environment.time = (global.world.environment.time + _delta_time) % 54_000;
	
	ctrl_weather();
}

global.luck = clamp(accessory_get_buff(BUFF_LUCK, obj_Player), 0.2, 3);

var _player_x = obj_Player.x;
var _player_y = obj_Player.y;

var _item_data = global.item_data;

if (global.local_settings.draw_gui)
{
	ctrl_chat();
}
else if (is_opened_chat)
{
	chat_disable();
}

var _camera = global.camera;
	
var _camera_x = _camera.x;
var _camera_y = _camera.y;
	
var _camera_width  = _camera.width;
var _camera_height = _camera.height;
	
var _camera_x_real = _player_x - (_camera_width  / 2);
var _camera_y_real = _player_y - (_camera_height / 2);

#region Chunk Handling

with (obj_Chunk)
{
	is_in_view = false;
	
	if (point_distance(_player_x, _player_y, xcenter, ycenter) > CHUNK_SIZE_WIDTH * 8)
	{
		instance_destroy();
		
		break;
	}
}

#endregion

ctrl_chunk_generate();

if (_world_value & (1 << 17))
{
	ctrl_creature_spawn();
}

ctrl_pets();

ctrl_effects();

with (obj_Menu_Button)
{
	x = _camera_x + xstart;
	y = _camera_y + ystart;
}

with (obj_Menu_Textbox)
{
	x = _camera_x + xstart;
	y = _camera_y + ystart;
}

with (obj_Menu_Text)
{
	x = _camera_x + xstart;
	y = _camera_y + ystart;
}

#region Inventory Management

#macro CRAFTING_STATION_MAX_DISTANCE 8

if (is_opened_container) && (point_distance(_player_x, _player_y, global.container_tile_position_x * TILE_SIZE, global.container_tile_position_y * TILE_SIZE) > CRAFTING_STATION_MAX_DISTANCE * TILE_SIZE)
{
	inventory_container_close();
}

var _item;

var _mouse_left = mouse_check_button(mb_left);

if (!is_opened_chat) && (global.local_settings.draw_gui)
{
	var _mouse_right_pressed = mouse_check_button_pressed(mb_right);
	
	if (_mouse_right_pressed)
	{
		var _inst = instance_position(mouse_x, mouse_y, obj_Inventory);
		
		if (_inst)
		{
			var _type = _inst.type;
		
			if (_type != "craftable")
			{
				var _placement = _inst.inventory_placement;
				var _index = global.inventory[$ _type][_placement];
		
				if (_index != INVENTORY_EMPTY)
				{
					var _interaction = _item_data[_index.item_id].on_interaction_inventory;
		
					if (_interaction != -1)
					{
						_interaction(_type, _placement);
				
						surface_refresh_inventory = true;
					}
				}
			}
		}
		else
		{
			var _x = round(mouse_x / TILE_SIZE);
			var _y = round(mouse_y / TILE_SIZE);
			var _z = CHUNK_SIZE_Z - 1;
			
			var _menu_opened = is_opened_menu;
			
			var _tile;
			var _data;
			var _menu;
			var _interaction;
			
			repeat (CHUNK_SIZE_Z)
			{
				_tile = tile_get(_x, _y, _z);
				
				if (_tile == ITEM.EMPTY)
				{
					--_z;
					
					continue;
				}
				
				_data = _item_data[_tile];
					
				if (!_menu_opened) && (_data.type & ITEM_TYPE.MENU)
				{
					_menu = _data.menu;
						
					if (_menu != -1)
					{
						is_opened_menu = true;
						global.menu_layer = "Menu_" + _menu;
						global.menu_tile = {
							x: _x,
							y: _y,
							z: _z,
						};
							
						with (obj_Tile_Instance)
						{
							if (position_x != _x) || (position_y != _y) || (position_z != _z) continue;
								
							global.menu_inst = id;
								
							break;
						}
							
						instance_activate_layer(global.menu_layer);
							
						break;
					}
				}
					
				_interaction = _data.on_interaction;
					
				if (_interaction != -1)
				{
					_interaction(_x, _y, _z);
						
					break;
				}
				
				--_z;
			}
		}
	}
	
	var i = 0;
	
	repeat (INVENTORY_SIZE.ROW)
	{
		if (keyboard_check_pressed(ord(string(i))))
		{
			global.inventory_selected_hotbar = ((i - 1) + INVENTORY_SIZE.ROW) % INVENTORY_SIZE.ROW;
			
			surface_refresh_inventory = true;
			
			break;
		}
		
		++i;
	}
	
	#macro INVENTORY_SCROLL_CRAFTABLE_SPEED 12
	#macro INVENTORY_SCROLL_CRAFTABLE_DISTANCE_THRESHOLD 16
	
	if (mouse_wheel_up())
	{
		var _inventory_slot = instance_nearest(mouse_x, mouse_y, obj_Inventory);
		
		if (_inventory_slot) && (_inventory_slot.type == "craftable") && (rectangle_distance(mouse_x, mouse_y, _inventory_slot.bbox_left, _inventory_slot.bbox_top, _inventory_slot.bbox_right, _inventory_slot.bbox_bottom) < INVENTORY_SCROLL_CRAFTABLE_DISTANCE_THRESHOLD)
		{
			if (craftable_scroll_offset <= 0)
			{
				craftable_scroll_offset += INVENTORY_SCROLL_CRAFTABLE_SPEED * _delta_time;
				
				with (obj_Inventory)
				{
					if (type != "craftable") continue;
					
					yoffset += INVENTORY_SCROLL_CRAFTABLE_SPEED;
				}
			}
	
			surface_refresh_inventory = true;
			
			audio_play_sound(sfx_Inventory_Click, 0, false, 1, 0, random_range(0.9, 1.1));
		}
		else if (--global.inventory_selected_hotbar < 0)
		{
			global.inventory_selected_hotbar = INVENTORY_SIZE.ROW - 1;
		}
	
		surface_refresh_inventory = true;
			
		audio_play_sound(sfx_Inventory_Click, 0, false, 1, 0, random_range(0.9, 1.1));
	}
	else if (mouse_wheel_down())
	{
		var _inventory_slot = instance_nearest(mouse_x, mouse_y, obj_Inventory);
		
		if (_inventory_slot) && (_inventory_slot.type == "craftable") && (rectangle_distance(mouse_x, mouse_y, _inventory_slot.bbox_left, _inventory_slot.bbox_top, _inventory_slot.bbox_right, _inventory_slot.bbox_bottom) < INVENTORY_SCROLL_CRAFTABLE_DISTANCE_THRESHOLD)
		{
			craftable_scroll_offset -= INVENTORY_SCROLL_CRAFTABLE_SPEED * _delta_time;
				
			with (obj_Inventory)
			{
				if (type != "craftable") continue;
				
				yoffset -= INVENTORY_SCROLL_CRAFTABLE_SPEED;
			}
	
			surface_refresh_inventory = true;
			
			audio_play_sound(sfx_Inventory_Click, 0, false, 1, 0, random_range(0.9, 1.1));
		}
		else if (++global.inventory_selected_hotbar > INVENTORY_SIZE.ROW - 1)
		{
			global.inventory_selected_hotbar = 0;
		}
	
		surface_refresh_inventory = true;
			
		audio_play_sound(sfx_Inventory_Click, 0, false, 1, 0, random_range(0.9, 1.1));
	}
	
	if (_mouse_right_pressed)
	{
		var _inst = instance_position(mouse_x, mouse_y, obj_Tile_Container);
		
		if (_inst)
		{
			inventory_container_open(mouse_x, mouse_y, _inst);
		}
	}

	var key_inventory = keyboard_check_pressed(global.settings.controls.inventory.value);

	#region Open / Close Inventory

	if (key_inventory) && (!is_opened_menu)
	{
		is_opened_inventory = !is_opened_inventory;
		surface_refresh_inventory = true;
	
		if (!is_opened_inventory)
		{
			with (obj_Inventory)
			{
				if (type == "container") continue;
				
				instance_deactivate_object(id);
			}
			
			inventory_container_close();
		}
		else
		{
			instance_activate_object(obj_Inventory);
			inventory_container_open(_player_x, _player_y);
			refresh_craftables();
		}
	}

	#endregion

	#region Item Organization
	
	if (is_opened_inventory)
	{
		var _is_opened_container = is_opened_container;
		var _inventory = global.inventory;
		
		var inventory = _inventory.base;
		var key_shift = keyboard_check(vk_shift);
		
		with (obj_Inventory)
		{
			x = _camera_x + (((xoffset - 1) / _camera.gui_width)  * _camera_width);
			y = _camera_y + (((yoffset - 1) / _camera.gui_height) * _camera_height);
			
			if (type == "craftable") continue;
			
			if (_mouse_right_pressed) && (point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom))
			{
				_item = _inventory[$ type][inventory_placement];
				
				if (_item != INVENTORY_EMPTY)
				{
					var _slot_to = -1;
					var _slot_index = 0;
				
					var _data = _item_data[_item.item_id];
					var _type = _data.type;
					
					if (_type & ITEM_TYPE.ARMOR_HELMET)
					{
						_slot_to = "armor_helmet";
						_slot_index = 0;
					}
					else if (_type & ITEM_TYPE.ARMOR_BREASTPLATE)
					{
						_slot_to = "armor_breastplate";
						_slot_index = 0;
					}
					else if (_type & ITEM_TYPE.ARMOR_LEGGINGS)
					{
						_slot_to = "armor_leggings";
						_slot_index = 0;
					}
					else if (_type & ITEM_TYPE.ACCESSORY)
					{
						i = 0;
						
						repeat (INVENTORY_SIZE.ACCESSORIES)
						{
							if (keyboard_check(ord(string(i + 1))))
							{
								_slot_to = "accessory";
								_slot_index = INVENTORY_SIZE.ACCESSORIES - 1 - i;
								
								break;
							}
							
							++i;
						}
						
						if (_slot_to == -1)
						{
							i = 0;
							var _accessory = _inventory.accessory;
							
							repeat (INVENTORY_SIZE.ACCESSORIES)
							{
								if (_accessory[INVENTORY_SIZE.ACCESSORIES - 1 - i] == INVENTORY_EMPTY)
								{
									_slot_to = "accessory";
									_slot_index = i;
							
									break;
								}
								
								++i;
							}
						}
					}
				
					if (_slot_to != -1)
					{
						var _a = _inventory[$ type][inventory_placement];
						var _b = _inventory[$ _slot_to][_slot_index];
					
						global.inventory[$ type][@ inventory_placement] = _b;
						global.inventory[$ _slot_to][@ _slot_index] = _a;
						
						if (_a != INVENTORY_EMPTY)
						{
							if (_slot_to == "accessory")
							{
								audio_play_sound(choose(sfx_Equip_Accessory_00, sfx_Equip_Accessory_01), 0, false, global.settings.audio.master.value * global.settings.audio.sfx.value);
							}
							else if (_slot_to == "armor_helmet") || (_slot_to == "armor_breastplate") || (_slot_to == "armor_leggings")
							{
								audio_play_sound(choose(sfx_Equip_Armor_00, sfx_Equip_Armor_01), 0, false, global.settings.audio.master.value * global.settings.audio.sfx.value);
							}
						}
						
						obj_Control.surface_refresh_inventory = true;
					}
				}
			}
			else if (type != "craftable") && (_is_opened_container) && (_mouse_right_pressed) && (key_shift) && (point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom))
			{
				inventory_shortcut_shift(type, inventory_placement, (type == "base" ? "container" : "base"));
			}
		}
		
		#region Organize Using Mouse
	
		var _inst = instance_position(mouse_x, mouse_y, obj_Inventory);
	
		if (mouse_check_button_pressed(mb_left)) && (instance_exists(_inst))
		{
			if (_inst.type == "craftable")
			{
				if (_inst.enough_ingredients)
				{
					inventory_craft(_player_x, _player_y, _inst);
				}
			}
			else
			{
				global.inventory_selected_backpack = _inst;
			}
		}
		
		var _slot_a;
		
		var _item_a;
		var _item_b;
		
		with (global.inventory_selected_backpack)
		{
			if (_mouse_left)
			{
				obj_Control.surface_refresh_inventory = true;
				
				x = mouse_x;
				y = mouse_y;
				
				break;
			}
			
			global.inventory_selected_backpack = noone;
			
			x = _camera_x + xoffset;
			y = _camera_y + yoffset;
			
			if (!instance_exists(_inst)) || (_inst == id) break;
			
			_item_b = _inventory[$ type][inventory_placement];
			
			if (_item_b == INVENTORY_EMPTY) break;
			
			var _id = _item_b.item_id;
			var _data = _item_data[_id];
				
			if ((_data.get_slot_valid() & _inst.slot_type) == 0) break;
			
			obj_Control.surface_refresh_inventory = true;
				
			_slot_a = _inst.inventory_placement;
			var _switch_type = _inst.type;
				
			_item_a = _inventory[$ _switch_type][_slot_a];
		
			if (_item_a == INVENTORY_EMPTY) || (_item_a.item_id != _id)
			{
				global.inventory[$ _switch_type][@ _slot_a] = _item_b;
				global.inventory[$ type][@ inventory_placement] = _item_a;
					
				break;
			}
			
			var _a_amount = _item_a.amount;
			var _b_amount = _item_b.amount;
						
			var _inventory_max = _data.get_inventory_max();
			var _ab_amount = _a_amount + _b_amount;
					
			if (_ab_amount <= _inventory_max)
			{
				global.inventory[$ _switch_type][@ _slot_a].amount = _ab_amount;
				global.inventory[$ type][@ inventory_placement] = INVENTORY_EMPTY;
						
				break;
			}
					
			global.inventory[$ _switch_type][@ _slot_a].amount = _inventory_max;
			global.inventory[$ type][@ inventory_placement].amount = _inventory_max - _a_amount;
		}
	
		#endregion
	
		#region Organize Using Shift
		
		with (_inst)
		{
			// NOTE: point_distance is used to get what inventory slot is going to be switched with from the hotbar
			if (type != "base") || (!keyboard_check(vk_shift)) break;
			
			i = 0;
				
			repeat (INVENTORY_SIZE.ROW)
			{
				if (!keyboard_check_pressed(ord(string(i))))
				{
					++i;
						
					continue;
				}
					
				_slot_a = (i == 0 ? INVENTORY_SIZE.ROW : i) - 1;
				
				_item_a = inventory[_slot_a];
				_item_b = inventory[inventory_placement];
		
				global.inventory.base[@ _slot_a] = _item_b;
				global.inventory.base[@ inventory_placement] = _item_a;
				
				obj_Control.surface_refresh_inventory = true;
					
				break;
			}
		}
	
		#endregion
	}

	#endregion

	if (keyboard_check_pressed(vk_anykey)) || (mouse_check_button(mb_left)) || (mouse_check_button_released(mb_left))
	{
		surface_refresh_inventory = true;
	}
}

#endregion

#region Floating Text

var _acceleration = PHYSICS_GLOBAL_GRAVITY * _delta_time / 2;
var _alpha_decrease_speed = FLOATING_TEXT_ALPHA_DECREASE_SPEED * _delta_time;

with (obj_Floating_Text)
{
	x += xvelocity * _delta_time;
	
	yvelocity += _acceleration;
	
	y += yvelocity;
	
	yvelocity += _acceleration;

	image_alpha -= _alpha_decrease_speed;

	if (image_alpha <= 0)
	{
		instance_destroy();
	}
}

#endregion

#region Item Drops

var _inventory = global.inventory;
var _drop_reach_max = 64 + (accessory_get_buff(BUFF_ITEM_REACH, obj_Player) * TILE_SIZE);

var _amount;
var _amount_pre;

var _data;
var _inventory_max;
	
var _picked_up;
var _picked_up_amount;
	
var i;

var _text;

with (obj_Item_Drop)
{
	if (timer > 0)
	{
		timer -= _delta_time;
	}
	
	life += _delta_time;
	
	if (point_distance(x, y, _player_x, _player_y) >= _drop_reach_max) || (timer > 0)
	{
		if (tile_meeting(x, y + 1))
		{
			xvelocity = 0;
			xdirection = 0;
		}
		else
		{
			physics_x(xdirection, 2);
			physics_y();
		}
	
		continue;
	}
	
	xvelocity = 0;
	yvelocity = 0;
	
	xdirection = 0;

	move_towards_point(_player_x, _player_y, 8 * _delta_time);
	
	if (!place_meeting(x, y, obj_Player)) continue;
	
	_data = _item_data[item_id];
	_inventory_max = _data.get_inventory_max();
	
	_picked_up = false;
	_picked_up_amount = 0;
	
	i = 0;
	
	repeat (INVENTORY_SIZE.BASE)
	{	
		_item = _inventory.base[i];
		
		if (_item == INVENTORY_EMPTY)
		{
			_amount_pre = amount;
				
			if (amount <= _inventory_max)
			{
				global.inventory.base[@ i] = new Inventory(item_id, amount);
				amount = 0;
			}
			else 
			{
				global.inventory.base[@ i] = new Inventory(item_id, _inventory_max);
				amount -= _inventory_max;
			}
			
			_picked_up = true;
			_picked_up_amount = _amount_pre - amount;
		}
		else if (_item.item_id == item_id)
		{
			_amount = _item.amount;
			_amount_pre = amount;
				
			if (_amount + amount <= _inventory_max)
			{
				global.inventory.base[@ i].amount += amount;
				amount = 0;
			}
			else 
			{
				global.inventory.base[@ i].amount = _inventory_max;
				amount = (amount - _inventory_max) + (_inventory_max - _amount);
			}
			
			_picked_up = true;
			_picked_up_amount = _amount_pre - amount;
		}
			
		if (_picked_up)
		{
			obj_Control.surface_refresh_inventory = true;
			
			refresh_craftables();
			
			if (show_text)
			{
				_text = loca_translate($"item.{_data.name}.name");
					
				if (_picked_up_amount > 1)
				{
					_text += $" ({_picked_up_amount})";
				}
			
				spawn_text(x, y, new FloatingText(_text)
					.set_yvelocity(-8));
			}
			
			if (amount <= 0)
			{
				instance_destroy();
			}
				
			break;
		}
		
		++i;
	}
}

#endregion

#region Projectiles

var _x;
var _y;

with (obj_Projectile)
{
	_x = physics_x(sign(xvelocity), abs(xvelocity), false, collision, physics_step_projectile);
	_y = physics_y(1, gravity_strength, false, collision, physics_step_projectile);

	life_current += _delta_time;

	if ((life > 0) && (life_current > life)) || ((_x || _y) && (destroy_on_collision))
	{
		instance_destroy();
	
		continue;
	}

	image_angle = (point ? point_direction(x, y, x + xvelocity, y + yvelocity) : (image_angle + (rotation * _delta_time)));
	
	if (fade)
	{
		image_alpha = lerp(1, 0, 1 - (life_current / life));
	}
}

#endregion

#region Particles

var _px1 = _camera_x - TILE_SIZE;
var _py1 = _camera_y - TILE_SIZE;
var _px2 = _camera_x + _camera_width  + TILE_SIZE;
var _py2 = _camera_y + _camera_height + TILE_SIZE;

with (obj_Particle)
{
	life_current += _delta_time;

	if (life_current > life)
	{
		instance_destroy();
	
		continue;
	}

	if (physics_x(sign(xvelocity), abs(xvelocity), false))
	{
		if (boolean & 0b100)
		{
			instance_destroy();
			
			continue;
		}
		
		if (collision)
		{
			if (collision_xvelocity != PARTICLE_COLLISION_EMPTY)
			{
				xvelocity = collision_xvelocity;
			}
				
			if (collision_yvelocity != PARTICLE_COLLISION_EMPTY)
			{
				yvelocity = collision_yvelocity;
			}
		}
	}
	
	if (!rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, _px1, _py1, _px2, _py2))
	{
		instance_destroy();
		
		continue;
	}
	
	if (physics_y(1,, false))
	{
		if (boolean & 0b100)
		{
			instance_destroy();
			
			continue;
		}
		
		if (collision)
		{
			if (collision_xvelocity != PARTICLE_COLLISION_EMPTY)
			{
				xvelocity = collision_xvelocity;
			}
				
			if (collision_yvelocity != PARTICLE_COLLISION_EMPTY)
			{
				yvelocity = collision_yvelocity;
			}
		}
	}
	
	if (!rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, _px1, _py1, _px2, _py2))
	{
		instance_destroy();
		
		continue;
	}

	image_angle += rotation * _delta_time;

	if (boolean & 0b10)
	{
		image_alpha = lerp(1, 0, life_current / life);
	}
}

#endregion

#region Toast
/*
var _i;
var _l;
var _d;

with (obj_Toast)
{
	_i = id;
	_l = life;
	_d = draw;

	with (obj_Toast)
	{
		if (_i != id) && (_l == 0) && (_d == draw) continue;
	}

	life += _delta_time;

	if (life >= life_max)
	{
		instance_destroy();
	}
}
*/
#endregion

if (refresh_sun_ray)
{
	refresh_sun_ray = false;
	
	light_clusterize();
}

// Show / Hide GUI
if (keyboard_check_pressed(vk_f1)) && (!is_opened_chat)
{
	global.local_settings.draw_gui = !global.local_settings.draw_gui;
}

// Snapshot
if (keyboard_check_pressed(vk_f2))
{
	var _surface = surface_create(_camera_width, _camera_height);
	
	surface_set_target(_surface);
	
	draw_surface_stretched(application_surface, 0, 0, _camera_width, _camera_height);
	
	if (global.local_settings.draw_gui)
	{
		draw_surface_stretched(surface_inventory, 0, 0, _camera_width, _camera_height);
		draw_surface_stretched(surface_hp, 0, 0, _camera_width, _camera_height);
	}
	
	surface_reset_target();
	
	surface_save(_surface, $"{DIRECTORY_SNAPSHOTS}/{date_current_datetime()}.png");
	surface_free(_surface);
}