function load_entity_item()
{
	var _directory = $"{global.directory}/{global.world_data[global.world.environment.value & 0xf].name}/Entities/Items.dat";
	
	if (!file_exists(_directory)) exit;
	
	var _camera = global.camera;
	
	var _camera_x = _camera.x_real - LIGHT_REFRESH_CULL_OFFSET;
	var _camera_y = _camera.y_real - LIGHT_REFRESH_CULL_OFFSET;
	
	var _camera_width  = _camera_x + _camera.width  + (LIGHT_REFRESH_CULL_OFFSET * 2);
	var _camera_height = _camera_y + _camera.height + (LIGHT_REFRESH_CULL_OFFSET * 2);
	
	var _buffer = buffer_load(_directory);
	var _buffer2 = buffer_decompress(_buffer);
	
	var _length = buffer_read(_buffer2, buffer_u16);
	
	repeat (_length)
	{
		var _x = buffer_read(_buffer2, buffer_f64);
		var _y = buffer_read(_buffer2, buffer_f64);
		
		with (instance_create_layer(_x, _y, "Instances", obj_Item_Drop))
		{
			xvelocity = buffer_read(_buffer2, buffer_f16);
			yvelocity = buffer_read(_buffer2, buffer_f16);
			
			life = buffer_read(_buffer2, buffer_f16);
			timer = buffer_read(_buffer2, buffer_f16);
			
			var _v = buffer_read(_buffer2, buffer_u64);
			
			item_id = _v & 0xffff;
			amount = (_v >> 16) & 0xffff;
			
			index = ((_v & 0x8000_0000_0000) ? -((_v >> 40) & 0xff) : ((_v >> 40) & 0xff));
			index_offset = ((_v & 0x80_0000_0000) ? -((_v >> 32) & 0xff) : ((_v >> 32) & 0xff));
			
			show_text = (_v >> 48) & 1;
			xdirection = _v >> 49;
			
			if (!point_in_rectangle(_x, _y, _camera_x, _camera_y, _camera_width, _camera_height))
			{
				instance_deactivate_object(id);
			}
		}
	}
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}