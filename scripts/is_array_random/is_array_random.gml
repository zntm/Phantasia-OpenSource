function is_array_random(val)
{
	
	
	return (is_array(val) ? random_range(val[0], val[1]) : val);
}