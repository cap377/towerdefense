import starling.display.Sprite;
import starling.utils.AssetManager;
import starling.core.Starling;
import starling.animation.Transitions;
import starling.events.Event;
import starling.display.Image;
import starling.display.Button;
import starling.text.TextField;
import flash.media.*;
import starling.animation.IAnimatable;

class Root extends Sprite {

	public var level:Int;
	public static var assets: AssetManager;
	public var tdintro: SoundChannel;
	public var repeatsong: IAnimatable;

	public function new() {
		super();
	}

	public function start(startup:Startup) {
		assets = new AssetManager();

		assets.enqueue("assets/assets.png");
		assets.enqueue("assets/assets.xml");

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
		
		assets.enqueue("assets/tdintro.mp3");
		assets.enqueue("assets/Pickup_Coin.mp3");
		
		assets.enqueue("assets/caveman_left1.png");
		assets.enqueue("assets/caveman_left2.png");
		assets.enqueue("assets/caveman_right1.png");
		assets.enqueue("assets/caveman_right2.png");
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

		assets.enqueue("assets/projectile.png");
		
		assets.loadQueue(function onProgress(ratio:Float) {
			if (ratio == 1) {

				// fade the loading screen, start game
				Starling.juggler.tween(startup.loadingBitmap, 1.0, {
					transition:Transitions.EASE_OUT, delay:0.5, alpha: 0, onComplete: function() {
						startup.removeChild(startup.loadingBitmap);
						Root.assets.playSound("tdintro", 120, 0);
						repeatsong = Starling.juggler.repeatCall(musicLoop, 20.1, 0);
					}
				});
				
				//Starting point for the game
				addChild(new Menu(this));
			}
		});
	}
	public function musicLoop(){
		Root.assets.playSound("tdintro", 120, 0);
	}
}

class Menu extends Sprite {

	public function new(root:Root) {
		super();
		var background = new Image(Root.assets.getTexture("menu"));
		addChild(background);
		
		var startImage = new Image(Root.assets.getTexture("redmenubutton"));
		startImage.x = 200;
		startImage.y = 200;
		addChild(startImage);
		var startText = new TextField(150, 75, "PLAY", "font", 24, 0xFFFFFF);
		startText.x = 200;
		startText.y = 200;
		addChild(startText);
		var startButton = new Button(Root.assets.getTexture("button"));
		startButton.width = 150;
		startButton.height = 75;
		startButton.x = 200;
		startButton.y = 200;
		startButton.addEventListener(Event.TRIGGERED, function() {
			root.removeChild(this);
			root.addChild(new Levels(root));
		});
		addChild(startButton);

		var creditsImage = new Image(Root.assets.getTexture("bluemenubutton"));
		creditsImage.x = 200;
		creditsImage.y = 350;
		addChild(creditsImage);
		var creditsText = new TextField(150, 75, "CREDITS", "font", 24, 0xFFFFFF);
		creditsText.x = 200;
		creditsText.y = 350;
		addChild(creditsText);
		var creditsButton = new Button(Root.assets.getTexture("button"));
		creditsButton.width = 150;
		creditsButton.height = 75;
		creditsButton.x = 200;
		creditsButton.y = 350;
		creditsButton.addEventListener(Event.TRIGGERED, function() {
			root.removeChild(this);
			root.addChild(new Credits(root));
		});
		addChild(creditsButton);

		root.addChild(this);
	}
}

class Credits extends Sprite {

	public function new(root:Root) {
		super();
		var background = new Image(Root.assets.getTexture("menu"));
		addChild(background);
		
		var backImage = new Image(Root.assets.getTexture("redmenubutton"));
		addChild(backImage);
		var backText = new TextField(150, 75, "BACK", "font", 24, 0xFFFFFF);
		addChild(backText);
		var backButton = new Button(Root.assets.getTexture("button"));
		backButton.width = 150;
		backButton.height = 75;
		backButton.addEventListener(Event.TRIGGERED, function() {
			root.removeChild(this);
			root.addChild(new Menu(root));
		});
		addChild(backButton);

		root.addChild(this);
	}
}

