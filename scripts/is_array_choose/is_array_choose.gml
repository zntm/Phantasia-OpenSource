function is_array_choose(_item)
{
	
	
	if (is_array(_item))
	{
		_item = array_choose(_item);
	}
	
	return _item;
}