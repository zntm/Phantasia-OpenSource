function item_update_plant(_x, _y, _z, _chance, _max)
{
	if (!chance(_chance)) exit;
	
	var _tile = tile_get(_x, _y, _z, "all");
	
	var _state = _tile.state;
	var _s = _state >> 16;
	
	if (_s < _max)
	{
		tile_set(_x, _y, _z, "state", (++_s << 16) | (_state & 0xffff));
		tile_set(_x, _y, _z, "flip_rotation_index", (_tile.flip_rotation_index & 0xfffffff00) | _state);
	}
}