biome = irandom(array_length(global.surface_biome_data) - 1);

if (!audio_is_playing(mus_Phantasia))
{
	audio_stop_all();
	audio_play_sound(mus_Phantasia, 0, true);
}

enum MENU_BACKGROUND_TYPE
{
	DEFAULT,
	SCROLLING
}

type = MENU_BACKGROUND_TYPE.DEFAULT;
timer = 0;