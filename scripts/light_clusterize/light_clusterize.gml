function light_clusterize()
{
	with (obj_Light_Sun)
	{
		y = -512;
	}
	
	var _sun_rays = global.sun_rays;
	
	var _x;
	var _y;
	
	var _current_y = 0;
	var _current_inst;
	
	var _xstart = round(global.camera.x / TILE_SIZE) - LIGHT_STRECTCH_AMOUNT;
	
	var _length = array_length(_sun_rays);
	
	var i = 0;
	var j;
	
	var _sun_rays_y = global.sun_rays_y;

	var _r;

	repeat (_length)
	{
		_x = _xstart + i;
		
		_y = ((_sun_rays_y[$ string(_x)] ?? 0) * TILE_SIZE) - (TILE_SIZE / 2);
			
		if (_y != _current_y)
		{
			_current_y = _y;
			
			_current_inst = _sun_rays[i];
				
			_current_inst.x = _x * TILE_SIZE;
			_current_inst.y = _y;
			
			_current_inst.image_xscale = 1;
		}
		else
		{
			_current_inst.x += (TILE_SIZE / 2);
			
			++_current_inst.image_xscale;
		}
		
		++i;
	}
}