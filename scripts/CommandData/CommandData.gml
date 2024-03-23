enum CHAT_COMMAND_ARGUMENT_TYPE {
	EMPTY,
	SUBCOMMAND,
	INPUT
}

enum CHAT_COMMAND_INPUT_TYPE {
	STRING,
	NUMBER,
	INTEGER,
	BOOLEAN,
	USER,
	POSITION_X,
	POSITION_Y,
	POSITION_Z,
	RANGE_NUMBER,
	RANGE_INTEGER,
}

enum CHAT_COMMAND_LEVEL {
	OWNER,
	MODERATOR,
	NONE
}

#macro CHAT_COMMAND_INPUT_LENGTH_ANY -1

function CommandData(_type) constructor
{
	type = _type;
	
	if (_type == CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
	{
		static add_subcommand = function(_subcommand, _command_data)
		{
			self[$ string(_subcommand)] = _command_data;
		
			return self;
		}
	}
	else if (_type == CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
	{
		input = [];
		input_length = 0;
		
		output = -1;
		
		static add_input = function(_input)
		{
			array_push(input, _input);
			
			if (_input.required)
			{
				++input_length;
			}
			
			return self;
		}
		
		static set_input_any = function()
		{
			input_length = CHAT_COMMAND_INPUT_LENGTH_ANY;
			
			return self;
		}
		
		static set_output = function(_output)
		{
			output = _output;
			
			return self;
		}
	}
	
	description = "EMPTY DESCRIPTION";
	
	static set_description = function(_description)
	{
		description = _description;
		
		return self;
	}
	
	command_level = CHAT_COMMAND_LEVEL.NONE;
	
	static set_command_level = function(_level)
	{
		command_level = _level;
		
		return self;
	}
}

function CommandInput(_name, _type, _default_value = 0) constructor
{
	name = _name;
	type = _type;
	default_value = _default_value;
	
	// 0x0000_ffff - first 16 bits are input min, last 16 bits are input max
	input = 0x0000_0000 | 50000;
	
	static set_input = function(_min, _max)
	{
		input = (_min << 16) | _max;
		
		return self;
	}
	
	static get_input_min = function()
	{
		return input >> 16;
	}
	
	static get_input_max = function()
	{
		return input & 0xffff;
	}
	
	choices = [];
		
	static set_choices = function()
	{
		var i = 0;
			
		repeat (argument_count)
		{
			choices[@ i] = argument[i];
				
			++i;
		}
		
		return self;
	}
	
	required = (_default_value == 0);
	
	static set_required = function()
	{
		required = true;
		
		return self;
	}
}

global.command_data = {};

function add_command(_name, _command)
{
	global.command_data[$ _name] = _command;
}

add_command("time", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
	.set_description("Manage world time")
	.add_subcommand("get", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.EMPTY)
		.set_description("Get current world time")
		.set_output(function(_input)
		{
			return $"\{cog\} Current world time is {global.world.environment.time}";
		}))
	.add_subcommand("set", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Set world time")
		.add_input(new CommandInput("time", CHAT_COMMAND_INPUT_TYPE.INTEGER)
			.set_input(0, 50000)
			.set_required())
		.set_output(function(_input)
		{
			global.world.environment.time = _input[0];
			
			return $"\{cog\} Set current world time to {global.world.environment.time}";
		})));

add_command("tp", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
	.set_description("Teleport a user to a position")
	.add_input(new CommandInput("user", CHAT_COMMAND_INPUT_TYPE.USER)
		.set_required())
	.add_input(new CommandInput("x", CHAT_COMMAND_INPUT_TYPE.POSITION_X)
		.set_required())
	.add_input(new CommandInput("y", CHAT_COMMAND_INPUT_TYPE.POSITION_Y)
		.set_required())
	.set_output(function(_input)
	{
		_input[0].x = _input[1] * TILE_SIZE;
		_input[0].y = _input[2] * TILE_SIZE;
		
		return $"\{cog\} Teleported {_input[0].name} to ({_input[1]}, {_input[2]})";
	}));

add_command("tile", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
	.set_description("Place a tile on a give position")
	.add_input(new CommandInput("x", CHAT_COMMAND_INPUT_TYPE.POSITION_X)
		.set_required())
	.add_input(new CommandInput("y", CHAT_COMMAND_INPUT_TYPE.POSITION_Y)
		.set_required())
	.add_input(new CommandInput("z", CHAT_COMMAND_INPUT_TYPE.POSITION_Z)
		.set_required())
	.add_input(new CommandInput("item", CHAT_COMMAND_INPUT_TYPE.STRING)
		.set_required())
	.set_output(function(_input)
	{
		var _item_data = global.item_data;
		
		var _tile;
		
		if (_input[3] == "-1") || (_input[3] == "empty")
		{
			_tile = ITEM.EMPTY;
		}
		else
		{
			var _length = array_length(_item_data);
			
			var _id = -1;
			
			for (var i = 0; i < _length; ++i)
			{
				var _data = _item_data[i];
				
				var _name = _data.name;
					_name = string_lower(_name);
					_name = string_replace_all(_name, " ", "_");
					_name = string_replace_all(_name, "'", "");
				
				var _shortcut = "";
				
				if (string_count("_", _name) > 0)
				{
					var _split = string_split(_name, "_");
					var _split_length = array_length(_split);
					
					for (var j = 0; j < _split_length; ++j)
					{
						_shortcut += string_char_at(_split[j], 1);
					}
				}
				
				if (_shortcut != "" && _input[3] == _shortcut) || (string_starts_with(_name, _input[3]))
				{
					_id = i;
					
					break;
				}
			}
			
			if (_id < 0)
			{
				return $"\{warning\} Item {_input[3]} is not valid";
			}
			
			_tile = new Tile(_id);
		}
		
		tile_place(_input[0], _input[1], _input[2], _tile);
		
		return $"\{cog\} Placed '{_tile == ITEM.EMPTY ? "Empty" : _item_data[_tile.item_id].name}' at position ({_input[0]}, {_input[1]}, {_input[2]})";
	}));

add_command("fill", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
	.set_description("Fills an area with given positions")
	.add_input(new CommandInput("from_x", CHAT_COMMAND_INPUT_TYPE.POSITION_X)
		.set_required())
	.add_input(new CommandInput("from_y", CHAT_COMMAND_INPUT_TYPE.POSITION_Y)
		.set_required())
	.add_input(new CommandInput("to_x", CHAT_COMMAND_INPUT_TYPE.POSITION_X)
		.set_required())
	.add_input(new CommandInput("to_y", CHAT_COMMAND_INPUT_TYPE.POSITION_Y)
		.set_required())
	.add_input(new CommandInput("z", CHAT_COMMAND_INPUT_TYPE.POSITION_Z)
		.set_required())
	.add_input(new CommandInput("item", CHAT_COMMAND_INPUT_TYPE.STRING)
		.set_required())
	.set_output(function(_input)
	{
		#macro COMMAND_FILL_MAX 512
		
		var _amount = 0;
		
		for (var i = _input[0]; i <= _input[2]; ++i)
		{
			for (var j = _input[1]; j <= _input[3]; ++j)
			{
				++_amount;
			}
		}
		
		if (_amount > COMMAND_FILL_MAX)
		{
			return $"\{warning\} Tried to fill an area that's too big '({_amount})'";
		}
		
		var _item_data = global.item_data;
		
		var _tile;
		
		if (_input[5] == "-1") || (_input[5] == "empty")
		{
			_tile = ITEM.EMPTY;
		}
		else
		{
			var _length = array_length(_item_data);
			
			var _id = -1;
			
			for (var i = 0; i < _length; ++i)
			{
				var _data = _item_data[i];
				
				var _name = _data.name;
					_name = string_lower(_name);
					_name = string_replace_all(_name, " ", "_");
					_name = string_replace_all(_name, "'", "");
				
				var _shortcut = "";
				
				if (string_count("_", _name) > 0)
				{
					var _split = string_split(_name, "_");
					var _split_length = array_length(_split);
					
					for (var j = 0; j < _split_length; ++j)
					{
						_shortcut += string_char_at(_split[j], 1);
					}
				}
				
				if (_shortcut != "" && _input[5] == _shortcut) || (string_starts_with(_name, _input[5]))
				{
					_id = i;
					
					break;
				}
			}
			
			if (_id < 0)
			{
				return $"\{warning\} Item {_input[5]} is not valid";
			}
			
			_tile = new Tile(_id);
		}
		
		var _from_x = min(_input[0], _input[2]);
		var _from_y = min(_input[1], _input[3]);
		
		var _to_x = max(_input[0], _input[2]);
		var _to_y = max(_input[1], _input[3]);
		
		for (var i = _from_x; i <= _to_x; ++i)
		{
			for (var j = _from_y; j <= _to_y; ++j)
			{
				tile_place(i, j, _input[4], _tile);
			}
		}
		
		for (var i = _from_x - 1; i <= _to_x + 1; ++i)
		{
			for (var j = _from_y - 1; j <= _to_y + 1; ++j)
			{
				tile_update(i, j, _input[4]);
			}
		}
		
		return $"\{cog\} Placed '{_tile == ITEM.EMPTY ? "Empty" : _item_data[_tile.item_id].name}' at positions ({_input[0]}, {_input[2]}, {_input[4]}) to ({_input[1]}, {_input[3]}, {_input[4]}) ({_amount} total)";
	}));

if (DEV_MODE)
{
	add_command("debug", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
		.set_description("Manage debug settings (unstable)")
		.add_subcommand("fps", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
			.set_description("Set game FPS")
			.add_input(new CommandInput("time", CHAT_COMMAND_INPUT_TYPE.INTEGER, "60")
				.set_input(15, 240))
			.set_output(function(_input)
			{
				game_set_speed(_input[0], gamespeed_fps);
			
				return $"\{cog\} Set game FPS to {_input[0]}";
			}))
		.add_subcommand("physics", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.EMPTY)
			.set_description("Enable/disable player physics")
			.set_output(function(_input)
			{
				var _value = !global.local_settings.enable_physics;
				
				global.local_settings.enable_physics = _value;
			
				obj_Player.image_xscale = 1;
				obj_Player.image_yscale = 1;
			
				return $"\{cog\} Set physics to {_value ? "true" : "false"}";
			}))
		.add_subcommand("gui", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.EMPTY)
			.set_description("Enable/disable debug GUI")
			.set_output(function(_input)
			{
				var _value = !global.local_settings.draw_fps;
				
				global.local_settings.draw_fps = _value;
			
				show_debug_log(_value);
			
				return $"\{cog\} Set FPS to {_value ? "true" : "false"}";
			}))
		.add_subcommand("sunlight", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.EMPTY)
			.set_description("Enable/disable sun light ray visibility")
			.set_output(function(_input)
			{
				var _value = !global.local_settings.visible_sunlight;
				
				global.local_settings.visible_sunlight = _value;
			
				with (obj_Light_Sun)
				{
					visible = _value;
				}
				
				return $"\{cog\} Set FPS to {_value ? "true" : "false"}";
			}))
		.add_subcommand("lighting", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.EMPTY)
			.set_description("Enable/disable drawing lighting")
			.set_output(function(_input)
			{
				var _value = !global.local_settings.enable_lighting;
				
				global.local_settings.enable_lighting = _value;
				
				return $"\{cog\} Set physics to {_value ? "true" : "false"}";
			})));
}

