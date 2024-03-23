function draw_sprite_pos_fixed(_sprite, _subimg, _x1, _y1, _x2, _y2, _x3, _y3, _x4, _y4, _colour, _alpha)
{
	
	
	static __buffer = vertex_create_buffer();
	static __init = false;
	static __format_perspective = 0;
	
	if (!__init)
	{
		__init = true;
		
		vertex_format_begin();

		vertex_format_add_colour();
		vertex_format_add_position();
		vertex_format_add_normal();

		__format_perspective = vertex_format_end();
	}
	
	var _ax = _x2 - _x4;
	var _ay = _y2 - _y4;
	var _bx = _x1 - _x3;
	var _by = _y1 - _y3;

	var _can = (_ax * _by) - (_ay * _bx);

	if (_can == 0) exit;
	
	var _cx = _x4 - _x3;
	var _cy = _y4 - _y3; 
		
	var _s = ((_ax * _cy) - (_ay * _cx)) / _can;  
		
	if (_s <= 0) || (_s >= 1) exit;
	
	var _t = ((_bx * _cy) - (_by * _cx)) / _can;  
			
	if (_t <= 0) || (_t >= 1) exit;
		
	var _q0 = 1 / (1 - _t);
	var _q1 = 1 / (1 - _s);
	var _q2 = 1 / _t;
	var _q3 = 1 / _s;
			
	var _uv = sprite_get_uvs(_sprite, _subimg);
			
	var _uv0 = _uv[0];
	var _uv1 = _uv[1];
	var _uv2 = _uv[2];
	var _uv3 = _uv[3];
	
	vertex_begin(__buffer, __format_perspective);
			
	vertex_colour(__buffer, _colour, _alpha);
	vertex_position(__buffer, _x1, _y1);
	vertex_normal(__buffer, _q3 * _uv0, _q3 * _uv1, _q3);
			
	vertex_colour(__buffer, _colour, _alpha);
	vertex_position(__buffer, _x2, _y2);
	vertex_normal(__buffer, _q2 * _uv2, _q2 * _uv1, _q2);
			
	vertex_colour(__buffer, _colour, _alpha);
	vertex_position(__buffer, _x4, _y4);
	vertex_normal(__buffer, _q0 * _uv0, _q0 * _uv3, _q0);
			
	vertex_colour(__buffer, _colour, _alpha);
	vertex_position(__buffer, _x3, _y3);
	vertex_normal(__buffer, _q1 * _uv2, _q1 * _uv3, _q1);
			
	vertex_end(__buffer);
				
	shader_set(sh_perspective);
			
	vertex_submit(__buffer, pr_trianglestrip, sprite_get_texture(_sprite, _subimg));
			
	shader_reset();
}