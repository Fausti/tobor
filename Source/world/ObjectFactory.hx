package world;
import world.entities.Drift;
import world.entities.Entity;
import world.entities.EntityFloor;
import world.entities.EntityItem;
import world.entities.Marker;
import world.entities.std.*;

/**
 * ...
 * @author Matthias Faust
 */
class ObjectFactory {
	public var length(default, null):Int = 0;
	
	private var list:Map<String, ObjectTemplate> = new Map<String, ObjectTemplate>();
	
	public var listItems:Array<ObjectTemplate> = [];
	public var listFloors:Array<ObjectTemplate> = [];
	
	public function new() {
		// OBJECT_NAME # OBJECT_TYPE
		// e.g. OBJ_KEY#2
		
		register("OBJ_CHARLIE", 	Charlie, 	Gfx.getSprite(16, 0))
			.disableBrush();
		register("OBJ_START_POSITION", StartPosition, Gfx.getSprite(128, 156))
			.disableBrush();
		
		register("OBJ_ROBOT",		Robot, 		Gfx.getSprite(0, 120), null, Room.LAYER_LEVEL_0 + 1)
			.disableBrush();
		register("OBJ_ANDROID_EGG", AndroidEgg, Gfx.getSprite(208, 216), null)
			.disableBrush();
		register("OBJ_ANDROID",		Android, 	Gfx.getSprite(176, 120), null, Room.LAYER_LEVEL_0 + 1)
			.disableBrush();
		register("OBJ_SHARK",		Shark, 		Gfx.getSprite(126, 120), null, Room.LAYER_LEVEL_0 + 1)
			.disableBrush();
		
		register("OBJ_GROUND_NEST", GroundNest, Gfx.getSprite(240, 24))
			.disableBrush();
		register("OBJ_WATCHER", Watcher, Gfx.getSprite(80, 60), null, Room.LAYER_OVERLAY)
			.disableBrush();
		
		register("OBJ_ISOLATOR", 	Isolator, 	Gfx.getSprite(240, 0));
		
		register("OBJ_ISOLATOR_SOFT", 	SoftIsolator, 	Gfx.getSprite(128, 132))
			.disableBrush();
		register("OBJ_ISOLATOR_WATER", WaterIsolator, Gfx.getSprite(112, 156))
			.disableBrush();
		register("OBJ_WATER_PLANT", WaterPlant, Gfx.getSprite(144, 72))
			.disableBrush();
		
		register("OBJ_ELECTRIC_FENCE", ElectricFence, Gfx.getSprite(64, 12), {type: 0});
		register("OBJ_ELECTRIC_FENCE_OFF", ElectricFence, Gfx.getSprite(96, 156), {type: 1});
		
		register("OBJ_SKULL", 		Skull, 		Gfx.getSprite(80, 12))
			.disableBrush();
		
		register("OBJ_WALL", 		Wall, 		Gfx.getSprite(160, 0), 				{type: 0}, Room.LAYER_FLOOR)
			.setAutoTiles([0], [4, 1, 3, 2]);
		register("OBJ_WALL_NE", 	Wall, 		Gfx.getSprite(160 + 16 * 1, 0), 	{type: 1}, Room.LAYER_FLOOR)
			.setAutoTiles([0], [4, 1, 3, 2])
			.disableBrush();
		register("OBJ_WALL_SW", 	Wall, 		Gfx.getSprite(160 + 16 * 2, 0), 	{type: 2}, Room.LAYER_FLOOR)
			.setAutoTiles([0], [4, 1, 3, 2])
			.disableBrush();
		register("OBJ_WALL_SE", 	Wall, 		Gfx.getSprite(160 + 16 * 3, 0), 	{type: 3}, Room.LAYER_FLOOR)
			.setAutoTiles([0], [4, 1, 3, 2])
			.disableBrush();
		register("OBJ_WALL_NW", 	Wall, 		Gfx.getSprite(160 + 16 * 4, 0), 	{type: 4}, Room.LAYER_FLOOR)
			.setAutoTiles([0], [4, 1, 3, 2])
			.disableBrush();
		
		register("OBJ_WALL_BLACK", 		Wall, 		Gfx.getSprite(48, 132),				{type: 5}, Room.LAYER_FLOOR)
			.setAutoTiles([5], [9, 6, 8, 7]);
		register("OBJ_WALL_BLACK_NE", 	Wall, 		Gfx.getSprite(48 + 16 * 1, 132),	{type: 6}, Room.LAYER_FLOOR)
			.setAutoTiles([5], [9, 6, 8, 7])
			.disableBrush();
		register("OBJ_WALL_BLACK_SW", 	Wall, 		Gfx.getSprite(48 + 16 * 2, 132),	{type: 7}, Room.LAYER_FLOOR)
			.setAutoTiles([5], [9, 6, 8, 7])
			.disableBrush();
		register("OBJ_WALL_BLACK_SE", 	Wall, 		Gfx.getSprite(48 + 16 * 3, 132),	{type: 8}, Room.LAYER_FLOOR)
			.setAutoTiles([5], [9, 6, 8, 7])
			.disableBrush();
		register("OBJ_WALL_BLACK_NW", 	Wall, 		Gfx.getSprite(48 + 16 * 4, 132),	{type: 9}, Room.LAYER_FLOOR)
			.setAutoTiles([5], [9, 6, 8, 7])
			.disableBrush();
		
		register("OBJ_WALL_HARD", 	Wall, 		Gfx.getSprite(160, 12), 	{type: 10}, Room.LAYER_FLOOR);
		
		register("OBJ_ROOM_EXIT", 	Exit, 		Gfx.getSprite(0, 12))
			.disableBrush();
		
		register("OBJ_BANK",		Bank,		Gfx.getSprite(48, 12))
			.disableBrush();
			
		register("OBJ_GOLD",		Gold, 		Gfx.getSprite(96, 12));
		
		register("OBJ_PLATIN", Platin, Gfx.getSprite(128, 12));
		// register("OBJ_QUESTION_MARK", QuestionMark, Gfx.getSprite(144, 12));
		
		register("OBJ_CLOCK", Clock, Gfx.getSprite(176, 12))
			.setPoints(200)
			.disableBrush();
		
		register("OBJ_NOTICE", Notice, Gfx.getSprite(208, 12))
			.disableBrush();
		
		register("OBJ_MAGNET#0", Magnet, Gfx.getSprite(224, 12), {type: 0})
			.setPoints(500)
			.disableBrush();
		register("OBJ_MAGNET#1", Magnet, Gfx.getSprite(240, 12), {type: 1})
			.setPoints(500)
			.disableBrush();
		
		register("OBJ_TREE", Tree, Gfx.getSprite(80, 24))
			.setPoints(100)
			.disableBrush();
		
		register("OBJ_CLONE", Clone, Gfx.getSprite(128, 60))
			.setPoints(100)
			.disableBrush();
			
		register("OBJ_DOPPELGANGER_ITEM", 	DoppelgangerItem, 	Gfx.getSprite(160, 132))
			.disableBrush();
		register("OBJ_DOPPELGANGER", 	Doppelganger, 	Gfx.getSprite(16, 0))
			.disableBrush();
		
		register("OBJ_DIAMOND#0", Diamond, Gfx.getSprite(160, 24), {type: 0})
			.setPoints(1000);
		register("OBJ_DIAMOND#1", Diamond, Gfx.getSprite(176, 24), {type: 1})
			.setPoints(1000);
		
		register("OBJ_SLING", Sling, Gfx.getSprite(240, 60))
			.setPoints(1500)
			.disableBrush();
		
		for (i in 0 ... 6) {
			register("OBJ_MUNITION#" + Std.string(i), Munition, Gfx.getSprite(144 + i * 16, 60), {type: i})
				.setPoints(100)
				.disableBrush();
		}
		
		// Berge
		
		register("OBJ_MOUNTAIN_PATH", MountainPath, Gfx.getSprite(144, 264), null, Room.LAYER_FLOOR);
		
		for (i in 0 ... 4) {
			register("OBJ_MOUNTAIN_" + Std.string(i), Mountain, Gfx.getSprite(176 + i * 16, 264), {type: i}, Room.LAYER_FLOOR)
				.setRandom([0, 1, 2, 3])
				.setAutoTiles([0, 1, 2, 3], [8, 4, 16, 12]);
		}
		
		for (i in 0 ... 8) {
			register("OBJ_MOUNTAIN_" + Std.string(i + 4), Mountain, Gfx.getSprite(128 + i * 16, 288), {type: i + 4}, Room.LAYER_FLOOR)
			.setAutoTiles([0, 1, 2, 3], [8, 4, 16, 12])
			.disableBrush();
		}
		
		for (i in 0 ... 8) {
			register("OBJ_MOUNTAIN_" + Std.string(i + 12), Mountain, Gfx.getSprite(128 + i * 16, 300), {type: i + 12}, Room.LAYER_FLOOR)
			.setAutoTiles([0, 1, 2, 3], [8, 4, 16, 12])
			.disableBrush();
		}
		
		// Türen
		
		for (i in 0 ... 15) {
			var door = register("OBJ_DOOR#" + Std.string(i), Door, Gfx.getSprite(i * 16, 36), {type: i})
			.disableBrush();
			
			door.sprBlack = Gfx.getSprite(i * 16, 192);
		}
		
		for (i in 0 ... 15) {
			var key = register("OBJ_KEY#" + Std.string(i), Key, Gfx.getSprite(i * 16, 48), {type: i})
				.setPoints(500)
				.disableBrush();
			
				key.sprBlack = Gfx.getSprite(i * 16, 204);
		}
		
		register("OBJ_EXPLOSION", 	Explosion, 	Gfx.getSprite(64, 0))
			.allowInEditor(false)
			.disableBrush();
		
		register("OBJ_BARRIER", 	Barrier, 		Gfx.getSprite(240, 96))
			.disableBrush();
		
		register("OBJ_ELEXIR",		Elexir,			Gfx.getSprite(224, 24))
			.setPoints(100)
			.disableBrush();
		
		register("OBJ_GARLIC",		Garlic,			Gfx.getSprite(192, 24))
			.setPoints(100)
			.disableBrush();
		
		// register("OBJ_BRIDGE_NS",		Bridge,			Gfx.getSprite(176,156), {type: 0});
		// register("OBJ_BRIDGE_WE",		Bridge,			Gfx.getSprite(192,156), {type: 1});
		
		var ii:Int = 0;
		for (iy in 0 ... 2) {
			for (ix in 0 ... 3) {
				register("OBJ_GOAL_" + Std.string(ii), Goal, Gfx.getSprite(160 + ix * 16, 216 + iy * 12), {type: ii})
					.disableBrush();
				ii++;
			}
		}
		
		register("OBJ_NPC", NPC, Gfx.getSprite(128, 276), null, Room.LAYER_LEVEL_0 + 1)
			.disableBrush();
		register("OBJ_DEALER", Dealer, Gfx.getSprite(64, 276), null, Room.LAYER_LEVEL_0 + 1)
			.disableBrush();
		
		register("OBJ_ROOF_0", Roof, Gfx.getSprite(0, 132), {type: 0}, Room.LAYER_ROOF);
		register("OBJ_ROOF_1", Roof, Gfx.getSprite(0, 144), {type: 1}, Room.LAYER_ROOF);
		register("OBJ_ROOF_2", Roof, Gfx.getSprite(16, 132), {type: 2}, Room.LAYER_ROOF);
		register("OBJ_ROOF_3", Roof, Gfx.getSprite(16, 144), {type: 3}, Room.LAYER_ROOF);
		register("OBJ_ROOF_4", Roof, Gfx.getSprite(32, 132), {type: 4}, Room.LAYER_ROOF);
		register("OBJ_ROOF_5", Roof, Gfx.getSprite(32, 144), {type: 5}, Room.LAYER_ROOF);
		register("OBJ_ROOF_6", Roof, Gfx.getSprite(48, 144), {type: 6}, Room.LAYER_ROOF);
		register("OBJ_ROOF_7", Roof, Gfx.getSprite(64, 144), {type: 7}, Room.LAYER_ROOF);
		register("OBJ_ROOF_8", Roof, Gfx.getSprite(80, 144), {type: 8}, Room.LAYER_ROOF);
		
		register("OBJ_ROOF_9", Roof, Gfx.getSprite(208, 324), {type: 9}, Room.LAYER_ROOF);
		register("OBJ_ROOF_10", Roof, Gfx.getSprite(208 + 16, 324), {type: 10}, Room.LAYER_ROOF);
		register("OBJ_ROOF_11", Roof, Gfx.getSprite(208 + 32, 324), {type: 11}, Room.LAYER_ROOF);
		register("OBJ_ROOF_12", Roof, Gfx.getSprite(208, 324 + 12), {type: 12}, Room.LAYER_ROOF);
		register("OBJ_ROOF_13", Roof, Gfx.getSprite(208 + 16, 324 + 12), {type: 13}, Room.LAYER_ROOF);
		register("OBJ_ROOF_14", Roof, Gfx.getSprite(208 + 32, 324 + 12), {type: 14}, Room.LAYER_ROOF);
		register("OBJ_ROOF_15", Roof, Gfx.getSprite(208, 324 + 24), {type: 15}, Room.LAYER_ROOF);
		register("OBJ_ROOF_16", Roof, Gfx.getSprite(208 + 16, 324 + 24), {type: 16}, Room.LAYER_ROOF);
		register("OBJ_ROOF_17", Roof, Gfx.getSprite(208 + 32, 324 + 24), {type: 17}, Room.LAYER_ROOF);
		
		for (i in 0 ... 3) {
			register("OBJ_SHADOW#" + Std.string(i), Shadow, Gfx.getSprite(48 + (i * 16), 156), {type: i}, Room.LAYER_FLOOR)
			.disableBrush();
		}
		
		for (i in 0 ... 5) {
			var ot = register("OBJ_SAND#" + Std.string(i), Sand, Gfx.getSprite(16 * i, 24), {type: i}, Room.LAYER_FLOOR)
				.setAutoTiles([0], [3, 4, 1, 2]);
				
			if (i > 0) {
				ot.disableBrush();
			}
		}
		
		for (i in 0 ... 4) {
			register("OBJ_TUNNEL#" + Std.string(i), Tunnel, Gfx.getSprite(192 + i * 16, 72), {type: i}, Room.LAYER_FLOOR)
			.disableBrush();
		}
		
		register("OBJ_STAIRS_UP", Stairs, Gfx.getSprite(224, 108), {type: 0})
			.disableBrush();
		register("OBJ_STAIRS_DOWN", Stairs, Gfx.getSprite(240, 108), {type: 1})
			.disableBrush();
		
		register("OBJ_ACID", Acid, Gfx.getSprite(208, 24))
			.setPoints(200)
			.disableBrush();
		
		register("OBJ_WALL_DISSOLVE", WallDissolve, Gfx.getSprite(64, 60));
		register("OBJ_WALL_SAND_DISSOLVE", SandWallDissolve, Gfx.getSprite(64 + 64, 168));
		
		register("OBJ_HARD_SAND_0", SandHard, Gfx.getSprite(208, 144), {type: 0}, Room.LAYER_FLOOR)
			.disableBrush();
		register("OBJ_HARD_SAND_1", SandHard, Gfx.getSprite(208 + 16, 144), {type: 1}, Room.LAYER_FLOOR)
			.disableBrush();
		register("OBJ_HARD_SAND_2", SandHard, Gfx.getSprite(208 + 32, 144), {type: 2}, Room.LAYER_FLOOR)
			.disableBrush();
		register("OBJ_HARD_SAND_3", SandHard, Gfx.getSprite(208, 144 + 12), {type: 3}, Room.LAYER_FLOOR)
			.disableBrush();
		register("OBJ_HARD_SAND_4", SandHard, Gfx.getSprite(208 + 16, 144 + 12), {type: 4}, Room.LAYER_FLOOR)
			.disableBrush();
		register("OBJ_HARD_SAND_5", SandHard, Gfx.getSprite(208 + 32, 144 + 12), {type: 5}, Room.LAYER_FLOOR)
			.disableBrush();
		register("OBJ_HARD_SAND_6", SandHard, Gfx.getSprite(208 + 16, 144 + 24), {type: 6}, Room.LAYER_FLOOR)
			.disableBrush();
		register("OBJ_HARD_SAND_7", SandHard, Gfx.getSprite(208 + 32, 144 + 24), {type: 7}, Room.LAYER_FLOOR)
			.disableBrush();
		
		register("OBJ_SAND_DECO_0", SandDeco, Gfx.getSprite(208, 132), {type: 0}, Room.LAYER_FLOOR)
			.disableBrush();
		register("OBJ_SAND_DECO_1", SandDeco, Gfx.getSprite(208 + 16, 132), {type: 1}, Room.LAYER_FLOOR)
			.disableBrush();
		register("OBJ_SAND_DECO_2", SandDeco, Gfx.getSprite(208 + 32, 132), {type: 2}, Room.LAYER_FLOOR)
			.disableBrush();
		
		register("OBJ_SCORPION", Scorpion, Gfx.getSprite(176, 168), null, Room.LAYER_LEVEL_0 + 1)
			.disableBrush();
		
		register("OBJ_SHOVEL", Shovel, Gfx.getSprite(192, 132))
			.disableBrush()
			.setPoints(200);
		register("OBJ_SPOT", Spot, Gfx.getSprite(224, 84))
			.disableBrush();
			
		register("OBJ_LAMP", Lamp, Gfx.getSprite(144, 132))
			.disableBrush()
			.setPoints(2000);
			
		register("OBJ_TORCH", Torch, Gfx.getSprite(80, 348))
			.disableBrush();
			
		register("OBJ_KNIFE", Knife, Gfx.getSprite(48, 168))
			.disableBrush();
		
		for (i in 0 ... 3) {
			register("OBJ_SAND_PLANT_" + Std.string(i), SandPlant, Gfx.getSprite(0 + 16 * i, 168), {type: i})
				.disableBrush();
		}
		
		for (i in 0 ... 4) {
			register("OBJ_RING#" + Std.string(i), Ring, Gfx.getSprite(i * 16, 276), {type: i})
				.disableBrush();
		}
		
		register("OBJ_SAND_WALL", 		Wall, 		Gfx.getSprite(32, 120), 			{type: 11}, Room.LAYER_FLOOR)
			.setAutoTiles([11], [15, 12, 14, 13]);
		register("OBJ_SAND_WALL_NE", 	Wall, 		Gfx.getSprite(32 + 16 * 1, 120), 	{type: 12}, Room.LAYER_FLOOR)
			.setAutoTiles([11], [15, 12, 14, 13])
			.disableBrush();
		register("OBJ_SAND_WALL_SW", 	Wall, 		Gfx.getSprite(32 + 16 * 2, 120), 	{type: 13}, Room.LAYER_FLOOR)
			.setAutoTiles([11], [15, 12, 14, 13])
			.disableBrush();
		register("OBJ_SAND_WALL_SE", 	Wall, 		Gfx.getSprite(32 + 16 * 3, 120), 	{type: 14}, Room.LAYER_FLOOR)
			.setAutoTiles([11], [15, 12, 14, 13])
			.disableBrush();
		register("OBJ_SAND_WALL_NW", 	Wall, 		Gfx.getSprite(32 + 16 * 4, 120), 	{type: 15}, Room.LAYER_FLOOR)
			.setAutoTiles([11], [15, 12, 14, 13])
			.disableBrush();
			
		register("OBJ_SAND_WALL_HARD", 	Wall, 		Gfx.getSprite(160, 72), 	{type: 16}, Room.LAYER_FLOOR)
			.setAutoTiles([11], [15, 12, 14, 13]);
		
		register("OBJ_SICKLE", Sickle, Gfx.getSprite(240, 228))
			.setPoints(1500)
			.disableBrush();
		register("OBJ_SEED", Seed, Gfx.getSprite(240, 216))
			.disableBrush()
			.setPoints(500);
		
		register("OBJ_PLANT", Plant, Gfx.getSprite(96, 312))
			.disableBrush();
		register("OBJ_PLANT_GROWING", PlantGrowing, Gfx.getSprite(96, 312)).allowInEditor(false)
			.disableBrush();
		
		
		for (i in 0 ... 4) {
			register("OBJ_ARROW_" +Std.string(i), Arrow, Gfx.getSprite(96 + 16 * i, 24), {type: i})
			.disableBrush();
		}
		
		register("OBJ_GRATE", Grate, Gfx.getSprite(240, 84))
			.disableBrush();
		
		register("OBJ_EXCLAMATION_MARK", ExclamationMark, Gfx.getSprite(192, 12))
			.setPoints(1500)
			.disableBrush();
		
		register("OBJ_OVERALL", Overall, Gfx.getSprite(176, 132))
			.setPoints(1500)
			.disableBrush();
		
		for (i in 0 ... 5) {
			register("OBJ_BAGPACK#" + i, Bagpack, Gfx.getSprite(128 + i * 16, 144), {type: i})
			.disableBrush();
		}
		
		register("OBJ_FOOD#0", Food, Gfx.getSprite(192, 252), {type: 0})
			.setPoints(500)
			.disableBrush();
		register("OBJ_FOOD#1", Food, Gfx.getSprite(192 + 16, 252), {type: 1})
			.setPoints(500)
			.disableBrush();
		
		register("OBJ_TELEPORT_START_0", TeleportStart, Gfx.getSprite(0, 312), {type: 0})
			.disableBrush();
		register("OBJ_TELEPORT_START_1", TeleportStart, Gfx.getSprite(48, 312), {type: 1})
			.disableBrush();
		
		register("OBJ_TELEPORT_END_0", TeleportEnd, Gfx.getSprite(16, 312), {type: 0})
			.disableBrush();
		register("OBJ_TELEPORT_END_1", TeleportEnd, Gfx.getSprite(64, 312), {type: 1})
			.disableBrush();
		
		// Water
		
		register("OBJ_FLIPPERS", Flippers, Gfx.getSprite(96, 144))
			.setPoints(3000)
			.disableBrush();
		
		register("OBJ_WATER_SHALLOW", Water, Gfx.getSprite(0, 72), {type: 0}, Room.LAYER_FLOOR)
			.setRandom([0, 1])
			.setAutoTiles([0, 1], [2, 4, 5, 3]);
		register("OBJ_WATER_DEEP", Water, Gfx.getSprite(16, 72), {type: 1}, Room.LAYER_FLOOR)
			.setRandom([0, 1])
			.setAutoTiles([0, 1], [0, 2, 4, 5, 3]);
			
		register("OBJ_WATER_NW", Water, Gfx.getSprite(80, 72), {type: 2}, Room.LAYER_FLOOR)
			.disableBrush()
			.setAutoTiles([0, 1], [0, 2, 4, 5, 3]);
		register("OBJ_WATER_SW", Water, Gfx.getSprite(96, 72), {type: 3}, Room.LAYER_FLOOR)
			.disableBrush()
			.setAutoTiles([0, 1], [0, 2, 4, 5, 3]);
		register("OBJ_WATER_NE", Water, Gfx.getSprite(112, 72), {type: 4}, Room.LAYER_FLOOR)
			.disableBrush()
			.setAutoTiles([0, 1], [0, 2, 4, 5, 3]);
		register("OBJ_WATER_SE", Water, Gfx.getSprite(128, 72), {type: 5}, Room.LAYER_FLOOR)
			.disableBrush()
			.setAutoTiles([0, 1], [0, 2, 4, 5, 3]);
			
		register("OBJ_WATER_DEADLY", WaterDeadly, Gfx.getSprite(48, 72), null, Room.LAYER_FLOOR)
			.disableBrush();
		
		// Drift
		
		register("DRIFT_S", Drift, Gfx.getSprite(0, 300), {type: 0}, Room.LAYER_DRIFT)
			.disableBrush();
		register("DRIFT_N", Drift, Gfx.getSprite(16, 300), {type: 1}, Room.LAYER_DRIFT)
			.disableBrush();
		register("DRIFT_W", Drift, Gfx.getSprite(32, 300), {type: 2}, Room.LAYER_DRIFT)
			.disableBrush();
		register("DRIFT_E", Drift, Gfx.getSprite(48, 300), {type: 3}, Room.LAYER_DRIFT)
			.disableBrush();
		
		register("DRIFT_NW", Drift, Gfx.getSprite(64, 300), {type: 4}, Room.LAYER_DRIFT)
			.disableBrush();
		register("DRIFT_NE", Drift, Gfx.getSprite(80, 300), {type: 5}, Room.LAYER_DRIFT)
			.disableBrush();
		register("DRIFT_SW", Drift, Gfx.getSprite(96, 300), {type: 6}, Room.LAYER_DRIFT)
			.disableBrush();
		register("DRIFT_SE", Drift, Gfx.getSprite(112, 300), {type: 7}, Room.LAYER_DRIFT)
			.disableBrush();
		
		register("OBJ_BUCKET#0", Bucket, Gfx.getSprite(144, 156), {type: 0})
			.setPoints(1000)
			.disableBrush();
		register("OBJ_BUCKET#1", Bucket, Gfx.getSprite(160, 156), {type: 1})
			.setPoints(1000)
			.disableBrush();

		for (i in 0 ... 5) {
			var ot = register("OBJ_ICE_" + Std.string(i), Ice, Gfx.getSprite(64 + i * 16, 324), {type: i}, Room.LAYER_FLOOR)
				.setAutoTiles([0], [1, 3, 4, 2]);
				
			if (i > 0) {
				ot.disableBrush();
			}
		}
		
		register("OBJ_ICE_DEADLY", IceDeadly, Gfx.getSprite(0, 180))
			.disableBrush();
		
		register("OBJ_ICE_BLOCK", IceBlock, Gfx.getSprite(144, 324))
			.disableBrush();
		
		register("OBJ_THERMOPLATE_0", ThermoPlate, Gfx.getSprite(160, 324), {type: 0}, Room.LAYER_FLOOR)
			.disableBrush();
		register("OBJ_THERMOPLATE_1", ThermoPlate, Gfx.getSprite(176, 324), {type: 1}, Room.LAYER_FLOOR)
			.disableBrush();
		register("OBJ_THERMOPLATE_2", ThermoPlate, Gfx.getSprite(192, 324), {type: 2}, Room.LAYER_FLOOR)
			.disableBrush();
		
		for (i in 0 ... 7) {
			var ot = register("OBJ_WOOD_" + Std.string(i), Wood, Gfx.getSprite(0 + (i * 16), 252), {type: i}, Room.LAYER_FLOOR)
				.setRandom([0, 5, 6])
				.setAutoTiles([0, 5, 6], [1, 4, 3, 2]);
				
			if (i >= 1 && i <= 4) ot.disableBrush();
		}
		
		register("OBJ_WOOD_PATH", WoodPath, Gfx.getSprite(112, 252), null, Room.LAYER_FLOOR)
			.disableBrush();
		
		for (i in 0 ... 2) {
			register("OBJ_GRASS_" + Std.string(i), Grass, Gfx.getSprite(128 + 16 * i, 252), {type: i}, Room.LAYER_FLOOR)
			.disableBrush();
		}
		
		register("OBJ_SHOES", Shoes, Gfx.getSprite(112, 144))
			.setPoints(1500)
			.disableBrush();
		
		register("OBJ_COMPASS", Compass, Gfx.getSprite(176, 252))
			.setPoints(1500)
			.disableBrush();
			
		// Höhle
		
		for (i in 0 ... 13) {
			var ot = register("OBJ_CAVE_" + Std.string(i), Cave, Gfx.getSprite(32 + (i * 16), 180), {type: i}, Room.LAYER_FLOOR)
				.setAutoTiles([1, 3, 4, 6], [7, 5, 0, 2]);
				
			if (i != 12) ot.disableBrush();
		}
		
		// Fels
		
		for (i in 0 ... 9) {
			register("OBJ_BEDROCK_" + Std.string(i), Bedrock, Gfx.getSprite(0 + (i * 16), 264), {type: i}, Room.LAYER_FLOOR)
			.disableBrush();
		}
		
		register("OBJ_BEDROCK_9", Bedrock, Gfx.getSprite(240, 264), {type: 9}, Room.LAYER_FLOOR)
			.disableBrush();
		
		// Pfade
		
		register("OBJ_BEDROCK_PATH", BedrockPath, Gfx.getSprite(240, 180), null, Room.LAYER_FLOOR);
			
		register("OBJ_PATH", Path, Gfx.getSprite(224, 120), null, Room.LAYER_FLOOR);
		
		// Electric Stuff
		register("MARKER_0", Marker, Gfx.getSprite(0, 348), {type:0}, Room.LAYER_MARKER)
			.disableBrush();
		register("MARKER_1", Marker, Gfx.getSprite(16, 348), {type:1}, Room.LAYER_MARKER)
			.disableBrush();
		register("MARKER_2", Marker, Gfx.getSprite(32, 348), {type:2}, Room.LAYER_MARKER)
			.disableBrush();
		register("MARKER_3", Marker, Gfx.getSprite(48, 348), {type:3}, Room.LAYER_MARKER)
			.disableBrush();
		register("MARKER_4", Marker, Gfx.getSprite(64, 348), {type:4}, Room.LAYER_MARKER)
			.disableBrush();
		
		register("OBJ_ELECTRIC_DOOR_0", ElectricDoor, Gfx.getSprite(0, 336), {type: 0})
			.disableBrush();
		register("OBJ_ELECTRIC_DOOR_1", ElectricDoor, Gfx.getSprite(16, 336), {type: 1})
			.disableBrush();
		
		register("OBJ_ELECTRIC_FLOOR_PLATE_0", ElectricFloorPlate, Gfx.getSprite(32, 336), {type: 0}, Room.LAYER_FLOOR)
			.disableBrush();
		register("OBJ_ELECTRIC_FLOOR_PLATE_1", ElectricFloorPlate, Gfx.getSprite(48, 336), {type: 1}, Room.LAYER_FLOOR)
			.disableBrush();
		
		register("OBJ_ROBOT_FACTORY_0", RobotFactory, Gfx.getSprite(0, 324), {type: 0})
			.disableBrush();
		register("OBJ_ROBOT_FACTORY_1", RobotFactory, Gfx.getSprite(16, 324), {type: 1})
			.disableBrush();
		
		register("OBJ_TARGET", Target, Gfx.getSprite(64, 336))
			.disableBrush();
		
		register("OBJ_MIRROR_0", Mirror, Gfx.getSprite(32, 324), {type: 0})
			.disableBrush();
		register("OBJ_MIRROR_1", Mirror, Gfx.getSprite(48, 324), {type: 1})
			.disableBrush();
		
		for (i in 0 ... 4) {
			register("OBJ_SHOOTER_" + Std.string(i), Shooter, Gfx.getSprite(80 + (i * 16), 336), {type: i}, Room.LAYER_OVERLAY)
			.disableBrush();
		}
	}
	