add_command("info", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
	.set_description("Show info")
	.add_subcommand("user", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Show user info")
		.add_input(new CommandInput("user", CHAT_COMMAND_INPUT_TYPE.USER, "@"))
		.set_output(function(_input)
		{
			var _user = _input[0];
			
			chat_add("", $"\{speech_bubble\} - Player Name: {_user.name}");
			chat_add("", $"\{double_heart\} - Player HP: {_user.hp}/{_user.hp_max}");
			chat_add("", $"\{eye\} - Player Position: (x: {round(_user.x / TILE_SIZE)}) (y: {round(_user.y / TILE_SIZE)})");
		}))
	.add_subcommand("world", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.EMPTY)
		.set_description("Show world info")
		.set_output(function(_input)
		{
			var _gamemode = "Unknown";
			
			switch ((global.world.environment.value >> 12) & 0xf)
			{
			
			case GAMEMODE_TYPE.ADVENTURE:
				_gamemode = "Adventure";
				break;
			
			case GAMEMODE_TYPE.SANDBOX:
				_gamemode = "Sandbox";
				break;
			
			}
			
			var _difficulty = "Unknown";
			
			switch ((global.world.environment.value >> 8) & 0xf)
			{
			
			case DIFFICULTY_TYPE.PEACEFUL:
				_difficulty = "Peaceful";
				break;
			
			case DIFFICULTY_TYPE.EASY:
				_difficulty = "Easy";
				break;
			
			case DIFFICULTY_TYPE.NORMAL:
				_difficulty = "Normal";
				break;
			
			case DIFFICULTY_TYPE.HARD:
				_difficulty = "Hard";
				break;
			
			}
			
			chat_add("", $"\{globe\} - World Name: {global.world.info.name}");
			chat_add("", $"\{plant\} - World Seed: {global.world.info.seed}");
			chat_add("", $"\{key\} - World Gamemode: {_gamemode}");
			chat_add("", $"\{heart\} - World Difficulty: {_difficulty}");
		})));

