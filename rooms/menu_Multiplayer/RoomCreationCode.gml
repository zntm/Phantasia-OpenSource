if (!file_exists("Servers.json"))
{
	var _file = file_text_open_write("Servers.json");
	
	file_text_write_string(_file, "{ \"servers\": [] }");
	
	file_text_close(_file);
}

var _file = file_text_open_read("Servers.json");

// global.servers = json_parse(file_text_read_string(_file));

file_text_close(_file);