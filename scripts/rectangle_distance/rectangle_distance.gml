/// @func rectangle_distance(px, py, x1, y1, x2, y2)
/// @desc Returns the distance from a point and a rectangle.
/// @arg {Real} px The coordinate of the point
/// @arg {Real} py The coordinate of the point
/// @arg {Real} x1 The coordinate of the left part of the rectangle
/// @arg {Real} y1 The coordinate of the top part of the rectangle
/// @arg {Real} x2 The coordinate of the right part of the rectangle
/// @arg {Real} y2 The coordinate of the bottom part of the rectangle
function rectangle_distance(px, py, x1, y1, x2, y2)
{
	
	
	static __init = false;
	static __values = [];
	
	if (!__init)
	{
		__init = true;
		
		for (var i = 0; i < 512; ++i)
		{
			for (var j = 0; j < 512; ++j)
			{
				__values[@ i + (j * 512)] = sqrt((i * i) + (j * j));
			}
		}
	}
	
	var _x1 = x1 - px;
	var _x2 = px - x2;
	var _x = (_x1 > _x2 ? _x1 : _x2);
	
	var _y1 = y1 - py;
	var _y2 = py - y2;
	var _y = (_y1 > _y2 ? _y1 : _y2);
	
	switch (((_x <= 0) << 1) | (_y <= 0))
	{
		case 0b_11:
			return 0;
		
		case 0b_10:
			return _y;
		
		case 0b_01:
			return _x;
	}
	
	var _a = abs(_x >> 0);
	var _b = abs(_y >> 0);
	
	if ((_a | _b) < 512)
	{
		return __values[_a + (_b * 512)];
	}
	
	return sqrt((_a * _a) + (_b * _b));
}