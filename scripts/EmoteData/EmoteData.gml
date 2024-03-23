global.emote_data = {};

function EmoteData(_header) constructor
{
	type = _header;
	global.emote_data[$ _header] ??= [];
	
	static add_emote = function(_emote)
	{
		array_push(global.emote_data[$ type], {
			name: sprite_get_name(_emote),
			value: _emote
		});
		
		return self;
	}
}

new EmoteData("People")
	.add_emote(emote_joy)
	.add_emote(emote_thinking)
	.add_emote(emote_cry)
	.add_emote(emote_blush)
	.add_emote(emote_heart_eyes)
	.add_emote(emote_sad)
	.add_emote(emote_happy)
	.add_emote(emote_shocked)
	.add_emote(emote_cool)
	.add_emote(emote_nerd)
	.add_emote(emote_neutral)
	.add_emote(emote_sleeping)
	.add_emote(emote_horrified)
	.add_emote(emote_smile_with_hearts)
	.add_emote(emote_clown)
	.add_emote(emote_angry)
	.add_emote(emote_cold_face)
	.add_emote(emote_robot)
	.add_emote(emote_thumbs_up)
	.add_emote(emote_thumbs_down)
	.add_emote(emote_wave)
	.add_emote(emote_skull)
	.add_emote(emote_troll)
	.add_emote(emote_eye)
	.add_emote(emote_eyes)
	.add_emote(emote_lips);

new EmoteData("Objects")
	.add_emote(emote_cog)
	.add_emote(emote_lock)
	.add_emote(emote_key)
	.add_emote(emote_plant)
	.add_emote(emote_water_drops)
	.add_emote(emote_8ball)
	.add_emote(emote_bottle)
	.add_emote(emote_megaphone)
	.add_emote(emote_fortune_cookie)
	.add_emote(emote_dice);

new EmoteData("Symbols")
	.add_emote(emote_heart)
	.add_emote(emote_double_hearts)
	.add_emote(emote_star)
	.add_emote(emote_warning)
	.add_emote(emote_globe)
	.add_emote(emote_speech_bubble)
	.add_emote(emote_checkmark)
	.add_emote(emote_crossmark)
	.add_emote(emote_art)
	.add_emote(emote_musical_note)
	.add_emote(emote_bar_chart);

new EmoteData("Pride Flags")
	.add_emote(emote_pride)
	.add_emote(emote_non_binary)
	.add_emote(emote_transgender)
	.add_emote(emote_genderfluid)
	.add_emote(emote_asexual)
	.add_emote(emote_lesbian)
	.add_emote(emote_pansexual)
	.add_emote(emote_bisexual)
	.add_emote(emote_polysexual)
	.add_emote(emote_heterosexual)
	.add_emote(emote_aromantic)
	.add_emote(emote_gay)
	.add_emote(emote_intersex)
	.add_emote(emote_demigender)
	.add_emote(emote_demiboy)
	.add_emote(emote_demigirl);