add_command("inventory", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
	.set_description("Manage player inventory")
	.add_subcommand("give", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Gives item to player")
		.add_input(new CommandInput("item", CHAT_COMMAND_INPUT_TYPE.STRING)
			.set_required())
		.add_input(new CommandInput("amount", CHAT_COMMAND_INPUT_TYPE.INTEGER, "1"))
		.set_output(function(_input)
		{
			var _item_data = global.item_data;
			var _length = array_length(_item_data);
			
			var _id = -1;
			
			for (var i = 0; i < _length; ++i)
			{
				var _data = _item_data[i];
				
				var _name = _data.name;
					_name = string_lower(_name);
					_name = string_replace_all(_name, " ", "_");
					_name = string_replace_all(_name, "'", "");
				
				if (_input[0] == _name)
				{
					spawn_drop(obj_Player.x, obj_Player.y, i, _input[1], 0, 0, 0, 0);
					
					return $"Gave {global.player.name} {_input[1]} '{_data.name}'";
				}
			}
			
			for (var i = 0; i < _length; ++i)
			{
				var _data = _item_data[i];
				
				var _name = _data.name;
					_name = string_lower(_name);
					_name = string_replace_all(_name, " ", "_");
					_name = string_replace_all(_name, "'", "");
				
				var _shortcut = "";
				
				if (string_count("_", _name) > 0)
				{
					var _split = string_split(_name, "_");
					var _split_length = array_length(_split);
					
					for (var j = 0; j < _split_length; ++j)
					{
						_shortcut += string_char_at(_split[j], 1);
					}
				}
				
				if (_shortcut != "" && _input[0] == _shortcut) || (string_starts_with(_name, _input[0]))
				{
					if (_input[1] > _data.get_inventory_max())
					{
						return $"\{warning\} Amount of '{_data.name}' can only go up to {_data.get_inventory_max()}";
					}
			
					_id = i;
					
					break;
				}
			}
			
			if (_id < 0)
			{
				return $"\{warning\} Item {_input[0]} is not valid";
			}
			
			spawn_drop(obj_Player.x, obj_Player.y, _id, _input[1], 0, 0, 0, 0);
			
			return $"Gave {global.player.name} {_input[1]} '{_data.name}'";
		}))
	.add_subcommand("clear", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.EMPTY)
		.set_description("Clears player inventory")
		.set_output(function(_input)
		{
			var _item;
			
			//var _amount = 0;
			
			var _names = struct_get_names(global.inventory);
			var _names_length = array_length(_names);
			
			for (var i = 0; i < _names_length; ++i)
			{
				var _name = _names[i];
				
				if (_name == SLOT_TYPE.CRAFTABLE) continue;
				
				var _inventory = global.inventory[$ _name];
				var _inventory_length = array_length(_inventory);
				
				for (var j = 0; j < _inventory_length; ++j)
				{
					_item = _inventory[j];
					
					if (_inventory != INVENTORY_EMPTY)
					{
						//_amount += _inventory.amount;
						
						global.inventory[$ _name][@ j] = INVENTORY_EMPTY;
					}
				}
			}
			
			obj_Control.surface_refresh_inventory = true;
				
			//return $"\{cog\} Successfully cleared inventory (cleared {_amount} total items)";
		})));

