var _camera = global.camera;
		
var _camera_x = _camera.x;
var _camera_y = _camera.y;

var _camera_width  = _camera.width;
var _camera_height = _camera.height;

var _camera_half_width  = _camera_width  / 2;
var _camera_half_height = _camera_height / 2;

if (!DEV_DRAW_BACKGROUND) || (!global.settings.graphics.background.value)
{
	draw_sprite_ext(spr_Square, 0, _camera_x - 32, _camera_y - 32, display_get_width(), display_get_height(), 0, colour_sky_solid, 1);
	draw_sprite_ext(spr_Glow, 0, _camera_x + _camera_half_width, _camera_y + _camera_height, _camera_width, 4, 0, colour_sky_gradient, 1);

	exit;
}

if (!surface_exists(obj_Control.surface_background))
{
	obj_Control.surface_background = surface_create(_camera_width, _camera_height);
}

surface_set_target(obj_Control.surface_background);
draw_clear_alpha(c_black, 0);

draw_sprite_ext(spr_Square, 0, -16, -16, display_get_width() + 32, display_get_height() + 32, 0, colour_sky_solid, 1);
draw_sprite_ext(spr_Glow, 0, _camera_half_width, _camera_height, _camera_width, 4, 0, colour_sky_gradient, 1);

var _lerp_value;
var _multiplier;

var _xamount;
var _yamount;

var _xoffset;
var _yoffset;

var _index;

var _sprite;
var _sprite_width;
var _sprite_height;

var _cloud;
var _cloud_x;
var _cloud_update;

#macro BACKGROUND_CLOUD_EDGE 128

var _cloud_max = _camera_width + BACKGROUND_CLOUD_EDGE;

var _scale;
var _value;

var _is_paused = obj_Control.is_paused;

var _player_x = obj_Player.x;
var _player_y = obj_Player.y;

var _bg_x;
var _bg_y = _camera_height;

var _type = in_biome.type;
var _transition_type = in_biome_transition.type;

var _background = in_biome.background;
var _transition_background = in_biome_transition.background;

var _bg_length = array_length(_background);
var _bg_transition_length = array_length(_transition_background);

var _wind = global.world.environment.weather_wind;
var _wind_multiplier = _wind - 0.5;
var _wind_multiplier_abs = (abs(_wind_multiplier) > 0.2);

var _delta_time = global.delta_time;

var i = 0;
var j;
var l;

repeat (BACKGROUND_CLOUD_DEPTH)
{
	_lerp_value = in_biome.lerp_value;
	
	if (_type == BIOME_TYPE.SURFACE)
	{
		j = 0;
		
		repeat (BACKGROUND_CLOUD_AMOUNT)
		{
			_cloud = clouds[j];
			_value = _cloud.value;
		
			if ((_value & 0b11) != i)
			{
				++j;
				
				continue;
			}
			
			_cloud_x = _cloud.x;
			
			if (!_is_paused)
			{
				_cloud_x += ((_cloud.xvelocity * _wind_multiplier) + _cloud.xvelocity_offset) * _delta_time;
				_cloud_update = false;
			
				if (_cloud_x > _cloud_max)
				{
					_cloud_x = -BACKGROUND_CLOUD_EDGE;
					_cloud_update = true;
				}
				else if (_cloud_x < -BACKGROUND_CLOUD_EDGE)
				{
					_cloud_x = _cloud_max;
					_cloud_update = true;
				}
				
				clouds[@ j].x = _cloud_x;
			
				if (_cloud_update)
				{
					if (_wind_multiplier_abs) && (chance(0.5))
					{
						clouds[@ j].value = ((_wind > 0.5) << 5) | (irandom_range(3, 5) << 2) | (_value & 0b11);
					}
					else
					{
						clouds[@ j].value = (irandom(1) << 5) | (irandom_range(0, 2) << 2) | (_value & 0b11);
					}
				}
			}
				
			_scale = _cloud.scale;
		
			draw_sprite_ext(_cloud.sprite, (_value >> 2) & 011, _cloud_x, _cloud.y, ((_value & 0b100000) ? -_scale : _scale), _scale, 0, colour_background, _cloud.alpha * _lerp_value);
			
			++j;
		}
	}
	
	if (i < _bg_length)
	{
		_sprite = _background[i];
		_sprite_width = sprite_get_width(_sprite);
		
		if (_type == BIOME_TYPE.CAVE)
		{
			_sprite_height = sprite_get_height(_sprite);
			
			_xamount = ceil(((_camera_width  / _sprite_width)  + 1) / 2);
			_yamount = ceil(((_camera_height / _sprite_height) + 1) / 2);
			
			_multiplier = (i + 1) * 0.05;
			
			_xoffset = _camera_half_width  - ((_player_x * _multiplier) % _sprite_width);
			_yoffset = _camera_half_height - ((_player_y * _multiplier) % _sprite_height);
			
			_index = i;
			
			j = -_xamount;
			
			repeat ((_xamount * 2) + 1)
			{
				_bg_x = (j++ * _sprite_width) + _xoffset;
				
				l = -_yamount;
				
				repeat ((_yamount * 2) + 1)
				{
					draw_sprite_ext(_sprite, 0, _bg_x, (l++ * _sprite_width) + _yoffset, 1, 1, 0, colour_background, _lerp_value);
				}
			}
		}
		else
		{
			_xoffset = (_player_x * (i + 1) * 0.05) % _sprite_width;
		
			j = -2;
			
			repeat (5)
			{
				draw_sprite_ext(_sprite, 0, (j++ * _sprite_width) + _xoffset, _bg_y, 1, 1, 0, colour_background, _lerp_value);
			}
		}
	}
	
	if (i < _bg_transition_length)
	{
		_lerp_value = in_biome_transition.lerp_value;
		
		_sprite = _transition_background[i];
		_sprite_width = sprite_get_width(_sprite);
		
		if (_transition_type == BIOME_TYPE.CAVE)
		{
			_sprite_height = sprite_get_width(_sprite);
			
			_xamount = ceil(((_camera_width  / _sprite_width)  + 1) / 2);
			_yamount = ceil(((_camera_height / _sprite_height) + 1) / 2);
			
			_multiplier = (i + 1) * 0.05;
			
			_xoffset = _camera_half_width  - ((_player_x * _multiplier) % _sprite_width);
			_yoffset = _camera_half_height - ((_player_y * _multiplier) % _sprite_height);
			
			_index = i;
			
			j = -_xamount;
			
			repeat ((_xamount * 2) + 1)
			{
				_bg_x = (j++ * _sprite_width) + _xoffset;
				
				l = -_yamount;
				
				repeat ((_yamount * 2) + 1)
				{
					draw_sprite_ext(_sprite, 0, _bg_x, (l++ * _sprite_width) + _yoffset, 1, 1, 0, colour_background, _lerp_value);
				}
			}
		}
		else
		{
			_xoffset = (_player_x * (i + 1) * 0.05) % _sprite_width;
		
			j = -2;
			
			repeat (5)
			{
				draw_sprite_ext(_sprite, 0, (j++ * _sprite_width) + _xoffset, _bg_y, 1, 1, 0, colour_background, _lerp_value);
			}
		}
	}
	
	++i;
}

surface_reset_target();

shader_set(shd_Abberation);
shader_set_uniform_f(global.shader_abberation_time, global.timer);

draw_surface(obj_Control.surface_background, _camera_x, _camera_y);

shader_reset();