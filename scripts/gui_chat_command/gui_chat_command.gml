function gui_chat_command(_x, _y, _height)
{
	static __command_data = global.command_data;
		
	var _command_arguments = string_split(string_delete(obj_Control.chat_message, 1, string_length(CHAT_COMMAND_PREFIX)), CHAT_COMMAND_SEPARATOR);
	var _command_arguments_length = array_length(_command_arguments);
	var _command_arguments_length_last = _command_arguments_length - 1;
		
	var _argument_depth = 0;
	var _show_subcommands = false;
		
	var _current_data = __command_data;
	var _current_argument;
			
	var _input_type;
			
	var _a;
	
	var i = 0;
			
	repeat (_command_arguments_length)
	{
		_current_argument = _command_arguments[i++];
			
		if (_current_argument == "description") || (_current_argument == "type") || (_current_argument == "input") || (_current_argument == "output") || (_current_argument == "command_level") break;
			
		if (_current_data[$ _current_argument] == undefined)
		{
			_show_subcommands = (_argument_depth == 0 || _current_data.type == CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND);
			
			break;
		}
				
		_current_data = _current_data[$ _current_argument];
			
		++_argument_depth;
	}
	
	if (_show_subcommands)
	{
		var _string = CHAT_COMMAND_PREFIX;
				
		i = 0;
				
		repeat (_argument_depth)
		{
			_string += $"{_command_arguments[i++]}{CHAT_COMMAND_SEPARATOR}";
		}
			
		var _offset = 1;
		
		var _subcommands = struct_get_names(_current_data);
			
		global.command_current_argument = _command_arguments[_argument_depth];
			
		if (global.command_current_argument != "")
		{
			_subcommands = array_filter(_subcommands, chat_filter_arguments);
		}
			
		array_sort(_subcommands, sort_alphabetical_ascending);
		
		var _is_subcommand;
		
		var _subcommand;
		var _subcommand_data;
		
		var _subcommands_length = array_length(_subcommands);
			
		var j = 0;
		
		repeat (_subcommands_length)
		{ 
			_subcommand = _subcommands[j++];
				
			if (_subcommand == "description") || (_subcommand == "type") || (_subcommand == "input") || (_subcommand == "output") || (_subcommand == "command_level") continue;
				
			_subcommand_data = _current_data[$ _subcommand];
			_is_subcommand = (_subcommand_data.type == CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND ? "\{#65FF51\}*\{#FFFFFF\}" : "");
				
			draw_text_cuteify(_x, _y - (_offset++ * _height), $"{_string}{_subcommand}{_is_subcommand} \{#666666\}- {_subcommand_data.description}");
		}
		
		exit;
	}
	
	var _string = CHAT_COMMAND_PREFIX;
				
	var _current_data_type = _current_data.type;
			
	if (_current_data_type == CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
	{
		i = 0;
					
		repeat (_argument_depth)
		{
			_string += $"{_command_arguments[i++]}{CHAT_COMMAND_SEPARATOR}";
		}
		
		var _subcommand;
		var _subcommand_data;
		
		var _subcommands = struct_get_names(_current_data);
		var _subcommands_length = array_length(_subcommands);
				
		array_sort(_subcommands, sort_alphabetical_ascending);
				
		var j = 0;
		var l = 1;
				
		repeat (_subcommands_length)
		{ 
			_subcommand = _subcommands[j++];
					
			if (_subcommand == "description") || (_subcommand == "type") || (_subcommand == "input") || (_subcommand == "output") || (_subcommand == "command_level") continue;
					
			_subcommand_data = _current_data[$ _subcommand];
						
			if (_subcommand_data.type == CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
			{
				draw_text_cuteify(_x, _y - (l++ * _height), _string + _subcommand + "{#65FF51}*{#FFFFFF}{#666666}-" + _subcommand_data.description);
				
				continue;
			}
		
			draw_text_cuteify(_x, _y - (l++ * _height), _string + _subcommand + "{#666666}-" + _subcommand_data.description);
		}
		
		exit;
	}
			
	if (_current_data_type == CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
	{
		i = 0;
				
		repeat (_argument_depth)
		{
			_string += $"{_command_arguments[i++]}{CHAT_COMMAND_SEPARATOR}";
		}
				
		if (_current_data.input_length == CHAT_COMMAND_INPUT_LENGTH_ANY) && (_command_arguments_length > _argument_depth)
		{
			if (_command_arguments[_argument_depth] != undefined) && (_command_arguments[_argument_depth] != "")
			{
				i = _argument_depth;
							
				repeat (_command_arguments_length - _argument_depth)
				{
					_string += _command_arguments[i];
							
					if (i++ < _command_arguments_length_last)
					{
						_string += CHAT_COMMAND_SEPARATOR;
					}
				}
			}
			
			draw_text_cuteify(_x, _y - _height, _string);
			
			exit;
		}
		
		var j = 0;
						
		var _input;
		var _inputs = _current_data.input;
		var _input_total_length = array_length(_inputs);
						
		repeat (_input_total_length)
		{ 
			_input = _inputs[j];
							
			_a = _argument_depth + j;
					
			if (_command_arguments_length > _a) && (_command_arguments[_a] != "")
			{
				_string += (_command_arguments_length_last == _a ? _command_arguments[_a] : $"\{#666666\}{_command_arguments[_a]}\{#FFFFFF\}");
				
				if (j++ < _input_total_length - 1)
				{
					_string += CHAT_COMMAND_SEPARATOR;
				}
				
				continue;
			}
			
			_input_type = _input.type;
								
			if (_input_type == CHAT_COMMAND_INPUT_TYPE.BOOLEAN)
			{
				_string += $"\{#666666\}({_input.name}: boolean{(!_input.required ? ("? " + _input.default_value) : "")})\{#FFFFFF\}";
			}
			else if (_input_type == CHAT_COMMAND_INPUT_TYPE.NUMBER)
			{
				_string += $"\{#666666\}({_input.name}: number{(!_input.required ? ("? " + _input.default_value) : "")})\{#FFFFFF\}";
			}
			else if (_input_type == CHAT_COMMAND_INPUT_TYPE.INTEGER)
			{
				_string += $"\{#666666\}({_input.name}: integer{(!_input.required ? ("? " + _input.default_value) : "")})\{#FFFFFF\}";
			}
			else if (_input_type == CHAT_COMMAND_INPUT_TYPE.STRING)
			{
				_string += $"\{#666666\}({_input.name}: string{(!_input.required ? ("? " + _input.default_value) : "")})\{#FFFFFF\}";
			}
			else if (_input_type == CHAT_COMMAND_INPUT_TYPE.USER)
			{
				_string += $"\{#666666\}({_input.name}: user{(!_input.required ? ("? " + _input.default_value) : "")})\{#FFFFFF\}";
			}
			else if (_input_type == CHAT_COMMAND_INPUT_TYPE.POSITION_X)
			{
				_string += $"\{#666666\}({_input.name}: pos_x{(!_input.required ? ("? " + _input.default_value) : "")})\{#FFFFFF\}";
			}
			else if (_input_type == CHAT_COMMAND_INPUT_TYPE.POSITION_Y)
			{
				_string += $"\{#666666\}({_input.name}: pos_y{(!_input.required ? ("? " + _input.default_value) : "")})\{#FFFFFF\}";
			}
			else if (_input_type == CHAT_COMMAND_INPUT_TYPE.POSITION_Z)
			{
				_string += $"\{#666666\}({_input.name}: pos_z{(!_input.required ? ("? " + _input.default_value) : "")})\{#FFFFFF\}";
			}
								
			if (_command_arguments_length_last == _argument_depth + j)
			{
				var _choices = _input.choices;
				var _choices_length = array_length(_choices);
				
				if (_choices_length > 1)
				{
					var l = 0;
										
					repeat (_choices_length)
					{
						draw_text_cuteify(_x, _y - _height - (((_choices_length - l) + 1) * 16), _choices[l++]);
					}
				}
			}
			
			if (j++ < _input_total_length - 1)
			{
				_string += CHAT_COMMAND_SEPARATOR;
			}
		}
		
		draw_text_cuteify(_x, _y - _height, _string);
	}
}