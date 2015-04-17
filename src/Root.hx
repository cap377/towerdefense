import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.events.Event;
import starling.display.Image;
import starling.display.Button;
import starling.text.TextField;


class Root extends Sprite {

	public var level:Int;
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
			root.addChild(new Levels(root));
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

class Levels extends Sprite {

	public function new(root:Root) {
		super();
		var background = new Image(Root.assets.getTexture("menu"));
		addChild(background);

		var backButton = new Button(Root.assets.getTexture("redmenubutton"));
		backButton.text = "Back";
		backButton.addEventListener(Event.TRIGGERED, function() {
			root.removeChild(this);
			root.addChild(new Menu(root));
		});

		//Create a button for each level
		for(i in 0...5) {
			var levelButton:Button;
			//Check if level is unlocked
			if(i <= root.level) {
				levelButton = new Button(Root.assets.getTexture("redmenubutton"));
				levelButton.addEventListener(Event.TRIGGERED, function() {
					root.removeChild(this);
					root.addChild(new LevelPreview(root, i));
				});
			} else {
				levelButton = new Button(Root.assets.getTexture("bluemenubutton"));
			}
			levelButton.y = 200;
			levelButton.x = i * 50;
			addChild(levelButton);
		}

		addChild(backButton);

		root.addChild(this);
	}
}

class LevelPreview extends Sprite {

	public function new(root:Root, level:Int) {
		super();
		var background = new Image(Root.assets.getTexture("menu"));
		var backButton = new Button(Root.assets.getTexture("redmenubutton"));
		backButton.text = "Back";
		backButton.addEventListener(Event.TRIGGERED, function() {
			root.removeChild(this);
			root.addChild(new Levels(root));
		});

		var startButton = new Button(Root.assets.getTexture("redmenubutton"));
		startButton.text = "Play";
		startButton.x = 200;
		startButton.y = 200;
		startButton.addEventListener(Event.TRIGGERED, function() {
			root.removeChild(this);
			root.addChild(new Game(root, level));
		});

		addChild(background);
		addChild(backButton);
		addChild(startButton);

		root.addChild(this);
	}
}