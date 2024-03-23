enum BIOME_TYPE {
	SKY,
	SURFACE,
	OCEAN,
	CAVE
}

function BiomeData(_name)
{
	name = string_lower(string_replace_all(_name, " ", "_"));
	
	background = [];
	
	if (asset_get_index($"bg_{name}_00") > -1)
	{
		var _background;
		
		var i = 0;
		
		while (true)
		{
			_background = asset_get_index($"bg_{name}_{i < 10 ? "0" : ""}{i}");
			
			if (_background == -1) break;
			
			array_push(background, _background);
			
			++i;
		}
	}
	else
	{
		background = [ bg_Greenia_00, bg_Greenia_01, bg_Greenia_02 ];
	}
	
	colour_offset = [
		(((1 << 7) | 118) << 16) | (((1 << 7) | 102) << 8) | ((1 << 7) | 67),
		0,
		(((1 << 7) | 32)  << 16) | (((1 << 7) | 76)  << 8) | ((1 << 7) | 67),
		(((1 << 7) | 118) << 16) | (((1 << 7) | 118) << 8) | ((1 << 7) | 55)
	];
	
	static set_colour_offset = function(_index, _r, _g, _b)
	{
		colour_offset[@ _index] = (((_r < 0) << 7) | (abs(_r)) << 16) | (((_g < 0) << 7) | (abs(_g)) << 16) | ((_b < 0) << 7) | (abs(_b));
		
		return self;
	}
	
	music = -1;
	
	static set_music = function()
	{
		music = [];
		
		var i = 0;
		
		repeat (argument_count)
		{
			array_push(music, argument[i++]);
		}
		
		return self;
	}
	
	passive_creatures_tile = [];
	passive_creatures = [];
	
	static set_passive_creatures = function(_tiles, _creatures)
	{
		passive_creatures_tile = _tiles;
		passive_creatures = _creatures;
		
		return self;
	}
	
	boss = -1;
	hostile_creatures_tile = [];
	hostile_creatures = [];
	
	static set_hostile_creatures = function(_boss, _tiles, _creatures)
	{
		boss = _boss;
		hostile_creatures_tile = _tiles;
		hostile_creatures = _creatures;
		
		return self;
	}
	
	rpc_icon = "game_icon";
	
	static set_rpc_icon = function(_rpc)
	{
		rpc_icon = _rpc;
		
		return self;
	}
}