gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);

var _camera = global.camera;

var _gui_width  = _camera.gui_width;
var _gui_height = _camera.gui_height;

var _colourblind = global.settings.accessibility.colourblind.value;

if (_colourblind != 0)
{
	if (!surface_exists(surface_colourblind))
	{
		surface_colourblind = surface_create(_gui_width, _gui_height);
	}
	
	surface_set_target(surface_colourblind);
	
	shader_set(shd_Colourblind);
	
	shader_set_uniform_i(global.shader_colourblind_type, _colourblind);
	
	draw_surface_stretched(application_surface, 0, 0, _gui_width, _gui_height);
	
	shader_reset();
	
	surface_reset_target();
}

if (is_exiting)
{
	shader_set(shd_Blur);
	
	var _surface = surface_get_texture(application_surface);
	
	shader_set_uniform_f(
		global.shader_blur_size,
		texture_get_texel_height(_surface),
		texture_get_texel_width(_surface),
		0.0000008
	);
	
	draw_surface_stretched((_colourblind != 0 ? surface_colourblind : application_surface), 0, 0, _gui_width, _gui_height);
	
	shader_reset();
	
	// TODO: Make it look good
	draw_set_align(fa_center, fa_middle);
	
	var _v = _gui_width / 4;
	var _g = _v / 2;
	
	var _x = _gui_width / 2;
	var _y = _gui_height / 2;
	
	draw_text_transformed(_x, _y - 16, $"Saving... ({chunk_count}/{chunk_count_max})", 2, 2, 0);
	
	draw_sprite_ext(spr_Square, 0, _x - _g, _y + 16, _v, 8, 0, c_black, 1);
	draw_sprite_ext(spr_Square, 0, _x - _g, _y + 16, _v * (chunk_count / chunk_count_max), 8, 0, c_lime, 1);
	
	exit;
}

var _item_data = global.item_data;

if (is_opened_inventory) || (is_paused)
{
	shader_set(shd_Blur);
	
	var _surface = surface_get_texture(application_surface);
	
	shader_set_uniform_f(
		global.shader_blur_size,
		texture_get_texel_height(_surface),
		texture_get_texel_width(_surface),
		0.0000008
	);
	
	draw_surface_stretched((_colourblind != 0 ? surface_colourblind : application_surface), 0, 0, _gui_width, _gui_height);
	
	shader_reset();
}
else
{
	draw_surface_stretched((_colourblind != 0 ? surface_colourblind : application_surface), 0, 0, _gui_width, _gui_height);
}

if (global.local_settings.enable_lighting) && (surface_exists(surface_lighting))
{
	draw_surface_stretched(surface_lighting, 0, 0, _gui_width, _gui_height);
}

draw_set_align(fa_left, fa_top);

var i;
var j;
var _x;
var _y;
var _xoffset;
var _amount;
var _data;
var _length;
var _xscale;
var _colour;
var _alpha;

var _cuteify_emote = global.cuteify_emote;

#region Draw Surfaces

#region Draw HP

var hp     = obj_Player.hp;
var hp_max = obj_Player.hp_max;

var _hp_critical = hp_max * 0.25;

#macro GUI_START_XOFFSET 20
#macro GUI_START_YOFFSET 40
#macro GUI_STATS_AMOUNT_ROW 10

#macro GUI_SEGMENT_THRESHOLD_HP 5

if (hp < _hp_critical)
{
	#macro GUI_HP_VIGNETTE_COLOUR #EA1A17
	#macro GUI_HP_VIGNETTE_ALPHA 0.5
	
	surface_refresh_hp = true;
		
	draw_sprite_stretched_ext(spr_Vignette, 0, 0, 0, _gui_width, _gui_height, GUI_HP_VIGNETTE_COLOUR, clamp((_hp_critical - hp) / _hp_critical, 0, 1) * GUI_HP_VIGNETTE_ALPHA);
		
	if (hp <= 0)
	{
		draw_set_align(fa_center, fa_middle);
			
		_x = _gui_width / 2;
		_y = _gui_height / 2;
		
		draw_text_transformed(_x, _y - 40, loca_translate("gui.death.header"), 3, 3, 0);
		
		draw_text(_x, _y + 40, string_get_death(obj_Player));
		draw_text(_x, _y + 80, string(loca_translate("gui.death.message"), ceil(obj_Player.dead_timer / GAME_FPS)));
	}
}

