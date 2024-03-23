if (obj_Control.is_paused) exit;

angle += swing_speed * accessory_speed * global.delta_time;

var _xscale = -owner.image_xscale;

x = owner.x + (lengthdir_x(32, angle) * _xscale);
y = owner.y + (lengthdir_y(32, angle) - 16);

image_xscale = _xscale;
image_angle  = (-45 + angle) * _xscale;

if (angle > 180)
{
	instance_destroy();
}