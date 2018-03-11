package world.entities.std;

import world.entities.EntityPushable;

/**
 * ...
 * @author Matthias Faust
 */
class ElectricFence extends EntityPushable {

	public function new() {
		super();
		
		sprites.push(Gfx.getSprite(64, 12));
	}
	
}