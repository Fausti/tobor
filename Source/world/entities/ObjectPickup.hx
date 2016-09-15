package world.entities;
import world.entities.Object;
import world.entities.core.Charlie;

/**
 * ...
 * @author Matthias Faust
 */
class ObjectPickup extends Object {

	public function new(?type:Int = 0) {
		super(type);
	}
	
	override public function onEnter(e:Object) {
		if (isPlayer(e)) {
			if (room.world.player.inventory.add(this)) {
				onPickup(e);
				destroy();
			} else {
				trace("Inventar ist voll!");
			}
		}
		
		super.onEnter(e);
	}
	
	public function onPickup(e:Object) {
		
	}
}