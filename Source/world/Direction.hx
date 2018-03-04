package world;

import lime.math.Vector2;

/**
 * ...
 * @author Matthias Faust
 */
class Direction {
	public static var NONE(default, null):Vector2 = new Vector2(0, 0);
	public static var S(default, null):Vector2 = new Vector2(0, 1);
	public static var N(default, null):Vector2 = new Vector2(0, -1);
	public static var W(default, null):Vector2 = new Vector2( -1, 0);
	public static var E(default, null):Vector2 = new Vector2(1, 0);
	
	public static var NW(default, null):Vector2 = N.add(W);
	public static var NE(default, null):Vector2 = N.add(E);
	public static var SW(default, null):Vector2 = S.add(W);
	public static var SE(default, null):Vector2 = S.add(E);
	
	public static var ALL:Array<Vector2> = [NONE, S, N, W, E, NW, NE, SW, SE];
}