function ctrl_chat()
{
	if (obj_Control.is_opened_menu)
	{
		chat_disable();
		
		exit;
	}
	
	if (!obj_Control.is_opened_chat) && (keyboard_check_pressed(vk_anykey))
	{
		if (keyboard_lastkey == vk_enter)
		{
			chat_enable();
		}
		else if (keyboard_lastchar == CHAT_COMMAND_PREFIX)
		{
			chat_enable(CHAT_COMMAND_PREFIX);
		}
		
		exit;
	}
	
	if (string_length(obj_Control.chat_message) > CHAT_HISTORY_MAX)
	{
		keyboard_string = string_copy(obj_Control.chat_message, 1, CHAT_HISTORY_MAX);
	}
	
	obj_Control.chat_message = keyboard_string;
	
	if (string_starts_with(obj_Control.chat_message, CHAT_COMMAND_PREFIX))
	{
		// obj_Control.is_command = true;
		
		try
		{
			var _arguments = string_split(string_delete(obj_Control.chat_message, 1, string_length(CHAT_COMMAND_PREFIX)), CHAT_COMMAND_SEPARATOR);
			var _length = array_length(_arguments);
		
			var _data = global.command_data;
		
			for (var i = 0; i < _length; ++i)
			{
				var _argument = _arguments[0];
				
				if (_data[$ _argument] == undefined)
				{
					if (i != 0 || _data.type == CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND) && (keyboard_check_pressed(vk_tab))
					{
						global.command_current_argument = _arguments[0];
					
						var _names = struct_get_names(_data);
					
						array_sort(_names, sort_alphabetical_descending);
					
						_names = array_filter(_names, chat_filter_arguments);
					
						var _names_length = array_length(_names);
					
						if (_names_length > 0)
						{
							var _name = string_delete(_names[0], 1, string_length(_arguments[0]));
						
							_arguments[@ 0] += _name;
							
							obj_Control.chat_message += _name + CHAT_COMMAND_SEPARATOR;
							keyboard_string     += _name + CHAT_COMMAND_SEPARATOR;
						}
					}
					else break;
				}
			
				_data = _data[$ _argument];
				
				array_delete(_arguments, 0, 1);
			}
		}
		catch (_error)
		{
		}
	}
	
	if (keyboard_check(vk_anykey)) || (keyboard_check_released(vk_anykey))
	{
		obj_Control.surface_refresh_chat = true;
	}
	
	if (string_length(obj_Control.chat_message) == 0)
	{
		if (keyboard_check_pressed(vk_backspace)) || (keyboard_check_pressed(vk_enter)) || (keyboard_check_pressed(vk_tab))
		{
			chat_disable();
		}
		
		exit;
	}
	
	if (keyboard_check_pressed(vk_enter))
	{
		if (global.chat_history[CHAT_HISTORY_MAX - 1] != -1)
		{
			global.chat_history[CHAT_HISTORY_MAX - 1] = -1;
		}
		
		if (string_starts_with(obj_Control.chat_message, CHAT_COMMAND_PREFIX))
		{
			chat_execute(string_delete(obj_Control.chat_message, 1, string_length(CHAT_COMMAND_PREFIX)), obj_Player);
		}
		else
		{
			chat_add(obj_Player.name, obj_Control.chat_message);
		}
		
		chat_add(obj_Player.name, obj_Control.chat_message);
		
		chat_disable();
	}
}