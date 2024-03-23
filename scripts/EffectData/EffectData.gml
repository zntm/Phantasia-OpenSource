function EffectData(_name, _is_percent, _icon = -1, _positive = true) constructor
{
	name = _name;
	icon = (_icon != -1 ? $"\{{sprite_get_name(_icon)}\}" : "");
	sprite = _icon;
	positive = _positive
	
	is_percent = _is_percent;
	
	base_value = 1;
	
	static set_base_value = function(_value)
	{
		base_value = _value;
		
		return self;
	}
}

global.effect_data = {};

#macro BUFF_STRENGTH "strength"
global.effect_data[$ BUFF_STRENGTH] = new EffectData("Attack Damage", true, ico_Effect_Strength);

#macro BUFF_ATTACK_SPEED "attack_speed"
global.effect_data[$ BUFF_ATTACK_SPEED] = new EffectData("Attack Speed", true, ico_Effect_Speed);

#macro BUFF_ATTACK_REACH "attack_reach"
global.effect_data[$ BUFF_ATTACK_REACH] = new EffectData("Attack Reach", true);

#macro BUFF_REGENERATION "regeneration"
global.effect_data[$ BUFF_REGENERATION] = new EffectData("Health Regeneration", true, ico_Effect_Regeneration);

#macro BUFF_SPEED "speed"
global.effect_data[$ BUFF_SPEED] = new EffectData("Speed", true, ico_Effect_Speed);

#macro BUFF_JUMPING "jumping"
global.effect_data[$ BUFF_JUMPING] = new EffectData("Jump Height", true, ico_Effect_Jumping);

#macro BUFF_GRAVITY "gravity"
global.effect_data[$ BUFF_GRAVITY] = new EffectData("Gravity", true, ico_Effect_Gravity, false);

#macro BUFF_MOVE_DASH "move_dash"
global.effect_data[$ BUFF_MOVE_DASH] = new EffectData("Dash Power", false, ico_Effect_Speed);

#macro BUFF_BUILD_REACH "build_reach"
global.effect_data[$ BUFF_BUILD_REACH] = new EffectData("Build Reach", false);

#macro BUFF_BUILD_COOLDOWN "cooldown_build"
global.effect_data[$ BUFF_BUILD_COOLDOWN] = new EffectData("Build Cooldown", true);

#macro BUFF_ITEM_REACH "item_reach"
global.effect_data[$ BUFF_ITEM_REACH] = new EffectData("Item Reach", false);

#macro BUFF_LUCK "luck"
global.effect_data[$ BUFF_LUCK] = new EffectData("Luck", true, ico_Effect_Luck);

#macro BUFF_FISHING_POWER "fish_power"
global.effect_data[$ BUFF_FISHING_POWER] = new EffectData("Fishing Power", false);

#macro BUFF_FISHING_LURE "fish_lure"
global.effect_data[$ BUFF_FISHING_LURE] = new EffectData("Fishing Lure", true);

#macro BUFF_PET_MAX "pet_max"
global.effect_data[$ BUFF_PET_MAX] = new EffectData("Pet Max", false);

#macro BUFF_BARING "baring"
global.effect_data[$ BUFF_BARING] = new EffectData("Baring", false, ico_Effect_Baring, false);

#macro BUFF_CLIMBING "climbing"
global.effect_data[$ BUFF_CLIMBING] = new EffectData("Climbing", false, ico_Effect_Climbing);

#macro BUFF_DARKNESS "darkness"
global.effect_data[$ BUFF_DARKNESS] = new EffectData("Darkness", false, ico_Effect_Darkness, false);

#macro BUFF_DEFENSE "defense"
global.effect_data[$ BUFF_DEFENSE] = new EffectData("Defense", false, ico_Effect_Defense);

#macro BUFF_POISON "poison"
global.effect_data[$ BUFF_POISON] = new EffectData("Poison", false, ico_Effect_Poison, false);

#macro BUFF_QUAKING "quaking"
global.effect_data[$ BUFF_QUAKING] = new EffectData("Quaking", false, ico_Effect_Quaking, false);

#macro BUFF_SLOW_FALLING "slow_falling"
global.effect_data[$ BUFF_SLOW_FALLING] = new EffectData("Slow Falling", false, ico_Effect_Slow_Falling);

#macro BUFF_SLOWNESS "slowness"
global.effect_data[$ BUFF_SLOWNESS] = new EffectData("Slowness", false, ico_Effect_Slowness, false);

#macro BUFF_SPELUNKING "spelunking"
global.effect_data[$ BUFF_SPELUNKING] = new EffectData("Spelunking", false, ico_Effect_Spelunking);

#macro BUFF_UNLUCK "unluck"
global.effect_data[$ BUFF_UNLUCK] = new EffectData("Unluck", false, ico_Effect_Unluck, false);

#macro BUFF_VISION "vision"
global.effect_data[$ BUFF_VISION] = new EffectData("Vision", false, ico_Effect_Vision);

#macro BUFF_WEAKNESS "weakness"
global.effect_data[$ BUFF_WEAKNESS] = new EffectData("Weakness", false, ico_Effect_Weakness, false);

#macro BUFF_SPICY "spicy"
global.effect_data[$ BUFF_SPICY] = new EffectData("Spicy", false, ico_Effect_Weakness, false);

#macro BUFF_BURNING "burning"
global.effect_data[$ BUFF_BURNING] = new EffectData("Burning", false, ico_Effect_Weakness, false);

#macro BUFF_FREEZING "freezing"
global.effect_data[$ BUFF_FREEZING] = new EffectData("Freezing", false, ico_Effect_Weakness, false);

#macro BUFF_INVISIBILITY "invisibility"
global.effect_data[$ BUFF_INVISIBILITY] = new EffectData("Invisibility", false, ico_Effect_Weakness, false);