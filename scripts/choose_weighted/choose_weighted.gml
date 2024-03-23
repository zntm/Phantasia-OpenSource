/// @func choose_weighted(args_or_array)
/// @desc Returns a random value with weight.
/// @arg {Any} args_or_array Set any value with the weight in the next argument or use an array.
/// @return {Any}
function choose_weighted(args_or_array)
{
	
	
	var a;
	var a0 = argument[0];
	
	if (!is_array(a0))
	{
		var n = 0;
		var _length = argument_count >> 1;
		
		var i = 1;
		
		repeat (_length)
		{
			a = argument[i];
			
			if (a > 0)
			{
				n += a;
			}
			
			i += 2;
		}
	
		n = random(n);
		i = 1;
	
		repeat (_length)
		{
			a = argument[i];
			
			if (a > 0)
			{
				n -= a;
			
				if (n < 0)
				{
					return argument[i - 1];
				}
			}
			
			i += 2;
		}
	
		return a0;
	}
	
	var n = 0;
	var _length = array_length(a0) >> 1;
		
	var i = 1;
	
	repeat (_length)
	{
		a = a0[i];
			
		if (a > 0)
		{
			n += a;
		}
		
		i += 2;
	}
	
	n = random(n);
	i = 1;
	
	repeat (_length)
	{
		a = a0[i];
			
		if (a > 0)
		{
			n -= a;
			
			if (n < 0)
			{
				return a0[i - 1];
			}
		}
		
		i += 2;
	}
	
	return a0[0];
}