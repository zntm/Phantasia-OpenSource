function physics_bury(_threshold = (TILE_SIZE / 2), _item_data = global.item_data)
{
	var i = y;

	repeat (_threshold)
	{
		if (!tile_meeting(x, i))
		{
			y = i;
		
			exit;
		}
	
		--i;
	}
}