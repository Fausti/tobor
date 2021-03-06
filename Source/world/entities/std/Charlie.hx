package world.entities.std;

import gfx.Sprite;
import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityMoveable;

/**
 * ...
 * @author Matthias Faust
 */
class Charlie extends EntityMoveable {
	public static var PLAYER_SPEED:Float = 8;
	
	var sprStanding:Sprite;
	var sprWalking_0:Sprite;
	var sprWalking_1:Sprite;
	
	var sprStandingOverall:Sprite;
	var sprWalkingOverall_0:Sprite;
	var sprWalkingOverall_1:Sprite;
	
	public var walkInTunnel:Bool = false;
	var lastTunnelStep:Int = 0;
	
	public var walkInWater:Bool = false;
	var lastX:Float = 0;
	var lastY:Float = 0;
	
	public function new() {
		super();
		
		// normal
		
		sprStanding = Gfx.getSprite(16, 0);
		
		sprWalking_0 = Gfx.getSprite(32, 0);
		sprWalking_1 = Gfx.getSprite(48, 0);
		
		// Blaumann
		
		sprStandingOverall = Gfx.getSprite(0, 156);
		
		sprWalkingOverall_0 = Gfx.getSprite(16, 156);
		sprWalkingOverall_1 = Gfx.getSprite(32, 156);
			
		sprites[0] = sprStanding;
		
		z = Room.LAYER_LEVEL_0 + 1;
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		if (isMoving()) {
			if (walkInTunnel) {
				var step = Math.floor(moveData.distanceLeft);
				
				if (step < lastTunnelStep) {
					Sound.play(Sound.SND_TUNNEL_STEP);
					lastTunnelStep = step;
				}
			}
		}
	}
	
