placeholder = loca_translate("menu.item.structure_point.import");

on_press = function()
{
	var _position = global.menu_tile;
	
	// structure_import(_position.x, _position.y, inst_61A29BAC.text);
	
	/*
	var _location = $"{DIRECTORY_DATA_EXPORTS_STRUCTURES}/{inst_61A29BAC.text}.str";
	
	if (!file_exists(_location)) exit;
	
	var _buffer = buffer_load(_location);
	var _buffer2 = buffer_decompress(buffer_peek(_buffer, 0, buffer_text));
	
	var _data = json_parse(buffer_peek(_buffer2, 0, buffer_text));
	var _tile = _data.tile;
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
	
	var _position = global.menu_tile;
	var _xstart = _position.x - _data.xoffset;
	var _ystart = _position.y - _data.yoffset;
	
	var _xrepeat = _data.width;
	var _yrepeat = _data.height;
	var _xyrepeat = _xrepeat * _yrepeat;
	
	var _index_xy;
	
	var i = 0;
	var j;
	var l;

	repeat (_xrepeat)
	{
		j = 0;
	
		repeat (_yrepeat)
		{
			_index_xy = i + (j * _xrepeat);
		
			l = 0;
		
			repeat (CHUNK_SIZE_Z)
			{
				tile_place(_xstart + i, _ystart + j, l, _tile[_index_xy + (l * _xyrepeat)]);
			
				++l;
			}
		
			++j;
		}
	
		++i;
	}
	*/
}