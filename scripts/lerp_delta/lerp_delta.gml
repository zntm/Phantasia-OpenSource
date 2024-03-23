function lerp_delta(_a, _b, _amount, _delta_time = global.delta_time)
{
	return _a + ((_b - _a) * power(1 - _amount, _delta_time));
}