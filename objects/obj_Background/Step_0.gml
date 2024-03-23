if (obj_Control.is_paused) exit;

#region Transition Manager

var _x = round(obj_Player.x / TILE_SIZE);
var _y = round(obj_Player.y / TILE_SIZE);

var _seed = global.world.info.seed;
var _attributes = global.world_data[global.world.environment.value & 0xf];

var _biome = _attributes.cave_biome;
	_biome = (is_method(_biome) ? _biome(_x, _y, _seed) : (_biome != -1 ? _biome : (_y > EMUSTONE_YSTART ? CAVE_BIOME.EMUSTONE : CAVE_BIOME.STONE)));
	
var _biome_data, _biome_type;

if (is_method(_biome))
{
	_biome_data = global.cave_biome_data[_biome];
	_biome_type = BIOME_TYPE.CAVE;
}
else
{
	_biome = _attributes.sky_biome;
	_biome = (is_method(_biome) ? _biome(_x, _y, _seed) : _biome);
	
	if (is_method(_biome))
	{
		_biome_data = global.sky_biome_data[_biome];
		_biome_type = BIOME_TYPE.SKY;
	}
	else
	{
		_biome = _attributes.surface_biome;
		_biome = (is_method(_biome) ? _biome(_x, _y, _seed) : _biome);
	
		_biome_data = global.surface_biome_data[_biome];
		_biome_type = BIOME_TYPE.SURFACE;
	}
}

#macro BACKGROUND_TRANSITION_SPEED 0.075

var _speed = BACKGROUND_TRANSITION_SPEED * global.delta_time;

if (in_biome_transition.lerp_value <= 0)
{
	if (in_biome.biome != _biome) || (in_biome.type != _biome_type)
	{
		in_biome.lerp_value = 1 - _speed;
		in_biome_transition.lerp_value = _speed;
		
		in_biome_transition.biome = _biome;
		in_biome_transition.type  = _biome_type;
		
		in_biome_transition.sky_colour = _biome_data.sky_colour;
		in_biome_transition.background = _biome_data.background;
		in_biome_transition.music = _biome_data.music;
	}
}
else
{
	in_biome.lerp_value -= _speed;
	in_biome_transition.lerp_value += _speed;
	
	if (in_biome_transition.lerp_value >= 1)
	{
		#region Stop Current Music
		
		var _music = in_biome.music;
		
		if (_music != -1)
		{
			var i = 0;
			var _length = array_length(_music);
			var _music_current;
		
			repeat (_length)
			{
				_music_current = _music[i];
			
				if (audio_is_playing(_music_current))
				{
					#macro MUSIC_FADE_SECONDS 1
				
					audio_sound_gain(_music_current, 0, MUSIC_FADE_SECONDS * 1000);
				
					break;
				}
				
				++i;
			}
		}
		
		#endregion
		
		if (!instance_exists(obj_Toast))
		{
			spawn_toast(GAME_FPS * 8, toast_biome);
		}
		
		in_biome.biome = in_biome_transition.biome;
		in_biome.type  = in_biome_transition.type;
		
		in_biome.sky_colour = in_biome_transition.sky_colour;
		in_biome.background = in_biome_transition.background;
		in_biome.music = in_biome_transition.music;
		
		in_biome.lerp_value = 1;
		in_biome_transition.lerp_value = 0;
	}
}

#endregion

var _world_time = (global.world.environment.time + 23400) % 54000;

global.light_updated_sun = false;

bg_time_update(_world_time, DIURNAL.DUSK,  DIURNAL.NIGHT, 50400, 54000);
bg_time_update(_world_time, DIURNAL.DAY,   DIURNAL.DUSK,  23400, 50400);
bg_time_update(_world_time, DIURNAL.DAWN,  DIURNAL.DAY,   3600,  23400);
bg_time_update(_world_time, DIURNAL.NIGHT, DIURNAL.DAWN,  0,     3600);

#region Sun Colour Offset

if (global.local_settings.enable_lighting)
{
	var _cr = (colour_offset >> 16) & 0xff;
	var _cg = (colour_offset >> 8) & 0xff;
	var _cb = colour_offset & 0xff;
	
	colour_background = ((((127 + (_cr & 0b_1_0000000 ? -(_cr & 0b_0_1111111) : (_cr & 0b_0_1111111))) << 1) & 255) << 16) | ((((127 + (_cg & 0b_1_0000000 ? -(_cg & 0b_0_1111111) : (_cg & 0b_0_1111111))) << 1) & 255) << 8) | (((127 + (_cb & 0b_1_0000000 ? -(_cb & 0b_0_1111111) : (_cb & 0b_0_1111111))) << 1) & 255);
	
	var _colour = colour_offset;
	
	with (obj_Light_Sun)
	{
		colour_offset = _colour;
	}
}
else
{
	colour_background = c_white;
	
	var _colour = light_get_offset(0, 0, 0);
	
	with (obj_Light_Sun)
	{
		colour_offset = _colour;
	}
}

#endregion

#region Background Music

var _music = in_biome.music;

if (_music != -1)
{
	var _current;
	
	// Check all music in biome if one is playing
	var _playing = false;
	
	var i = 0;
	var _length = array_length(_music);
	
	repeat (_length)
	{
		_current = _music[i];
		
		if (audio_is_playing(_current))
		{
			_playing = true;
			
			audio_sound_gain(_current, global.settings.audio.master.value * global.settings.audio.music.value, MUSIC_FADE_SECONDS * 1000);
				
			break;
		}
		
		++i;
	}
	
	if (!_playing)
	{
		var _play = _music[irandom(_length - 1)];
		
		audio_sound_gain(_play, 0, 0);
		audio_sound_gain(_play, global.settings.audio.master.value * global.settings.audio.music.value, MUSIC_FADE_SECONDS * 1000);
		audio_play_sound(_play, 0, false);
	}
}

#endregion