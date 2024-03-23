function tile_instance_destroy(_x, _y, _z)
{
	with (obj_Tile_Light)
	{
		if (position_x != _x) || (position_y != _y) || (position_z != _z) continue;
		
		instance_destroy();
			
		break;
	}
	
	with (obj_Tile_Station)
	{
		if (position_x != _x) || (position_y != _y) || (position_z != _z) continue;
		
		instance_destroy();
			
		break;
	}
	
	with (obj_Tile_Container)
	{
		if (position_x != _x) || (position_y != _y) || (position_z != _z) continue;
		
		instance_destroy();
			
		break;
	}
	
	with (obj_Tile_Instance)
	{
		if (position_x != _x) || (position_y != _y) || (position_z != _z) continue;
		
		instance_destroy();
			
		break;
	}
}