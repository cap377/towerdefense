import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.events.Event;
import starling.display.Image;
import starling.display.Button;
import starling.text.TextField;


class Root extends Sprite {

	public static var assets: AssetManager;

	public function new() {
		super();
	}

	public function start(startup:Startup) {
		assets = new AssetManager();
		assets.enqueue("assets/grass.png");
		assets.enqueue("assets/grass1.png");
		assets.enqueue("assets/entry.png");
		assets.enqueue("assets/path.png");
		assets.enqueue("assets/finish.png");
		assets.enqueue("assets/build.png");
		assets.enqueue("assets/stone.png");
		assets.enqueue("assets/rock.png");
		assets.enqueue("assets/dirt.png");
		assets.enqueue("assets/coin.png");
		
		
		assets.enqueue("assets/tower1.png");
		assets.enqueue("assets/tower2.png");
		assets.enqueue("assets/towerMenu.png");
		assets.enqueue("assets/towerButton.png");
		
		assets.enqueue("assets/towerButton1.png");
		assets.enqueue("assets/towerButton2.png");
		assets.enqueue("assets/createTowerMenu.png");
		assets.enqueue("assets/button.png");
		
		
		assets.enqueue("assets/W.png");
		assets.enqueue("assets/E.png");
		assets.enqueue("assets/S.png");
		
		
		assets.enqueue("assets/level1.txt");
		assets.enqueue("assets/level2.txt");

		assets.enqueue("assets/menu.png");
		assets.enqueue("assets/redmenubutton.png");
		assets.enqueue("assets/bluemenubutton.png");

		assets.enqueue("assets/font.png");
		assets.enqueue("assets/font.fnt");

		
		assets.loadQueue(function onProgress(ratio:Float) {
			if (ratio == 1) {

				// fade the loading screen, start game
				Starling.juggler.tween(startup.loadingBitmap, 1.0, {
					transition:Transitions.EASE_OUT, delay:0.5, alpha: 0, onComplete: function() {
						startup.removeChild(startup.loadingBitmap);
					}
				});
				
				//Starting point for the game
				addChild(new Menu(this));
			}
		});
	}
}

class Menu extends Sprite {

	public function new(root:Root) {
		super();
		var background = new Image(Root.assets.getTexture("menu"));
		var startButton = new Button(Root.assets.getTexture("redmenubutton"));
		startButton.text = "Play";
		startButton.x = 200;
		startButton.y = 200;
		startButton.addEventListener(Event.TRIGGERED, function() {
				root.removeChild(this);
				root.addChild(new Game());
			});

		var creditsButton = new Button(Root.assets.getTexture("bluemenubutton"));
		creditsButton.text = "Credits";
		creditsButton.x = 200;
		creditsButton.y = 350;
		creditsButton.addEventListener(Event.TRIGGERED, function() {
				root.removeChild(this);
				root.addChild(new Credits(root));
			});

		addChild(background);
		addChild(startButton);
		addChild(creditsButton);

		root.addChild(this);
	}
}

class Credits extends Sprite {

	public function new(root:Root) {
		super();
		var background = new Image(Root.assets.getTexture("menu"));
		var backButton = new Button(Root.assets.getTexture("redmenubutton"));
		backButton.text = "Back";
		backButton.addEventListener(Event.TRIGGERED, function() {
				root.removeChild(this);
				root.addChild(new Menu(root));
			});

		addChild(background);
		addChild(backButton);

		root.addChild(this);
	}
}