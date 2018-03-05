package screens;

import ui.Screen;

/**
 * ...
 * @author Matthias Faust
 */
class IntroScreen extends Screen {
	var bgSprite:Sprite;
	
	public function new(game:Tobor) {
		super(game);
		
		bgSprite = Gfx.getSprite(48, 132, Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT);
	}
	
	override public function show() {
		Sound.play(Sound.MUS_INTRO_DOS, true);
	}
	
	override public function hide() {
		Sound.stop(Sound.MUS_INTRO_DOS);
	}
	
	override public function update(deltaTime:Float) {
		if (Input.down([Input.key.ESCAPE])) {
			game.setScreen(new EpisodesScreen(game));
		} else if (Input.down([Input.key.RETURN])) {
			game.setScreen(new PlayScreen(game));
		}
	}
	
	override public function render() {
		for (x in 0 ... 40) {
			for (y in 0 ... 29) {
				Gfx.drawSprite(x * Tobor.TILE_WIDTH, y * Tobor.TILE_HEIGHT, bgSprite);
			}
		}
	}
}