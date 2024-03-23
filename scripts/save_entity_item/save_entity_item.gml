function save_entity_item()
{
	var _buffer = buffer_create(0xffff, buffer_grow, 1);
	
	instance_activate_object(obj_Item_Drop);
	
	buffer_write(_buffer, buffer_u16, instance_number(obj_Item_Drop));
	
	with (obj_Item_Drop)
	{
		buffer_write(_buffer, buffer_f64, x);
		buffer_write(_buffer, buffer_f64, y);
		
		buffer_write(_buffer, buffer_f16, xvelocity);
		buffer_write(_buffer, buffer_f16, yvelocity);
		
		buffer_write(_buffer, buffer_f16, life);
		buffer_write(_buffer, buffer_f16, timer);
		
		buffer_write(_buffer, buffer_u64,
			((xdirection < 0) << 49) |
			(show_text << 48) |
			((((index < 0) << 7) | abs(index)) << 40) |
			((((index_offset < 0) << 7) | abs(index_offset)) << 32) |
			(amount << 16) |
			item_id
		);
	}
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{global.directory}/{global.world_data[global.world.environment.value & 0xf].name}/Entities/Items.dat");
}