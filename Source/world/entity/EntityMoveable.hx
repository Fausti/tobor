package world.entity;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class EntityMoveable extends Entity {

	// Bewegung
	var direction:Vector2 = new Vector2();
	var movement:Vector2 = new Vector2();
	var speed:Float = 1 / 4;
	var timeLeft:Float = 0.0;
	
	public function new() {
		super();
		
		isStatic = false;
	}
	
	override public function update(deltaTime:Float) {
		super.update(deltaTime);
		
		if (isMoving) {
			if (timeLeft < deltaTime) timeLeft = deltaTime;
			timeLeft -= deltaTime;
			
			var perc:Float = clamp((speed - timeLeft) / speed, 0.0, 1.0);
			
			movement.x = perc * Entity.WIDTH * direction.x;
			movement.y = perc * Entity.HEIGHT * direction.y;
			
			if (timeLeft <= 0.0) {
				timeLeft = 0.0;
				
				movement.setTo(0, 0);
				
				position.x = Std.int((gridX + direction.x) * Entity.WIDTH);
				position.y = Std.int((gridY + direction.y) * Entity.HEIGHT);
				
				direction.setTo(0.0, 0.0);
				
				onStopMoving();
			}
			
			changed = true;
		}
	}
	
	function onStartMoving() {
		
	}
	
	function onStopMoving() {
		
	}
	
	function clamp(value:Float, min:Float, max:Float):Float {
		if (value < min) {
			return min;
		} else if (value > max) {
			return max;
		}
		
		return value;
	}
	
	public var isMoving(get, null):Bool;
	function get_isMoving():Bool {
		return (direction.x != 0.0 || direction.y != 0.0);
	}
	
	public function move(dirX:Int, dirY:Int) {
		if (isMoving) return;
		if (dirX == 0 && dirY == 0) return;
		
		var canMove:Bool = true;
		
		for (e in room.getEntitiesAt(gridX + dirX, gridY + dirY, this)) {
			if (e.isSolid(this)) canMove = false;
		}
		
		if (canMove) {
			direction.x = dirX;
			direction.y = dirY;
		
			timeLeft = speed;
			
			onStartMoving();
		}
	}
	
	override
	function get_x():Float {
		return position.x + movement.x;
	}
	
	override
	function set_x(v:Float):Float {
		if (v != position.x) {
			position.x = v;
			changed = true;
		}
		
		return v;
	}
	
	override
	function get_y():Float {
		return position.y + movement.y;
	}
	
	override
	function set_y(v:Float):Float {
		if (v != position.y) {
			position.y = v;
			changed = true;
		}
		
		return v;
	}
	
	override function set_gridX(v:Int):Int {
		changed = true;
		return super.set_gridX(v);
	}
	
	override function set_gridY(v:Int):Int {
		changed = true;
		return super.set_gridY(v);
	}
}