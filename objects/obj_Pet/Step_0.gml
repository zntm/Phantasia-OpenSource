if (obj_Control.is_paused) exit;

var _x = obj_Player.x;
var _y = obj_Player.y;

var _distance = point_distance(x, y, _x, _y);

if (type == PET_TYPE.FLY) || (_distance > 256)
{
	var _direction = sign(obj_Player.xvelocity);
	
	if (_direction != 0)
	{
		xoffset = _direction;
	}

	var _speed = (_distance > 16 * 8 ? 0.035 : 0.025);

	x = lerp_delta(x, _x - (xoffset * 24), _speed);
	y = lerp_delta(y, _y - 32, _speed);

	// image_xscale = (x < _x ? 1 : -1);
	// image_yscale = (y < _y ? 1 : -1);

	if (_distance > 128)
	{
		sprite_index = sprite_moving;
		image_angle = lerp_delta(image_angle, clamp(image_angle - image_xscale, -45, 45), 0.45);
	}
	else
	{
		sprite_index = sprite_idle;
		image_angle = lerp_delta(image_angle, 0, 0.05);
	}
}
else if (type == PET_TYPE.WALK)
{
	var _direction = (_distance > 64 ? (x < _x ? 1 : -1) : 0);
	
	if (tile_meeting(x + _direction, y)) && (tile_meeting(x, y + 1))
	{
		yvelocity = -8;
	}
	
	physics_x(_direction, 4);
	physics_y();
	
	if (tile_meeting(x, y + 1)) && (xvelocity == 0 || yvelocity == 0)
	{
		sprite_index = sprite_moving;
	}
	else
	{
		sprite_index = sprite_idle;
	}
}

image_xscale = (x < _x ? 1 : -1);