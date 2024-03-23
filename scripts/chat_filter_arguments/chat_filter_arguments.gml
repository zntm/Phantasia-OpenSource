function chat_filter_arguments(_value, _index)
{
	return (string_starts_with(_value, global.command_current_argument)) && (_value != "description") && (_value != "type") && (_value != "input") && (_value != "output") && (_value != "command_level");
}