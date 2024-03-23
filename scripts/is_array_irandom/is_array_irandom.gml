function is_array_irandom(val)
{
	
	
	return (is_array(val) ? irandom_range(val[0], val[1]) : val);
}