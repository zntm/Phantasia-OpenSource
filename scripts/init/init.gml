#macro DEV_DRAW_BACKGROUND true
#macro DEV_MODE false
#macro DEV_COMPILATION_INLINE !DEV_MODE

#macro FORCE_SPAWN_ON SURFACE_BIOME.GREENIA
#macro FORCE_SURFACE_BIOME -1
#macro FORCE_CAVE_BIOME -1

if (!DEV_MODE)
{
	gml_pragma("UnityBuild", "true");
	gml_release_mode(true);
}

global.time_source_rpc = -1;

global.menu_main_fade = true;
global.menu_setting = "general";
global.menu_player_create = "base_body";
global.menu_player_create_page_colour = 0;
global.menu_player_create_page_attire = 0;

#region Directories

#macro DIRECTORY_CRASH_LOGS "Crash_Logs"

if (!directory_exists(DIRECTORY_CRASH_LOGS))
{
	directory_create(DIRECTORY_CRASH_LOGS);
}

#macro DIRECTORY_DATA_PLAYER "Players"

if (!directory_exists(DIRECTORY_DATA_PLAYER))
{
	directory_create(DIRECTORY_DATA_PLAYER);
}

#macro DIRECTORY_SNAPSHOTS "Snapshots"

if (!directory_exists(DIRECTORY_SNAPSHOTS))
{
	directory_create(DIRECTORY_SNAPSHOTS);
}

#macro DIRECTORY_DATA_WORLD "Worlds"

if (!directory_exists(DIRECTORY_DATA_WORLD))
{
	directory_create(DIRECTORY_DATA_WORLD);
}

#macro DIRECTORY_DATA_EXPORTS "Exports"

if (!directory_exists(DIRECTORY_DATA_EXPORTS))
{
	directory_create(DIRECTORY_DATA_EXPORTS);
}

#macro DIRECTORY_DATA_EXPORTS_STRUCTURES "Exports/Structures"

if (!directory_exists(DIRECTORY_DATA_EXPORTS_STRUCTURES))
{
	directory_create(DIRECTORY_DATA_EXPORTS_STRUCTURES);
}
/*
#macro DIRECTORY_DATA_RESOURCE_PACKS "Resource_Packs"

if (!directory_exists(DIRECTORY_DATA_RESOURCE_PACKS))
{
	directory_create(DIRECTORY_DATA_RESOURCE_PACKS);
}

#macro DIRECTORY_DATA_ADDON "Add-ons"

if (!directory_exists(DIRECTORY_DATA_ADDON))
{
	directory_create(DIRECTORY_DATA_ADDON);
}

if (!directory_exists($"{DIRECTORY_DATA_ADDON}_Backup"))
{
	directory_create($"{DIRECTORY_DATA_ADDON}_Backup");
}
*/
#macro MENU_SELECTION_MAX 150

#endregion

#macro FLOATING_TEXT_ALPHA_DECREASE_SPEED 0.02

#macro PLAYER_REACH_MAX 128

#region Macros

#macro GAME_FPS 60

#macro TILE_SIZE_BIT 4
#macro TILE_SIZE (1 << TILE_SIZE_BIT)
#macro WORLD_HEIGHT_TILE_SIZE (WORLD_HEIGHT * TILE_SIZE)

enum VERSION_TYPE {
	RELEASE,
	ALPHA,
	BETA
}

enum VERSION_NUMBER {
	TYPE = VERSION_TYPE.BETA,
	MAJOR = 1,
	MINOR = 0,
	PATCH = 0,
}

#macro DRAW_CLEAR_COLOUR c_black
#macro DRAW_CLEAR_ALPHA 0

#macro CAMERA_VIGENETTE_START floor(WORLD_HEIGHT_CONSTANT / 2)

#macro DRAW_SURFACE_OFFSET (TILE_SIZE * 3)

#macro DRAW_SURFACE_WIDTH  (CHUNK_SIZE_WIDTH  + (DRAW_SURFACE_OFFSET * 2))
#macro DRAW_SURFACE_HEIGHT (CHUNK_SIZE_HEIGHT + (DRAW_SURFACE_OFFSET * 2))

