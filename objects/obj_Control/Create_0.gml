// Feather disable GM1050

audio_stop_all();
draw_texture_flush();

texturegroup_load("Game_Creatures");
texturegroup_load("Game_Items");
texturegroup_load("Game_Tiles");
texturegroup_load("Game_Tools");

global.timer = 0;

var _refresh_rate = global.settings.general.refresh_rate;

game_set_speed(real(_refresh_rate.values[_refresh_rate.value]), gamespeed_fps);

global.tick = GAME_FPS;
global.delta_time = 1;

refresh_sun_ray = true;
refresh_time_chunk = REFRESH_TIME_CHUNK_DEFAULT;

is_paused  = false;
is_command = false;
is_exiting = false;

is_opened_chat      = false;
is_opened_container = false;
is_opened_inventory = false;
is_opened_menu      = false;

global.menu_layer = -1;
global.menu_inst = noone;

#macro CHAT_HISTORY_MAX 1024
#macro CHAT_HISTORY_INDEX_MAX 16

chat_message = "";
chat_history_index = 0;

global.chat_history = array_create(CHAT_HISTORY_MAX, -1);

global.inventory_selected_backpack = noone;
global.inventory_selected_hotbar   = global.player.hotbar;

lights = [];

craftable_scroll_offset = 0;

global.cuteify_emote = new Cuteify()
	.set_sprite_prefix("emote_");

#region Load World Data

var _world = global.world;
var _seed = _world.info.seed;

var _world_data = global.world_data[_world.environment.value & 0xf];

random_set_seed(_seed);

var _directory = $"{DIRECTORY_DATA_WORLD}/{_world.directory_name}";

global.directory = _directory;

// global.achievement_unlocks = {};
global.command_value = {};

if (!directory_exists(_directory))
{
	if (FORCE_SPAWN_ON != -1) && (FORCE_SURFACE_BIOME == -1)
	{
		var _attributes = global.world_data[_world.environment.value & 0xf];
		
		var _surface_biome_data = global.surface_biome_data;
		var _surface_biome = _attributes.surface_biome;
		
		var _x;
		var _xstring;
		
		var _ysurface;
		
		var i = 1;
		
		repeat (128)
		{
			_x = (i * CHUNK_SIZE_X) + floor(CHUNK_SIZE_X / 2);
			_xstring = string(_x);
			
			if ((typeof(_surface_biome) == "method" ? _surface_biome(_x, 0, _seed) : SURFACE_BIOME.GREENIA) == FORCE_SPAWN_ON)
			{
				obj_Player.x = _x * TILE_SIZE;
				obj_Player.y = (worldgen_get_ysurface(_x, _seed, _attributes) - 1) * TILE_SIZE;
				
				break;
			}
			
			if ((typeof(_surface_biome) == "method" ? _surface_biome(-_x, 0, _seed) : SURFACE_BIOME.GREENIA) == FORCE_SPAWN_ON)
			{
				obj_Player.x = -_x * TILE_SIZE;
				obj_Player.y = (worldgen_get_ysurface(_x, _seed, _attributes) - 1) * TILE_SIZE;
				
				break;
			}
			
			++i;
		}
	}
	else
	{
		obj_Player.y = (worldgen_get_ysurface(0, _seed) - 1) * TILE_SIZE;
	}
}
else
{
	var _d = $"{DIRECTORY_DATA_WORLD}/{global.world.directory_name}/{_world_data.name}/Spawnpoint/{obj_Player.uuid}.dat";
	
	if (file_exists(_d))
	{
		var _buffer = buffer_load(_d);
		var _buffer2 = buffer_decompress(_buffer);
	
		obj_Player.x = buffer_read(_buffer2, buffer_f64);
		obj_Player.y = buffer_read(_buffer2, buffer_f64);
	}
	
	load_values($"{_directory}/Values.dat");
}

obj_Player.ylast = obj_Player.y;

#endregion

global.container_size = 0;

global.container_tile_position_x = undefined;
global.container_tile_position_y = undefined;
global.container_tile_position_z = undefined;

surface_refresh_chat      = true;
surface_refresh_inventory = true;
surface_refresh_hp        = true;

surface_background  = -1;
surface_boss        = -1;
surface_chat        = -1;
surface_colourblind = -1;
surface_hp          = -1;
surface_inventory   = -1;
surface_lighting    = -1;
surface_mine        = -1;

#region Setup Camera

var _graphics = global.settings.graphics;

var _camera_size = _graphics.camera_size;
var _graphics_camera = string_split(_camera_size.values[_camera_size.value], "x");

