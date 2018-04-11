package world;

import haxe.Timer;
import lime.math.Vector2;
import screens.PlayScreen;
import ui.Dialog;
import ui.DialogMessage;
import world.entities.Entity;
import world.entities.std.Charlie;
import tjson.TJSON;
import world.entities.std.StartPosition;
import screens.IntroScreen;
import ui.DialogInput;

/**
 * ...
 * @author Matthias Faust
 */
class World {
	public var editing:Bool = false;
	
	public var file:FileEpisode;
	
	public var factory:ObjectFactory;
	
	private var roomCurrent:Room;
	public var room(get, null):Room;
	
	public var rooms:RoomList;
	
	public var player:Charlie;
	public var playerName:String = null;
	
	public var oldPlayerX:Int = 0;
	public var oldPlayerY:Int = 0;
	
	// Temporär?
	var inRoomX:Int = 0;
	var inRoomY:Int = 0;
	var inRoomZ:Int = 0;
	
	public var inventory:Inventory;
	
	public var lives:Int = 3;
	public var points:Int = 0;
	public var gold:Int = 0;
	
	public var pointsAnim:Int = 0;
	
	public var garlic:Float = 0;
	
	public var flags:Array<Bool> = [false, false, false, false, false];
	
	public var game:Tobor;
	
	private var visitedRooms:Map<String, Bool>;
	private var firstUse:Map<String, Bool>;
	
	public var highScore:Highscore;
	
	// AFTER_UPDATE Aktionen
	var actionSaveGame:Bool = false;
	
	var actionLoadGame:Bool = false;
	
	var actionResetRoom:Bool = false;
	
	var actionTeleport:Bool = false;
	var actionTeleportTarget:Entity = null;
	
	var actionStairs:Bool = false;
	var actionStairsTarget:Entity = null;
	
	var actionChangeRoom:Bool = false;
	var actionChangeRoomDirection:Vector2 = null;
	
	public var episodeWon:Bool = false;
	public var episodeLost:Bool = false;
	
	public function new(game:Tobor, file:FileEpisode) {
		this.game = game;
		this.file = file;
		
		factory = new ObjectFactory();
		
		rooms = new RoomList();
		
		highScore = new Highscore();
		highScore.load(file.loadHighscore());
	}
	
	public function init(?fileName:String = null) {
		visitedRooms = new Map<String, Bool>();
		firstUse = new Map<String, Bool>();
		
		player = cast factory.create("OBJ_CHARLIE");
		player.setPosition(0, 0);
		oldPlayerX = 0;
		oldPlayerY = 0;
		
		inventory = new Inventory();
		
		gold = 0;
		lives = 3;
		points = 0;
		garlic = 0;
		
		Text.loadForWorld(file.loadFile('translation.json'));
		
		var content:String;
		
		if (fileName == null) {
			content = file.loadFile('rooms.json');
			playerName = null;
		} else {
			content = file.loadSavegame(fileName);
		}
		
		if (content == null) { 
			rooms.add(createRoom(0, 0, 0));
			switchRoom(0, 0, 0);
		
			var sp:StartPosition = cast factory.create("OBJ_START_POSITION");
			room.addEntity(sp);
			
			player.setRoom(roomCurrent);
		} else {
			loadData(content);
			
			switchRoom(inRoomX, inRoomY, inRoomZ);
			room.restoreState();
			player.setRoom(roomCurrent);
		}
		
		flags = [false, false, false, false, false];
		
		episodeWon = false;
		episodeLost = false;
		
		pointsAnim = points;
	}
	
	public function start() {
		Input.wait(0.25);
		Input.clearKeys();
		
		// Startposition suchen...
		var sp:StartPosition = null;
		
		for (r in rooms) {
			if (sp == null) {
				sp = r.findStartPosition();
				
				if (sp != null) {
					oldPlayerX = Std.int(sp.x);
					oldPlayerY = Std.int(sp.y);
			
					player.setPosition(oldPlayerX, oldPlayerY);
				
					switchRoom(r.position.x, r.position.y, r.position.z);
					room.restoreState();
				}
			}
		}

		if (room != null) {
			room.start();
		} else {
			trace("World.start: no room!");
		}
	}
	
	public function checkHighScore() {
		if (playerName != null && playerName != "" && points > 0) {
			var roomsVisited:Int = Lambda.count(visitedRooms);
			highScore.add(playerName, points, roomsVisited);
			
			file.saveHighscore(highScore.save());
		}
		
		game.setScreen(new IntroScreen(game));
	}
	
