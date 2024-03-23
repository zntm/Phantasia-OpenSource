function chat_disable()
{
	if (!obj_Control.is_opened_menu)
	{
		keyboard_string = "";
	}
	
	obj_Control.chat_message = "";
	
	obj_Control.is_opened_chat = false;
	obj_Control.is_command = false;
	
	obj_Control.surface_refresh_chat = true;
}