class Levels extends Sprite {

	public function new(root:Root) {
		super();
		var background = new Image(Root.assets.getTexture("menu"));
		addChild(background);

		var backImage = new Image(Root.assets.getTexture("redmenubutton"));
		addChild(backImage);
		var backText = new TextField(150, 75, "BACK", "font", 24, 0xFFFFFF);
		addChild(backText);
		var backButton = new Button(Root.assets.getTexture("button"));
		backButton.width = 150;
		backButton.height = 75;
		backButton.addEventListener(Event.TRIGGERED, function() {
			root.removeChild(this);
			root.addChild(new Menu(root));
		});
		addChild(backButton);

		//Create a button for each level
		var x = 0;
		var y = 0;
		for(i in 0...15) {
			//Check if level is unlocked
			var levelImage : Image;
			var levelText : TextField;
			if(i <= root.level) {
				levelImage = new Image(Root.assets.getTexture("redmenubutton"));
				levelText = new TextField(150, 75, "LEVEL " + i, "font", 24, 0xFFFFFF);
				var levelButton : Button;
				levelButton = new Button(Root.assets.getTexture("button"));
				levelButton.addEventListener(Event.TRIGGERED, function() {
					root.removeChild(this);
					root.addChild(new LevelPreview(root, i));
				});
				levelButton.width = 150;
				levelButton.height = 75;
				levelButton.x = 10 + x * (levelImage.width + 5);
				levelButton.y = 200 + (levelImage.height + 5) * y;
				levelImage.x = 10 + x * (levelImage.width + 5);
				levelImage.y = 200 + (levelImage.height + 5) * y;
				levelText.x = 10 + x * (levelImage.width + 5);
				levelText.y = 200 + (levelImage.height + 5) * y;
				addChild(levelImage);
				addChild(levelText);
				addChild(levelButton);
			} else {
				levelImage = new Image(Root.assets.getTexture("bluemenubutton"));
				levelText = new TextField(150, 75, "LEVEL " + i, "font", 24, 0xFFFFFF);
				levelImage.x = 10 + x * (levelImage.width + 5);
				levelImage.y = 200 + (levelImage.height + 5) * y;
				levelText.x = 10 + x * (levelImage.width + 5);
				levelText.y = 200 + (levelImage.height + 5) * y;
				addChild(levelImage);
				addChild(levelText);
			}
			if (levelImage.x + levelImage.width + 15 >= 640)
			{
				y++;
				x = -1;
			}
			
			x++;
		}

		root.addChild(this);
	}
}

class LevelPreview extends Sprite {

	public function new(root:Root, level:Int) {
		super();
		var background = new Image(Root.assets.getTexture("menu"));
		addChild(background);

		var backImage = new Image(Root.assets.getTexture("redmenubutton"));
		addChild(backImage);
		var backText = new TextField(150, 75, "BACK", "font", 24, 0xFFFFFF);
		addChild(backText);
		var backButton = new Button(Root.assets.getTexture("button"));
		backButton.width = 150;
		backButton.height = 75;
		backButton.addEventListener(Event.TRIGGERED, function() {
			root.removeChild(this);
			root.addChild(new Levels(root));
		});
		addChild(backButton);

		var startImage = new Image(Root.assets.getTexture("redmenubutton"));
		startImage.x = 200;
		startImage.y = 200;
		addChild(startImage);
		var startText = new TextField(150, 75, "PLAY", "font", 24, 0xFFFFFF);
		startText.x = 200;
		startText.y = 200;
		addChild(startText);
		var startButton = new Button(Root.assets.getTexture("button"));
		startButton.width = 150;
		startButton.height = 75;
		startButton.x = 200;
		startButton.y = 200;
		startButton.addEventListener(Event.TRIGGERED, function() {
			root.removeChild(this);
			root.addChild(new Game(root, level));
		});
		addChild(startButton);

		root.addChild(this);
	}
}
