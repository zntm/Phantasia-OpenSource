function BiomeDataCave(_name) : BiomeData(_name) constructor
{
	tile = 0xffffffff;
	
	static set_tiles = function(_solid = ITEM.EMPTY, _wall = ITEM.EMPTY)
	{
		tile = (_solid == ITEM.EMPTY ? 0xffff0000 : (_solid << 16)) | (_wall == ITEM.EMPTY ? 0xffff : _wall);
		
		return self;
	}
	
	foliage = -1;
	
	static set_foliage = function(_foliage)
	{
		foliage = _foliage;
		
		return self;
	}
	
	// Used for air
	cave_foliage = -1;
	
	static set_cave_foliage = function(_foliage)
	{
		cave_foliage = _foliage;
		
		return self;
	}
	
	sky_colour = new BiomeSkyColour();
	
	static set_sky_colour = function(_colour)
	{
		sky_colour = _colour;
	
		return self;
	}
}

global.cave_biome_data = [];

function add_biome_cave(_data)
{
	array_push(global.cave_biome_data, _data);
}

add_biome_cave(new BiomeDataCave("Stone")
	.set_music(mus_Somewhere_Deep)
	.set_passive_creatures([
		ITEM.STONE,
		ITEM.EMUSTONE,
		ITEM.GRANITE,
	], [
		CREATURE.SNAIL,
		CREATURE.ZOMBIE,
		CREATURE.SKELETON,
		CREATURE.BAT,
		CREATURE.SLIME
	])
	.set_foliage(function(_x, _y, _z, _seed)
	{
		if (tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY) exit;
		
		if (chance(0.12))
		{
			tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(ITEM.ROCKS));
			
			exit;
		}
		
		if (chance(0.08))
		{
			tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(ITEM.TWIG));
			
			exit;
		}
		
		if (chance(0.01))
		{
			tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(choose(ITEM.RED_MUSHROOM, ITEM.BLUE_MUSHROOM, ITEM.BROWN_MUSHROOM)));
			
			exit;
		}
		
		if (_x % 11 == 0) && (_y % 7 == 0) && (chance(0.01)) && (tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
		{
			tile_place(_x, _y - 1, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.OAK_CHEST)
				.set_loot("stone_chest"));
		}
	}));

add_biome_cave(new BiomeDataCave("Emustone")
	.set_music(mus_Of_Past_And_Future)
	.set_passive_creatures([
		ITEM.STONE,
		ITEM.EMUSTONE,
		ITEM.GRANITE,
	], [
		CREATURE.SNAIL,
		CREATURE.GHOST,
		CREATURE.ZOMBIE,
		CREATURE.MINER_ZOMBIE,
		CREATURE.SKELETON,
		CREATURE.BAT,
		CREATURE.RAT,
		CREATURE.BEETLE
	])
	.set_foliage(function(_x, _y, _z, _seed)
	{
		if (tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY) exit;
		
		if (chance(0.001))
		{
			// structure_underground_campsite(_x, _y, _seed);
			
			exit;
		}
		
		if (chance(0.004))
		{
			// structure_ore_rubble(_x, _y, _seed);
			
			exit;
		}
		
		if (chance(0.12))
		{
			tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(ITEM.ROCKS));
			
			exit;
		}
		
		if (chance(0.08))
		{
			tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(ITEM.TWIG));
			
			exit;
		}
		
		if (chance(0.01))
		{
			tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(choose(ITEM.RED_MUSHROOM, ITEM.BLUE_MUSHROOM, ITEM.BROWN_MUSHROOM)));
			
			exit;
		}
		
		if (_x % 11 == 0) && (_y % 7 == 0) && (chance(0.02)) && (tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
		{
			tile_place(_x, _y - 1, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.PINE_CHEST)
				.set_loot("emustone_chest"));
		}
	}));

