placeholder = loca_translate("menu.create_world.enter_name");

randomize_text = function()
{
	randomize();
	
	#region Adjective
	
	var _adjective = choose(
		"Abandoned",
		"Absurd",
		"Acidic",
		"Aggressive",
		"Alien",
		"Amazing",
		"Angry",
		"Annoyed",
		"Average",
		"Awesome",
		"Bashful",
		"Beautiful",
		"Big",
		"Boring",
		"Breathtaking",
		"Bustling",
		"Calm",
		"Chaotic",
		"Cheap",
		"Close",
		"Comedic",
		"Confident",
		"Creepy",
		"Crowded",
		"Cubic",
		"Cute",
		"Dazzling",
		"Desaturated",
		"Dying",
		"Dynamic",
		"Easy",
		"Echoing",
		"Enchanting",
		"Energetic",
		"Exciting",
		"Extraordinary",
		"Fancy",
		"Fantastical",
		"Flat",
		"Freezing",
		"Frozen",
		"Ghastly",
		"Generic",
		"Giant",
		"Gigantic",
		"Grilled",
		"Gross",
		"Gleaming",
		"Glittering",
		"Gorgeous",
		"Happy",
		"Hard",
		"High",
		"Homely",
		"Inspiring",
		"Iridescent",
		"Jagged",
		"Large",
		"Living",
		"Low",
		"Loving",
		"Majestic",
		"Melodic",
		"Mysterious",
		"Natural",
		"Neutral",
		"New",
		"Night",
		"Old",
		"Open",
		"Optimistic",
		"Ordinary",
		"Pale",
		"Perfect",
		"Persistent",
		"Pessimistic",
		"Petrified",
		"Playful",
		"Puny",
		"Radiant",
		"Resting",
		"Rich",
		"Round",
		"Rustling",
		"Sad",
		"Saturated",
		"Shameful",
		"Shimmering",
		"Shy",
		"Small",
		"Sparkling",
		"Stale",
		"Stable",
		"Streaming",
		"Suave",
		"Super",
		"Terrifying",
		"Tiny",
		"Ugly",
		"Unknown",
		"Unstable",
		"Vague",
		"Villanous",
		"Wandering",
		"Wondrous",
		"Young"
	);
	
	#endregion
	
	#region Location
	
	var _location = choose(
		"Abode",
		"Abyss",
		"Afterworld",
		"Archipelago",
		"Badlands",
		"Beach",
		"Beforeworld",
		"Caves",
		"Canopy",
		"Cliffs",
		"Continent",
		"Dune",
		"Domain",
		"Desert",
		"Forest",
		"Grove",
		"Haven",
		"Heaven",
		"Hills",
		"Hive",
		"Hole",
		"Island",
		"Jungle",
		"Kingdom",
		"Lagoon",
		"Lake",
		"Land",
		"Meadow",
		"Mesa",
		"Mountains",
		"Ocean",
		"Oasis",
		"Playground",
		"Pond",
		"Prairie",
		"Realm",
		"River",
		"Sanctuary",
		"Serenity",
		"Snowlands",
		"Spring",
		"Stronghold",
		"Swamp",
		"Taiga",
		"Terrain",
		"Terrace",
		"Trench",
		"Tropic",
		"Tundra",
		"Turf",
		"Valley",
		"Void",
		"World"
	);
	
	#endregion
		
	#region Preposition
		
	var _preposition = choose(
		"above",
		"against",
		"alongside",
		"amidst",
		"around",
		"as",
		"at",
		"before",
		"beside",
		"besieged",
		"beneath",
		"beyond",
		"by",
		"during",
		"enveloped",
		"for",
		"from",
		"inside",
		"into",
		"like",
		"near",
		"of",
		"onto",
		"over",
		"outside",
		"past",
		"through",
		"opposite",
		"throughout",
		"to",
		"toward",
		"underneath",
		"upon",
		"with",
		"within"
	);
	
	#endregion
		
	#region Noun
	
	var _noun = choose(
		"Agony",
		"Blossoms",
		"Clouds",
		"Comfort",
		"Confidence",
		"Confusion",
		"Distortion",
		"Elements",
		"Fauna",
		"Flora",
		"Legends",
		"Loneliness",
		"Lore",
		"Losers",
		"Loss",
		"Love",
		"Luck",
		"Luxury",
		"Madness",
		"Man",
		"Melancholy",
		"Misfortune",
		"Opportunity",
		"Orchids",
		"Relief",
		"Remorse",
		"Rolling Hills",
		"Secrets",
		"Secrecy",
		"Serenity",
		"Sorrow",
		"Souls",
		"the Above",
		"the Adventurers",
		"the Below",
		"the Beyond",
		"the Chosen Ones",
		"the Explorers",
		"the Fool",
		"the Left",
		"the Lost",
		"the Prophecy",
		"the Right",
		"the Wanderers",
		"the Worthies",
		"Time",
		"Trash",
		"Trees",
		"Trust",
		"Truth",
		"Victory",
		"Winner",
		"Winners",
		"Wonder",
		"Yonder"
	);
	
	#endregion
	
	var _name;
	
	switch (irandom(3))
	{
	
	default:
		_name = $"{_adjective} {_location} {_preposition} {_noun}";
		break;
			
	case 1:
		_name = $"{_adjective} {_location}";
		break;
		
	case 2:
		_name = $"{_location} {_preposition} {_noun}";
		break;
		
	case 3:
		_name = $"{_adjective} {_preposition} {_noun}";
		break;
	
	}
	
	#macro MENU_WORLD_NAME_RANDOM_ONCE  choose("Once", "Thrice", "Twice")
	#macro MENU_WORLD_NAME_RANDOM_START choose("The", "Thy", choose("Galloping", "Infinity", MENU_WORLD_NAME_RANDOM_ONCE, "Whispering") + ", in the")
	
	switch (irandom(5))
	{
	
	case 0:
		_name = $"{MENU_WORLD_NAME_RANDOM_START} {_name}";
		break;
		
	case 1:
		var _prefix = "";
		
		if (irandom(1))
		{
			_prefix = $"{MENU_WORLD_NAME_RANDOM_START} ";
		}
		
		_name = $"{_prefix}{choose("Chronicle", "Fable", "Legend", "Myth", "Narrative", "Saga", "Story", "Tale")} of the {_name}";
		break;
		
	case 2:
		static _vowels = [ "a", "e", "i", "o", "u" ];
		
		var _a_or_an = (array_contains(_vowels, string_lower(string_char_at(_name, 1))) ? "an" : "a");
		
		_name = $"{MENU_WORLD_NAME_RANDOM_ONCE} {_preposition} {_a_or_an} {_name}";
		break;
		
	case 3:
		_name = $"{MENU_WORLD_NAME_RANDOM_START} {choose("Domain", "Frontier", "Kingdom", "Land", "Province", "Realm", "Territory", "World")} of {_name}";
		break;
	
	}
	
	text = _name;
}

randomize_text();