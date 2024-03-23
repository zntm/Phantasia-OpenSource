var _buffer = buffer_create((1 << 24) - 1, buffer_grow, 1);

var _settings = global.settings;

var _d = {};

var _category;
var _categories = struct_get_names(_settings);
var _categories_length = array_length(_categories);

var _setting;
var _settings_value;
var _settings_value_keys;
var _settings_value_length;

var i = 0;
var j;

repeat (_categories_length)
{
	_category = _categories[i++];
	
	_d[$ _category] = {};
	
	_settings_value = _settings[$ _category];
	_settings_value_keys = struct_get_names(_settings_value);
	_settings_value_length = array_length(_settings_value_keys);
	
	j = 0;
	
	repeat (_settings_value_length)
	{
		_setting = _settings_value_keys[j++];
		
		_d[$ _category][$ _setting] = _settings_value[$ _setting].value;
	}
}

buffer_poke(_buffer, 0, buffer_text, json_stringify(_d));

var _buffer2 = buffer_compress(_buffer, 0, buffer_get_size(_buffer));

buffer_save(_buffer2, "Settings.dat");

buffer_delete(_buffer);
buffer_delete(_buffer2);