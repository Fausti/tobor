package world.entities;
import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Drift extends Entity {
	public static var SPR_DRIFT:Array<Sprite>;
	
	public static function getSprite(index:Int):Sprite {
		if (SPR_DRIFT == null) {
			SPR_DRIFT = [
				Gfx.getSprite(0, 288),
				Gfx.getSprite(16, 288),
				Gfx.getSprite(32, 288),
				Gfx.getSprite(48, 288),
		
				Gfx.getSprite(64, 288),
				Gfx.getSprite(80, 288),
				Gfx.getSprite(96, 288),
				Gfx.getSprite(112, 288),
			];
		}
		
		return SPR_DRIFT[index];
	}
	
	public function new() {
		super();
	}
	
}