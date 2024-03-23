var _camera = global.camera;

var _camera_width = _camera.width;
var _camera_height = _camera.height;

#region Clouds

#macro BACKGROUND_CLOUD_DEPTH 4
#macro BACKGROUND_CLOUD_AMOUNT 40

var _sprite = spr_Cloud;

if (global.world.info.seed == string_get_seed("nhj"))
{
	_sprite = spr_Cloud_NHJ;
}

randomize();

var _scale;
var _cloud_ymax = _camera_height / 8;

var i = 0;

repeat (BACKGROUND_CLOUD_AMOUNT)
{
	_scale = random_range(0.8, 1);
	
	clouds[@ i++] = {
		x: random_range(0, _camera_width),
		y: random_range(0, _cloud_ymax),
		
		xvelocity: random_range(0.4, 1),
		xvelocity_offset: random_range(-0.1, 0.1),
		
		sprite: _sprite,
		value: (irandom(1) << 5) | (irandom_range(0, 2) << 2) | irandom(BACKGROUND_CLOUD_DEPTH - 1),
		scale: _scale,
		
		alpha: random_range(0.2, 0.8)
	};
}

#endregion

#region Background

colour_offset = light_get_offset(0, 0, 0);

var _x = floor(obj_Player.x / TILE_SIZE);
var _y = floor(obj_Player.y / TILE_SIZE);

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

in_biome = {
	biome: _biome,
	type:  _biome_type,
	
	sky_colour: _biome_data.sky_colour,
	background: _biome_data.background,
	music: _biome_data.music,
	
	lerp_value: 1
};

in_biome_transition = {
	biome: _biome,
	type:  _biome_type,
	
	sky_colour: _biome_data.sky_colour,
	background: _biome_data.background,
	music: _biome_data.music,
	
	lerp_value: 0
};

#endregion

colour_background = c_black;

colour_sky_solid    = c_black;
colour_sky_gradient = c_black;