/*
var _length = array_length(mods);

if (_length > 0) && (index < _length)
{
	draw_set_font(global.font_current);
	draw_set_align(fa_center, fa_middle);
	
	draw_text_transformed(960, 540, $"Loading Mod: '{mods[index]}'...\n({index + 1}/{_length} Mods Loaded)", 2, 2, 0);
}