	public function register(id:String, c:Dynamic, spr:Sprite, ?d:Dynamic = null, ?layer:Int = Room.LAYER_LEVEL_0):ObjectTemplate {
		var _class:Class<Entity> = null;
		
		if (d == null) d = {};
		
		if (Std.isOfType(c, String)) {
			_class = cast Type.resolveClass(c);
			
			if (_class == null) {
				_class = cast Type.resolveClass("world.entities.std." + c);
			}
		} else {
			_class = c;
		}
		
		var ot:ObjectTemplate = new ObjectTemplate(id, length, _class, d, spr, layer);
		
		list.set(id, ot);
		length++;

		// Objekte nach Typ filtern...
		var e = Type.createEmptyInstance(_class);
		if (e != null) {
			if (Std.isOfType(e, EntityItem)) {
				listItems.push(ot);
			} else if (Std.isOfType(e, EntityFloor)) {
				listFloors.push(ot);
			}
		}
		
		return ot;
	}
	
	public function get(index:Int):ObjectTemplate {
		var oe:ObjectTemplate = null;
		
		for (key in list.keys()) {
			oe = list.get(key);
			if (oe.index == index) return oe;
		}
		
		return null;
	}
	
	public function findFromID(id:String):ObjectTemplate {
		for (key in list.keys()) {
			var oe:ObjectTemplate = list.get(key);
			
			if (oe.name == id) return oe;
		}
		
		return null;
	}
	
