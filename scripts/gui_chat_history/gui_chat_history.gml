function gui_chat_history(_x, _y, _height)
{
	var _chat_history = global.chat_history;
	var _chat_history_scroll = obj_Control.chat_history_index;
	
	var i;
	
	if (mouse_wheel_down()) && (obj_Control.chat_history_index > 0)
	{
		obj_Control.chat_history_index = --_chat_history_scroll;
	}
	else if (mouse_wheel_up())
	{
		var _scroll = true;
		
		i = _chat_history_scroll + 1;
				
		repeat (CHAT_HISTORY_INDEX_MAX)
		{
			if (i >= CHAT_HISTORY_MAX) || (_chat_history[i] == -1)
			{
				_scroll = false;
					
				break;
			}
			
			++i;
		}
			
		if (_scroll) && (_chat_history_scroll < CHAT_HISTORY_MAX - CHAT_HISTORY_INDEX_MAX - 1)
		{
			obj_Control.chat_history_index = ++_chat_history_scroll;
		}
	}
	
	var _index;
	var _message;
	var _name;
	var _message_history;
		
	i = 0;
	
	if (obj_Control.is_opened_chat)
	{
		repeat (CHAT_HISTORY_INDEX_MAX)
		{
			_index = _chat_history_scroll + i;
			
			if (_index >= CHAT_HISTORY_MAX) exit;
			
			_message = _chat_history[_index];
	
			if (_message == -1) exit;
	
			_name = _message.name;
			_message_history = _message.message;
					
			if (_name != "")
			{
				_message_history = $"<{_name}> {_message_history}";
			}
				
			draw_text_cuteify(_x, _y - ((i + 1) * _height), _message_history,,,,, 1, _message.data);
				
			++i;
		}
		
		exit;
	}
	
	var _alpha;
	
	repeat (CHAT_HISTORY_INDEX_MAX)
	{
		_index = _chat_history_scroll + i;
			
		if (_index >= CHAT_HISTORY_MAX) exit;
			
		_message = _chat_history[_index];
	
		if (_message == -1) exit;
	
		_alpha = normalize(_message.timer, 0, 60);
	
		if (_alpha > 0)
		{
			_name = _message.name;
			_message_history = _message.message;
					
			if (_name != "")
			{
				_message_history = $"<{_name}> {_message_history}";
			}
				
			draw_text_cuteify(_x, _y - ((i + 1) * _height), _message_history,,,,, _alpha, _message.data);
		}
				
		++i;
	}
}