if (surface_refresh_hp)
{
	surface_refresh_hp = false;
	
	if (!surface_exists(surface_hp))
	{
		surface_hp = surface_create(_gui_width, _gui_height);
	}
	
	surface_set_target(surface_hp);
	draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
	
	#macro GUI_HP_XSCALE 2
	#macro GUI_HP_YSCALE 2
	
	draw_set_align(fa_right, fa_bottom);
	draw_set_font(global.font_current);
	
	draw_text(_gui_width - GUI_START_XOFFSET, GUI_START_YOFFSET, $"HP: {hp}/{hp_max}");

	draw_set_halign(fa_left);
	
	var _width  = sprite_get_width(gui_Heart) * GUI_HP_XSCALE;
	var _height = sprite_get_height(gui_Heart) * GUI_HP_YSCALE;
	
	var _xstart = _gui_width - (_width * GUI_STATS_AMOUNT_ROW) - GUI_START_XOFFSET;
	var _hp_clamped = max(GUI_SEGMENT_THRESHOLD_HP, hp);

	var _row_xoffset;
	var _row_yoffset;
	
	randomize();
	
	_amount = ceil(hp_max / GUI_STATS_AMOUNT_ROW);
	
	var _w = _width + 1;
	var _h = _height + 1;
	
	i = 0;
	
	if (hp < _hp_critical)
	{
		repeat (_amount)
		{
			_row_xoffset = i mod GUI_STATS_AMOUNT_ROW;
			
			draw_sprite_ext(gui_Heart, clamp(ceil((_hp_clamped - (i * GUI_STATS_AMOUNT_ROW)) / GUI_SEGMENT_THRESHOLD_HP), 0, 2) + ((_row_xoffset > 0) * 3), _xstart + (_row_xoffset * _w) + (random_range(-2, 2) * _hp_critical), GUI_START_YOFFSET + ((i div GUI_STATS_AMOUNT_ROW) * _h) + (random_range(-2, 2) * _hp_critical), GUI_HP_XSCALE, GUI_HP_YSCALE, 0, c_white, 1);
		
			++i;
		}
	}
	else
	{
		repeat (_amount)
		{
			_row_xoffset = i mod GUI_STATS_AMOUNT_ROW;
			
			draw_sprite_ext(gui_Heart, clamp(ceil((_hp_clamped - (i * GUI_STATS_AMOUNT_ROW)) / GUI_SEGMENT_THRESHOLD_HP), 0, 2) + ((_row_xoffset > 0) * 3), _xstart + (_row_xoffset * _w), GUI_START_YOFFSET + (i div GUI_STATS_AMOUNT_ROW) * _h, GUI_HP_XSCALE, GUI_HP_YSCALE, 0, c_white, 1);
		
			++i;
		}
	}
	
	surface_reset_target();
}
	
#endregion

var _inventory = global.inventory;

var _gui_mouse_x = display_mouse_get_x() / display_get_gui_width() * _gui_width;
var _gui_mouse_y = display_mouse_get_y() / display_get_gui_height() * _gui_height;

global.gui_mouse_x = _gui_mouse_x;
global.gui_mouse_y = _gui_mouse_y;

#region Draw Inventory

