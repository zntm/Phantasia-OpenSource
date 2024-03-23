function tile_meeting(_x, _y, _z = CHUNK_DEPTH_DEFAULT, _type = ITEM_TYPE.SOLID)
{
	var _item_data = global.item_data;
	
	if (_y < 0) || (_y >= WORLD_HEIGHT_TILE_SIZE)
	{
		return false;
	}
	
	var xscale = abs(image_xscale);
	var yscale = abs(image_yscale);
	
	var ax1 = _x - (abs(sprite_xoffset) * xscale);
	var ay1 = _y - (abs(sprite_yoffset) * yscale);
	
	var _ax2 = sprite_get_bbox_right(sprite_index)  * xscale;
	var _ay2 = sprite_get_bbox_bottom(sprite_index) * yscale;
	
	var ax2 = ax1 + _ax2;
	var ay2 = ay1 + _ay2;
	
	var bx1;
	var by1;
	
	var tile_x = round((ax1 + (_ax2 / 2)) / TILE_SIZE);
	var tile_y = round((ay1 + (_ay2 / 2)) / TILE_SIZE);
	
	var _xsize = ceil(abs(sprite_width) / TILE_SIZE / 2);
	var _ysize = ceil(abs(sprite_height) / TILE_SIZE / 2);
	
	var _xstart = tile_x - _xsize;
	
	var _c;
	var _l;
	var _v;
	var _w;
	
	var i;
	var _i;
	
	var j = tile_y - _ysize;
	var _j;
	
	var l;
	
	var _tile;
	var _data;
	
	var _rx = (_xsize * 2) + 1;
	var _ry = (_ysize * 2) + 1;
	
	repeat (_ry)
	{
		if (j < 0)
		{
			++j;
			
			continue;
		}
		
		if (j >= WORLD_HEIGHT) break;
		
		_j = j * TILE_SIZE;
		
		i = _xstart;
		
		repeat (_rx)
		{
			_tile = tile_get(i, j, _z, "all");
			
			if (_tile == ITEM.EMPTY) || ((_tile.boolean & 1) == 0)
			{
				++i;
				
				continue;
			}
			_data = _item_data[_tile.item_id];
				
			if ((_data.type & _type) == 0)
			{
				++i;
						
				continue;
			}
					
			_i = i * TILE_SIZE;
					
			_c = _data.collision_box;
			_l = _data.collision_box_length;
		
			l = 0;
			
			repeat (_l)
			{
				_w = _c[l];
						
				_v = _w >> 36;
				bx1 = _i - ((_v & 0x800) ? -(_v & 0x7ff) : (_v & 0x7ff));
						
				if (ax2 <= bx1)
				{
					++l;
							
					continue;
				}
						
				_v = (_w >> 12) & 0xfff;
						
				if (ax1 > (bx1 + ((_v & 0x800) ? -(_v & 0x7ff) : (_v & 0x7ff))))
				{
					++l;
							
					continue;
				}
						
				_v = (_w >> 24) & 0xfff;
				by1 = _j - ((_v & 0x800) ? -(_v & 0x7ff) : (_v & 0x7ff));
						
				if (ay2 <= by1)
				{
					++l;
							
					continue;
				}
						
				_v = _w & 0xfff;
						
				if (ay1 > (by1 + ((_v & 0x800) ? -(_v & 0x7ff) : (_v & 0x7ff))))
				{
					++l;
					
					continue;
				}
				
				return true;
			}
			
			++i;
		}
		
		++j;
	}
	
	return false;
}