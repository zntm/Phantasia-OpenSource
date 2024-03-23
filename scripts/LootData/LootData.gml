function LootData() constructor
{
	loots = [];
	loots_length = 0;
	
	static add_loot = function(_item_id, _min_amount, _max_amount, _probability, _slot_amount = 0xffff)
	{
		loots[@ loots_length++] =  (_item_id << 40) | (_min_amount << 32) | (_max_amount << 24) | (round(_probability * 100) << 16) | _slot_amount;
		
		static __loot_sort = function(_e1, _e2)
		{
			return ((_e1 >> 16) & 0xff) - ((_e2 >> 16) & 0xff);
		};
		
		array_sort(loots, __loot_sort);
		
		loots = array_reverse(loots);
		
		return self;
	}
}

global.loot_data = {};

global.loot_data.campsite = new LootData()
	.add_loot(ITEM.TWIG, 1, 4, 0.13, 2)
	.add_loot(ITEM.ROCKS, 1, 2, 0.14, 3)
	.add_loot(ITEM.BOTTLE, 1, 2, 0.06)
	.add_loot(ITEM.OAK_WOOD, 1, 3, 0.11)
	.add_loot(ITEM.TORCH, 1, 8, 0.09)
	.add_loot(ITEM.ROPE, 2, 4, 0.07)
	.add_loot(ITEM.WOODEN_CANE, 1, 1, 0.03)
	.add_loot(ITEM.THORNED_PENDANT, 1, 1, 0.04)
	.add_loot(ITEM.MINING_HELMET, 1, 1, 0.02);

global.loot_data.campsite2 = new LootData()
	.add_loot(ITEM.TWIG, 1, 4, 0.13, 2)
	.add_loot(ITEM.ROCKS, 1, 2, 0.14, 3)
	.add_loot(ITEM.POTATO_SEEDS, 1, 3, 0.06)
	.add_loot(ITEM.CARROT_SEEDS, 1, 3, 0.11)
	.add_loot(ITEM.TORCH, 1, 8, 0.09)
	.add_loot(ITEM.ROPE, 2, 4, 0.07)
	.add_loot(ITEM.SHEEP_RAM, 1, 1, 0.03)
	.add_loot(ITEM.LUCKY_CLOVER, 1, 1, 0.04);

global.loot_data.underground_campsite = new LootData()
	.add_loot(ITEM.TWIG, 1, 4, 0.05)
	.add_loot(ITEM.ROCKS, 1, 2, 0.11)
	.add_loot(ITEM.OAK_WOOD, 1, 5, 0.13)
	.add_loot(ITEM.TORCH, 2, 6, 0.07)
	.add_loot(ITEM.ROPE, 3, 5, 0.07)
	.add_loot(ITEM.RAW_TARNISHED_COPPER, 3, 5, 0.04)
	.add_loot(ITEM.BUBBLE_WAND, 1, 1, 0.01)
	.add_loot(ITEM.MINING_HELMET, 1, 1, 0.03)
	.add_loot(ITEM.MAGNET, 1, 1, 0.04);

global.loot_data.ruined_small_hut = new LootData()
	.add_loot(ITEM.TWIG, 1, 4, 0.05)
	.add_loot(ITEM.ROCKS, 1, 2, 0.09)
	.add_loot(ITEM.OAK_WOOD, 1, 5, 0.13)
	.add_loot(ITEM.TORCH, 2, 6, 0.04)
	.add_loot(ITEM.ROPE, 3, 5, 0.07)
	.add_loot(ITEM.RAW_TARNISHED_COPPER, 3, 5, 0.04)
	.add_loot(ITEM.TARNISHED_COPPER_PICKAXE, 1, 1, 0.01)
	.add_loot(ITEM.TARNISHED_COPPER_AXE, 1, 1, 0.01)
	.add_loot(ITEM.MAGNET, 1, 1, 0.04, 1);

global.loot_data.ruined_small_hut2 = new LootData()
	.add_loot(ITEM.ROCKS, 1, 2, 0.08)
	.add_loot(ITEM.SAND, 1, 5, 0.13)
	.add_loot(ITEM.TORCH, 2, 6, 0.04)
	.add_loot(ITEM.MUD, 3, 5, 0.04)
	.add_loot(ITEM.HATCHET, 1, 1, 0.01);

global.loot_data.ruined_small_hut3 = new LootData()
	.add_loot(ITEM.TWIG, 1, 4, 0.05)
	.add_loot(ITEM.BIRCH_WOOD, 1, 5, 0.12)
	.add_loot(ITEM.TORCH, 2, 6, 0.04)
	.add_loot(ITEM.ROPE, 3, 5, 0.07)
	.add_loot(ITEM.COAL, 2, 4, 0.03)
	.add_loot(ITEM.TARNISHED_COPPER_PICKAXE, 1, 1, 0.01);

global.loot_data.stone_chest = new LootData()
	.add_loot(ITEM.OAK_WOOD, 2, 6, 0.11)
	.add_loot(ITEM.TORCH, 2, 5, 0.06)
	.add_loot(ITEM.TARNISHED_COPPER_PICKAXE, 1, 1, 0.02);

global.loot_data.emustone_chest = new LootData()
	.add_loot(ITEM.OAK_WOOD, 1, 5, 0.13)
	.add_loot(ITEM.TORCH, 3, 8, 0.05)
	.add_loot(ITEM.HEARTHSTONE_CLEAVER, 1, 1, 0.01)
	.add_loot(ITEM.GOLDEN_PICKAXE, 1, 1, 0.05);