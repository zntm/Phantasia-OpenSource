function BiomeSkyColour() constructor
{
	solid = [ c_black, c_black, c_black, c_black ];
	
	gradient = [ c_black, c_black, c_black, c_black ];
	
	static set_solid = function(_dawn, _day, _dusk, _night)
	{
		solid = [ _dawn, _day, _dusk, _night ];
		
		return self;
	}
	
	static set_gradient = function(_dawn, _day, _dusk, _night)
	{
		gradient = [ _dawn, _day, _dusk, _night ];
		
		return self;
	}
}

function BiomeSurfaceTiles() constructor
{
	crust_top = 0x80008000;
	crust_bottom = 0x80008000;
	stone = 0x80008000;
	
	static set_crust = function(_solid, _wall)
	{
		crust_top = (_solid == ITEM.EMPTY ? 0x80000000 : (_solid << 16)) | (_wall == ITEM.EMPTY ? 0x8000 : _wall);
		crust_bottom = (_solid == ITEM.EMPTY ? 0x80000000 : (_solid << 16)) | (_wall == ITEM.EMPTY ? 0x8000 : _wall);
		
		return self;
	}
	
	static set_crust_top = function(_solid, _wall)
	{
		crust_top = (_solid == ITEM.EMPTY ? 0x80000000 : (_solid << 16)) | (_wall == ITEM.EMPTY ? 0x8000 : _wall);
		
		return self;
	}
	
	static set_crust_bottom = function(_solid, _wall)
	{
		crust_bottom = (_solid == ITEM.EMPTY ? 0x80000000 : (_solid << 16)) | (_wall == ITEM.EMPTY ? 0x8000 : _wall);
		
		return self;
	}
	
	static set_stone = function(_solid, _wall)
	{
		stone = (_solid == ITEM.EMPTY ? 0x80000000 : (_solid << 16)) | (_wall == ITEM.EMPTY ? 0x8000 : _wall);
		
		return self;
	}
}

function BiomeDataSurface(_name, _type = BIOME_TYPE.SURFACE) : BiomeData(_name) constructor
{
	type = _type;
	
	tiles = noone;
	
	static set_tiles = function(_tiles)
	{
		tiles = _tiles;
		
		return self;
	}
	
	foliage = -1;
	
	static set_foliage = function(_foliage)
	{
		foliage = _foliage;
		
		return self;
	}
	
	natural = -1;
	
	static set_natural = function(_natural)
	{
		natural = _natural;
		
		return self;
	}
	
	sky_colour = new BiomeSkyColour();
	
	static set_sky_colour = function(_colour)
	{
		sky_colour = _colour;
	
		return self;
	}
	
	map_colour = #33B826;
	
	static set_map_colour = function(_colour)
	{
		map_colour = _colour;
	
		return self;
	}
	
	fishing_loot = -1;
	
	static add_fishing_loot = function(_item, _loot)
	{
		if (fishing_loot == -1)
		{
			fishing_loot = {};
		}
		
		fishing_loot[$ string(_item)] = _loot;
		
		return self;
	}
	
	structure_surface = [];
	structure_underground = [];
	
	static set_structure = function()
	{
		var _structure_data = global.structure_data;
		var _structure;
		
		var _data;
		var _type;
		
		var i = 0;
		
		repeat (argument_count)
		{
			_structure = argument[i++];
			_type = _structure_data[$ _structure];
			
			if (_type == undefined) continue;
			
			_type = _type.type;
		
			if (_type == STRUCTURE_TYPE.SURFACE)
			{
				array_push(structure_surface, _structure);
			}
			else if (_type == STRUCTURE_TYPE.UNDERGROUND)
			{
				array_push(structure_underground, _structure);
			}
			else
			{
				throw $"{_structure} is not a valid structure";
			}
		}
		
		return self;
	}
}

global.surface_biome_data = [];

