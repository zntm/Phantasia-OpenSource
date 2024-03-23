var _name;
var _names = global.attire_elements;
var _length = array_length(_names);

var _attire_data = global.attire_data;
var _colour_data = global.colour_data;

var _attire;
var _attire_colour;
var _attire_white;
var _attires = global.menu_player_create_attire;
	
var _colour_white = _colour_data[8];

var _x = x - (11 * image_xscale);
var _y = y - (24 * image_yscale);

var i = 0;

var _match = global.shader_colour_replace_match;
var _replace = global.shader_colour_replace_replace;
var _amount = global.shader_colour_replace_amount;

var j;
var k;

repeat (_length)
{
	_name = _names[i];
	
	if (!surface_exists(surface[$ _name] ?? -1))
	{
		surface[$ _name] = surface_create(22, 32);
		refresh[$ _name] = true;
	}
	
	_attire = _attires[$ _name];
	
	if (refresh[$ _name] ?? true)
	{
		surface_set_target(surface[$ _name]);
		draw_clear_alpha(DRAW_CLEAR_COLOUR, DRAW_CLEAR_ALPHA);
		
		shader_set(shd_Colour_Replace);
		shader_set_uniform_i_array(_match, _colour_white);
		shader_set_uniform_i_array(_replace, _colour_data[_attire.colour]);
		shader_set_uniform_i(_amount, PLAYER_COLOUR_MAP_BASE_AMOUNT + PLAYER_COLOUR_MAP_OUTLINE_AMOUNT);
	
		if (_name == "base_body")
		{
			draw_sprite(att_Base_Arm_Right, 0, 11, 24);
			draw_sprite(att_Base_Body, 0, 11, 24);
			draw_sprite(att_Base_Arm_Left, 0, 11, 24);
			draw_sprite(att_Base_Legs, 0, 11, 24);
		}
		else
		{
			_attire_colour = _attire_data[$ _name][_attire.index];
			
			if (_attire_colour != -1)
			{
				draw_sprite(_attire_colour.colour, 0, 11, 24);
			}
		}
	
		shader_reset();
		
		surface_reset_target();
	}
	
	draw_surface_ext(surface[$ _name], _x, _y, image_xscale, image_yscale, 0, c_white, 1);
	
	if (_name != "base_body")
	{
		_attire_white = _attire_data[$ _name][_attire.index];
		
		if (_attire_white != -1)
		{
			_attire_white = _attire_white.white;
			
			if (_attire_white != -1)
			{
				draw_sprite_ext(_attire_white, 0, x, y, image_xscale, image_yscale, 0, c_white, 1);
			}
		}
	}
	
	++i;
}