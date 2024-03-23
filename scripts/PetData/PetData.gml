enum PET_TYPE {
	WALK,
	FLY
}

function PetData(_name, _type = PET_TYPE.FLY) constructor
{
	type = _type;
	
	var _asset_name = "pet_" + string_replace_all(_name, " ", "");
	var _asset_idle = asset_get_index(_asset_name + "_Idle");
	
	if (_asset_idle != -1)
	{
		sprite_idle = _asset_idle;
		sprite_moving = asset_get_index(_asset_name + "_Moving");
	}
	else
	{
		sprite_idle = [];
		sprite_moving = [];
		
		var i = 0;
		var _i;
		var _d;
		
		while (true)
		{
			if (i > 99)
			{
				throw $"{_name} can not have more than 99 sprite variation";
			}
				
			_i = (i < 10 ? "0" : "") + string(i);
			
			_asset_name = $"pet_{_name}_{_i}_";
			
			_d = asset_get_index(_asset_name + "Idle");
			
			if (_d == -1) break;
			
			sprite_idle[@ i] = _d;
			sprite_moving[@ i] = asset_get_index(_asset_name + "Moving");
			
			++i;
		}
	}
	
	var _asset_sfx = "sfx_Pet_" + _name;
	
	sfx_on = asset_get_index(_asset_sfx + "_On");
	sfx_off = asset_get_index(_asset_sfx + "_Off");
	
	if (sfx_on == -1)
	{
		sfx_on = sfx_Menu_Button_00;
	}
	
	if (sfx_off == -1)
	{
		sfx_off = sfx_Menu_Button_00;
	}
}

global.pet_data = [];

array_push(global.pet_data, new PetData("Maurice"));

array_push(global.pet_data, new PetData("Raindrop"));

array_push(global.pet_data, new PetData("Cuber"));

array_push(global.pet_data, new PetData("Bal"));

array_push(global.pet_data, new PetData("Sihp"));

array_push(global.pet_data, new PetData("Ufoe"));

array_push(global.pet_data, new PetData("Robet"));

array_push(global.pet_data, new PetData("Swign"));

array_push(global.pet_data, new PetData("Wavee"));

array_push(global.pet_data, new PetData("Shelly"));

array_push(global.pet_data, new PetData("Shelly"));

array_push(global.pet_data, new PetData("Kiko"));

array_push(global.pet_data, new PetData("Airi"));

array_push(global.pet_data, new PetData("Bushido"));

array_push(global.pet_data, new PetData("Capdude"));

array_push(global.pet_data, new PetData("Chroma"));