	override public function render() {
		if (getInventory().hasItem("OBJ_LAMP")) getWorld().game.addLight(x + 0.5, y + 0.5, 5);
		
		var spr:Sprite = null;
		
		if (!isMoving()) {
			if (hasOverall()) {
				spr = sprStandingOverall;
			} else {
				spr = sprStanding;
			}
		} else {
			var animPhase:Float = Math.fceil(moveData.distanceLeft) - moveData.distanceLeft;
			
			if (hasOverall()) {
				if (animPhase <= 0.5) {
					spr = sprWalkingOverall_0;
				} else {
					spr = sprWalkingOverall_1;
				}
			} else {
				if (animPhase <= 0.5) {
					spr = sprWalking_0;
				} else {
					spr = sprWalking_1;
				}
			}
		}
		
		if (spr != null) Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, spr);
	}
	
	override public function isMoving():Bool {
		if (!visible) return true;
		
		return super.isMoving();
	}
	
	override function onStartMoving() {
		if (room.findEntityAt(x, y, Water).length != 0) {
			walkInWater = true;
		} else {
			walkInWater = false;
		}
		
		if (moveData.distanceLeft > 1.0) {
			walkInTunnel = true;
			lastTunnelStep = Math.floor(moveData.distanceLeft);
			Sound.play(Sound.SND_TUNNEL_STEP);
		} else {
			if (!walkInWater) {
				Sound.play(Sound.SND_CHARLIE_STEP);
			}
		}
	}
	
	override function onStopMoving() {
		if (walkInTunnel) {
			Sound.play(Sound.SND_TUNNEL_STEP);
			walkInTunnel = false;
		} else {
			if (room.findEntityAt(x, y, Water).length != 0) {
				walkInWater = true;
			} else {
				walkInWater = false;
			}
			
			if (!walkInWater) {
				Sound.play(Sound.SND_CHARLIE_STEP);
			}
		}
	}
	
	override public function die() {
		var p:Charlie = this;
		var e:Explosion = new Explosion();
		
		e.onRemove = function() {
			room.world.player.visible = true;
			room.world.player.alive = true;
			room.world.lives--;
			
			if (walkInWater) {
				walkInWater = false;
			}
			
			p.x = lastX;
			p.y = lastY;
		}
		
		room.spawnEntity(x, y, e);
		
		Sound.play(Sound.SND_EXPLOSION_CHARLIE);
		
		visible = false;
		
		super.die();
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (alive && visible && (Std.isOfType(e, Robot))) {
			die();
			
			if (getWorld().checkFirstUse("KILLED_BY_ROBOT")) {
					
			} else {
				getWorld().markFirstUse("KILLED_BY_ROBOT");
				getWorld().showPickupMessage("KILLED_BY_ROBOT", false, function () {
					getWorld().hideDialog();
				});
			}
		} else if (alive && visible && (Std.isOfType(e, Android))) {
			die();
			
			if (getWorld().checkFirstUse("KILLED_BY_ANDROID")) {
					
			} else {
				getWorld().markFirstUse("KILLED_BY_ANDROID");
				getWorld().showPickupMessage("KILLED_BY_ANDROID", false, function () {
					getWorld().hideDialog();
				});
			}
		} else if (alive && visible && (Std.isOfType(e, Shark))) {
			die();
			
			if (getWorld().checkFirstUse("KILLED_BY_SHARK")) {
					
			} else {
				getWorld().markFirstUse("KILLED_BY_SHARK");
				getWorld().showPickupMessage("KILLED_BY_SHARK", false, function () {
					getWorld().hideDialog();
				});
			}
		} else if (alive && visible && (Std.isOfType(e, Scorpion))) {
			die();
			
			if (getWorld().checkFirstUse("KILLED_BY_SCORPION")) {
					
			} else {
				getWorld().markFirstUse("KILLED_BY_SCORPION");
				getWorld().showPickupMessage("KILLED_BY_SCORPION", false, function () {
					getWorld().hideDialog();
				});
			}
		} else if (alive && visible && (Std.isOfType(e, NPC))) {
			e.onEnter(this, direction);
		}
	}
	
	public inline function hasOverall():Bool {
		return room.world.inventory.containsOverall;
	}
	
	override public function move(direction:Vector2, speed:Float, ?dist:Int = 1):Bool {
		moveData.oldPositionX = gridX;
		moveData.oldPositionY = gridY;
		
		if (direction == Direction.NONE) return false;
		
		if (!isMoving()) {
			if (isOutsideMap(x + direction.x, y + direction.y)) {
				// kein diagonaler Raumwechsel!
				if (Direction.isDiagonal(direction)) return false;
				
				var nextRoom = getWorld().rooms.find(
					Std.int(room.position.x + direction.x), 
					Std.int(room.position.y + direction.y), 
					room.position.z
				);
				
				if (nextRoom == null) {
					return false;
				} else {
					getWorld().changeRoom(direction);
					
					return true;
				}
			}
			
			// Geschwindigkeit anpassen
			speed = Config.getSpeed(speed);
			
			var atTarget:Array<Entity> = room.getCollisionsAt(gridX + direction.x, gridY + direction.y);
			
			// kann Feld betreten werden?
			if (dist == 1) { // Tunnel ignorieren dies hier...
				for (e in atTarget) {
					if (!e.canEnter(this, direction, speed)) return false;
				}
			}
			
			// dann bewegen wir uns mal...
			moveData.direction = direction;
			moveData.speedMovement = speed;
			moveData.distanceLeft = dist;
			
			// informieren wir mal jeden auf dem Zielfeld das wir es demnächst betreten
			for (e in atTarget) {
				e.willEnter(this, direction, speed);
			}
			
			// auf dem Startfeld auch alle Objekte informieren...
			var atStart:Array<Entity> = room.getCollisionsAt(gridX, gridY, this);
			for (e in atStart) {
				e.onLeave(this, direction);
			}
			
			onStartMoving();
			
			return true;
		}
		
		return false;
	}
	
	override public function onRoomStart() {
		lastX = x;
		lastY = y;
	}
	
	override public function onRoomEnds() {
		return;
	}
}