	public function findFromObject(o:Dynamic, ?checkForType:Bool = true):ObjectTemplate {
		for (key in list.keys()) {
			var oe:ObjectTemplate = list.get(key);
			
			if (oe.classPath == Type.getClass(o)) {
				if (checkForType) {
					if (Reflect.hasField(oe.data, "type")) { 
						if (oe.data.type == cast(o, Entity).type) return oe;
					} else {
						return oe;
					}
				} else {
					return oe;
				}
			}
		}
		
		trace("Template not found for: " + Type.getClass(o));
		return null;
	}
	
	public function create(id:Dynamic):Entity {
		var oe:ObjectTemplate;
		
		if (Std.isOfType(id, String)) {
			oe = list.get(id);
		} else {
			oe = get(cast id);
		}
		
		var e:Entity = null;
		
		if (oe != null) {
			e = oe.create();
		}
		
		return e;
	}
}

class ObjectTemplate {
	public var canBePlaced:Bool = true;
	public var allowBrush:Bool = true;
	
	public var random:Array<Int>;
	
	public var autoEdges:Array<Int> = null;
	public var autoFull:Array<Int> = null;
	
	public var index:Int = -1;
	public var name:String;
	public var classPath:Class<Entity>;
	public var data:Dynamic;
	
	public var spr:Sprite;
	public var sprBlack:Sprite;
	