	public function clearStartPositions() {
		for (r in rooms) {
			r.removeStateEntity(StartPosition);
		}
	}
	
	public function update(deltaTime:Float) {
		if (pointsAnim < points) {
			pointsAnim = pointsAnim + 50;
			if (pointsAnim > points) pointsAnim = points;
		}
		
		if (garlic > 0) {
			garlic = garlic - deltaTime;
			if (garlic < 0) garlic = 0;
		}
		
		if (player != null) player.update(deltaTime);
		if (roomCurrent != null) roomCurrent.update(deltaTime);
		
		// AFTER-UPDATE Aktionen durchführen
		
		if (actionChangeRoom) {
			actionChangeRoom = false;

			if (actionChangeRoomDirection != null) {
			
				var rx:Int = Std.int(room.position.x + actionChangeRoomDirection.x);
				var ry:Int = Std.int(room.position.y + actionChangeRoomDirection.y);
				var rz:Int = room.position.z;
			
				if (rooms.find(rx, ry, rz) != null) {
					if (actionChangeRoomDirection.x < 0) {
						player.x = Room.WIDTH - 1;
					} else if (actionChangeRoomDirection.x > 0) {
						player.x = 0;
					}
					
					if (actionChangeRoomDirection.y < 0) {
						player.y = Room.HEIGHT - 1;
					} else if (actionChangeRoomDirection.y > 0) {
						player.y = 0;
					}
				
					if (!editing) game.world.room.saveState();
					switchRoom(rx, ry, rz);
					game.world.room.restoreState();
				
					var atTarget:Array<Entity> = room.getAllEntitiesAt(player.x, player.y, player);
					for (e in atTarget) {
						e.onEnter(player, actionChangeRoomDirection);
					}
				
					var playScreen:PlayScreen = cast game.getScreen();
					playScreen.showRoomName();
				
					Input.wait(0.25);
				}
			
				actionChangeRoomDirection = null;
			}
		}
		
		if (actionTeleport) {
			if (actionTeleportTarget != null) {
				actionTeleport = false;
				
				var t = actionTeleportTarget;
			
				game.world.room.saveState();
				switchRoom(t.room.position.x, t.room.position.y, t.room.position.z);
				game.world.room.restoreState();
			
				player.setPosition(t.gridX, t.gridY);
				actionTeleportTarget = null;
				
				var playScreen:PlayScreen = cast game.getScreen();
				playScreen.showRoomName();
				
				Input.wait(0.25);
			}
		}
		
		if (actionStairs) {
			if (actionStairsTarget != null) {
				actionStairs = false;
				
				var t = actionStairsTarget;
			
				game.world.room.saveState();
				switchRoom(t.room.position.x, t.room.position.y, t.room.position.z);
				game.world.room.restoreState();
			
				player.setPosition(t.gridX, t.gridY);
				actionStairsTarget = null;
				
				var playScreen:PlayScreen = cast game.getScreen();
				playScreen.showRoomName();
				
				Input.wait(0.25);
			}
		}
		
		if (actionResetRoom) {
			actionResetRoom = false;
		}
		
		if (actionSaveGame) {
			actionSaveGame = false;
			
			if (!editing) {
				var d:DialogInput = new DialogInput(game.getScreen(), 0, 0, Text.get("TXT_ASK_FOR_SAVEGAME_NAME"));
		
				d.onOk = function () {
					var fileName:String = d.getInput(true);
					
					if (fileName != "" && fileName != null) {
						room.onRoomEnd();
						room.saveState();
						
						saveGame(fileName);
						
						inventory.remove("OBJ_CLOCK", 1);
						
						game.getScreen().hideDialog();
					}
				};
		
				showDialog(d);
			}
		}
		
		if (actionLoadGame) {
			actionLoadGame = false;
			
			/*
			if (!editing) {
				var playScreen:PlayScreen = cast game.getScreen();
				playScreen.showLoadgameDialog();
			}
			*/
		}
	}
	
	public function render(?editMode:Bool = false) {
		if (roomCurrent != null) roomCurrent.render(editMode);
	}
	
	function get_room():Room {
		return roomCurrent;
	}
	
	public function createRoom(x:Int, y:Int, z:Int, ?data:Dynamic = null):Room {
		var r:Room = rooms.find(x, y, z);
		
		if (r == null) {
			r = new Room(this);
			r.position.x = x;
			r.position.y = y;
			r.position.z = z;
			
			r.getName();
		}
		
		return r;
	}
	