if (surface_refresh_inventory)
{
	surface_refresh_inventory = false;
	
	if (!surface_exists(surface_inventory))
	{
		surface_inventory = surface_create(_gui_width, _gui_height);
	}
	
	surface_set_target(surface_inventory);
	draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
	
	draw_set_align(fa_left, fa_top);
	
	struct_foreach(_inventory, gui_inventory);
	
	#macro GUI_DEFENSE_SCALE 2
	
	if (is_opened_inventory)
	{
		_x = _gui_width  - GUI_SAFE_ZONE_X - (INVENTORY_SLOT_WIDTH  * INVENTORY_SLOT_SCALE * 2) - (1 * INVENTORY_SLOT_SCALE) + (INVENTORY_SLOT_WIDTH * INVENTORY_SLOT_SCALE / 2);
		_y = _gui_height - GUI_SAFE_ZONE_Y - (INVENTORY_SLOT_HEIGHT * INVENTORY_SLOT_SCALE * 3) - (sprite_get_height(ico_Effect_Defense) * GUI_DEFENSE_SCALE);
	
		draw_sprite_ext(ico_Effect_Defense, 0, _x, _y, GUI_DEFENSE_SCALE, GUI_DEFENSE_SCALE, 0, c_white, 1);
		
		draw_set_align(fa_center, fa_middle);
		
		#macro GUI_DEFENSE_TEXT_XOFFSET 0
		#macro GUI_DEFENSE_TEXT_YOFFSET 4
		
		draw_text_transformed(_x + GUI_DEFENSE_TEXT_XOFFSET, _y + GUI_DEFENSE_TEXT_YOFFSET, accessory_get_buff(BUFF_DEFENSE, obj_Player), GUI_DEFENSE_SCALE / 2, GUI_DEFENSE_SCALE / 2, 0);
	}
	else
	{
		var _item = _inventory.base[global.inventory_selected_hotbar];
		
		if (_item != INVENTORY_EMPTY)
		{
			draw_set_align(fa_left, fa_top);
			
			#macro GUI_INVENTORY_ITEM_NAME_XOFFSET 0
			#macro GUI_INVENTORY_ITEM_NAME_YOFFSET 4
			
			draw_text(GUI_SAFE_ZONE_X + GUI_INVENTORY_ITEM_NAME_XOFFSET, GUI_SAFE_ZONE_Y + (INVENTORY_SLOT_WIDTH * INVENTORY_SLOT_SCALE) + GUI_INVENTORY_ITEM_NAME_YOFFSET, loca_translate($"item.{_item_data[_item.item_id].name}.name"));
		}
	}
	
	if (array_length(_inventory.container) == 0)
	{
		var _recipe;
		var _item_x;
		var _item_y;
		var _scale;
		
		with (obj_Inventory)
		{
			if (type != "craftable") continue;
			
			_colour = (enough_ingredients ? c_white : c_dkgray);
			
			_xoffset = xoffset - 1 + (INVENTORY_SLOT_WIDTH  * INVENTORY_CRAFTABLE_SCALE);
			_y       = yoffset - 1 + (INVENTORY_SLOT_HEIGHT * INVENTORY_CRAFTABLE_SCALE / 2);
			
			i = 0;
			_length = array_length(crafting_recipes);
			
			repeat (_length)
			{
				_recipe = crafting_recipes[i];
				
				#macro INVENTORY_CRAFTABLE_SCALE 0.75
				#macro INVENTORY_SLOT_CRAFTABLE_SCALE (INVENTORY_SLOT_SCALE * INVENTORY_CRAFTABLE_SCALE)
				
				_x = _xoffset + ((i + 1) * INVENTORY_SLOT_WIDTH * INVENTORY_SLOT_SCALE);
				
				draw_sprite_ext(sprite, 1, _x, _y, INVENTORY_SLOT_CRAFTABLE_SCALE, INVENTORY_SLOT_CRAFTABLE_SCALE, 0, _colour, 1);
				draw_sprite_ext(sprite, 0, _x, _y, INVENTORY_SLOT_CRAFTABLE_SCALE, INVENTORY_SLOT_CRAFTABLE_SCALE, 0, _colour, 1);
				draw_sprite_ext(sprite, 2, _x, _y, INVENTORY_SLOT_CRAFTABLE_SCALE, INVENTORY_SLOT_CRAFTABLE_SCALE, 0, _colour, background_alpha);
				
				_item_x = _x + (INVENTORY_SLOT_CRAFTABLE_SCALE * INVENTORY_SLOT_WIDTH  / 2);
				_item_y = _y + (INVENTORY_SLOT_CRAFTABLE_SCALE * INVENTORY_SLOT_HEIGHT / 2);
				
				_data = _item_data[_recipe & 0xffff];
				_scale = _data.get_inventory_scale() * INVENTORY_CRAFTABLE_SCALE;
				
				draw_sprite_ext(_data.sprite, 0, _item_x, _item_y, _scale, _scale, 0, _colour, 1);
				
				_amount = _recipe >> 32;
				
				if (_amount > 1)
				{
					draw_text_transformed_colour(_item_x + (GUI_AMOUNT_XOFFSET * INVENTORY_CRAFTABLE_SCALE), _item_y + (GUI_AMOUNT_YOFFSET * INVENTORY_CRAFTABLE_SCALE), _amount, INVENTORY_CRAFTABLE_SCALE, INVENTORY_CRAFTABLE_SCALE, 0, _colour, _colour, _colour, _colour, 1);
				}
				
				++i;
			}
		}
	}
	
	surface_reset_target();
}

#endregion

#endregion

var _player_x = obj_Player.x;
var _player_y = obj_Player.y;

// Draw vignette at lower regions of the world
var _alpha_vignette = ((_player_y / TILE_SIZE) - (WORLD_HEIGHT - CAMERA_VIGENETTE_START)) / CAMERA_VIGENETTE_START;

if (_alpha_vignette > 0)
{
	draw_sprite_stretched_ext(spr_Vignette, 0, 0, 0, _gui_width, _gui_height, c_black, _alpha_vignette);
}

gui_effects();

if (instance_exists(obj_Boss))
{
	gui_boss_hp();
}

with (obj_Toast)
{
	if (life > 0)
	{
		draw(x, y, id);
	}
}

if (global.local_settings.draw_fps) && (!is_opened_chat) && (!is_opened_inventory)
{
	draw_set_align(fa_left, fa_bottom);
	
	_x = round(_player_x / TILE_SIZE);
	_y = round(_player_y / TILE_SIZE);
	
	var _seed = global.world.info.seed;
	
	draw_text_transformed_colour(8, _gui_height - 8,
		$"- Player Variables:\n" +
		$"X: {_player_x}\n" +
		$"Y: {_player_y}\n\n" +
		$"- FPS Variables:\n" +
		$"FPS: {fps}/{fps_real} ({1000 / fps_real}ms)\n" +
		$"Delta Time: {global.delta_time}\n" +
		$"Game Time: {global.timer}\n\n" +
		$"- World Variables:\n" +
		$"Seed: {_seed}\n" +
		$"Chunks Loaded: {instance_number(obj_Chunk)}",
		0.75, 0.75, 0, c_white, c_white, c_white, c_white, 0.25
	);
}

