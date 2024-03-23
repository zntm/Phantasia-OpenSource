#macro CHAT_COMMAND_PREFIX "/"
#macro CHAT_COMMAND_SEPARATOR " "
#macro CHAT_COMMAND_RANGE_SEPARATOR ".."
#macro CHAT_COMMAND_POSITION_PLACEHOLDER "~"
#macro CHAT_COMMAND_PLAYER_PLACEHOLDER "@"

function chat_execute(_message, _user = -1)
{
	var _data = global.command_data;
	
	static _chat_command_shortcut_true  = [ "true", "t", "y", "1" ];
	static _chat_command_shortcut_false = [ "false", "f", "n", "0" ];
	
	var _error = false;
	
	var _arguments = string_split(_message, CHAT_COMMAND_SEPARATOR);
	var _length = array_length(_arguments);
	
	var _position;
	
	for (var i = 0; i < _length; ++i)
	{
		var _argument = _arguments[0];
				
		if (_data[$ _argument] == undefined)
		{
			_error = true;
					
			if (i == 0)
			{
				chat_add("", $"\{warning\} '{_argument}' is not a valid command");
			}
			else if (_data.type == CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
			{
				chat_add("", $"\{warning\} '{_argument}' is not a valid subcommand");
			}
			else
			{
				chat_add("", $"\{warning\} Argument {i} '{_argument}' is not a valid argument");
			}
					
			break;
		}
				
		_data = _data[$ _argument];
				
		array_delete(_arguments, 0, 1);
		
		var _type = _data.type;
		
		if (_type == CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND) continue;
				
		if (_type == CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		{
			_length = array_length(_arguments);
			
			var _input_length = _data.input_length;
			
			if (_input_length > _length)
			{
				_error = true;
								
				chat_add("", $"\{warning\} Only passed {_length} arguments when {_input_length} is required");
			}
						
			var _input_total_length = array_length(_data.input);
				
			for (var j = 0; j < _input_total_length; ++j)
			{
				var _i = _data.input;
				
				if (j >= _length)
				{
					var _input = _i[j];
					
					if (!_input.required)
					{
						_arguments[@ j] = _input.default_value;
					}
				}

				if (_arguments[j] == "") && (_i[j].required)
				{
					_error = true;
							
					chat_add("", $"\{warning\} Argument {j} is empty");
								
					break;
				}
				
				var _input = _i[_data.input_length == CHAT_COMMAND_INPUT_LENGTH_ANY ? 0 : j];
				var _input_type = _input.type;
				
				switch (_input_type)
				{
								
				case CHAT_COMMAND_INPUT_TYPE.STRING:
					var _string_length = string_length(_arguments[j]);
					
					if (_string_length < _input.get_input_min()) || (_string_length >= _input.get_input_max())
					{
						_error = true;
								
						chat_add("", $"\{warning\} String length of argument {j} '{_arguments[j]}' can only be in range of {_input.get_input_min()} and {_input.get_input_max()}");
					}
					break;
				
				case CHAT_COMMAND_INPUT_TYPE.POSITION_X:
				case CHAT_COMMAND_INPUT_TYPE.POSITION_Y:
				case CHAT_COMMAND_INPUT_TYPE.POSITION_Z:
					try
					{
						var _numbers = _arguments[j];
						
						if (string_starts_with(_numbers, CHAT_COMMAND_POSITION_PLACEHOLDER))
						{
							if (_input_type == CHAT_COMMAND_INPUT_TYPE.POSITION_X)
							{
								_position = _user.x;
							}
							else if (_input_type == CHAT_COMMAND_INPUT_TYPE.POSITION_Y)
							{
								_position = _user.y;
							}
							else if (_input_type == CHAT_COMMAND_INPUT_TYPE.POSITION_Z)
							{
								_position = _user.z;
							}
							
							_numbers = string_replace(_numbers, CHAT_COMMAND_POSITION_PLACEHOLDER, $"{_input_type == CHAT_COMMAND_INPUT_TYPE.POSITION_Z ? _position : round(_position / TILE_SIZE)}+0");
						}
						
						_numbers = string_replace_all(_numbers, "--", ",");
						_numbers = string_replace_all(_numbers, "+-", ",-");
						_numbers = string_replace_all(_numbers, "-+", ",-");
						_numbers = string_replace_all(_numbers, "+", ",");
						_numbers = string_replace_all(_numbers, "-", ",-");
						
						_numbers = string_split(_numbers, ",");
						
						var _number;
						var _numbers_length = array_length(_numbers);
						
						var _result = 0;
						
						var l = 0;
						
						repeat (_numbers_length)
						{
							_number = _numbers[l++];
							
							if (string_length(_number) == 0) || (string_digits(_number) == "") continue;
							
							_result += real(_number);
						}
						
						if (_input_type == CHAT_COMMAND_INPUT_TYPE.POSITION_Z) && (_result < 0 || _result >= CHUNK_SIZE_Z)
						{
							_error = true;
						
							chat_add("", $"\{warning\} Argument {j} '{_arguments[j]}' is not a valid Z position");
							
							break;
						}
						
						_arguments[@ j] = _result;
					}
					catch (error)
					{
						_error = true;
						
						chat_add("", $"\{warning\} Argument {j} '{_arguments[j]}' is not a valid position");
					}
					break;
								
				case CHAT_COMMAND_INPUT_TYPE.NUMBER:
				case CHAT_COMMAND_INPUT_TYPE.INTEGER:
					try
					{
						_arguments[@ j] = real(_arguments[j]);
									
						if (_arguments[j] < _input.get_input_min()) || (_arguments[j] > _input.get_input_max())
						{
							_error = true;
								
							chat_add("", $"\{warning\} Number '{_arguments[j]}' on argument {j} can only be in range of {_input.get_input_min()} and {_input.get_input_max()}");
						}
						else if (_input_type == CHAT_COMMAND_INPUT_TYPE.INTEGER) && (frac(_arguments[j]) > 0)
						{
							_error = true;
								
							chat_add("", $"\{warning\} Argument {j} '{_arguments[j]}' is not an integer");
						}
					}
					catch (error)
					{
						_error = true;
								
						chat_add("", $"\{warning\} Argument {j} '{_arguments[j]}' is not a number");
					}
					break;
				
				case CHAT_COMMAND_INPUT_TYPE.RANGE_NUMBER:
				case CHAT_COMMAND_INPUT_TYPE.RANGE_INTEGER:
					try
					{
						_arguments[@ j] = string_split(_arguments[j], CHAT_COMMAND_RANGE_SEPARATOR);
						
						if (array_length(_arguments[j]) != 2)
						{
							_error = true;
							
							chat_add("", $"\{warning\} Argument {j} '{_arguments[j]}' is not a valid range");
							
							break;
						}
						
						_arguments[@ j][@ 0] = real(_arguments[j][0]);
						_arguments[@ j][@ 1] = real(_arguments[j][1]);
						
						if (_input_type == CHAT_COMMAND_INPUT_TYPE.RANGE_INTEGER) && (frac(_arguments[j][0]) > 0 || frac(_arguments[j][1]) > 0)
						{
							_error = true;
								
							chat_add("", $"\{warning\} Argument {j} '{_arguments[j]}' is not a range integer");
						}
					}
					catch (error)
					{
						_error = true;
								
						chat_add("", $"\{warning\} Argument {j} '{_arguments[j]}' is not a valid range");
					}
					break;
						
				case CHAT_COMMAND_INPUT_TYPE.BOOLEAN:
					if (array_contains(_chat_command_shortcut_true, _arguments[j], 0, 4))
					{
						_arguments[@ j] = true;
					}
					else if (array_contains(_chat_command_shortcut_false, _arguments[j], 0, 4))
					{
						_arguments[@ j] = false;
					}
					else
					{
						_error = true;
								
						chat_add("", $"\{warning\} Argument {j} '{_arguments[j]}' is not a boolean");
					}
					break;
						
				case CHAT_COMMAND_INPUT_TYPE.USER:
					var _player_name = global.player.name;
						_player_name = string_lower(_player_name);
						_player_name = string_replace_all(_player_name, " ", "_");
								
					if (_arguments[j] == CHAT_COMMAND_PLAYER_PLACEHOLDER) || (string_starts_with(_player_name, _arguments[j]))
					{
						_arguments[@ j] = obj_Player;
					}
					else
					{
						_error = true;
								
						chat_add("", $"\{warning\} Argument {j} '{_arguments[j]}' is not a player");
					}
					break;
				
				}
				
				var _choices = _input.choices;
				var _choices_length = array_length(_choices);
				
				if (_choices_length > 1) && (!array_contains(_choices, _arguments[j], _choices_length))
				{
					_error = true;
								
					chat_add("", $"\{warning\} Argument {j} '{_arguments[j]}' isn't included in choices");
				}
						
				if (_error) break;
			}
		}
		
		var _o = _data.output;
		
		if (!_error) && (_o != -1)
		{
			var _output = _o(_arguments);
						
			if (_output != undefined)
			{
				chat_add("", string(_output));
			}
		}
		
		break;
	}
}