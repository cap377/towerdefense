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

		
		assets.loadQueue(function onProgress(ratio:Float) {
			if (ratio == 1) {

				// fade the loading screen, start game
				Starling.juggler.tween(startup.loadingBitmap, 1.0, {
					transition:Transitions.EASE_OUT, delay:0.5, alpha: 0, onComplete: function() {
						startup.removeChild(startup.loadingBitmap);
					}
				});
				
				//Starting point for the game
				//addChild();
			}
		});
	}
}