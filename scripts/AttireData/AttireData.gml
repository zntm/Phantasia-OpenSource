function AttireData(_sprite, _sprite2, _sprite3) constructor
{
	colour = _sprite;
	white = asset_get_index($"{sprite_get_name(_sprite)}_White");
	
	if (_sprite2 != undefined)
	{
		colour2 = _sprite2;
	}
	
	if (_sprite3 != undefined)
	{
		colour3 = _sprite3;
	}
}

global.attire_data = {
	headwear: [
		-1,
		new AttireData(att_Headwear_01),
		new AttireData(att_Headwear_02),
		new AttireData(att_Headwear_03)
	],
	
	hair: [
		-1,
		new AttireData(att_Hair_00),
		new AttireData(att_Hair_01),
		new AttireData(att_Hair_02),
		new AttireData(att_Hair_03),
		new AttireData(att_Hair_04),
		new AttireData(att_Hair_05)
	],
	
	head_detail: [
		-1,
		new AttireData(att_Head_Detail_01),
	],
	
	eyes: [
		new AttireData(att_Eye_00),
		new AttireData(att_Eye_01),
		new AttireData(att_Eye_02),
		new AttireData(att_Eye_03)
	],
	
	pants: [
		new AttireData(att_Pant_00),
		/*
		new AttireData(att_Pant_01),
		new AttireData(att_Pant_02)
		*/
	],
	
	shirt: [
		new AttireData(att_Shirt_00, att_Shirt_00_Arm_Left, att_Shirt_00_Arm_Right),
		new AttireData(att_Shirt_01, att_Shirt_00_Arm_Left, att_Shirt_00_Arm_Right),
		/*
		new AttireData(att_Shirt_00, att_Shirt_00_Arm_Left, att_Shirt_00_Arm_Right),
		new AttireData(att_Shirt_00, att_Shirt_00_Arm_Left, att_Shirt_00_Arm_Right),
		new AttireData(att_Shirt_00, att_Shirt_00_Arm_Left, att_Shirt_00_Arm_Right)
		*/
	],
	
	undershirt: [
		-1,
		new AttireData(att_Undershirt_01),
		/*/
		new AttireData(att_Undershirt_02),
		new AttireData(att_Undershirt_03),
		new AttireData(att_Undershirt_04)
		*/
	],
	
	body_detail: [
		-1,
		new AttireData(att_Body_Detail_01),
	],
	
	footwear: [
		new AttireData(att_Shoe_00),
		new AttireData(att_Shoe_01)
	]
}