var _handle = call_later(2, time_source_units_frames, function()
{
	array_push(global.surface_biome_data, new BiomeDataSurface("Greenia")
		.set_rpc_icon("surface_greenia")
		.set_map_colour(#ff0000)
		.set_sky_colour(new BiomeSkyColour()
			.set_solid(#180738, #5F91FE, #C4502D, #000019)
			.set_gradient(#2A1504, #244FE9, #DA651C, #020008)
		)
		.set_music(mus_Another_Day, mus_The_Other_Day)
		.set_tiles(new BiomeSurfaceTiles()
			.set_crust_top(ITEM.GREENIAN_GRASS_BLOCK, ITEM.DIRT_WALL)
			.set_crust_bottom(ITEM.DIRT, ITEM.DIRT_WALL)
			.set_stone(ITEM.STONE, ITEM.STONE_WALL)
		)
		.set_passive_creatures([
			ITEM.GREENIAN_GRASS_BLOCK,
			ITEM.DIRT,
		], [
			CREATURE.CHICKEN,
			CREATURE.FOX,
			CREATURE.RABBIT,
			// CREATURE.CHICK,
			// CREATURE.SQUIRREL,
			CREATURE.SNAIL,
			// CREATURE.OWL,
			// CREATURE.BEE,
		])
		.set_structure(
			"tree_oak_0", "tree_oak_1", "tree_oak_2", "tree_oak_3", "tree_oak_4", "tree_oak_5",
			"campsite_0", "campsite_1"
		)
		.set_foliage(function(_x, _y, _z, _seed) {
			if (irandom(6) == 0) || (tile_get(_x, _y, CHUNK_DEPTH_DEFAULT) != ITEM.GREENIAN_GRASS_BLOCK) exit;
		
			var _plant_y = _y - 1;
			
			if (tile_get(_x, _plant_y, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY) exit;
		
			var _plant_z = CHUNK_DEPTH_PLANT;
				
			if (tile_get(_x, _plant_y, _plant_z) != ITEM.EMPTY) exit;
			
			tile_place(_x, _plant_y, _plant_z, new Tile(choose_weighted(
				ITEM.SHORT_GREENIAN_GRASS, 3,
				ITEM.TALL_GREENIAN_GRASS, 1,
				ITEM.ROCKS, 4,
				ITEM.TWIG, 3,
				ITEM.ROSE, 1,
				ITEM.YELLOW_GROWLER, 1,
				ITEM.DAISY, 1,
				ITEM.BLUE_BELLS, 1,
				ITEM.PERSIAN_SPEEDWELL, 2,
				ITEM.PURPLE_DENDROBIUM, 1,
				ITEM.SMALL_SWEET_PEA, 1,
				ITEM.SWEET_PEA, 1,
				ITEM.LILY_OF_THE_VALLEY, 1,
				ITEM.HIGH_SOCIETY, 1,
				ITEM.VIOLETS, 1,
				ITEM.PETUNIA, 1
			))
				.set_xoffset(irandom_range(-2, 2)));
		}));

	array_push(global.surface_biome_data, new BiomeDataSurface("Desert")
		.set_rpc_icon("surface_desert")
		.set_map_colour(#ffff00)
		.set_sky_colour(new BiomeSkyColour()
			.set_solid(#180738, #5F91FE, #C4502D, #000019)
			.set_gradient(#2A1504, #244FE9, #DA651C, #020008)
		)
		.set_music(mus_Dune)
		.set_tiles(new BiomeSurfaceTiles()
			.set_crust(ITEM.SAND, ITEM.SANDSTONE_WALL)
			.set_stone(ITEM.SANDSTONE, ITEM.SANDSTONE_WALL)
		)
		.set_passive_creatures([
			ITEM.SAND,
			ITEM.SANDSTONE,
		], [
			CREATURE.OSTRICH,
			CREATURE.CAMEL,
			CREATURE.MEERKAT,
			CREATURE.CRAB,
			CREATURE.VULTURE,
			CREATURE.SCORPION
		])
		.set_structure(
			"tree_oak_0", "tree_oak_1", "tree_oak_2", "tree_oak_3", "tree_oak_4", "tree_oak_5",
			"tree_yucca_0", "tree_yucca_1", "tree_yucca_2", "tree_yucca_3", "tree_yucca_4", "tree_yucca_5",
			"cactus_0", "cactus_1", "cactus_2", "cactus_3", "cactus_4", "cactus_5",
			"cactus_flower_0", "cactus_flower_1", "cactus_flower_2", "cactus_flower_3", "cactus_flower_4", "cactus_flower_5",
		)
		.set_foliage(function(_x, _y, _z, _seed)
		{
			if (!chance(0.15)) || (tile_get(_x, _y, CHUNK_DEPTH_DEFAULT) == ITEM.SAND) || (tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY) exit;
		
			tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(choose_weighted(
				ITEM.YUCCA, 2,
				ITEM.DEAD_BUSH, 6,
				ITEM.DESERT_WAVES, 2,
				ITEM.SKULL, 1,
				ITEM.TUMBLEWEED, 2,
				ITEM.DESERT_GRASS, 3,
				ITEM.TWIG, 4,
				ITEM.ROCKS, 3
			)));
		}));

	array_push(global.surface_biome_data, new BiomeDataSurface("Borealis")
		.set_map_colour(#00ff00)
		.set_sky_colour(new BiomeSkyColour()
			.set_solid(#180738, #5F91FE, #C4502D, #000019)
			.set_gradient(#2A1504, #244FE9, #DA651C, #020008)
		)
		.set_music(mus_Slowly_Falling_Deep, mus_Aurora)
		.set_tiles(new BiomeSurfaceTiles()
			.set_crust_top(ITEM.BOREAL_GRASS_BLOCK, ITEM.DIRT_WALL)
			.set_crust_bottom(ITEM.DIRT, ITEM.DIRT_WALL)
			.set_stone(ITEM.STONE, ITEM.STONE_WALL)
		)
		.set_passive_creatures([
			ITEM.BOREAL_GRASS_BLOCK,
			ITEM.DIRT,
		], [
			CREATURE.FOX,
			CREATURE.RABBIT,
			CREATURE.DUCK,
			CREATURE.SQUIRREL,
			CREATURE.PLATYPUS,
			CREATURE.GOAT,
			CREATURE.OWL,
			CREATURE.BEE,
			CREATURE.LADYBUG,
			CREATURE.BUTTERFLY,
			CREATURE.TURKEY
		])
		.set_structure(
			"tree_oak_0", "tree_oak_1", "tree_oak_2", "tree_oak_3", "tree_oak_4", "tree_oak_5",
			"tree_pine_0", "tree_pine_1", "tree_pine_2", "tree_pine_3", "tree_pine_4", "tree_pine_5",
			"campsite_0", "campsite_1"
		)
		.set_foliage(function(_x, _y, _z, _seed)
		{
			var _plant_z = CHUNK_DEPTH_PLANT;
	
			if (perlin_noise(_x - 512, 512, 8, 16, _seed) > 5.2)
			{
				var _plant_y = _y - 1;
			
				tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.PERMAFROST));
			
				if (irandom(6) > 0) && (tile_get(_x, _plant_y, _plant_z) == ITEM.EMPTY)
				{
					tile_place(_x, _plant_y, _plant_z, new Tile(choose_weighted(
						ITEM.SHORT_SNOWY_GRASS, 5,
						ITEM.TALL_SNOWY_GRASS, 3,
						ITEM.ANEMONE, 2,
						ITEM.FORGET_ME_NOT, 1,
						ITEM.SNOW_PILE, 2,
						ITEM.TWIG, 3,
						ITEM.ROCKS, 3
					)));
				}
		
				exit;
			}
		
			var _plant_y = _y - 1;
	
			if (irandom(6) > 0) && (tile_get(_x, _plant_y, _plant_z) == ITEM.EMPTY)
			{
				tile_place(_x, _plant_y, _plant_z, new Tile(choose_weighted(
					ITEM.SHORT_BOREAL_GRASS, 5,
					ITEM.TALL_BOREAL_GRASS, 3,
					ITEM.REDBERRY_BUSH, 2,
					ITEM.BLUEBERRY_BUSH, 1,
					ITEM.FERN, 2,
					ITEM.CURLY_FERN, 3,
					ITEM.ROSEHIP, 2,
					ITEM.CYAN_ROSE, 2,
					ITEM.PAEONIA, 3,
					ITEM.PEONY, 1,
					ITEM.RED_MUSHROOM, 1,
					ITEM.BLUE_MUSHROOM, 1,
					ITEM.BROWN_MUSHROOM, 1,
					ITEM.TWIG, 3,
					ITEM.ROCKS, 3
				)));
			}
		}));

	array_push(global.surface_biome_data, new BiomeDataSurface("Swamplands")
		.set_rpc_icon("surface_swamp")
		.set_map_colour(#00ffff)
		.set_sky_colour(new BiomeSkyColour()
			.set_solid(#180738, #5F91FE, #C4502D, #000019)
			.set_gradient(#2A1504, #244FE9, #DA651C, #020008)
		)
		.set_music(mus_Muskeg, mus_Soil)
		.set_tiles(new BiomeSurfaceTiles()
			.set_crust_top(ITEM.SWAMPY_GRASS_BLOCK, ITEM.DIRT_WALL)
			.set_crust_bottom(ITEM.DIRT, ITEM.DIRT_WALL)
			.set_stone(ITEM.STONE, ITEM.STONE_WALL)
		)
		.set_passive_creatures([
			ITEM.SWAMPY_GRASS_BLOCK,
			ITEM.DIRT,
		], [
			CREATURE.FROG,
			CREATURE.TOAD,
			CREATURE.CAPYBARA,
			CREATURE.BUTTERFLY,
			CREATURE.CRAB
		])
		.set_structure(
			"tree_mangrove_0", "tree_mangrove_1", "tree_mangrove_2", "tree_mangrove_3", "tree_mangrove_4", "tree_mangrove_5",
		)
		.set_natural(function(_x, _y, _z, _seed)
		{
			if (perlin_noise(_x - 8192, _y - 2048, 8, 32, _seed) > 4)
			{
				tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.MUD));
			}
		})
		.set_foliage(function(_x, _y, _z, _seed)
		{
			var _plant_y = _y - 1;
		
			if (tile_get(_x, _plant_y, CHUNK_DEPTH_DEFAULT) != ITEM.EMPTY) || (irandom(2) == 0) exit;
		
			var tile = tile_get(_x, _y, CHUNK_DEPTH_DEFAULT);
			
			if (tile == ITEM.MUD)
			{
				tile_place(_x, _plant_y, CHUNK_DEPTH_PLANT, (_x % 14 == 0 ? new Tile(ITEM.SWAMP_FOGPOD) : new Tile(choose_weighted(
					ITEM.CATTAILS, 2,
					ITEM.ROCKS, 2,
					ITEM.RED_MUSHROOM, 1,
					ITEM.BLUE_MUSHROOM, 1,
					ITEM.BROWN_MUSHROOM, 1
				))));
			
				exit;
			}
		
			tile_place(_x, _plant_y, CHUNK_DEPTH_PLANT, new Tile(choose_weighted(
				ITEM.SHORT_SWAMPY_GRASS, 8,
				ITEM.TALL_SWAMPY_GRASS, 3,
				ITEM.CATTAILS, 3,
				ITEM.DEAD_BUSH, 7,
				ITEM.ROCKS, 5,
				ITEM.TWIG, 3,
				ITEM.PURPLE_DENDROBIUM, 1,
				ITEM.YELLOW_GROWLER, 2,
				ITEM.MIXED_ORCHIDS, 1,
				ITEM.RED_MUSHROOM, 2,
				ITEM.BROWN_MUSHROOM, 2,
				ITEM.SWAMP_LILYBELL, 1,
			)));
		}));

	array_push(global.surface_biome_data, new BiomeDataSurface("Amazonia")
		.set_map_colour(#78F73F)
		.set_sky_colour(new BiomeSkyColour()
			.set_solid(#180738, #5F91FE, #C4502D, #000019)
			.set_gradient(#2A1504, #244FE9, #DA651C, #020008)
		)
		.set_music(mus_Growth)
		.set_tiles(new BiomeSurfaceTiles()
			.set_crust_top(ITEM.AMAZONIAN_GRASS_BLOCK, ITEM.DIRT_WALL)
			.set_crust_bottom(ITEM.DIRT, ITEM.DIRT_WALL)
			.set_stone(ITEM.STONE, ITEM.STONE_WALL)
		)
		.set_passive_creatures([
			ITEM.AMAZONIAN_GRASS_BLOCK,
			ITEM.DIRT,
		], [
			CREATURE.COW,
			CREATURE.CAPYBARA,
			CREATURE.TOAD,
			CREATURE.TORTOISE,
			CREATURE.PARROT,
			CREATURE.TOUCAN,
			CREATURE.SNAIL,
			CREATURE.BUTTERFLY,
			CREATURE.LADYBUG
		])
		.set_structure(
			"tree_oak_0", "tree_oak_1", "tree_oak_2", "tree_oak_3", "tree_oak_4", "tree_oak_5",
		)
		.set_foliage(function(_x, _y, _z, _seed)
		{
			var _plant_z = CHUNK_DEPTH_PLANT;
		
			var _val = perlin_noise(_x, 0, 9, 16, _seed);
		
			if (_val > 3.5)
			{
				tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.PODZOL));
			
				if (_val > 4.3) exit;
			}
	
			if (_x % 12 == 0) && (irandom(3) == 0)
			{
				tile_place(_x, _y - 1, _plant_z, new Tile(ITEM.RAFFLESIA));
		
				exit;
			}
		
			var _plant_y = _y - 1;
	
			if (irandom(6) == 0) || (tile_get(_x, _plant_y, _plant_z) != ITEM.EMPTY) exit;
		
			tile_place(_x, _plant_y, _plant_z, new Tile(choose_weighted(
				ITEM.TALL_AMAZONIAN_GRASS, 4,
				ITEM.ROSE, 2,
				ITEM.HIGH_SOCIETY, 2,
				ITEM.LILY_OF_THE_VALLEY, 2,
				ITEM.RED_MUSHROOM, 1,
				ITEM.BROWN_MUSHROOM, 1,
				ITEM.VENUS_FLY_TRAP, 1,
				ITEM.HELICONIA, 2,
				ITEM.ROCKS, 4,
				ITEM.TWIG, 3
			)));
		}));

	array_push(global.surface_biome_data, new BiomeDataSurface("Tundra")
		.set_map_colour(#D1DDEC)
		.set_sky_colour(new BiomeSkyColour()
			.set_solid(#180738, #5F91FE, #C4502D, #000019)
			.set_gradient(#2A1504, #244FE9, #DA651C, #020008)
		)
		.set_music(mus_Permafrost)
		.set_tiles(new BiomeSurfaceTiles()
			.set_crust_top(ITEM.PERMAFROST, ITEM.DIRT_WALL)
			.set_crust_bottom(ITEM.DIRT, ITEM.DIRT_WALL)
			.set_stone(ITEM.KYANITE, ITEM.STONE_WALL)
		)
		.set_passive_creatures([
			ITEM.PERMAFROST,
			ITEM.DIRT,
		], [
			CREATURE.FOX,
			CREATURE.RABBIT,
			CREATURE.PENGUIN
		])
		.set_structure(
			"campsite_0", "campsite_1"
		)
		.set_foliage(function(_x, _y, _z, _seed)
		{
			#region Foliage Generation
	
			var _plant_z = CHUNK_DEPTH_PLANT;
	
			if (irandom(8) > 0) && (tile_get(_x, _y - 1, _plant_z) == ITEM.EMPTY)// && (tile_get(_x, _y, CHUNK_DEPTH_DEFAULT) == ITEM.PERMAFROST)
			{
				tile_place(_x, _y - 1, _plant_z, new Tile(choose_weighted(
					ITEM.SHORT_SNOWY_GRASS, 4,
					ITEM.TALL_SNOWY_GRASS, 1,
					ITEM.BLUE_BELLS, 1,
					ITEM.PERSIAN_SPEEDWELL, 1,
					ITEM.ICELEA, 3,
					ITEM.LILY_OF_THE_VALLEY, 1,
					ITEM.SNOW_PILE, 2,
					ITEM.FORGET_ME_NOT, 1,
					ITEM.ANEMONE, 2,
					ITEM.HAREBELL, 1,
					ITEM.TWIG, 3,
					ITEM.ROCKS, 3
				)));
			}
	
			#endregion
		}));

	array_push(global.surface_biome_data, new BiomeDataSurface("Savannah")
		.set_map_colour(#92801C)
		.set_sky_colour(new BiomeSkyColour()
			.set_solid(#180738, #5F91FE, #C4502D, #000019)
			.set_gradient(#2A1504, #244FE9, #DA651C, #020008)
		)
		.set_music(mus_Yellowish)
		.set_tiles(new BiomeSurfaceTiles()
			.set_crust_top(ITEM.DRY_GRASS_BLOCK, ITEM.DIRT_WALL)
			.set_crust_bottom(ITEM.DRY_DIRT, ITEM.DIRT_WALL)
			.set_stone(ITEM.STRATA, ITEM.STRATA_WALL)
		)
		.set_passive_creatures([
			ITEM.DRY_GRASS_BLOCK,
			ITEM.DRY_DIRT,
		], [
			CREATURE.OSTRICH,
			CREATURE.CAMEL,
			CREATURE.CAPYBARA,
			CREATURE.SNAIL,
			CREATURE.ZEBRA
		])
		.set_natural(function(_x, _y, _z, _seed)
		{
			if (perlin_noise((_x * 0.7) - 2048, _y - 2048, 8, 32, _seed) > 5)
			{
				tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.STRATA));
			}
		})
		.set_foliage(function(_x, _y, _z, _seed)
		{
			#region Foliage Generation
	
			if (irandom(3) > 0) &&
				(tile_get(_x, _y, CHUNK_DEPTH_DEFAULT) == ITEM.DRY_GRASS_BLOCK) &&
				(tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY) &&
				(tile_get(_x, _y - 1, CHUNK_DEPTH_PLANT_FRONT) == ITEM.EMPTY) &&
				(tile_get(_x, _y - 1, CHUNK_DEPTH_PLANT_BACK) == ITEM.EMPTY)
			{
				tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(choose_weighted(
					ITEM.SHORT_DRY_GRASS, 5,
					ITEM.TALL_DRY_GRASS, 2,
					ITEM.DEAD_BUSH, 3,
					ITEM.YELLOW_GROWLER, 2,
					ITEM.DAFFODIL, 1,
					ITEM.DANDELION, 2,
					ITEM.DESERT_WAVES, 2,
					ITEM.TWIG, 3,
					ITEM.ROCKS, 3,
					ITEM.YARROW, 2
				)));
			}
	
			#endregion
		}));

	array_push(global.surface_biome_data, new BiomeDataSurface("Cherry Blossoms")
		.set_rpc_icon("surface_cherry")
		.set_map_colour(#F67F96)
		.set_sky_colour(new BiomeSkyColour()
			.set_solid(#180738, #5F91FE, #C4502D, #000019)
			.set_gradient(#2A1504, #244FE9, #DA651C, #020008)
		)
		.set_music(mus_Another_Day, mus_The_Other_Day)
		.set_tiles(new BiomeSurfaceTiles()
			.set_crust_top(ITEM.GREENIAN_GRASS_BLOCK, ITEM.DIRT_WALL)
			.set_crust_bottom(ITEM.DIRT, ITEM.DIRT_WALL)
			.set_stone(ITEM.STONE, ITEM.STONE_WALL)
		)
		.set_passive_creatures([
			ITEM.GREENIAN_GRASS_BLOCK,
			ITEM.DIRT,
		], [
			CREATURE.FOX,
			CREATURE.RABBIT,
			CREATURE.RED_PANDA,
			CREATURE.DUCK,
			CREATURE.OWL,
			CREATURE.BEE,
			CREATURE.BUTTERFLY,
		])
		.set_foliage(function(_x, _y, _z, _seed) {
			var zplant = CHUNK_DEPTH_PLANT;
		
			if (irandom(9) > 0) &&
			(tile_get(_x, _y, CHUNK_DEPTH_DEFAULT) == ITEM.GREENIAN_GRASS_BLOCK) &&
			(tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY) &&
			(tile_get(_x, _y - 1, CHUNK_DEPTH_PLANT_FRONT) == ITEM.EMPTY) &&
			(tile_get(_x, _y - 1, CHUNK_DEPTH_PLANT_BACK) == ITEM.EMPTY)
			{
				var foliage = choose_weighted(
					ITEM.SHORT_GREENIAN_GRASS, 4,
					ITEM.TALL_GREENIAN_GRASS, 2,
					ITEM.ROCKS, 2,
					ITEM.DAISY, 1,
					ITEM.SMALL_SWEET_PEA, 1,
					ITEM.SWEET_PEA, 1,
					ITEM.LILY_OF_THE_VALLEY, 1,
					ITEM.VIOLETS, 2,
					ITEM.PINK_AMARYLLIS, 1,
					ITEM.PETUNIA, 1
				);
			
				tile_place(_x, _y - 1, zplant, new Tile(foliage)
					.set_offset(irandom_range(-2, 2), 0));
		
				exit;
			}
		}));

	array_push(global.surface_biome_data, new BiomeDataSurface("Birch Forest")
		.set_rpc_icon("surface_birch")
		.set_map_colour(#0C492E)
		.set_sky_colour(new BiomeSkyColour()
			.set_solid(#180738, #5F91FE, #C4502D, #000019)
			.set_gradient(#2A1504, #244FE9, #DA651C, #020008)
		)
		.set_music(mus_Another_Day, mus_The_Other_Day)
		.set_tiles(new BiomeSurfaceTiles()
			.set_crust_top(ITEM.GREENIAN_GRASS_BLOCK, ITEM.DIRT_WALL)
			.set_crust_bottom(ITEM.DIRT, ITEM.DIRT_WALL)
			.set_stone(ITEM.STONE, ITEM.STONE_WALL)
		)
		.set_passive_creatures([
			ITEM.GREENIAN_GRASS_BLOCK,
			ITEM.DIRT,
		], [
			CREATURE.FOX,
			CREATURE.SQUIRREL,
			CREATURE.RACCOON,
			CREATURE.WEASEL,
			CREATURE.OWL,
			CREATURE.BEE,
			CREATURE.BUTTERFLY,
		])
		.set_foliage(function(_x, _y, _z, _seed) {
			var zplant = CHUNK_DEPTH_PLANT;
		
			if (irandom(9) > 0) &&
				(tile_get(_x, _y, CHUNK_DEPTH_DEFAULT) == ITEM.GREENIAN_GRASS_BLOCK) &&
				(tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY) &&
				(tile_get(_x, _y - 1, CHUNK_DEPTH_PLANT_FRONT) == ITEM.EMPTY) &&
				(tile_get(_x, _y - 1, CHUNK_DEPTH_PLANT_BACK) == ITEM.EMPTY)
			{
				tile_place(_x, _y - 1, zplant, new Tile(choose_weighted(
					ITEM.SHORT_GREENIAN_GRASS, 4,
					ITEM.TALL_GREENIAN_GRASS, 2,
					ITEM.ROCKS, 3,
					ITEM.TWIG, 3,
					ITEM.DAISY, 1,
					ITEM.LILY_OF_THE_VALLEY, 1,
					ITEM.DANDELION, 1,
					ITEM.PUFFBALL, 2,
					ITEM.VIOLETS, 4,
					ITEM.RED_MUSHROOM, 1,
					ITEM.BROWN_MUSHROOM, 1,
					ITEM.NEMESIA, 2,
					ITEM.DANDELION, 1,
					ITEM.DAFFODIL, 1,
					ITEM.TALL_PUFFBALL, 1,
					ITEM.BLUE_PHLOX, 1
				))
				.set_xoffset(irandom_range(-2, 2)));
		
				exit;
			}
		}));

	array_push(global.surface_biome_data, new BiomeDataSurface("Oasis")
		.set_rpc_icon("surface_oasis")
		.set_map_colour(#9DC947)
		.set_sky_colour(new BiomeSkyColour()
			.set_solid(#180738, #5F91FE, #C4502D, #000019)
			.set_gradient(#2A1504, #244FE9, #DA651C, #020008)
		)
		.set_music(mus_Dune)
		.set_tiles(new BiomeSurfaceTiles()
			.set_crust(ITEM.SAND, ITEM.SANDSTONE_WALL)
			.set_stone(ITEM.SANDSTONE, ITEM.SANDSTONE_WALL)
		)
		.set_passive_creatures([
			ITEM.SAND,
			ITEM.SANDSTONE,
		], [
			CREATURE.OSTRICH,
			CREATURE.CAMEL,
			CREATURE.MEERKAT,
			CREATURE.TORTOISE
		])
		.set_foliage(function(_x, _y, _z, _seed)
		{
			// worldgen_set_seed(_x, _y, _seed);
		
			if (perlin_noise(_x, 1024, 8, 4, _seed) > 2.5)
			{
				tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.MOSS));
			
				if (_x % 16 == 0) && (irandom(9) > 0)
				{
					// structure_tree_palm(_x, _y - 1, _seed);
			
					exit;
				}
			
				if (tile_get(_x, _y - 1, CHUNK_DEPTH_PLANT_BACK) == ITEM.EMPTY) && (tile_get(_x, _y - 1, CHUNK_DEPTH_PLANT_FRONT) == ITEM.EMPTY) && (tile_get(_x, _y - 1, CHUNK_DEPTH_DEFAULT) == ITEM.EMPTY)
				{
					if (perlin_noise(_x, 512, 8, 4, _seed) > 5)
					{
						tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(ITEM.PAPYRUS));
					}
					else if (chance(0.6))
					{
						tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(choose_weighted(
							ITEM.TWIG, 2,
							ITEM.ROCKS, 2,
							ITEM.DESERT_WAVES, 4,
							ITEM.ALOE_VERA, 2,
							ITEM.YUCCA, 1
						))
						.set_xoffset(irandom_range(-2, 2)));
					}
				}
			
				exit;
			}
		
			if (chance(0.35))
			{
				tile_place(_x, _y - 1, CHUNK_DEPTH_PLANT, new Tile(choose_weighted(
					ITEM.TWIG, 2,
					ITEM.ROCKS, 2,
					ITEM.DEAD_BUSH, 3,
					ITEM.DESERT_GRASS, 5
				))
				.set_xoffset(irandom_range(-2, 2)));
			}
			else if (chance(0.35)) && (_x % 12 == 0)
			{
				// structure_cactus(_x, _y - 1, _seed);
			}
		}));

	array_push(global.surface_biome_data, new BiomeDataSurface("Bamboo Forest")
		.set_map_colour(#9FE95F)
		.set_sky_colour(new BiomeSkyColour()
			.set_solid(#180738, #5F91FE, #C4502D, #000019)
			.set_gradient(#2A1504, #244FE9, #DA651C, #020008)
		)
		.set_music(mus_Growth)
		.set_tiles(new BiomeSurfaceTiles()
			.set_crust_top(ITEM.PODZOL, ITEM.DIRT_WALL)
			.set_crust_bottom(ITEM.DIRT, ITEM.DIRT_WALL)
			.set_stone(ITEM.STONE, ITEM.STONE_WALL)
		)
		.set_passive_creatures([
			ITEM.AMAZONIAN_GRASS_BLOCK,
			ITEM.DIRT,
		], [
			CREATURE.COW,
			CREATURE.CAPYBARA,
			CREATURE.TOAD,
			CREATURE.TORTOISE,
			CREATURE.PARROT
		])
		.set_foliage(function(_x, _y, _z, _seed)
		{
			// worldgen_set_seed(_x, _y, _seed);
		
			var _val = perlin_noise(_x, 0, 9, 16, _seed);
		
			if (_val > 4)
			{
				tile_place(_x, _y, CHUNK_DEPTH_DEFAULT, new Tile(ITEM.PODZOL));
			}
	
			if (irandom(6) > 0)
			{
				var _plant_z = CHUNK_DEPTH_PLANT;
			
				if (tile_get(_x, _y - 1, _plant_z) == ITEM.EMPTY)
				{
					tile_place(_x, _y - 1, _plant_z, new Tile(choose_weighted(
						ITEM.SHORT_AMAZONIAN_GRASS, 6,
						ITEM.TALL_AMAZONIAN_GRASS, 4,
						ITEM.ROSE, 2,
						ITEM.HIGH_SOCIETY, 2,
						ITEM.LILY_OF_THE_VALLEY, 2,
						ITEM.RED_MUSHROOM, 1,
						ITEM.BROWN_MUSHROOM, 1,
						ITEM.VENUS_FLY_TRAP, 1,
						ITEM.HELICONIA, 2
					))
					.set_index(irandom_range(-2, 2)));
				}
			}
		}));
});