add_command("hp", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
	.set_description("Manage player HP")
	.add_subcommand("add", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Add player HP")
		.add_input(new CommandInput("hp", CHAT_COMMAND_INPUT_TYPE.INTEGER)
			.set_input(-500, 500)
			.set_required())
		.set_output(function(_input)
		{
			hp_add(obj_Player, _input[0], DAMAGE_TYPE.DEFAULT, false);
			
			return $"\{cog\} Added {_input[0]}HP to {global.player.name}";
		}))
	.add_subcommand("set", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Set player HP")
		.add_input(new CommandInput("hp", CHAT_COMMAND_INPUT_TYPE.INTEGER)
			.set_input(-500, 500)
			.set_required())
		.set_output(function(_input)
		{
			hp_set(obj_Player, _input[0]);
			
			return $"\{cog\} Set {_input[0]}HP to {global.player.name}";
		})));

add_command("effect", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
	.set_description("Manage entity effects")
	.add_subcommand("set", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
		.set_description("Manage user effects")
		.add_subcommand("user", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
			.set_description("Set user effects")
			.add_input(new CommandInput("user", CHAT_COMMAND_INPUT_TYPE.USER)
				.set_required())
			.add_input(new CommandInput("effect", CHAT_COMMAND_INPUT_TYPE.STRING)
				.set_required())
			.add_input(new CommandInput("time", CHAT_COMMAND_INPUT_TYPE.INTEGER, "60"))
			.add_input(new CommandInput("level", CHAT_COMMAND_INPUT_TYPE.INTEGER, "1"))
			.set_output(function(_input)
			{
				var _effect_data = global.effect_data;
				var _names = struct_get_names(global.effect_data);
			
				var _length = array_length(_names);
			
				var _id = -1;
			
				for (var i = 0; i < _length; ++i)
				{
					var _name = _names[i];
					// var _data = _effect_data[$ _name];
				
					var _shortcut = "";
				
					if (string_count("_", _name) > 0)
					{
						var _split = string_split(_name, "_");
						var _split_length = array_length(_split);
					
						for (var j = 0; j < _split_length; ++j)
						{
							_shortcut += string_char_at(_split[j], 1);
						}
					}
				
					if (_shortcut != "" && _input[1] == _shortcut) || (string_starts_with(_name, _input[1]))
					{
						_id = _name;
					
						break;
					}
				}
			
				if (_id == -1)
				{
					return $"\{warning\} Effect {_input[1]} is not valid";
				}
			
				effect_set(_id, _input[2], _input[3], _input[0]);
			
				return $"\{cog\} Gave {_input[0].name} {_effect_data[$ _id].name} for {_input[2]} seconds with level {_input[3]}";
			})))
	.add_subcommand("clear", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
		.set_description("Clear entity effects")
		.add_subcommand("user", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
			.set_description("Clear entity effects")
			.add_input(new CommandInput("user", CHAT_COMMAND_INPUT_TYPE.USER, "@"))
			.set_output(function(_input)
			{
				with (_input[0])
				{
					var _names = struct_get_names(effects);
					var _length = array_length(_names);
				
					for (var i = 0; i < _length; ++i)
					{
						var _name = _names[i];
					
						effects[$ _name].timer = 0;
						effects[$ _name].level = 0;
					}
				}
			
				return $"\{cog\} Cleared {_input[0].name} effects";
			}))));