#macro PHYSICS_GLOBAL_GRAVITY 0.65
#macro PHYSICS_GLOBAL_YVELOCITY_MAX 24
#macro PHYSICS_GLOBAL_THRESHOLD_NUDGE 3

#macro PHYSICS_GLOBAL_CLIMB_XSPEED 3
#macro PHYSICS_GLOBAL_CLIMB_YSPEED 6

#macro PHYSICS_PLAYER_WALK_SPEED 3
#macro PHYSICS_PLAYER_RUN_MULTIPLIER 0.5

#macro PHYSICS_PLAYER_JUMP_AMOUNT_MAX 1
#macro PHYSICS_PLAYER_JUMP_HEIGHT 6
#macro PHYSICS_PLAYER_THRESHOLD_COYOTE 2
#macro PHYSICS_PLAYER_THRESHOLD_APEX 2

#macro CHUNK_SIZE_X_BIT 4
#macro CHUNK_SIZE_Y_BIT 4
#macro CHUNK_SIZE_X (1 << CHUNK_SIZE_X_BIT)
#macro CHUNK_SIZE_Y (1 << CHUNK_SIZE_Y_BIT)
#macro CHUNK_SIZE_Z 6

#macro CHUNK_SIZE_WIDTH  (CHUNK_SIZE_X * TILE_SIZE)
#macro CHUNK_SIZE_HEIGHT (CHUNK_SIZE_Y * TILE_SIZE)

#region Chunk Depth

#macro CHUNK_DEPTH_DEFAULT     2
#macro CHUNK_DEPTH_WALL        0
#macro CHUNK_DEPTH_TREE_BACK   1
#macro CHUNK_DEPTH_TREE_FRONT  3
#macro CHUNK_DEPTH_TREE choose(CHUNK_DEPTH_TREE_BACK, CHUNK_DEPTH_TREE_FRONT)
#macro CHUNK_DEPTH_PLANT_BACK  1
#macro CHUNK_DEPTH_PLANT_FRONT 3
#macro CHUNK_DEPTH_PLANT choose(CHUNK_DEPTH_PLANT_BACK, CHUNK_DEPTH_PLANT_FRONT)
#macro CHUNK_DEPTH_LIQUID      (CHUNK_SIZE_Z - 1)

#endregion

#region Social Media

#macro SITE_DISCORD "https://discord.gg/RaG8ArmJRD"
#macro SITE_TWITTER "https://twitter.com/PhantasiaGame"
#macro SITE_SPOTIFY "https://open.spotify.com/artist/4zXQNaC5wCUdKW9YxIBGOS"
#macro SITE_YOUTUBE "https://www.youtube.com/channel/UC2STJKDl-_DfXxuDqpcsb0g"

#endregion

#macro SCROLL_SPEED 12

#macro ACHIEVEMENTS_BUTTON_XSCALE 2
#macro ACHIEVEMENTS_BUTTON_YSCALE 2

#endregion

#region Enums

global.difficulty_multiplier_hp = [ 0.75, 0.9, 1, 1.3 ];
global.difficulty_multiplier_damage = [ 0.6, 0.85, 1, 1.2 ];

#endregion

global.shader_abberation_time = shader_get_uniform(shd_Abberation, "time");

global.shader_colourblind_type = shader_get_uniform(shd_Colourblind, "type");

global.shader_colour_replace_match = shader_get_uniform(shd_Colour_Replace, "match");
global.shader_colour_replace_replace = shader_get_uniform(shd_Colour_Replace, "replace");
global.shader_colour_replace_amount = shader_get_uniform(shd_Colour_Replace, "amount");

global.shader_blur_size = shader_get_uniform(shd_Blur, "size");

global.shader_menu_list_area = shader_get_uniform(shd_Menu_List, "area");
global.shader_menu_list_create = shader_get_uniform(shd_Menu_List, "create");

#macro FADE_SPEED 0.03

