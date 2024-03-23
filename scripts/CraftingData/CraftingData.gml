function CraftingData(_item, _amount, _index_offset = 0) constructor
{
	item_id = _item;
	amount = _amount;
	
	// crafting recipes length, item stations length, index offset
	value = 0;
	
	crafting_recipes = [];
	
	static add_recipe = function(_item_id, _amount, _give_back = ITEM.EMPTY)
	{
		array_push(crafting_recipes, (_amount << 32) | ((_give_back == ITEM.EMPTY ? 0xffff : _give_back) << 16) | _item_id);
		
		value = (array_length(crafting_recipes) << 16) | (value & 0xffff);
		
		global.item_data[@ _item_id].is_material = true;
		
		return self;
	}
	
	item_stations = [];
	
	static add_crafting_station = function(i)
	{
		array_push(item_stations, i);
		
		value = (array_length(item_stations) << 8) | (value & 0xff00ff);
		
		return self;
	}
	
	static set_index_offset = function(_index_offset)
	{
		value = (value & 0xffff00) | ((_index_offset < 0) << 7) | abs(_index_offset);
	}
}

global.crafting_data = [];

var _handle = call_later(1, time_source_units_frames, function()
{
	enum CRAFTING_ENUM {
		RECIPE_SAWMILL_WOOD = 4,
		RECIPE_SAWMILL_IRON = 2,
		RECIPE_ANVIL = 4,
		RECIPE_FURNACE = 4,
		RECIPE_WORKBENCH = 4,
		RECIPE_SWORD = 10,
		RECIPE_PICKAXE = 8,
		RECIPE_AXE = 7,
		RECIPE_SHOVEL = 6,
		RECIPE_HAMMER = 7,
		RECIPE_BOW = 9,
		RECIPE_FISHING_POLE = 6,
		RECIPE_CHEST_WOOD = 3,
		RECIPE_CHEST_IRON = 1,
		RECIPE_CHAIR = 3,
		RECIPE_TABLE = 5,
		RECIPE_DOOR = 6,
		
		AMOUNT_PLANKS = 3,
		AMOUNT_BLOCK_OF = 8,
	}
	
	array_push(global.crafting_data, new CraftingData(ITEM.ANVIL, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.STONE, CRAFTING_ENUM.RECIPE_ANVIL));
	
	array_push(global.crafting_data, new CraftingData(ITEM.FURNACE, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.STONE, CRAFTING_ENUM.RECIPE_FURNACE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.WORKBENCH, 1)
		.add_recipe(ITEM.MAHOGANY_WOOD, CRAFTING_ENUM.RECIPE_WORKBENCH));
	
	array_push(global.crafting_data, new CraftingData(ITEM.WORKBENCH, 1)
		.add_recipe(ITEM.OAK_WOOD, CRAFTING_ENUM.RECIPE_WORKBENCH));
	
	array_push(global.crafting_data, new CraftingData(ITEM.WORKBENCH, 1)
		.add_recipe(ITEM.YUCCA_WOOD, CRAFTING_ENUM.RECIPE_WORKBENCH));
	
	array_push(global.crafting_data, new CraftingData(ITEM.WORKBENCH, 1)
		.add_recipe(ITEM.PINE_WOOD, CRAFTING_ENUM.RECIPE_WORKBENCH));
	
	array_push(global.crafting_data, new CraftingData(ITEM.WORKBENCH, 1)
		.add_recipe(ITEM.MANGROVE_WOOD, CRAFTING_ENUM.RECIPE_WORKBENCH));
		
	array_push(global.crafting_data, new CraftingData(ITEM.SAWMILL, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.MAHOGANY_WOOD, CRAFTING_ENUM.RECIPE_SAWMILL_WOOD)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_SAWMILL_IRON));
		
	array_push(global.crafting_data, new CraftingData(ITEM.SAWMILL, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.OAK_WOOD, CRAFTING_ENUM.RECIPE_SAWMILL_WOOD)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_SAWMILL_IRON));
		
	array_push(global.crafting_data, new CraftingData(ITEM.SAWMILL, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.YUCCA_WOOD, CRAFTING_ENUM.RECIPE_SAWMILL_WOOD)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_SAWMILL_IRON));
		
	array_push(global.crafting_data, new CraftingData(ITEM.SAWMILL, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.PINE_WOOD, CRAFTING_ENUM.RECIPE_SAWMILL_WOOD)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_SAWMILL_IRON));
		
	array_push(global.crafting_data, new CraftingData(ITEM.SAWMILL, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.MANGROVE_WOOD, CRAFTING_ENUM.RECIPE_SAWMILL_WOOD)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_SAWMILL_IRON));
	
	array_push(global.crafting_data, new CraftingData(ITEM.STOVE, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.MUD_BRICKS, 4)
		.add_recipe(ITEM.STONE, 2));
		
	array_push(global.crafting_data, new CraftingData(ITEM.STONECUTTER, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.STONE, 2)
		.add_recipe(ITEM.IRON, 3));
	
	array_push(global.crafting_data, new CraftingData(ITEM.BLOCK_OF_COAL, 1)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.COAL, CRAFTING_ENUM.AMOUNT_BLOCK_OF));
	
	array_push(global.crafting_data, new CraftingData(ITEM.COAL, CRAFTING_ENUM.AMOUNT_BLOCK_OF)
		.add_recipe(ITEM.BLOCK_OF_COAL, 1));
		
	array_push(global.crafting_data, new CraftingData(ITEM.COAL, 3)
		.add_crafting_station(ITEM.FURNACE)
		.add_recipe(ITEM.MAHOGANY_WOOD, 1));
		
	array_push(global.crafting_data, new CraftingData(ITEM.COAL, 3)
		.add_crafting_station(ITEM.FURNACE)
		.add_recipe(ITEM.OAK_WOOD, 1));
		
	array_push(global.crafting_data, new CraftingData(ITEM.COAL, 3)
		.add_crafting_station(ITEM.FURNACE)
		.add_recipe(ITEM.YUCCA_WOOD, 1));
		
	array_push(global.crafting_data, new CraftingData(ITEM.COAL, 3)
		.add_crafting_station(ITEM.FURNACE)
		.add_recipe(ITEM.PINE_WOOD, 1));
		
	array_push(global.crafting_data, new CraftingData(ITEM.COAL, 3)
		.add_crafting_station(ITEM.FURNACE)
		.add_recipe(ITEM.MANGROVE_WOOD, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PLATINUM_SWORD, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.PLATINUM, CRAFTING_ENUM.RECIPE_SWORD));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PLATINUM_PICKAXE, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.PLATINUM, CRAFTING_ENUM.RECIPE_PICKAXE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PLATINUM_AXE, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.PLATINUM, CRAFTING_ENUM.RECIPE_AXE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PLATINUM_SHOVEL, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.PLATINUM, CRAFTING_ENUM.RECIPE_SHOVEL));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PLATINUM_HAMMER, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.PLATINUM, CRAFTING_ENUM.RECIPE_HAMMER));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PLATINUM_BOW, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.PLATINUM, CRAFTING_ENUM.RECIPE_BOW));
	/*
	array_push(global.crafting_data, new CraftingData(ITEM.PLATINUM_FISHING_POLE, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.PLATINUM, CRAFTING_ENUM.RECIPE_FISHING_POLE));
	*/
	array_push(global.crafting_data, new CraftingData(ITEM.BLOCK_OF_PLATINUM, 1)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.PLATINUM, CRAFTING_ENUM.AMOUNT_BLOCK_OF));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PLATINUM, CRAFTING_ENUM.AMOUNT_BLOCK_OF)
		.add_recipe(ITEM.BLOCK_OF_PLATINUM, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PLATINUM, 1)
		.add_crafting_station(ITEM.FURNACE)
		.add_recipe(ITEM.RAW_PLATINUM, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.GOLDEN_SWORD, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.GOLD, CRAFTING_ENUM.RECIPE_SWORD));
	
	array_push(global.crafting_data, new CraftingData(ITEM.GOLDEN_PICKAXE, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.GOLD, CRAFTING_ENUM.RECIPE_PICKAXE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.GOLDEN_AXE, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.GOLD, CRAFTING_ENUM.RECIPE_AXE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.GOLDEN_SHOVEL, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.GOLD, CRAFTING_ENUM.RECIPE_SHOVEL));
	
	array_push(global.crafting_data, new CraftingData(ITEM.GOLDEN_HAMMER, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.GOLD, CRAFTING_ENUM.RECIPE_HAMMER));
	
	array_push(global.crafting_data, new CraftingData(ITEM.GOLDEN_BOW, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.GOLD, CRAFTING_ENUM.RECIPE_BOW));
	/*
	array_push(global.crafting_data, new CraftingData(ITEM.GOLDEN_FISHING_POLE, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.GOLD, CRAFTING_ENUM.RECIPE_FISHING_POLE));
	*/
	array_push(global.crafting_data, new CraftingData(ITEM.BLOCK_OF_GOLD, 1)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.GOLD, CRAFTING_ENUM.AMOUNT_BLOCK_OF));
	
	array_push(global.crafting_data, new CraftingData(ITEM.GOLD, CRAFTING_ENUM.AMOUNT_BLOCK_OF)
		.add_recipe(ITEM.BLOCK_OF_GOLD, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.GOLD, 1)
		.add_crafting_station(ITEM.FURNACE)
		.add_recipe(ITEM.RAW_GOLD, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.IRON_SWORD, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_SWORD));
	
	array_push(global.crafting_data, new CraftingData(ITEM.IRON_PICKAXE, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_PICKAXE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.IRON_AXE, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_AXE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.IRON_SHOVEL, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_SHOVEL));
	
	array_push(global.crafting_data, new CraftingData(ITEM.IRON_HAMMER, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_HAMMER));
	
	array_push(global.crafting_data, new CraftingData(ITEM.IRON_BOW, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_BOW));
	/*
	array_push(global.crafting_data, new CraftingData(ITEM.IRON_FISHING_POLE, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_FISHING_POLE));
	*/
	array_push(global.crafting_data, new CraftingData(ITEM.BLOCK_OF_IRON, 1)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.AMOUNT_BLOCK_OF));
	
	array_push(global.crafting_data, new CraftingData(ITEM.IRON, CRAFTING_ENUM.AMOUNT_BLOCK_OF)
		.add_recipe(ITEM.BLOCK_OF_IRON, 1));
		
	array_push(global.crafting_data, new CraftingData(ITEM.IRON, 1)
		.add_crafting_station(ITEM.FURNACE)
		.add_recipe(ITEM.RAW_IRON, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.COPPER_SWORD, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.COPPER, CRAFTING_ENUM.RECIPE_SWORD));
	
	array_push(global.crafting_data, new CraftingData(ITEM.COPPER_PICKAXE, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.COPPER, CRAFTING_ENUM.RECIPE_PICKAXE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.COPPER_AXE, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.COPPER, CRAFTING_ENUM.RECIPE_AXE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.COPPER_SHOVEL, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.COPPER, CRAFTING_ENUM.RECIPE_SHOVEL));
	
	array_push(global.crafting_data, new CraftingData(ITEM.COPPER_HAMMER, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.COPPER, CRAFTING_ENUM.RECIPE_HAMMER));
	
	array_push(global.crafting_data, new CraftingData(ITEM.COPPER_BOW, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.COPPER, CRAFTING_ENUM.RECIPE_BOW));
	/*
	array_push(global.crafting_data, new CraftingData(ITEM.COPPER_FISHING_POLE, 1)
		.add_crafting_station(ITEM.ANVIL)
		.add_recipe(ITEM.COPPER, CRAFTING_ENUM.RECIPE_FISHING_POLE));
	*/
	array_push(global.crafting_data, new CraftingData(ITEM.WEATHERED_BLOCK_OF_COPPER, 1)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.WEATHERED_COPPER, CRAFTING_ENUM.AMOUNT_BLOCK_OF));
	
	array_push(global.crafting_data, new CraftingData(ITEM.WEATHERED_BLOCK_OF_COPPER, 1)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.WEATHERED_COPPER, CRAFTING_ENUM.AMOUNT_BLOCK_OF));
	
	array_push(global.crafting_data, new CraftingData(ITEM.TARNISHED_BLOCK_OF_COPPER, 1)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.TARNISHED_COPPER, CRAFTING_ENUM.AMOUNT_BLOCK_OF));
	
	array_push(global.crafting_data, new CraftingData(ITEM.TARNISHED_COPPER, CRAFTING_ENUM.AMOUNT_BLOCK_OF)
		.add_recipe(ITEM.TARNISHED_BLOCK_OF_COPPER, 1));
		
	array_push(global.crafting_data, new CraftingData(ITEM.COPPER, 1)
		.add_crafting_station(ITEM.FURNACE)
		.add_recipe(ITEM.RAW_COPPER, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.COPPER, 1)
		.add_crafting_station(ITEM.FURNACE)
		.add_recipe(ITEM.RAW_WEATHERED_COPPER, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.COPPER, 1)
		.add_crafting_station(ITEM.FURNACE)
		.add_recipe(ITEM.RAW_TARNISHED_COPPER, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.COOKED_CHICKEN, 1)
		.add_crafting_station(ITEM.STOVE)
		.add_recipe(ITEM.RAW_CHICKEN, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MAHOGANY_PICKAXE, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.MAHOGANY_WOOD, CRAFTING_ENUM.RECIPE_PICKAXE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MAHOGANY_SHOVEL, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.MAHOGANY_WOOD, CRAFTING_ENUM.RECIPE_SHOVEL));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MAHOGANY_PLANKS, CRAFTING_ENUM.AMOUNT_PLANKS)
		.add_recipe(ITEM.MAHOGANY_WOOD, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MAHOGANY_PLANKS_WALL, 2)
		.add_recipe(ITEM.MAHOGANY_PLANKS, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MAHOGANY_CHEST, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.MAHOGANY_WOOD, CRAFTING_ENUM.RECIPE_CHEST_WOOD)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_CHEST_IRON));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MAHOGANY_CHAIR, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.MAHOGANY_WOOD, CRAFTING_ENUM.RECIPE_CHAIR));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MAHOGANY_TABLE, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.MAHOGANY_WOOD, CRAFTING_ENUM.RECIPE_TABLE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MAHOGANY_DOOR, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.MAHOGANY_WOOD, CRAFTING_ENUM.RECIPE_DOOR));
	
	array_push(global.crafting_data, new CraftingData(ITEM.YUCCA_PICKAXE, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.YUCCA_WOOD, CRAFTING_ENUM.RECIPE_PICKAXE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.YUCCA_SHOVEL, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.YUCCA_WOOD, CRAFTING_ENUM.RECIPE_SHOVEL));
	
	array_push(global.crafting_data, new CraftingData(ITEM.YUCCA_PLANKS, CRAFTING_ENUM.AMOUNT_PLANKS)
		.add_recipe(ITEM.YUCCA_WOOD, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.YUCCA_PLANKS_WALL, 2)
		.add_recipe(ITEM.YUCCA_PLANKS, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.YUCCA_CHEST, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.YUCCA_WOOD, CRAFTING_ENUM.RECIPE_CHEST_WOOD)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_CHEST_IRON));
	
	array_push(global.crafting_data, new CraftingData(ITEM.YUCCA_CHAIR, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.YUCCA_WOOD, CRAFTING_ENUM.RECIPE_CHAIR));
	
	array_push(global.crafting_data, new CraftingData(ITEM.YUCCA_TABLE, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.YUCCA_WOOD, CRAFTING_ENUM.RECIPE_TABLE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.YUCCA_DOOR, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.YUCCA_WOOD, CRAFTING_ENUM.RECIPE_DOOR));
	
	array_push(global.crafting_data, new CraftingData(ITEM.OAK_PICKAXE, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.OAK_WOOD, CRAFTING_ENUM.RECIPE_PICKAXE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.OAK_SHOVEL, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.OAK_WOOD, CRAFTING_ENUM.RECIPE_SHOVEL));
	
	array_push(global.crafting_data, new CraftingData(ITEM.OAK_PLANKS, CRAFTING_ENUM.AMOUNT_PLANKS)
		.add_recipe(ITEM.OAK_WOOD, 1));
		
	array_push(global.crafting_data, new CraftingData(ITEM.OAK_PLANKS_WALL, 2)
		.add_recipe(ITEM.OAK_PLANKS, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.OAK_CHEST, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.OAK_WOOD, CRAFTING_ENUM.RECIPE_CHEST_WOOD)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_CHEST_IRON));
	
	array_push(global.crafting_data, new CraftingData(ITEM.OAK_CHAIR, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.OAK_WOOD, CRAFTING_ENUM.RECIPE_CHAIR));
	
	array_push(global.crafting_data, new CraftingData(ITEM.OAK_TABLE, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.OAK_WOOD, CRAFTING_ENUM.RECIPE_TABLE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.OAK_DOOR, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.OAK_WOOD, CRAFTING_ENUM.RECIPE_DOOR));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PINE_PICKAXE, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.PINE_WOOD, CRAFTING_ENUM.RECIPE_PICKAXE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PINE_SHOVEL, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.PINE_WOOD, CRAFTING_ENUM.RECIPE_SHOVEL));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PINE_PLANKS, CRAFTING_ENUM.AMOUNT_PLANKS)
		.add_recipe(ITEM.PINE_WOOD, 1));
		
	array_push(global.crafting_data, new CraftingData(ITEM.PINE_PLANKS_WALL, 2)
		.add_recipe(ITEM.PINE_PLANKS, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PINE_CHEST, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.PINE_WOOD, CRAFTING_ENUM.RECIPE_CHEST_WOOD)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_CHEST_IRON));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PINE_CHAIR, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.PINE_WOOD, CRAFTING_ENUM.RECIPE_CHAIR));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PINE_TABLE, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.PINE_WOOD, CRAFTING_ENUM.RECIPE_TABLE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.PINE_DOOR, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.PINE_WOOD, CRAFTING_ENUM.RECIPE_DOOR));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MANGROVE_PICKAXE, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.MANGROVE_WOOD, CRAFTING_ENUM.RECIPE_PICKAXE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MANGROVE_SHOVEL, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.MANGROVE_WOOD, CRAFTING_ENUM.RECIPE_SHOVEL));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MANGROVE_PLANKS, CRAFTING_ENUM.AMOUNT_PLANKS)
		.add_recipe(ITEM.MANGROVE_WOOD, 1));
		
	array_push(global.crafting_data, new CraftingData(ITEM.MANGROVE_PLANKS_WALL, 2)
		.add_recipe(ITEM.MAHOGANY_PLANKS, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MANGROVE_CHEST, 1)
		.add_crafting_station(ITEM.WORKBENCH)
		.add_recipe(ITEM.MANGROVE_WOOD, CRAFTING_ENUM.RECIPE_CHEST_WOOD)
		.add_recipe(ITEM.IRON, CRAFTING_ENUM.RECIPE_CHEST_IRON));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MANGROVE_CHAIR, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.MANGROVE_WOOD, CRAFTING_ENUM.RECIPE_CHAIR));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MANGROVE_TABLE, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.MANGROVE_WOOD, CRAFTING_ENUM.RECIPE_TABLE));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MANGROVE_DOOR, 1)
		.add_crafting_station(ITEM.SAWMILL)
		.add_recipe(ITEM.MANGROVE_WOOD, CRAFTING_ENUM.RECIPE_DOOR));
	
	array_push(global.crafting_data, new CraftingData(ITEM.STONE_BRICKS, 2)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.STONE, 2));
	
	array_push(global.crafting_data, new CraftingData(ITEM.POLISHED_STONE, 1)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.STONE, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.STONE_BRICKS_WALL, 2)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.STONE_BRICKS, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.STONE_WALL, 2)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.STONE, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.EMUSTONE_BRICKS, 2)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.EMUSTONE, 2));
	
	array_push(global.crafting_data, new CraftingData(ITEM.POLISHED_EMUSTONE, 1)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.EMUSTONE, 1));
		
	array_push(global.crafting_data, new CraftingData(ITEM.EMUSTONE_WALL, 2)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.EMUSTONE, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.EMUSTONE_BRICKS_WALL, 2)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.EMUSTONE_BRICKS, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.DRIED_MUD, 1)
		.add_crafting_station(ITEM.FURNACE)
		.add_recipe(ITEM.DIRT, 4));
	
	array_push(global.crafting_data, new CraftingData(ITEM.DRIED_MUD, 1)
		.add_crafting_station(ITEM.FURNACE)
		.add_recipe(ITEM.MUD, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MUD_BRICKS, 2)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.DRIED_MUD, 2));
	
	array_push(global.crafting_data, new CraftingData(ITEM.MUD_BRICKS_WALL, 2)
		.add_crafting_station(ITEM.STONECUTTER)
		.add_recipe(ITEM.MUD_BRICKS, 1));
	
	array_push(global.crafting_data, new CraftingData(ITEM.HATCHET, 1)
		.add_recipe(ITEM.TWIG, 2)
		.add_recipe(ITEM.ROCKS, 2));
	
	#region Collect Crafting Stations

	global.item_stations = [];

	var i = 0;
	var j;

	var _data;
	var _crafting_data = global.crafting_data;
	var _crafting_data_length = array_length(_crafting_data);

	var _station;
	var _stations;
	var _stations_length;

	repeat (_crafting_data_length)
	{
		_data = _crafting_data[i++];
	
		_stations = _data.item_stations;
		_stations_length = (_data.value >> 8) & 0xff;
	
		j = 0;
	
		repeat (_stations_length)
		{
			_station = _stations[j++];
		
			if (!array_contains(global.item_stations, _station))
			{
				array_push(global.item_stations, _station);
			}
		}
	}

	#endregion
});