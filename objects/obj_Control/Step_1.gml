var _c = global.camera;

var _cx = _c.x;
var _cy = _c.y;

if (_cx == infinity) || (_cy == infinity)
{
	var _camera = global.camera;
	
	global.camera.x = _camera.x_real;
	global.camera.y = _camera.y_real;
}

ctrl_camera();

var _camera = global.camera;

var _camera_x = _camera.x;
var _camera_y = _camera.y;

var _camera_width  = _camera.width;
var _camera_height = _camera.height;

if (global.world.environment.value & (1 << 16)) && ((_camera_x != _cx) || (_camera_y != _cy))
{
	ctrl_structure(_camera_x, _camera_y, _camera_width, _camera_height);
}
