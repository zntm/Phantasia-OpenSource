function draw_curve(x1, y1, x2, y2, start_angle, detail, _colour = c_white, _alpha = 1)
{
	
	
	var dist = point_distance(x1, y1, x2, y2);
	var dist_ang = angle_difference(point_direction(x1, y1, x2, y2), start_angle);
	var inc = 1 / detail;

	draw_primitive_begin(pr_linestrip);
	
	var _length;
	var _direction;
	
	for (var i = 0; i < 1 + inc; i += inc)
	{
		_length = i * dist;
		_direction = (i * dist_ang) + start_angle;
		
		draw_vertex_colour(
			x1 + lengthdir_x(_length, _direction),
			y1 + lengthdir_y(_length, _direction),
			_colour,
			_alpha
		);
	}
	
	draw_primitive_end();
}