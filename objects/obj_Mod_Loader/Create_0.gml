/*
mods = [];
index = 0;

var _directory = file_find_first($"{DIRECTORY_DATA_ADDON}/*", fa_directory);

while (_directory != "")
{
	// show_debug_message($"Collecting Mod: '{_directory}'");
	
	array_push(mods, _directory);
	
	_directory = file_find_next();
}

file_find_close();

array_sort(mods, sort_alphabetical_descending);