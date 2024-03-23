text = "Export";

on_press = function()
{
	var _text = inst_AB71710.text;
	
	if (string_length(_text) <= 0)
	{
		inst_49F64DCE.text = $"File name is empty";
		
		var _handle = call_later(5, time_source_units_seconds, function()
		{
			if (room != rm_World) exit;
			
			inst_49F64DCE.text = "";
		});
		
		exit;
	}
	
	var _directory = $"{DIRECTORY_DATA_EXPORTS_STRUCTURES}/{_text}.dat";
	
	if (file_exists(_directory))
	{
		inst_49F64DCE.text = $"Structure file with name '{_text}' already exists";
		
		var _handle = call_later(5, time_source_units_seconds, function()
		{
			if (room != rm_World) exit;
			
			inst_49F64DCE.text = "";
		});
		
		exit;
	}
	
	var _handle = call_later(5, time_source_units_seconds, function()
	{
		if (room != rm_World) exit;
		
		inst_49F64DCE.text = "Successfully exported";
	});
	
	structure_export(_text);
}

