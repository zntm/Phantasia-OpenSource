function FloatingText(_text) constructor
{
	
	
	text = string(_text);
	
	xvelocity = 0;
	yvelocity = 0;
	
	static set_speed = function(_xvelocity, _yvelocity)
	{
		xvelocity = _xvelocity;
		yvelocity = _yvelocity;
	}
	
	static set_xvelocity = function(_xvelocity)
	{
		xvelocity = _xvelocity;
		
		return self;
	}
	
	static set_yvelocity = function(_yvelocity)
	{
		yvelocity = _yvelocity;
		
		return self;
	}
	
	colour = #FFFFFF;
	
	static set_colour = function(_colour)
	{
		colour = _colour;
		
		return self;
	}
}

function spawn_text(_x, _y, _data)
{
	
	
	return instance_create_layer(_x, _y, "Instances", obj_Floating_Text, {
		text: _data.text,
		
		xvelocity: _data.xvelocity,
		yvelocity: _data.yvelocity,
		
		colour: _data.colour
	});
}