var _gui_size = _graphics.gui_size;
var _graphics_gui = string_split(_gui_size.values[_gui_size.value], "x");

var _camera_width  = real(_graphics_camera[0]);
var _camera_height = real(_graphics_camera[1]);

var _camera_x = obj_Player.x - (_camera_width  / 2);
var _camera_y = obj_Player.y - (_camera_height / 2);

var _gui_width  = real(_graphics_gui[0]);
var _gui_height = real(_graphics_gui[1]);

global.camera = {
	x: infinity,
	y: infinity,
	
	x_real:	_camera_x,
	y_real:	_camera_y,
	
	width:  _camera_width,
	height: _camera_height,
	
	gui_width:	_gui_width,
	gui_height:	_gui_height,
	
	shake: 0
};

camera_set_view_pos(view_camera[0], 0, 0);
camera_set_view_size(view_camera[0], _camera_width, _camera_height);

display_set_gui_size(_gui_width, _gui_height);
room_set_viewport(room, 0, true, 0, 0, _camera_width, _camera_height);

#macro GUI_SAFE_ZONE_X 24
#macro GUI_SAFE_ZONE_Y 24

#endregion

#region Inventory

#macro INVENTORY_SLOT_WIDTH  16
#macro INVENTORY_SLOT_HEIGHT 16
#macro INVENTORY_SLOT_SCALE  3

#macro INVENTORY_EMPTY -1

enum INVENTORY_SIZE {
	BASE        = 50,
	ROW         = 10,
	ARMOR       = 3,
	ACCESSORIES = 6,
}

load_inventory();

#endregion

load_structures();
load_entity_item();

#region Sun Rays

var i = 0;

// Used to control how much sun rays get generated off-view
#macro LIGHT_STRECTCH_AMOUNT 8

global.sun_rays = array_create_ext(floor(_camera_width / TILE_SIZE) + (LIGHT_STRECTCH_AMOUNT * 2), function()
{
	return instance_create_layer(0, 0, "Instances", obj_Light_Sun, {
		image_xscale: 1,
		image_yscale: WORLD_HEIGHT
	});
});

global.sun_rays_y = {};

#endregion

#region Discord Rich Presence

if (!time_source_exists(global.time_source_rpc)) && (global.settings.general.discord_rpc.value)
{
	var _rpc = _world_data.rpc;
	
	if (_rpc != -1)
	{
		global.time_source_rpc = time_source_create(time_source_game, _world_data.rpc_seconds, time_source_units_seconds, _rpc, [], -1);
		
		time_source_start(global.time_source_rpc);
	}
}

#endregion

/*
#region Load Bestiary

var _creature_length = array_length(global.creature_data);
var _boss_data = array_length(global.boss_data);

if (file_exists($"{_directory}/bestiary.json"))
{
	var _file = file_text_open_read($"{_directory}/bestiary.json");
	
	var _bestiary = json_parse(file_text_read_string(_file)).bestiary;
	var _bestiary_creature = _bestiary.creature;
	var _bestiary_boss = _bestiary.boss;
	
	global.bestiary = {
		creature: [],
		boss: []
	};
	
	i = 0;
	
	repeat (_creature_length)
	{
		try
		{
			global.bestiary.creature[@ i] = _bestiary_creature[i];
		}
		catch (error)
		{
			global.bestiary.creature[@ i] = 0;
		}
		
		++i;
	}
	
	i = 0;
	
	repeat (_boss_data)
	{
		try
		{
			global.bestiary.boss[@ i] = _bestiary_boss[i];
		}
		catch (error)
		{
			global.bestiary.boss[@ i] = 0;
		}
		
		++i;
	}
	
	file_text_close(_file);
}
else
{
	global.bestiary = {
		creature: array_create(_creature_length, 0),
		boss: array_create(_boss_data, 0)
	};
}

global.kill_count = {
	creature: array_create(_creature_length, 0),
	boss: array_create(_boss_data, 0)
};

var _kill_count = global.player.kill_count;

var _kc_creature = _kill_count.creature;
var _kc_creature_length = array_length(_kc_creature);

i = 0;

repeat (_kc_creature_length)
{
	global.kill_count.creature[@ i] = _kc_creature[i];
	
	++i;
}

var _kc_boss = _kill_count.boss;
var _kc_boss_length = array_length(_kc_boss);

i = 0;

repeat (_kc_boss_length)
{
	global.kill_count.boss[@ i] = _kc_boss[i];
	
	++i;
}
*/