add_command("kill", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
	.set_description("Kills player")
	.add_input(new CommandInput("type", CHAT_COMMAND_INPUT_TYPE.STRING, "default"))
	.set_output(function(_input)
	{
		var _type = DAMAGE_TYPE.DEFAULT;
		
		switch (_input[0])
		{
		
		case "blast":
			_type = DAMAGE_TYPE.BLAST;
			break;
		
		case "default":
			_type = DAMAGE_TYPE.DEFAULT;
			break;
		
		case "fall":
			_type = DAMAGE_TYPE.FALL;
			break;
		
		case "fire":
			_type = DAMAGE_TYPE.FIRE;
			break;
		
		case "magic":
			_type = DAMAGE_TYPE.MAGIC;
			break;
		
		case "melee":
			_type = DAMAGE_TYPE.MELEE;
			break;
		
		case "projectile":
			_type = DAMAGE_TYPE.RANGED;
			break
		
		}
		
		hp_set(obj_Player, 0, _type);
		
		return $"\{cog\} Killed {global.player.name}";
	}));

add_command("pick", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
	.set_description("Pick a random value")
	.add_subcommand("integer", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Get random integer")
		.add_input(new CommandInput("min", CHAT_COMMAND_INPUT_TYPE.RANGE_INTEGER, 0))
		.set_output(function(_input)
		{
			return $"\{cog\} Picked {irandom_range(_input[0][0], _input[0][1])}";
		}))
	.add_subcommand("number", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Get random number")
		.add_input(new CommandInput("range", CHAT_COMMAND_INPUT_TYPE.RANGE_NUMBER, 0))
		.set_output(function(_input)
		{
			return $"\{cog\} Picked {random_range(_input[0][0], _input[0][1])}";
		}))
	.add_subcommand("string", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Choose random string")
		.add_input(new CommandInput("string", CHAT_COMMAND_INPUT_TYPE.STRING)
			.set_required())
		.set_input_any()
		.set_output(function(_input)
		{
			return $"\{cog\} Picked {array_choose(_input)}";
		})));

add_command("say", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
	.set_description("Sends a raw message")
	.add_input(new CommandInput("message", CHAT_COMMAND_INPUT_TYPE.STRING, "message"))
	.set_input_any()
	.set_output(function(_input)
	{
		var _string = "";
		var _length = array_length(_input);
		
		for (var i = 0; i < _length; ++i)
		{
			_string += _input[i];
			
			if (i != _length - 1)
			{
				_string += CHAT_COMMAND_SEPARATOR;
			}
		}
		
		if (_string != "")
		{
			return _string;
		}
	}));

