package world.entities.std;

import lime.math.Vector2;
import world.entities.Entity;
import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Door extends EntityStatic {
	public static var SPR_DOOR:Array<Sprite> = Gfx.getSprites(null, 0, 36, 0, 16);
	public static var SPR_DOOR_BLACK:Array<Sprite> = Gfx.getSprites(null, 0, 192, 0, 16);
	
	public function new() {
		super();
	}
	
	override public function render() {
		Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, Config.colorKeys?SPR_DOOR[type]:SPR_DOOR_BLACK[type]);
	}
	
	override public function canEnter(e:Entity, direction:Vector2, ?speed:Float = 0):Bool {
		// Charlie nur mit Schlüssel
		if (Std.isOfType(e, Charlie)) {
			return room.world.inventory.hasItem("OBJ_KEY#" + type);
		}
		
		// Roboter nur wenn Charlie AUF der Tür steht
		if (Std.isOfType(e, Robot)) {
			if (getPlayer().gridX == gridX && getPlayer().gridY == gridY) return true;
		}
		
		if (Std.isOfType(e, Android)) return true;
		
		return false;
	}
	
	override public function onEnter(e:Entity, direction:Vector2) {
		if (Std.isOfType(e, Charlie) && e.visible) {
			if (room.world.inventory.hasItem("OBJ_KEY#" + type)) {
				Sound.play(Sound.SND_OPEN_DOOR);
			
				if (!getWorld().checkFirstUse("USED_KEY")) {
					getWorld().markFirstUse("USED_KEY");
					getWorld().showPickupMessage("OBJ_KEY_USE", false, function () {
						getWorld().addPoints(2500);
						getWorld().hideDialog();
					}, 2500);
				}
			}
			
			return;
		}
		
		if (Std.isOfType(e, Android)) {
			if (getPlayer().visible) Sound.play(Sound.SND_OPEN_DOOR);
			return;
		}
		
		super.onEnter(e, direction);
	}
}