exception_unhandled_handler(function(_e)
{
	var _buffer = buffer_create(0x1000, buffer_grow, 1);
	
	var _secret = choose(
		"Oops, this error message also encountered an error.",
		"Oh it looks like we've encountered an error, sad... :(",
		"Ah, more reason to work on old code!",
		"Boo! Did I get ya?",
		"I'll do better next time, I promise!",
		"zhen wrote this error message, tell him he's cool",
		"Stop thinking about the crash... Think about the love. 💜",
		"What if tomorrow, we could go and kidnap Roxanne Ritchi! That always seems to lift your spirits!",
		"Woah what is this wacky error?!",
		"I couldn't tell you.",
		"But what if it was green though.",
		"I’m not saying it was aliens... but it was aliens.",
		"I’m not sure what happened, but it wasn’t supposed to do that.",
		"Would you like an apple pie with that?",
		"cool",
		"Oh good! I'm finally able to talk to you about your car's extended warranty.",
		"Who put that there?",
		"Someone clearly didn't press the button that makes a game.",
		"This is basically like turning it off an on again, right?",
		"Huh?!",
		"Hey, at least this game took less time to develop than 2.2.",
		"Okay girls, let's count to 10.",
		"nisa was here",
		"nisa wasn't here",
		"meow",
		"mewo",
		":)",
		":(",
		";)",
		"Hello.",
		"Hi.",
		"Hey.",
		"Have some respect and don't spoil the game.",
		"It's impossible to have mysteries nowadays.",
		"Because of nosy people like you.",
		"Please keep all of this between us.",
		"If you post it online I won't make any more secrets.",
		"No one will be impressed.",
		"It will be your fault.",
		"WHY IS THERE A DUCK IN A CONICAL HAT WITH A SAMURAI SWORD RUNNING AROUND IN MY CODEBASE?!",
		"No, I do not want a banana.",
		"I intentionally crashed the game, you were simply playing for too long...",
		"Oh no! The game crashed... Or did it? You see, Charles Darwin came up with a theory stating that-",
		"Then BigT busted in like a Level 6 Wall Breaker.",
		"!",
		"?",
		"?!",
		"oh",
		"uhh",
		"guh",
		"Chat, what does this error mean?",
		"Totally not a virus, just a normal error message.",
		"Rate this error message from 1 to 10.",
		"Hoping this isn't game breaking",
		"Automod can handle this.",
		"I'm busy fixing other parts of the game, hold on.",
		"I just need to get the rubber duck.",
		"WAAAAAAAAAAH",
		"Them Jordans fake brah",
		"heck",
		"Your car becomes significantly more flammable if filled with gasoline."
	);
	
	var _message =
		// $"{_secret}\n\n" +
		$"* Error Message:\n{_e.longMessage}\n\n" +
		$"* Stacktrace:\n{string_join_ext("\n", _e.stacktrace)}\n\n" +
		$"It is advised to report this error to the Discord Server (link shown below) so that it will be sorted out in future updates.\n{SITE_DISCORD}"
	
	buffer_poke(_buffer, 0, buffer_text, $"* {_secret}\n\n" + _message);
	buffer_save(_buffer, $"{DIRECTORY_CRASH_LOGS}/{_e.script} (Line {_e.line}).txt");
	buffer_delete(_buffer);
	
	show_debug_message(_message);
    show_message(_message);
});

global.attire_elements = [ "base_body", "headwear", "hair", "eyes", "head_detail", "shirt", "undershirt", "body_detail", "pants", "footwear" ];
global.attire_elements_ordered = [ "base_body", "base_left_arm", "base_right_arm", "base_legs", "eyes", "headwear", "head_detail", "hair", "pants", "shirt", "undershirt", "body_detail", "footwear" ];

global.chunk_cache_chunk = array_create(CHUNK_SIZE_X * CHUNK_SIZE_Y * CHUNK_SIZE_Z, ITEM.EMPTY);
global.chunk_cache_lighting = array_create(CHUNK_SIZE_X * CHUNK_SIZE_Y, 0);