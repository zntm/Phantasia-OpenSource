function chunk_refresh(_x, _y, _force = false)
{
	if (!_force) && (global.timer % obj_Control.refresh_time_chunk != 0) exit;
	
	var _camera = global.camera;
	
	var _xamount = ceil(_camera.width  / CHUNK_SIZE_WIDTH  / 2) + 1;
	var _yamount = ceil(_camera.height / CHUNK_SIZE_HEIGHT / 2) + 1;
	
	var _repeat_x = _xamount * 2;
	var _repeat_y = _yamount * 2;
	
	var _xstart = floor(_x / CHUNK_SIZE_WIDTH)  * CHUNK_SIZE_WIDTH;
	var _ystart = floor(_y / CHUNK_SIZE_HEIGHT) * CHUNK_SIZE_HEIGHT;
	
	var _cx;
	var _inst;
	
	var i = -_xamount;
	var j;
	
	if (_force)
	{
		repeat (_repeat_x)
		{
			_cx = _xstart + (i++ * CHUNK_SIZE_WIDTH);
		
			j = -_yamount;
		
			repeat (_repeat_y)
			{
				_inst = instance_nearest(_cx, _ystart + (j++ * CHUNK_SIZE_HEIGHT), obj_Chunk);
				
				_inst.is_in_view = true;
				_inst.is_refresh = true;
			}
		}
	
		exit;
	}
	
	repeat (_repeat_x)
	{
		_cx = _xstart + (i++ * CHUNK_SIZE_WIDTH);
		
		j = -_yamount;
		
		repeat (_repeat_y)
		{
			_inst = instance_nearest(_cx, _ystart + (j++ * CHUNK_SIZE_HEIGHT), obj_Chunk);
			
			_inst.is_in_view = true;
		}
	}
}