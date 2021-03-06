package world.entities.std;

import lime.math.Vector2;
import world.entities.EntityDynamic;

/**
 * ...
 * @author Matthias Faust
 */

typedef MoveData = {
	var distanceLeft:Float;
	var direction:Vector2;
	var speedMovement:Float; // Tiles per second
	
	var oldPositionX:Int;
	var oldPositionY:Int;
}

class Bullet extends EntityDynamic {
	public static var BULLET_SPEED:Float = 4;
	
	var wasMoving:Bool = false;
	var moveData:MoveData;
	
	var traveled:Int = 0;
	var travelDirection:Vector2 = Direction.NONE;
	var MAX_DISTANCE:Int = 0;
	
	public function new() {
		super();
		
		setSprite(Gfx.getSprite(144, 60));
		
		moveData = {
			direction: Direction.NONE,
			speedMovement:0.0,
			distanceLeft: 0.0,
			
			oldPositionX: -1,
			oldPositionY: -1,
		}
		
		MAX_DISTANCE = Std.random(10) + 10;
	}
	
	override public function update(deltaTime:Float) {
		if (!isMoving() && wasMoving) {
			onStopMoving();
			wasMoving = false;
			
			moveData.oldPositionX = Std.int(x);
			moveData.oldPositionY = Std.int(y);
		}
		
		if (isMoving()) {
			processMovement(deltaTime);
			wasMoving = true;
			
			if (traveled >= 1) { // wenn noch kein ganzes Feld geflogen tun wir niemandem weh!
				// haben wir unterwegs einen Roboter erwischt?
				var ais = room.getCollisionsWithAI(x + (5.5 / 16), y + (5.5 / 16), 5 / 16, 5 / 16);
				var will_die:Bool = false;
				
				for (ai in ais) {
					if (Std.isOfType(ai, Scorpion)) {
						if (ai.type > 0) {
							ai.die();
							will_die = true;
						}
					} else {
						ai.die();
						will_die = true;
					}
				}
			
				if (will_die) die();
			}
		}
		
		if (!isMoving()) {
			move(travelDirection, (BULLET_SPEED));
		}
		
		super.update(deltaTime);
	}
	
	override public function render() {
		super.render();
	}
	
	override public function isMoving():Bool {
		if (moveData.direction != Direction.NONE) {
			return true;
		} else {
			return false;
		}
	}
	
	public function changeSpeed(spd:Float) {
		moveData.speedMovement = spd;
	}
	
	public function move(direction:Vector2, speed:Float, ?dist:Int = 1):Bool {
		if (direction == Direction.NONE) return false;
		
		if (!isMoving()) {
			speed = Config.getSpeed(speed);
			
			// dann bewegen wir uns mal...
			moveData.direction = direction;
			moveData.speedMovement = speed;
			moveData.distanceLeft = dist;
			
			travelDirection = direction;
			
			moveData.oldPositionX = Std.int(x);
			moveData.oldPositionY = Std.int(y);
			
			onStartMoving();
			
			return true;
		}
		
		return false;
	}
	
	function processMovement(deltaTime:Float) {
		var distance:Float = 0;

		distance = deltaTime * moveData.speedMovement;
		
		if (distance > moveData.distanceLeft) {
			distance = moveData.distanceLeft;
			moveData.distanceLeft = 0.0;
		} else {
			moveData.distanceLeft -= distance;
		}
		
		x += (moveData.direction.x * distance);
		y += (moveData.direction.y * distance);
		
		if (moveData.distanceLeft == 0.0) {
			traveled++;
			
			x = Math.fround(x);
			y = Math.fround(y);
			
			var atTarget:Array<Entity> = room.getEntitiesAt(gridX, gridY, this);
			
			var oldDirection = moveData.direction;
			moveData.direction = Direction.NONE;
			
			for (e in atTarget) {
				e.onEnter(this, oldDirection);
				onHit(e, oldDirection);
			}
			
			if (Room.isOutsideMap(x, y)) {
				die();
				return;
			}
			
			if (traveled >= MAX_DISTANCE) {
				var atTarget:Array<Entity> = room.getEntitiesAt(x, y, this);
				
				if (atTarget.length == 0) {
					var munition:Munition = new Munition();
					room.spawnEntity(x, y, munition);
					die();
					
					return;
				}
				
				for (e in atTarget) {
					onFallDown(e);
				}
				
				die();
			}
		}
	}
	