add_command("summon", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
	.set_description("Summon creatures/bosses")
	.add_subcommand("creature", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Summon creature")
		.add_input(new CommandInput("name", CHAT_COMMAND_INPUT_TYPE.STRING)
			.set_required())
		.add_input(new CommandInput("amount", CHAT_COMMAND_INPUT_TYPE.INTEGER, "1")
			.set_input(1, SPAWN_CREATURE_MAX))
		.set_output(function(_input)
		{
			var _creature_data = global.creature_data;
			var _length = array_length(_creature_data);
			
			var _id = -1;
			
			for (var i = 0; i < _length; ++i)
			{
				var _data = _creature_data[i];
			
				var _name = _data.name;
					_name = string_lower(_name);
					_name = string_replace_all(_name, " ", "_");
					_name = string_replace_all(_name, "'", "");
				
				var _shortcut = "";
				
				if (string_count("_", _name) > 0)
				{
					var _split = string_split(_name, "_");
					var _split_length = array_length(_split);
					
					for (var j = 0; j < _split_length; ++j)
					{
						_shortcut += string_char_at(_split[j], 1);
					}
				}
				
				if (_shortcut != "" && _input[0] == _shortcut) || (string_starts_with(_name, _input[0]))
				{
					_id = i;
					
					break;
				}
			}
			
			if (_id == -1)
			{
				return $"\{warning\} Creature {_input[0]} is not valid";
			}
		
			spawn_creature(obj_Player.x, obj_Player.y, _id, _input[1]);
		
			return $"Summoned {_input[1]} {_creature_data[_id].name}";
		}))
	.add_subcommand("boss", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Summon boss")
		.add_input(new CommandInput("name", CHAT_COMMAND_INPUT_TYPE.STRING)
			.set_required())
		.set_output(function(_input)
		{
			var _boss_data = global.boss_data;
			var _length = array_length(_boss_data);
			
			var _id = -1;
			
			for (var i = 0; i < _length; ++i)
			{
				var _data = _boss_data[i];
			
				var _name = _data.name;
					_name = string_lower(_name);
					_name = string_replace_all(_name, " ", "_");
					_name = string_replace_all(_name, "'", "");
				
				var _shortcut = "";
				
				if (string_count("_", _name) > 0)
				{
					var _split = string_split(_name, "_");
					var _split_length = array_length(_split);
					
					for (var j = 0; j < _split_length; ++j)
					{
						_shortcut += string_char_at(_split[j], 1);
					}
				}
				
				if (_shortcut != "" && _input[0] == _shortcut) || (string_starts_with(_name, _input[0]))
				{
					_id = i;
					
					break;
				}
			}
			
			if (_id == -1)
			{
				return $"\{warning\} Creature {_input[0]} is not valid";
			}
			
			if (!instance_exists(obj_Boss))
			{
				spawn_boss(obj_Player.x, obj_Player.y, _id);
		
				return $"Summoned {_boss_data[_id].name}";
			}
			
			return $"There is already a boss spawned";
		})));

add_command("weather", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
	.set_description("Manage weather")
	.add_subcommand("set", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Set weather")
		.add_input(new CommandInput("wind", CHAT_COMMAND_INPUT_TYPE.NUMBER, 0)
			.set_input(0, 1))
		.add_input(new CommandInput("storm", CHAT_COMMAND_INPUT_TYPE.NUMBER, 0)
			.set_input(0, 1))
		.set_output(function(_input)
		{
			var _wind  = _input[0];
			var _storm = _input[1];
			
			global.world.environment.weather_wind  = _wind;
			global.world.environment.weather_storm = _storm;
			
			chat_add("", $"\{cog\} Set wind to {round(_wind * 100)}%");
			chat_add("", $"\{cog\} Set storm to {round(_storm * 100)}%");
		}))
	.add_subcommand("clear", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Clear weather")
		.set_output(function(_input)
		{
			global.world.environment.weather_wind  = 0;
			global.world.environment.weather_storm = 0;
			
			return $"\{cog\} Cleared weather";
		})));

add_command("tick", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
	.set_description("Manage game tick speed")
	.add_input(new CommandInput("speed", CHAT_COMMAND_INPUT_TYPE.INTEGER, 60)
		.set_input(1, 600))
	.set_output(function(_input)
	{
		global.tick = _input[0];
		
		chat_add("", $"\{cog\} Set tick speed to {_input[0]}%");
	}));