	public function switchRoom(x:Int, y:Int, z:Int) {
		var r:Room = rooms.find(x, y, z);
		
		if (r != null) {
			if (roomCurrent != null) {
				// aktuellen Raum beenden!
				roomCurrent.onRoomEnd();
			}
			roomCurrent = r;
			player.setRoom(roomCurrent);
			
			roomCurrent.onRoomStart();
		}
	}
	
	public function changeRoom(d:Vector2) {
		actionChangeRoom = true;
		actionChangeRoomDirection = d;
	}
	
	public function markFirstUse(id:String) {
		firstUse.set(id, true);
	}
	
	public function checkFirstUse(id:String) {
		if (firstUse.exists(id)) {
			return firstUse.get(id);
		} else {
			return false;
		}
	}
	
	public function markRoomVisited() {
		visitedRooms.set(room.getID(), true);
	}
	
	public function roomVisited():Bool {
		if (visitedRooms.get(room.getID()) == true) {
			return true;
		}
		
		return false;
	}
	
	public function stairsFrom(e:Entity) {
		var target:Entity;
		
		for (r in rooms) {
			if (r.position.x == room.position.x && r.position.y == room.position.y) {
				if (e.type == 1 && r.position.z > room.position.z) { 
					target = r.findStairs(e.gridX, e.gridY, 0);
				} else if (e.type == 0 && r.position.z < room.position.z) {
					target = r.findStairs(e.gridX, e.gridY, 1);
				} else {
					target = null;
				}
			
				if (target != null) {
					actionStairs = true;
					actionStairsTarget = target;
					return;
				}
			}
		}
	}
	
	public function teleportFrom(e:Entity) {
		var target:Entity;
		
		// im aktuellen Raum
		target = room.findTeleportTarget(e.type, e.content);
		
		if (target != null) {
			player.setPosition(target.gridX, target.gridY);
			return;
		}
		
		// freie Teleporter NUR im aktuellen Raum
		if (e.content == null) return;
		
		// in allen Räumen
		for (r in rooms) {
			target = r.findTeleportTargetState(e.type, e.content);
			
			if (target != null) {
				actionTeleport = true;
				actionTeleportTarget = target;
				return;
			}
		}
	}
	
	public function addPoints(p:Int) {
		points = points + p;
	}
	
	public function showDialog(dialog:Dialog) {
		game.showDialog(dialog);
	}
	
	public function hideDialog() {
		game.getScreen().hideDialog();
	}
	
	public function showMessage(key:String, ?smallFont:Bool = true, ?cb:Dynamic = null) {
		var msg:String = Text.getFromWorld(key);
		if (msg != "") {
			var messageBox:DialogMessage = new DialogMessage(game.getScreen(), 0, 0, msg, smallFont);
		
			if (cb != null) {
				messageBox.onOk = cb;
				messageBox.onCancel = cb;
			}
			
			showDialog(messageBox);
		}
	}
	
	public function showPickupMessage(key:String, ?smallFont:Bool = true, ?cb:Dynamic = null, ?p:Int = 0) {
		var msg:String = Text.getFromWorld(key);
		if (p > 0) {
			msg = msg + "\n\n" + Text.get("TXT_BONUS") + " : " + Std.string(p) + " " + Text.get("TXT_POINTS") + " !";
		}
		
		if (msg != "") {
			var messageBox:DialogMessage = new DialogMessage(game.getScreen(), 0, 0, msg, smallFont);
		
			if (cb != null) {
				messageBox.onOk = cb;
				messageBox.onCancel = cb;
			}
			
			showDialog(messageBox);
		}
	}
	
	// Save / Load
	
	public function load() {
		var content:String = file.loadFile('rooms.json');
		if (content != null) loadData(content);
	}
	
	public function doSaveGame() {
		actionSaveGame = true;
	}
	
	public function saveGame(fileName:String) {
		var content:String;

		content = saveData();
		file.saveSavegame(fileName, content);
	}
	
	public function loadGame(fileName:String) {
		var content:String = file.loadSavegame(fileName);

		loadData(content);
			
		switchRoom(inRoomX, inRoomY, inRoomZ);
		player.setRoom(roomCurrent);
	}
	
	public function save() {
		var content:String;
		
		Text.loadForWorld(file.loadFile('translation.json'));
		Text.loadForWorld(file.loadFile('translation_missing.json'));
		
		content = saveData();
		file.saveFile('rooms.json', content);
		
		if (editing) {
			content = Text.saveForWorld();
			file.saveFile('translation.json', content);
		
			content = Text.saveForWorldMissing();
			file.saveFile('translation_missing.json', content);
		}
	}
	
