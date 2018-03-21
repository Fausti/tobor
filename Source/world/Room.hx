package world;

import world.World;
import world.entities.Entity;
import world.entities.EntityRoof;
import world.entities.std.Charlie;
import world.entities.std.Robot;
import world.ObjectFactory.ObjectTemplate;

/**
 * ...
 * @author Matthias Faust
 */
class Room {
	public static inline var LAYER_FLOOR:Int = 0;
	public static inline var LAYER_LEVEL_0:Int = 10;
	public static inline var LAYER_LEVEL_1:Int = 20;
	public static inline var LAYER_ROOF:Int = 30;
	
	public static inline var WIDTH:Int = 40;
	public static inline var HEIGHT:Int = 28;
	
	public var world:World;
	public var x:Int;
	public var y:Int;
	public var z:Int;
	
	// Objectlisten
	private var entities:EntityList;
	public var length(get, null):Int;
	
	public var robots:Int = 0;
	public var underRoof:Bool = false;
	
	function get_length():Int {
		return entities.length;
	}
	
	public function new(w:World, ?x:Int = 0, ?y:Int = 0, ?z:Int = 0) {
		this.world = w;
		this.x = x;
		this.y = y;
		this.z = z;
		
		entities = new EntityList(this);
	}
	
	public function update(deltaTime:Float) {
		var listRemove:Array<Entity> = [];
		
		// Anzahl lebender Roboter
		robots = 0;
		for (e in entities.getTicking()) {
			if (Std.is(e, Robot)) robots++;
		}
		
		for (e in entities.getTicking()) {
			if (e.alive) {
				e.update(deltaTime);
			}
			
			if (!e.alive) {
				listRemove.push(e);
			}
		}
		
		for (e in listRemove) {
			removeEntity(e);
		}

		underRoof = false;
		
		var atPlayerPos:Array<Entity> = getEntitiesAt(world.player.x, world.player.y, world.player);
		for (e in atPlayerPos) {
			if (Std.is(e, EntityRoof)) {
				underRoof = true;
				return;
			}
		}
	}
	
	public function render(?editMode:Bool = false) {
		var playerDrawn:Bool = false;
		
		entities.getAll().sort(function (a:Entity, b:Entity):Int {
			if (a.z < b.z) return -1;
			if (a.z > b.z) return 1;
			return 0;
		});
		
		for (e in entities.getAll()) {
			if (e.z > world.player.z) {
				if (!playerDrawn) {
					playerDrawn = true;
					if (world.player != null) {
						if (editMode) world.player.render_editor();
						else world.player.render();
					}
				}
			}
			
			if (editMode) e.render_editor();
			else e.render();
		}
		
		if (!playerDrawn) {
			if (world.player != null) {
				if (editMode) world.player.render_editor();
				else world.player.render();
			}
		}
	}
	
	public function spawnEntity(x:Float, y:Float, e:Entity) {
		e.x = x;
		e.y = y;
		
		addEntity(e);
	}
	
	public function addEntity(e:Entity) {
		if (Std.is(e, Charlie)) {
			trace("Player shouldn't added to rooms!");
			return;
		}
		
		entities.add(e);
		
		entities.getAll().sort(function (a:Entity, b:Entity):Int {
			if (a.z < b.z) return -1;
			if (a.z > b.z) return 1;
			return 0;
		});
	}
	
	public function removeEntity(e:Entity) {
		entities.remove(e);
	}
	
	public function getCollisionsAt(x:Float, y:Float, ?without:Entity = null):Array<Entity> {
		var listTarget:Array<Entity> = entities.getAll().filter(function(e):Bool {
			return e.collisionAt(x, y);
		});
		
		if (without != null) listTarget.remove(without);
		
		return listTarget;
	}
	
	public function getEntitiesAt(x:Float, y:Float, ?without:Entity = null):Array<Entity> {
		var listTarget:Array<Entity> = entities.getAt(x, y, without);
		
		return listTarget;
	}
	
	public function findEntityAt(x:Float, y:Float, cl:Dynamic):Array<Entity> {
		var listTarget:Array<Entity> = entities.getAll().filter(function(e):Bool {
			return e.gridX == Std.int(x) && e.gridY == Std.int(y) && e.alive && Std.is(e, cl);
		});
		
		return listTarget;
	}
	
	public function getPlayer():Charlie {
		return world.player;
	}
	
	// Save / Load
	
	public function saveState() {
		entities.saveState();
	}
	
	public function restoreState() {
		entities.restoreState();
	}
	
	public function load(data) {
		for (entry in cast(data, Array<Dynamic>)) {
			var template:ObjectTemplate = world.factory.findFromID(entry.id);
			
			var obj = template.create();
			obj.parseData(entry);
			
			addEntity(obj);
		}
		
		saveState();
	}
	
	public function save():Array<Map<String, Dynamic>> {
		entities.saveState();
		
		var data:Array<Map<String, Dynamic>> = [];
		
		for (e in entities.getState()) {
			if (e != null) {
				if (!Std.is(e, Charlie)) {
					if (e.canSave()) {
						data.push(e.saveData());
					}
				}
			}
		}
		
		return data;
	}
	
	// STATIC
	
	public static function isOutsideMap(x:Float, y:Float):Bool {
		return x < 0 || x >= Room.WIDTH || y < 0 || y >= Room.HEIGHT;
	}
}