	public var points:Int;
	
	public var layer:Int;
	
	public var editorName:String;
	
	public function new(id:String, index:Int, c:Class<Entity>, d:Dynamic, spr:Sprite, ?layer:Int = Room.LAYER_LEVEL_0) {
		this.name = id;
		this.index = index;
		this.classPath = c;
		this.data = d;
		this.spr = spr;
		this.sprBlack = spr;
		this.layer = layer;
		
		if (d != null) {
			if (Reflect.field(d, "type") != null) {
				this.random = [Reflect.field(d, "type")];
			}
		} else {
			this.random = [0];
		}
		
		this.editorName = GetText.get(id);
		
		var e = Type.createEmptyInstance(c);
		if (e != null) {
			if (Std.isOfType(e, EntityItem)) {
				var temp:String = GetText.get(id + "_DESC");
				temp = GetText.get(id.split("#")[0] + "_PICKUP");
			}
		}
	}
	
	public function isTileable(t:Int):Bool {
		for (a in autoFull) {
			if (a == t) return true;
		}
		
		return false;
	}
	
	public function setAutoTiles(f:Array<Int>, e:Array<Int>):ObjectTemplate {
		this.autoFull = f;
		this.autoEdges = e;
		
		return this;
	}
	
	public function getAutoTile(index:Int):Int {
		if (this.autoEdges == null || index < 0 || index > 4) {
			if (data != null) {
				if (Reflect.field(data, "type") != null) {
					return Reflect.field(data, "type");
				}
			}
		} else {
			return this.autoEdges[index];
		}
		
		return 0;
	}
	
	public function setRandom(rnd:Array<Int>):ObjectTemplate {
		this.random = rnd;
		return this;
	}
	
	public function allowInEditor(v:Bool):ObjectTemplate {
		this.canBePlaced = v;
		return this;
	}
	
	public function disableBrush():ObjectTemplate {
		this.allowBrush = false;
		return this;
	}
	
	public function setPoints(p:Int):ObjectTemplate {
		this.points = p;
		
		return this;
	}
	
	public function create():Entity {
		var e:Entity = Type.createInstance(classPath, []);
		
		if (e != null) {
			e.parseData(data);
		}
		
		return e;
	}
	
	public function createRandom():Entity {
		var e:Entity = Type.createInstance(classPath, []);
		
		if (e != null && random != null) {
			e.parseData(data);
			e.type = random[Std.random(random.length)];
		}
		
		if (e.type == -1) return null;
		return e;
	}
	
	function toString() {
		return Std.string(index) + "# " + Std.string(classPath);
	}
	
	public function isRoof():Bool {
		return layer == Room.LAYER_ROOF;
	}
	
	public function isFloor():Bool {
		return layer == Room.LAYER_FLOOR;
	}
}