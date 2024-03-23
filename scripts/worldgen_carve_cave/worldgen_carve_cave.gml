function worldgen_carve_cave(_x, _y, _seed, _attributes, _ysurface)
{
	var _caves_value = _attributes.caves_value;
	
	if (_y <= _ysurface + (_caves_value >> 8))
	{
		return false;
	}
	
	var _cave;
	var _caves = _attributes.caves;
		
	var _val;
		
	var _value;
	var _value2;
		
	var i = 0;
		
	repeat (_caves_value & 0xff)
	{
		_cave = _caves[i];
		_value = _cave.value;
			
		if (_y <= ((_value >> 48) & 0xffff)) || (_y > ((_value >> 32) & 0xffff))
		{
			++i;
			
			continue;
		}
		
		_value2 = _cave.value2;
		
		_val = perlin_noise(_x + ((_value >> 16) & 0xffff), _y + (_value & 0xffff), (_value2 >> 16) & 0xff, (_value2 >> 24) & 0xff, _seed);
		
		if (_val > ((_value2 >> 8) & 0xff)) && (_val <= (_value2 & 0xff))
		{
			return true;
		}
		
		++i;
	}
	
	return false;
}