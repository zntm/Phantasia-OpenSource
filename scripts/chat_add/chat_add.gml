function chat_add(_name, _message, _sprite_prefix = "emote_")
{
	var _string_length = string_length(_message);
	
	while (string_ends_with(_message, " "))
	{
		_message = string_delete(_message, _string_length--, 1);
	}
	
	while (string_starts_with(_message, " "))
	{
		_message = string_delete(_message, 1, 1);
		
		--_string_length;
	}
	
	if (_string_length <= 0) exit;
	
	array_insert(global.chat_history, 0, {
		name: _name,
		message: _message,
		timer: GAME_FPS * 8,
		data: new Cuteify()
			.set_sprite_prefix(_sprite_prefix)
	});
}