	function saveData():String {
		var data:Map<String, Dynamic> = new Map<String, Dynamic>();
		
		if (!editing) {
			data.set("garlic", garlic);
			data.set("gold", gold);
			data.set("points", points);
			data.set("lives", lives);
			
			if (playerName != null) {
				data.set("playerName", playerName);
			}
			
			// firstUse
			
			var firstUseData:Array<String> = [];
		
			for (vr in firstUse.keys()) {
				firstUseData.push(vr);
			}
		
			data.set("firstUse", firstUseData);
			
			// besuchte Räume
			
			var visitedData:Array<String> = [];
		
			for (vr in visitedRooms.keys()) {
				visitedData.push(vr);
			}
		
			data.set("visited", visitedData);
			
			data.set("inventory", inventory.save());
		}
		
		var playerData:Map<String, Dynamic> = player.saveData();
		
		playerData.set("inRoomX", roomCurrent.position.x);
		playerData.set("inRoomY", roomCurrent.position.y);
		playerData.set("inRoomZ", roomCurrent.position.z);
		
		data.set("player", playerData);
		data.set("flags", flags);
		
		for (r in rooms) {
			var worldData:Map<String, Dynamic> = new Map();
			
			if (!editing) {
				worldData.set("treeTimer", r.treeTimer);
			}
			
			worldData.set("x", r.position.x);
			worldData.set("y", r.position.y);
			worldData.set("z", r.position.z);
			
			worldData.set("data", r.save());
			
			data.set(r.getID(), worldData);
		}
		
		return TJSON.encode(data, 'fancy');
	}
	
	function loadData(fileData:String) {
		roomCurrent = null;
		rooms = new RoomList();

		var data = TJSON.parse(fileData);
		
		for (key in Reflect.fields(data)) {
			parseKey(key, data);
		}
	}
	
	function parseKey(key, data) {
		switch(key) {
			case "garlic":
				if (!editing) garlic = Reflect.field(data, "garlic");
			case "gold":
				if (!editing) gold = Reflect.field(data, "gold");
			case "points":
				if (!editing) points = Reflect.field(data, "points");
			case "lives":
				if (!editing) lives = Reflect.field(data, "lives");
			case "inventory":
				if (!editing) inventory.load(factory, Reflect.field(data, "inventory"));
			case "playerName":
				if (!editing) playerName = cast Reflect.field(data, "playerName");
			case "firstUse":
				if (!editing) {
					firstUse = new Map<String, Bool>();
				
					var vrs:Array<String> = Reflect.field(data, "firstUse");
					for (vr in vrs) {
						firstUse.set(vr, true);
					}
				}
			case "visited":
				if (!editing) {
					visitedRooms = new Map<String, Bool>();
				
					var vrs:Array<String> = Reflect.field(data, "visited");
					for (vr in vrs) {
						visitedRooms.set(vr, true);
					}
				}
			case "player":
				parsePlayer(Reflect.field(data, "player"));
			case "flags":
				flags = Reflect.field(data, "flags");
			default:
				if (StringTools.startsWith(key, "ROOM_")) {
					parseRoom(Reflect.field(data, key));
				} else {
					// Debug.error(this, "Unknown key '" + key + "' in WorldData!");
				}
			}
	}
	
	function parseRoom(data) {
		var rx:Int = -1;
		var ry:Int = -1;
		var rz:Int = -1;
		var rdata = null;
		var rtree:Float = 0;
		
		for (key in Reflect.fields(data)) {
			switch(key) {
			case "treeTimer":
				if (!editing) {
					rtree = Reflect.field(data, "treeTimer");
				}
			case "x":
				rx = Reflect.field(data, "x");
			case "y":
				ry = Reflect.field(data, "y");
			case "z":
				rz = Reflect.field(data, "z");
			case "data":
				rdata = Reflect.field(data, "data");
			default:
			}
		}
		
		var newRoom:Room = new Room(this, rx, ry, rz);
		newRoom.load(rdata);
		newRoom.getName();
		
		rooms.add(newRoom);
		switchRoom(rx, ry, rz);
	}
	
	function parsePlayer(data) {
		player.parseData(data);
		
		oldPlayerX = Std.int(player.x);
		oldPlayerY = Std.int(player.y);
		
		for (key in Reflect.fields(data)) {
			switch(key) {
			case "inRoomX":
				inRoomX = Reflect.field(data, "inRoomX");
			case "inRoomY":
				inRoomY = Reflect.field(data, "inRoomY");
			case "inRoomZ":
				inRoomZ = Reflect.field(data, "inRoomZ");
			default:
			}
		}
	}
	
	public function getName():String {
		return file.getName();
	}
}