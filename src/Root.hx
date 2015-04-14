import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.core.Starling;
import starling.animation.Transitions;


class Root extends Sprite {

	public static var assets: AssetManager;

	public function new() {
		super();
	}

	public function start(startup:Startup) {
		assets = new AssetManager();
		assets.enqueue("assets/grass.png");
		assets.enqueue("assets/entry.png");
		assets.enqueue("assets/path.png");
		assets.enqueue("assets/finish.png");
		assets.enqueue("assets/build.png");
		assets.enqueue("assets/hill.png");
		assets.enqueue("assets/tree1.png");
		assets.enqueue("assets/tree2.png");
		
		
		assets.enqueue("assets/tower1.png");
		assets.enqueue("assets/tower2.png");
		assets.enqueue("assets/towerMenu.png");
		
		assets.enqueue("assets/towerButton1.png");
		assets.enqueue("assets/towerButton2.png");
		assets.enqueue("assets/createTowerMenu.png");
		assets.enqueue("assets/button.png");
		
		
		assets.enqueue("assets/W.png");
		assets.enqueue("assets/E.png");
		assets.enqueue("assets/S.png");
		
		
		assets.enqueue("assets/level1.txt");
		assets.enqueue("assets/level2.txt");

		
		assets.loadQueue(function onProgress(ratio:Float) {
			if (ratio == 1) {

				// fade the loading screen, start game
				Starling.juggler.tween(startup.loadingBitmap, 1.0, {
					transition:Transitions.EASE_OUT, delay:0.5, alpha: 0, onComplete: function() {
						startup.removeChild(startup.loadingBitmap);
					}
				});
				
				//Starting point for the game
				addChild(new Game());
			}
		});
	}
}