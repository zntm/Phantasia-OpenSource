global.credit_data = {};

function CreditData(_header) constructor
{
	type = _header;
	global.credit_data[$ _header] ??= [];
	
	static add_user = function(_user)
	{
		array_push(global.credit_data[$ type], _user);
		
		return self;
	}
}

function CreditUser(_name) constructor
{
	name = _name;
	icon = asset_get_index($"ico_Credits_{string_replace_all(_name, " ", "_")}");
	
	youtube = -1;
	
	static set_youtube = function(_user)
	{
		youtube = _user;
		
		return self;
	}
	
	twitter = -1;
	
	static set_twitter = function(_user)
	{
		twitter = _user;
		
		return self;
	}
	
	tumblr = -1;
	
	static set_tumblr = function(_user)
	{
		tumblr = _user;
		
		return self;
	}
}

new CreditData("Owner")
	.add_user(new CreditUser("Zhen")
		.set_youtube("zntm")
		.set_twitter("zhntm"));

new CreditData("Lead Artist")
	.add_user(new CreditUser("NHJ")
		.set_youtube("UCmucRQqVmpq3mTQygBRlIAg")
		.set_twitter("NHJ__NHJ"));

new CreditData("Background Artist")
	.add_user(new CreditUser("NetBa")
		.set_twitter("NetBa_Art"));

new CreditData("Concept Artist")
	.add_user(new CreditUser("lettucenotcabbage")
		.set_twitter("lettucenotcabb"));

new CreditData("Composers")
	.add_user(new CreditUser("LonelyChicken")
		.set_twitter("LonelyChicken12"))
	.add_user(new CreditUser("GlydeOut")
		.set_twitter("GlydeGameDev"))
	.add_user(new CreditUser("Skies"));

new CreditData("Translators (Español)")
	.add_user(new CreditUser("LanFemboy"))
	.add_user(new CreditUser("Artemisia"));
/*
new CreditData("Translators (German)")
	.add_user(new CreditUser("FabBeyond"));

new CreditData("Translators (Japanese)")
	.add_user(new CreditUser("GeoTheMakuGamer")
		.set_youtube("UCAkNbMDL_twXz4m1HOguTSA")
		.set_twitter("o0OMakuO0o"));

new CreditData("Translators (Dutch)")
	.add_user(new CreditUser("CannyMantis5421"))
	.add_user(new CreditUser("MasterK"));

new CreditData("Translators (Russian)")
	.add_user(new CreditUser("Yuiayyy"));

new CreditData("Translators (Français)")
	.add_user(new CreditUser("Élo13"));

new CreditData("Journal Writers")
	.add_user(new CreditUser("ceasingbonsai17"))
	.add_user(new CreditUser("LanFemboy"))
	.add_user(new CreditUser("pieusername"));

new CreditData("Playtesters")
	.add_user(new CreditUser("zenuss."))
	.add_user(new CreditUser("abyssaltheking"))
	.add_user(new CreditUser("fordivinity"))
	.add_user(new CreditUser("jay_ar3"))
	.add_user(new CreditUser("licensedfunnyman"))
	.add_user(new CreditUser("iammefr"))
	.add_user(new CreditUser("srisrid"))
	.add_user(new CreditUser("wanterwither"))
	.add_user(new CreditUser("anxieteaplushbee"))
	.add_user(new CreditUser("ceasingbonsai17"))
	.add_user(new CreditUser("emjaycrowe"))
	.add_user(new CreditUser("greetingscultist"))
	.add_user(new CreditUser("hunvich"))
	.add_user(new CreditUser("hyfa"))
	.add_user(new CreditUser("jarviscrompz"))
	.add_user(new CreditUser("void_4736"))
	.add_user(new CreditUser("tamtixx"))
	.add_user(new CreditUser("kksxx"))
	.add_user(new CreditUser("Yuiayyy"));

new CreditData("Special Thanks")
	.add_user(new CreditUser("zenuss"))
	.add_user(new CreditUser("pieusername"))
	.add_user(new CreditUser("nisazzz"))
	.add_user(new CreditUser("jay_ar3"))
	.add_user(new CreditUser("anxieteaplushbee"));
*/