add_command("hp", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
	.set_description("Manage player HP")
	.add_input(new CommandInput("user", CHAT_COMMAND_INPUT_TYPE.USER, "@"))
	.add_input(new CommandInput("hp", CHAT_COMMAND_INPUT_TYPE.INTEGER, 100)
		.set_input(1, 5000))
	.set_output(function(_input)
	{
		var _user = _input[0];
		var _hp = _input[1];
		
		_user.hp = _hp * _user.hp / _user.hp_max;
		_user.hp_max = _hp;
		
		obj_Control.surface_refresh_hp = true;
		
		chat_add("", $"\{cog\} Set HP of {_user.name} to {_hp}");
	}));

add_command("value", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.SUBCOMMAND)
	.set_description("Manage values")
	.add_subcommand("create", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Create a value")
		.add_input(new CommandInput("name", CHAT_COMMAND_INPUT_TYPE.STRING)
			.set_required())
		.add_input(new CommandInput("value", CHAT_COMMAND_INPUT_TYPE.NUMBER, 0))
		.set_output(function(_input)
		{
			var _name = _input[0];
			var _value = _input[1];
			
			if (global.command_value[$ _name] != undefined)
			{
				chat_add("", $"\{cog\} Value '{_name}' alreayed exists");
			}
			
			if (array_length(struct_get_names(global.command_value)) >= 1024)
			{
				chat_add("", $"\{cog\} Max amount of values is 1024");
			}
			
			global.command_value[$ _name] = _value;
		
			chat_add("", $"\{cog\} Created value '{_name}' with a value of {_value}");
		}))
	.add_subcommand("destroy", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Destroy a value")
		.add_input(new CommandInput("name", CHAT_COMMAND_INPUT_TYPE.STRING)
			.set_required())
		.set_output(function(_input)
		{
			var _name = _input[0];
			
			if (global.command_value[$ _name] == undefined)
			{
				chat_add("", $"\{cog\} Value '{_name}' does not exist");
			}
			
			global.command_value[$ _name] = undefined;
		
			chat_add("", $"\{cog\} Destroyed value '{_name}'");
			
			// show_debug_message(json_stringify(global.command_value, true));
		}))
	.add_subcommand("set", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Set a value")
		.add_input(new CommandInput("name", CHAT_COMMAND_INPUT_TYPE.STRING)
			.set_required())
		.add_input(new CommandInput("value", CHAT_COMMAND_INPUT_TYPE.NUMBER, 0)
			.set_required())
		.set_output(function(_input)
		{
			var _name = _input[0];
			var _value = _input[1];
			
			if (global.command_value[$ _name] == undefined)
			{
				chat_add("", $"\{cog\} Value '{_name}' does not exist");
			}
			
			global.command_value[$ _name] = _value;
		
			chat_add("", $"\{cog\} Set value '{_name}' with a value of {_value}");
			
			// show_debug_message(json_stringify(global.command_value, true));
		}))
	.add_subcommand("add", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Add to a value")
		.add_input(new CommandInput("name", CHAT_COMMAND_INPUT_TYPE.STRING)
			.set_required())
		.add_input(new CommandInput("value", CHAT_COMMAND_INPUT_TYPE.NUMBER, 0)
			.set_required())
		.set_output(function(_input)
		{
			var _name = _input[0];
			var _value = _input[1];
			
			if (global.command_value[$ _name] == undefined)
			{
				chat_add("", $"\{cog\} Value '{_name}' does not exist");
			}
			
			global.command_value[$ _name] += _value;
		
			chat_add("", $"\{cog\} Added {_value} to value '{_name}' ({global.command_value[$ _name]})");
			
			// show_debug_message(json_stringify(global.command_value, true));
		}))
	.add_subcommand("subtract", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Subtracted to a value")
		.add_input(new CommandInput("name", CHAT_COMMAND_INPUT_TYPE.STRING)
			.set_required())
		.add_input(new CommandInput("value", CHAT_COMMAND_INPUT_TYPE.NUMBER, 0)
			.set_required())
		.set_output(function(_input)
		{
			var _name = _input[0];
			var _value = _input[1];
			
			if (global.command_value[$ _name] == undefined)
			{
				chat_add("", $"\{cog\} Value '{_name}' does not exist");
			}
			
			global.command_value[$ _name] -= _value;
		
			chat_add("", $"\{cog\} Subtracted {_value} to value '{_name}' ({global.command_value[$ _name]})");
			
			// show_debug_message(json_stringify(global.command_value, true));
		}))
	.add_subcommand("multiply", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Multiply to a value")
		.add_input(new CommandInput("name", CHAT_COMMAND_INPUT_TYPE.STRING)
			.set_required())
		.add_input(new CommandInput("value", CHAT_COMMAND_INPUT_TYPE.NUMBER, 0)
			.set_required())
		.set_output(function(_input)
		{
			var _name = _input[0];
			var _value = _input[1];
			
			if (global.command_value[$ _name] == undefined)
			{
				chat_add("", $"\{cog\} Value '{_name}' does not exist");
			}
			
			global.command_value[$ _name] *= _value;
		
			chat_add("", $"\{cog\} Multiplied {_value} to value '{_name}' ({global.command_value[$ _name]})");
			
			// show_debug_message(json_stringify(global.command_value, true));
		}))
	.add_subcommand("divide", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Divide to a value")
		.add_input(new CommandInput("name", CHAT_COMMAND_INPUT_TYPE.STRING)
			.set_required())
		.add_input(new CommandInput("value", CHAT_COMMAND_INPUT_TYPE.NUMBER, 0)
			.set_required())
		.set_output(function(_input)
		{
			var _name = _input[0];
			var _value = _input[1];
			
			if (global.command_value[$ _name] == undefined)
			{
				chat_add("", $"\{cog\} Value '{_name}' does not exist");
			}
			
			global.command_value[$ _name] /= _value;
		
			chat_add("", $"\{cog\} Divided {_value} to value '{_name}' ({global.command_value[$ _name]})");
			
			// show_debug_message(json_stringify(global.command_value, true));
		}))
	.add_subcommand("modulo", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
		.set_description("Modulo to a value")
		.add_input(new CommandInput("name", CHAT_COMMAND_INPUT_TYPE.STRING)
			.set_required())
		.add_input(new CommandInput("value", CHAT_COMMAND_INPUT_TYPE.NUMBER, 0)
			.set_required())
		.set_output(function(_input)
		{
			var _name = _input[0];
			var _value = _input[1];
			
			if (global.command_value[$ _name] == undefined)
			{
				chat_add("", $"\{cog\} Value '{_name}' does not exist");
			}
			
			global.command_value[$ _name] %= _value;
		
			chat_add("", $"\{cog\} Modulod {_value} to value '{_name}' ({global.command_value[$ _name]})");
			
			// show_debug_message(json_stringify(global.command_value, true));
		})));

