function light_get_offset(_r, _g, _b)
{
	var _ave = round((_r + _g + _b) / 3);

	return ((((_ave < 0) << 7) | abs(_ave)) << 24) | ((((_r < 0) << 7) | abs(_r)) << 16) | ((((_g < 0) << 7) | abs(_g)) << 8) | (((_b < 0) << 7) | abs(_b));
}