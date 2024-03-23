function cubic_midpoint_ease_in_out(_x, _w = 0.5)
{
	
	
	static __hermite = function(p0, v0, p1, v1, _x)
	{
		var _x2 = _x * _x;
	
		return (_x2 * _x * ((2 * p0) + v0 - (2 * p1) + v1)) + (_x2 * ((-3 * p0) - (2 * v0) + (3 * p1) - v1)) + (_x * v0) + p0;
	}
	
	return (_x <= 0.5 ? __hermite(0, 0, _w, 3 * (_w < 0.5 ? _w : 1 - _w), 2 * _x) : __hermite(_w, 3 * (_w < 0.5 ? _w : 1 - _w), 1, 0, (2 * _x) - 1));
}