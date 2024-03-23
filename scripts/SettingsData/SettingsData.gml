enum SETTINGS_TYPE {
	SWITCH,
	// Left and right arrow to switch between values
	ARROW,
	// Creates a slider from 0 to 1
	SLIDER_ZERO_ONE,
	HOTKEY
}

function SettingsData(_value = 1, _order = 0, _type = SETTINGS_TYPE.SWITCH) constructor
{
	value = _value;
	value_default = _value;
	
	order = _order;
	type = _type;
	
	on_press = -1;
	
	static set_on_press = function(_on_press)
	{
		on_press = _on_press;
		
		return self;
	}
	
	on_hold = -1;
	
	static set_on_hold = function(_on_hold)
	{
		on_hold = _on_hold;
		
		return self;
	}
}

function SettingsData_Switch(value = 1, order = 0, type = SETTINGS_TYPE.SWITCH) : SettingsData(value, order, type) constructor
{
}

function SettingsData_Arrow(value = 0, order = 0, type = SETTINGS_TYPE.ARROW) : SettingsData(value, order, type) constructor
{
	values = [];
	
	static add_values = function()
	{
		var i = 0;
		
		repeat (argument_count)
		{
			array_push(values, argument[i++]);
		}
		
		return self;
	}
}

function SettingsData_Hotkey(value = 1, order = 0, type = SETTINGS_TYPE.HOTKEY) : SettingsData(value, order, type) constructor
{
}

function SettingsData_SliderZeroOne(value = 1, order = 0, type = SETTINGS_TYPE.SLIDER_ZERO_ONE) : SettingsData(value, order, type) constructor
{
}

var _language = new SettingsData_Arrow(0, 0);

var _file_name = file_find_first($"Resources\\Languages\\*", fa_directory);

while (_file_name != "")
{
	_language.add_values(string_split(_file_name, " ")[1]);
	
	_file_name = file_find_next();
}

global.settings = {
	general: {
		discord_rpc: new SettingsData_Switch(true, 0),
		toast_notification: new SettingsData_Switch(true, 1),
		// chat_fliter: new SettingsData_Switch(true, 2),
		skip_warning: new SettingsData_Switch(false, 2),
		refresh_rate: new SettingsData_Arrow(0, 3)
			.add_values("60", "90", "120", "144", "240")
			.set_on_press(function(_data)
			{
				game_set_speed(real(_data.values[_data.value]), gamespeed_fps);
			}),
	},
	
	graphics: {
		background: new SettingsData_Switch(true, 0),
		particles: new SettingsData_Arrow(2, 1)
			.add_values("None", "Min", "Max"),
		weather: new SettingsData_Arrow(2, 2)
			.add_values("None", "Min", "Max"),
		coloured_lighting: new SettingsData_Switch(true, 3),
		camera_size: new SettingsData_Arrow(0, 4)
			.add_values("960x540", "1280x720", "1366x768"),
		gui_size: new SettingsData_Arrow(2, 5)
			.add_values("960x540", "1280x720", "1366x768", "1920x1080"),
		window_size: new SettingsData_Arrow(2, 6)
			.add_values("960x540", "1280x720", "1366x768", "1920x1080")
			.set_on_press(function(_data)
			{
				var _camera_size = global.settings.graphics.window_size;
				var _size = string_split(_camera_size.values[_camera_size.value], "x");
				
				window_set_size(real(_size[0]), real(_size[1]));
				window_center();
			}),
		fullscreen: new SettingsData_Switch(false, 7)
			.set_on_press(function(_data)
			{
				if (_data.value)
				{
					window_set_fullscreen(true);
					
					exit;
				}
				
				window_set_fullscreen(false);
				
				var _camera_size = global.settings.graphics.window_size;
				var _size = string_split(_camera_size.values[_camera_size.value], "x");
				
				window_set_size(real(_size[0]), real(_size[1]));
				window_center();
			}),
		borderless: new SettingsData_Switch(false, 8)
			.set_on_press(function(_data)
			{
				window_set_showborder(!_data.value);
			}),
		camera_shake: new SettingsData_SliderZeroOne(1, 9)
	},
	
	controls: {
		left: new SettingsData_Hotkey(ord("A"), 0),
		right: new SettingsData_Hotkey(ord("D"), 1),
		jump: new SettingsData_Hotkey(vk_space, 2),
		sprint: new SettingsData_Hotkey(vk_control, 3),
		inventory: new SettingsData_Hotkey(ord("E"), 4),
		drop: new SettingsData_Hotkey(ord("Q"), 5),
		climb_up: new SettingsData_Hotkey(ord("W"), 6),
		climb_down: new SettingsData_Hotkey(ord("S"), 7),
		auto_jump: new SettingsData_Switch(1, 8),
		auto_sprint: new SettingsData_Switch(0, 9)
	},
	
	audio: {
		master: new SettingsData_SliderZeroOne(1, 0)
			.set_on_hold(function(_data)
			{
				audio_sound_gain(mus_Phantasia, _data.value * global.settings.audio.master.value, 0);
			}),
		music: new SettingsData_SliderZeroOne(1, 1)
			.set_on_hold(function(_data)
			{
				audio_sound_gain(mus_Phantasia, global.settings.audio.master.value * _data.value, 0);
			}),
		sfx: new SettingsData_SliderZeroOne(1, 2),
		blocks: new SettingsData_SliderZeroOne(1, 3),
		passive: new SettingsData_SliderZeroOne(1, 4),
		hostile: new SettingsData_SliderZeroOne(1, 5)
	},
	
	accessibility: {
		language: _language
			.set_on_press(function(_data)
			{
				loca_setup($"{_data.value + 1}. {_data.values[_data.value]}");
			}),
		colourblind: new SettingsData_Arrow(0, 1)
			.add_values("Off", "Protanopia", "Deuteranopia", "Tritanopia", "Achromatopsia", "Protanopaly", "Deuteranomaly", "Tritanomaly", "Achromatomaly"),
		clear_text: new SettingsData_Switch(0, 2)
			.set_on_press(function(_data)
			{
				font_enable_effects(fnt_Main, true, _data.value ? {
				    outlineEnable: true,
				    outlineDistance: 2,
				    outlineColour: c_black
				} : {
				    outlineEnable: true,
				    outlineDistance: 1,
				    outlineColour: #151221
				});
			})
	}
}

if (file_exists("Settings.dat"))
{
	var _buffer = buffer_load("Settings.dat");
	var _buffer2 = buffer_decompress(_buffer);
	
	var _d = json_parse(buffer_peek(_buffer2, 0, buffer_text));
	var _v;

	var _key;
	var _keys;
	var _keys_length;

	var _settings = global.settings;

	var _category;
	var _categories = struct_get_names(_settings);
	var _categories_length = array_length(_categories);

	var i = 0;
	var j;

	repeat (_categories_length)
	{
		_category = _categories[i++];
	
		_keys = struct_get_names(_settings[$ _category]);
		_keys_length = array_length(_keys);
		
		j = 0;
		
		repeat (_keys_length)
		{
			_key = _keys[j++];
		
			global.settings[$ _category][$ _key].value = (_d[$ _category][$ _key] ?? _settings[$ _category][$ _key].value_default);
		}
	}
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}

global.local_settings = {
	draw_gui: true,
	draw_fps: false,
	enable_physics: true,
	enable_lighting: true,
	visible_sunlight: false
};