add_biome_cave(new BiomeDataCave("Lumin")
	.set_music(mus_Bioluminescence)
	.set_tiles(ITEM.LUMIN_MOSS, ITEM.LUMIN_MOSS_WALL)
	.set_passive_creatures([
		ITEM.LUMIN_MOSS,
		ITEM.LUMIN_STONE,
	], [
	])
	.set_hostile_creatures(BOSS.LUMINOSO, [
		ITEM.LUMIN_MOSS,
		ITEM.LUMIN_STONE,
	], [
		CREATURE.LUMIN_GOLEM,
		CREATURE.BEETLITE,
		CREATURE.LUMIN_BAT,
	])
	.set_foliage(function(_x, _y, _z, _seed)
	{
		if (perlin_noise(_x + 2048, _y + 2048, 8, 16, _seed) <= 4)
		{
			if (chance(0.01))
			{
				tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.LUMIN_BULB));
			}
			else if (irandom(5) > 0) && (tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
			{
				tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(choose_weighted(
					ITEM.SHORT_LUMIN_GROWTH, 7,
					ITEM.TALL_LUMIN_GROWTH, 3,
					ITEM.LUMIN_LOTUS, 2,
					ITEM.LUMIN_SHROOM, 4
				))
					.set_xoffset(irandom_range(-2, 2)));
			}
			
			exit;
		}
		
		if (tile_get(_x, _y, CHUNK_DEPTH_DEFAULT) == ITEM.LUMIN_MOSS)
		{
			tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.LUMIN_STONE));
		}
		else if (irandom(299) == 0)
		{
			tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.LUMIN_ORE));
		}
		else if (chance(0.05))
		{
			var _a;
			var _b = _y + 1;
			
			var i = irandom_range(-1, 3);
				
			repeat (irandom_range(2, 7))
			{
				_a = _x + i;
				
				if (tile_get(_a, _y, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY) && (tile_get(_x + i, _b, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
				{
					// structure_lumin_lens(_a, _b, _seed);
				}
					
				++i;
			}
		}
		else if (irandom(99) == 0) && (tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY) && (tile_get(_x - 1, _y, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY) && (tile_get(_x + 1, _y, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY)
		{
			// __ph_structure_shrine(_x, _y, ITEM.LUMINOSO_SHRINE);
		}
		else if (chance(0.1)) && (tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
		{
			tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(ITEM.LUMIN_ROCK));
		}
	}));

add_biome_cave(new BiomeDataCave("Verdant")
	.set_music(mus_Lichen)
	.set_tiles(, ITEM.MOSS_WALL)
	.set_foliage(function(_x, _y, _z, _seed) {
		if (tile_get(_x, _y, CHUNK_DEPTH_DEFAULT) != ITEM.MOSS) exit;
		
		var _plant_z = CHUNK_DEPTH_PLANT;
		
		if (irandom(7) > 0) && (tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
		{	
			tile_place(_x, _y - 1, _z, new Tile(choose_weighted(
				ITEM.SHORT_GREENIAN_GRASS, 11,
				ITEM.ROSE, 5,
				ITEM.HIGH_SOCIETY, 6,
				ITEM.DEAD_BUSH, 1
			)));
		}
	}));

add_biome_cave(new BiomeDataCave("Obitus")
	.set_music(mus_Heartbeat)
	.set_tiles(ITEM.DEADSTONE, ITEM.DEADSTONE_WALL)
	.set_hostile_creatures(BOSS.LUMINOSO, [
		ITEM.STONE,
		ITEM.EMUSTONE,
		ITEM.DEADSTONE
	], [
		CREATURE.GHOST,
		CREATURE.WRAITH
	])
	.set_foliage(function(_x, _y, _z, _seed) {
		var _noise = perlin_noise(_x + 4096, _y + 1024, 12, 16, _seed);
	
		if (_noise <= 5) || (_noise > 9) exit;
		
		if (tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY)
		{
			tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.DEAD_DIRT));
			
			exit;
		}
		
		tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.DEAD_GRASS_BLOCK));
			
		if (irandom(8) > 0)
		{
			tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(irandom(19) == 0 ? ITEM.DEAD_SUNFLOWER : choose_weighted(
				ITEM.SHORT_DEAD_GRASS, 4,
				ITEM.TALL_DEAD_GRASS, 1,
				ITEM.DEADFLOWER, 1,
				ITEM.DEAD_ROSE, 1,
				ITEM.ROCKS, 1,
				ITEM.BONE, 3,
				ITEM.SKULL, 1
			)));
		}
	}));

add_biome_cave(new BiomeDataCave("Araneae")
	.set_music(mus_Tincture_of_Ink)
	.set_tiles(ITEM.APHIDE, ITEM.APHIDE_WALL)
	.set_hostile_creatures(BOSS.LUMINOSO, [
		ITEM.APHIDE
	], [
		CREATURE.SPIDER
	])
	.set_foliage(function(_x, _y, _z, _seed) {
		var _noise = perlin_noise(_x + 4096, _y + 2048, 32, 32, _seed);
	
		if (_noise > 17) && (_noise < 26)
		{
			tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.HARDENED_APHIDE));
		}
		
		if (irandom(4) == 0) && (tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY) && (tile_get(_x, _y, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY)
		{
			if (irandom(6) == 0) && (tile_get(_x - 1, _y, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY) && (tile_get(_x + 1, _y, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY)
			{
				tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(ITEM.LARGE_COCOON));
			}
			else
			{
				tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(ITEM.COCOON));
			}
			
			exit;
		}
	})
	.set_cave_foliage(function(_x, _y, _z, _seed) {
		var _noise = perlin_noise(_x, _y, 32, 32, _seed);
	
		if (_noise > 15) && (_noise < 17)
		{
			tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.COBWEB));
		}
	}));

add_biome_cave(new BiomeDataCave("Chrystal")
	.set_music(mus_Shimmering)
	.set_foliage(function(_x, _y, _z, _seed) {
		if (irandom(3) == 0) && (tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
		{
			tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(ITEM.PINK_AMETHYST_CLUSTER));
		}
	}));