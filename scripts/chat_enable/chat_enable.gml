function chat_enable(_message = "")
{
	obj_Control.surface_refresh_chat = true;
	obj_Control.is_opened_chat = true;
	
	keyboard_string = _message;
	obj_Control.chat_message = _message;
}