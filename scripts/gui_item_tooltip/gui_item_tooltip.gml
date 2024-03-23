function gui_item_tooltip()
{
	var _inst = global.inventory_selected_backpack;
		
	if (!instance_exists(_inst))
	{
		_inst = instance_position(mouse_x, mouse_y, obj_Inventory);
	}

	if (!instance_exists(_inst)) exit;
	
	var _item_id = ITEM.EMPTY;
	var _amount = 0;
			
	var _type = _inst.type;
		
	if (_type != "craftable")
	{
		_inst = global.inventory[$ _type][_inst.inventory_placement];
			
		if (_inst == INVENTORY_EMPTY) exit;
	}
	
	_item_id = _inst.item_id;
	_amount  = _inst.amount;
	
	var _data = global.item_data[_item_id];
		
	var _name_loca = $"item.{_data.name}";
	var _name = loca_translate($"{_name_loca}.name");
			
	var _name_height = string_height(_name);
			
	#macro GUI_INFO_XOFFSET 2
	#macro GUI_INFO_YOFFSET 2
		
	var _x = global.gui_mouse_x + GUI_INFO_XOFFSET;
	var _y = global.gui_mouse_y + GUI_INFO_YOFFSET;
		
	if (_amount > 1)
	{
		_name += $" ({_amount})";
	}
	
	draw_set_align(fa_left, fa_top);
	
	var _description_loca = $"{_name_loca}.description";
	var _description = loca_translate(_description_loca);
	
	if (_description == _description_loca)
	{
		var _width = string_width(_name);
		
		draw_sprite_ext(spr_Menu_Dark, 0, _x + (_width / 2), _y + (_name_height / 2), (_width / sprite_get_width(spr_Menu_Dark)) + 1, (_name_height / sprite_get_height(spr_Menu_Dark)) + 1, 0, c_black, 0.5);
		draw_text(_x, _y, _name);
		
		exit;
	}
	
	_type = _data.type;
				
	if (_type & (ITEM_TYPE.ARMOR_HELMET | ITEM_TYPE.ARMOR_BREASTPLATE | ITEM_TYPE.ARMOR_LEGGINGS | ITEM_TYPE.ACCESSORY))
	{
		var _defense = _data.buffs.defense;
					
		if (_defense > 0)
		{
			_description = $"{string(loca_translate("gui.defense"), _defense)}\n{_description}";
		}
	}
	
	if (_data.is_material)
	{
		_description = $"{loca_translate("gui.material")}\n{_description}";
	}
				
	if (_type & ITEM_TYPE.THROWABLE)
	{
		_description = $"{loca_translate("gui.throwable")}\n{_description}";
	}
			
	var _damage = _data.get_damage();
	var _damage_type = _data.get_damage_type();
			
	if (_damage_type == DAMAGE_TYPE.MELEE)
	{
		_description += string(loca_translate("gui.damage.melee"), _damage);
	}
	else if (_damage_type == DAMAGE_TYPE.RANGED)
	{
		_description += string(loca_translate("gui.damage.ranged"), _damage);
	}
	else if (_damage_type == DAMAGE_TYPE.MAGIC)
	{
		_description += string(loca_translate("gui.damage.magic"), _damage);
	}
	else if (_damage_type == DAMAGE_TYPE.FIRE)
	{
		_description += string(loca_translate("gui.damage.fire"), _damage);
	}
	else if (_damage_type == DAMAGE_TYPE.BLAST)
	{
		_description += string(loca_translate("gui.damage.blast"), _damage);
	}
	else if (_damage > 1)
	{
		_description += string(loca_translate("gui.damage"), _damage);
	}
				
	#macro GUI_DESCRIPTION_XSCALE 0.6
	#macro GUI_DESCRIPTION_YSCALE 0.6
	
	static __cuteify_emote = global.cuteify_emote;
	
	var _width	= max(string_width(_name), cuteify_get_width(_description, __cuteify_emote) * GUI_DESCRIPTION_XSCALE);
	var _height	= _name_height + (string_height(_description) * GUI_DESCRIPTION_YSCALE);
		
	draw_sprite_ext(spr_Menu_Dark, 0, _x + (_width / 2), _y + (_height / 2), (_width / sprite_get_width(spr_Menu_Dark)) + 1, (_height / sprite_get_height(spr_Menu_Dark)) + 1, 0, c_black, 0.5);
		
	draw_text(_x, _y, _name);
	draw_text_cuteify(_x, _y + _name_height, _description, GUI_DESCRIPTION_XSCALE, GUI_DESCRIPTION_YSCALE);
}