	function onStartMoving() {
		
	}
	
	function onStopMoving() {
		
	}
	
	function onHit(other:Entity, direction:Vector2) {
		if (!alive) return;
		
		if (Std.isOfType(other, Bullet)) {
			
		} else if (Std.isOfType(other, Isolator)) {
			other.canEnter(this, direction, (BULLET_SPEED));
			die();
		} else if (Std.isOfType(other, IceBlock)) {
			other.canEnter(this, direction, (BULLET_SPEED));
			die();
		} else if (Std.isOfType(other, Tunnel)) {
			die();
		} else if (Std.isOfType(other, ElectricFence)) {
			other.die();
			die();
			
			room.spawnEntity(x, y, new Explosion());
			Sound.play(Sound.SND_EXPLOSION_ROBOT);
		} else if (Std.isOfType(other, Skull)) {
			other.die();
			die();
			
			room.spawnEntity(x, y, new Explosion());
			Sound.play(Sound.SND_EXPLOSION_ROBOT);
		} else if (Std.isOfType(other, Scorpion)) {
			if (other.type > 0) {
				other.die();
				die();
			}
		} else if (Std.isOfType(other, EntityAI)) {
			if (alive) {
				other.die();
				die();
			}
		} else if (Std.isOfType(other, Munition) || Std.isOfType(other, Explosion) || Std.isOfType(other, Grate)) {
			// Nüscht...
		} else if (Std.isOfType(other, Water) || Std.isOfType(other, WaterDeadly) || Std.isOfType(other, WaterIsolator)) {
			if (other.subType > 0) {
				if (!other.canEnterSubType(this, direction, Bullet.BULLET_SPEED)) {
					die();
				}
			}
		} else if (Std.isOfType(other, Wall)) {
			die();
		} else if (Std.isOfType(other, Cave)) {
			die();
		} else if (Std.isOfType(other, Bedrock)) {
			die();
		} else if (Std.isOfType(other, Mountain)) {
			die();
		} else if (Std.isOfType(other, Wood)) {
			die();
		} else if (Std.isOfType(other, EntityFloor)) {
			if (other.subType > 0) {
				if (!other.canEnterSubType(this, direction, Bullet.BULLET_SPEED)) {
					die();
				}
			}
		} else if (Std.isOfType(other, Target)) {
			if (other.flag != Marker.MARKER_NO) {
				room.switchStatus(other.flag);
			}
			
			die();
		} else if (Std.isOfType(other, Mirror)) {
			var bullet:Bullet = new Bullet();
			room.spawnEntity(x, y, bullet);
			
			var newDir:Vector2 = Direction.NONE;
			
			switch (other.type) {
				case 0:
					newDir = mirror(direction, false);
				case 1:
					newDir = mirror(direction, true);
			}
			
			bullet.move(newDir, (Bullet.BULLET_SPEED));
				
			die();
		} else if (Std.isOfType(other, AndroidEgg)) {
			room.spawnEntity(other.x, other.y, new Explosion());
			var rob:Robot = new Robot();
			room.spawnEntity(other.x, other.y, rob);

			other.die();
			die();
		} else {
			die();
		}
	}
	
	function onFallDown(other:Entity) {
		if (Std.isOfType(other, Munition)) {
			if (other.type < 5) {
				other.type++;
			} else {
				var munition:Munition = new Munition();
				room.spawnEntity(x, y, munition);
			}
		}
	}
	
	public static function mirror(d:Vector2, ?clockwise:Bool = true):Vector2 {
		if (d == Direction.N) {
			if (clockwise) return Direction.W;
			else return Direction.E;
		}
		
		if (d == Direction.S) {
			if (clockwise) return Direction.E;
			else return Direction.W;
		}
		
		if (d == Direction.W) {
			if (clockwise) return Direction.N;
			else return Direction.S;
		}
		
		if (d == Direction.E) {
			if (clockwise) return Direction.S;
			else return Direction.N;
		}
		
		return Direction.NONE;
	}
	
	override public function onRoomEnds() {
		if (moveData.oldPositionX == -1 || moveData.oldPositionY == -1) return;
		
		// alte Position wiederherstellen
		x = moveData.oldPositionX;
		y = moveData.oldPositionY;
		
		die();
		
		return;
	}
}