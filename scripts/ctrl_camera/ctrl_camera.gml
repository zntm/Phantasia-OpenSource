function ctrl_camera()
{
	var _camera = global.camera;
	
	var _camera_x = _camera.x;
	var _camera_y = _camera.y;
	
	var _camera_height = _camera.height;
	
	var _camera_x_real = obj_Player.x - (_camera.width  / 2);
	var _camera_y_real = obj_Player.y - (_camera_height / 2);

	if (_camera_x == _camera_x_real) && (_camera_y == _camera_y_real) exit;
	
	#macro CAMERA_XOFFSET 0
	#macro CAMERA_YOFFSET -8

	#macro CAMERA_SPEED 0.35

	var _travel = CAMERA_SPEED * global.delta_time;
	var _repeat = ceil(_travel);
	var _r;
	
	repeat (_repeat)
	{
		_r = (_travel > 1 ? 1 : _travel);
		
		_camera_x = lerp(_camera_x, _camera_x_real + CAMERA_XOFFSET, _r);
		_camera_y = clamp(lerp(_camera_y, _camera_y_real + CAMERA_YOFFSET, _r), 0, WORLD_HEIGHT_TILE_SIZE - _camera_height - (TILE_SIZE / 2));
		
		 --_travel;
	}
	
	var _camera_shake = _camera.shake;
	var _v = global.settings.graphics.camera_shake.value;
	
	if (_camera_shake > 0)
	{
		_camera_x += random_range(-_camera_shake, _camera_shake) * _v;
		_camera_y = clamp(_camera_y + (random_range(-_camera_shake, _camera_shake) * _v), 0, WORLD_HEIGHT_TILE_SIZE - _camera_height - (TILE_SIZE / 2));
		
		#macro CAMERA_SHAKE_DECREMENT 0.3
		
		_camera_shake -= CAMERA_SHAKE_DECREMENT * global.delta_time;
		
		if (_camera_shake < 0)
		{
			_camera_shake = 0;
		}
		
		global.camera.shake = _camera_shake;
	}
	
	global.camera.x = _camera_x;
	global.camera.y = _camera_y;
	
	global.camera.x_real = _camera_x_real;
	global.camera.y_real = _camera_y_real;
	
	camera_set_view_pos(view_camera[0], _camera_x, _camera_y);
}