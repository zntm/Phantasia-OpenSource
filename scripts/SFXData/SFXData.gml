enum SFX_TYPE {
	DEFAULT,
	TILE,
	PASSIVE,
	HOSTILE
}

function sfx_init(_name, _type)
{
	var _lower = string_lower(_type);
	
	self[$ _lower] = [];
	
	var _asset_name = $"sfx_{_name}_{_type}_";
	var _asset;
	
	var i = 0;
	
	while (true)
	{
		_asset = asset_get_index(_asset_name + (i < 10 ? "0" : "") + string(i));
		
		if (_asset == -1) break;
			
		self[$ _lower][i++] = _asset;
	}
}

function SFXData(_name, _type) constructor
{
	type = _type;
	
	if (_type == SFX_TYPE.TILE)
	{
		sfx_init(_name, "Destroy");
		sfx_init(_name, "Mine");
		sfx_init(_name, "Place");
		sfx_init(_name, "Step");
	}
	else if (_type == SFX_TYPE.PASSIVE)
	{
		sfx_init(_name, "Idle");
		sfx_init(_name, "Damage");
		sfx_init(_name, "Panic");
	}
	else if (_type == SFX_TYPE.HOSTILE)
	{
		sfx_init(_name, "Idle");
		sfx_init(_name, "Damage");
		sfx_init(_name, "Panic");
		sfx_init(_name, "Hunt");
	}
}

global.sfx_data = [];

array_push(global.sfx_data, new SFXData("Wood", SFX_TYPE.TILE));

array_push(global.sfx_data, new SFXData("Grain", SFX_TYPE.TILE));

array_push(global.sfx_data, new SFXData("Stone", SFX_TYPE.TILE));

array_push(global.sfx_data, new SFXData("Dirt", SFX_TYPE.TILE));

array_push(global.sfx_data, new SFXData("Chicken", SFX_TYPE.PASSIVE));

array_push(global.sfx_data, new SFXData("Cow", SFX_TYPE.PASSIVE));

array_push(global.sfx_data, new SFXData("Frog", SFX_TYPE.PASSIVE));

array_push(global.sfx_data, new SFXData("Owl", SFX_TYPE.PASSIVE));

array_push(global.sfx_data, new SFXData("Duck", SFX_TYPE.PASSIVE));

array_push(global.sfx_data, new SFXData("Leaves", SFX_TYPE.TILE));

array_push(global.sfx_data, new SFXData("Glass", SFX_TYPE.TILE));

array_push(global.sfx_data, new SFXData("Metal", SFX_TYPE.TILE));

array_push(global.sfx_data, new SFXData("Rat", SFX_TYPE.PASSIVE));

array_push(global.sfx_data, new SFXData("Snow", SFX_TYPE.TILE));

array_push(global.sfx_data, new SFXData("Bricks", SFX_TYPE.TILE));