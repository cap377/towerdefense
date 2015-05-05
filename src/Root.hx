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
	public static var assets : AssetManager;
	public var tdintro: SoundChannel;
	public var repeatsong: IAnimatable;

	public function new() {
		
		
		super();
	}

	public function start(startup:Startup) {
		
		assets = new AssetManager();

		assets.enqueue("assets/assets.png");
		assets.enqueue("assets/assets.xml");

		assets.enqueue("assets/tower_hit.mp3");
		assets.enqueue("assets/base_hit.mp3");
		assets.enqueue("assets/nope.mp3");
		assets.enqueue("assets/build.mp3");
		assets.enqueue("assets/upgrade.mp3");
		assets.enqueue("assets/sell.mp3");
		assets.enqueue("assets/font.png");
		assets.enqueue("assets/font.fnt");
		assets.enqueue("assets/tdintro.mp3");
		assets.enqueue("assets/Pickup_Coin.mp3");

		assets.enqueue("assets/levels/level1.txt");
		assets.enqueue("assets/levels/level2.txt");
		assets.enqueue("assets/levels/level3.txt");
		assets.enqueue("assets/levels/level4.txt");
		assets.enqueue("assets/levels/level5.txt");

		assets.enqueue("assets/towerValues/1_towerValues1.txt");
		assets.enqueue("assets/towerValues/1_towerValues2.txt");
		assets.enqueue("assets/towerValues/1_towerValues3.txt");
		assets.enqueue("assets/towerValues/2_towerValues1.txt");
		assets.enqueue("assets/towerValues/2_towerValues2.txt");
		assets.enqueue("assets/towerValues/2_towerValues3.txt");
		assets.enqueue("assets/towerValues/3_towerValues1.txt");
		assets.enqueue("assets/towerValues/3_towerValues2.txt");
		assets.enqueue("assets/towerValues/3_towerValues3.txt");
		assets.enqueue("assets/towerValues/4_towerValues1.txt");
		assets.enqueue("assets/towerValues/4_towerValues2.txt");
		assets.enqueue("assets/towerValues/4_towerValues3.txt");
		assets.enqueue("assets/towerValues/5_towerValues1.txt");
		assets.enqueue("assets/towerValues/5_towerValues2.txt");
		assets.enqueue("assets/towerValues/5_towerValues3.txt");

		
		
		assets.loadQueue(function onProgress(ratio:Float) {
			if (ratio == 1) {

				// fade the loading screen, start game
				Starling.juggler.tween(startup.loadingBitmap, 1.0, {
					transition:Transitions.EASE_OUT, delay:1.0, alpha: 0, onComplete: function() {
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
		startImage.x = 175;
		startImage.y = 300;
		addChild(startImage);
		var startText = new TextField(150, 75, "PLAY", "font", 24, 0xFFFFFF);
		startText.x = 175;
		startText.y = 300;
		addChild(startText);
		var startButton = new Button(Root.assets.getTexture("button"));
		startButton.width = 150;
		startButton.height = 75;
		startButton.x = 175;
		startButton.y = 300;
		startButton.addEventListener(Event.TRIGGERED, function() {
			root.removeChild(this);
			root.addChild(new Levels(root));
		});
		addChild(startButton);

		var creditsImage = new Image(Root.assets.getTexture("bluemenubutton"));
		creditsImage.x = 920;
		creditsImage.y = 300;
		addChild(creditsImage);
		var creditsText = new TextField(150, 75, "CREDITS", "font", 24, 0xFFFFFF);
		creditsText.x = 920;
		creditsText.y = 300;
		addChild(creditsText);
		var creditsButton = new Button(Root.assets.getTexture("button"));
		creditsButton.width = 150;
		creditsButton.height = 75;
		creditsButton.x = 920;
		creditsButton.y = 300;
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

		var creditText = new TextField(300, 250, "CHERIE PARSONS\nJORDAN HARRIS\nALEXANDER SEARS\nHAYDEN WESTBROOK\nTJ O'BRIEN", "font", 32, 0xFFFFFF);
		creditText.x = (Starling.current.stage.stageWidth - creditText.width)/2;
		creditText.y = 470;
		addChild(creditText);
		
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
		for(i in 0...5) {
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
				levelButton.x = 250 + x * (levelImage.width + 5);
				levelButton.y = 600 + (levelImage.height + 5) * y;
				levelImage.x = 250 + x * (levelImage.width + 5);
				levelImage.y = 600 + (levelImage.height + 5) * y;
				levelText.x = 250 + x * (levelImage.width + 5);
				levelText.y = 600 + (levelImage.height + 5) * y;
				addChild(levelImage);
				addChild(levelText);
				addChild(levelButton);
			} else {
				levelImage = new Image(Root.assets.getTexture("bluemenubutton"));
				levelText = new TextField(150, 75, "LEVEL " + i, "font", 24, 0xFFFFFF);
				levelImage.x = 250 + x * (levelImage.width + 5);
				levelImage.y = 600 + (levelImage.height + 5) * y;
				levelText.x = 250 + x * (levelImage.width + 5);
				levelText.y = 600 + (levelImage.height + 5) * y;
				addChild(levelImage);
				addChild(levelText);
			}
			if (levelImage.x + levelImage.width + 15 >= 1280)
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
		startImage.x = 560;
		startImage.y = 500;
		addChild(startImage);
		var startText = new TextField(150, 75, "PLAY", "font", 24, 0xFFFFFF);
		startText.x = 560;
		startText.y = 500;
		addChild(startText);
		var startButton = new Button(Root.assets.getTexture("button"));
		startButton.width = 150;
		startButton.height = 75;
		startButton.x = 560;
		startButton.y = 500;
		startButton.addEventListener(Event.TRIGGERED, function() {
			root.removeChild(this);
			root.addChild(new Game(root, level));
		});
		addChild(startButton);

		root.addChild(this);
	}
}
