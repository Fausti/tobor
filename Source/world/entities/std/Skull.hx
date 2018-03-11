package world.entities.std;

import world.entities.EntityStatic;

/**
 * ...
 * @author Matthias Faust
 */
class Skull extends EntityStatic {

	public function new() {
		super();
		
		setSprite(Gfx.getSprite(80, 12));
	}
	
}