if (is_paused)
{
	draw_set_align(fa_center, fa_middle);
	
	_x = _gui_width / 2;
	_y = _gui_height / 2;
	
	draw_text_transformed(_x, _y, "Game Paused", 3, 3, 0);
	draw_text_transformed(_x, _y + 40, "Press esc to resume\nPress enter to go back to main menu", 1, 1, 0);
}

if (hp > 0) && (global.local_settings.draw_gui) && (!is_opened_menu)
{
	if (surface_exists(surface_hp))
	{
		draw_surface(surface_hp, 0, 0);
	}
	
	if (surface_exists(surface_inventory))
	{
		draw_surface(surface_inventory, 0, 0);
	}
		
	gui_item_tooltip();
}

var _index;
var _message;
var _input;
var _default_value;
var _subcommands;
var _subcommands_length;
var _subcommand;
var _subcommand_data;
var _is_subcommand;

draw_set_align(fa_left, fa_top);

if (global.local_settings.draw_gui)
{
	var _chat_history = global.chat_history;

	#macro GUI_CHAT_XOFFSET 0
	#macro GUI_CHAT_YOFFSET -8
	
	#macro GUI_CHAT_XSCALE_OFFSET -1
	#macro GUI_CHAT_YSCALE_OFFSET 0
	
	#macro GUI_CHAT_TEXT_XOFFSET 2
	#macro GUI_CHAT_TEXT_YOFFSET -6
	
	#macro GUI_CHAT_TEXT_XSCALE 2
	#macro GUI_CHAT_TEXT_YSCALE 2
	
	var _width  = sprite_get_width(gui_Chat);
	var _height = sprite_get_height(gui_Chat);
	
		_xscale = (_gui_width / _width) + GUI_CHAT_XSCALE_OFFSET;
	var _yscale = 3 + GUI_CHAT_YSCALE_OFFSET;
	
	var _box_x = (_gui_width / 2) + GUI_CHAT_XOFFSET;
	var _box_y = _gui_height - (_height * _yscale / 2) + GUI_CHAT_YOFFSET;

	var _text_x = (_width * -GUI_CHAT_XSCALE_OFFSET) + GUI_CHAT_TEXT_XOFFSET;
	var _text_y = _box_y - (string_height(chat_message) / 2) + GUI_CHAT_TEXT_YOFFSET;

	var _history_ystart = _gui_height - (_height * _yscale) + GUI_CHAT_YOFFSET;
	var _history_height = string_height("Message");
	
	i = 0;
	
	var _delta_time = global.delta_time;

	repeat (CHAT_HISTORY_MAX)
	{
		_message = _chat_history[i];
	
		if (_message == -1) break;
	
		_alpha = normalize(_message.timer, 0, 60);
	
		if (_alpha > 0)
		{
			surface_refresh_chat = true;
		
			global.chat_history[@ i].timer -= _delta_time;
		}
		else
		{
			global.chat_history[@ i] = -1;
		}
		
		++i;
	}

	if (is_opened_chat)
	{
		draw_sprite_ext(gui_Chat, 0, _box_x, _box_y, _xscale, _yscale, 0, c_white, 0.5);
		
		draw_set_align(fa_left, fa_top);
	
		draw_text_cuteify(_text_x, _text_y, chat_message, GUI_CHAT_TEXT_XSCALE, GUI_CHAT_TEXT_YSCALE,,,, _cuteify_emote);
		
		if (floor(global.timer / 30) % 2 == 0)
		{
			_colour = cuteify_get_colour(chat_message, _cuteify_emote);
		
			draw_text_transformed_color(_text_x + (cuteify_get_width(chat_message, _cuteify_emote) * GUI_CHAT_TEXT_XSCALE), _text_y, "|", GUI_CHAT_TEXT_XSCALE, GUI_CHAT_TEXT_YSCALE, 0, _colour, _colour, _colour, _colour, 0.5);
		}
	}

	if (surface_refresh_chat)
	{
		surface_refresh_chat = false;
	
		if (!surface_exists(surface_chat))
		{
			surface_chat = surface_create(_gui_width, _gui_height);
		}
	
		surface_set_target(surface_chat);
		draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
		
		if (is_command)
		{
			gui_chat_command(_text_x, _history_ystart, _history_height);
		}
		else
		{
			gui_chat_history(_text_x, _history_ystart, _history_height);
		}
	
		surface_reset_target();
	}

	draw_surface(surface_chat, 0, 0);
}