add_command("if", new CommandData(CHAT_COMMAND_ARGUMENT_TYPE.INPUT)
	.set_description("If statement")
	.add_input(new CommandInput("name", CHAT_COMMAND_INPUT_TYPE.STRING)
		.set_required())
	.add_input(new CommandInput("operator", CHAT_COMMAND_INPUT_TYPE.STRING)
		.set_choices("=", "!=", ">", ">=", "<", "<=")
		.set_required())
	.add_input(new CommandInput("name", CHAT_COMMAND_INPUT_TYPE.STRING)
		.set_required())
	.set_output(function(_input)
	{
		var _value1 = _input[0];
		
		if (global.command_value[$ _value1] == undefined)
		{
			return chat_add("", $"\{cog\} Value '{_value1}' does not exist");
		}
		
		var _value2 = _input[2];
		
		if (global.command_value[$ _value2] == undefined)
		{
			return chat_add("", $"\{cog\} Value '{_value2}' does not exist");
		}
		
		var _command_value = global.command_value;
		
		switch (_input[1])
		{
		
		case "=":
			return chat_add("", $"\{cog\} {_command_value[$ _value1] == _command_value[$ _value2] ? "True" : "False"}");
		
		case "!=":
			return chat_add("", $"\{cog\} {_command_value[$ _value1] != _command_value[$ _value2] ? "True" : "False"}");
		
		case ">":
			return chat_add("", $"\{cog\} {_command_value[$ _value1] > _command_value[$ _value2] ? "True" : "False"}");
		
		case ">=":
			return chat_add("", $"\{cog\} {_command_value[$ _value1] >= _command_value[$ _value2] ? "True" : "False"}");
		
		case "<":
			return chat_add("", $"\{cog\} {_command_value[$ _value1] < _command_value[$ _value2] ? "True" : "False"}");
		
		case "<=":
			return chat_add("", $"\{cog\} {_command_value[$ _value1] <= _command_value[$ _value2] ? "True" : "False"}");
		
		}
	}));