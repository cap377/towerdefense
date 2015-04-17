import starling.display.Sprite;
import starling.display.Image;
import starling.display.Button;
import starling.events.*;
import flash.utils.Timer;
import flash.events.TimerEvent;
import starling.text.TextField;
import starling.core.Starling;
import starling.text.TextField;


class BuildMenu extends Sprite
{
	private var game : Game;
	private var bg : Image;
	private var selected : Array<Float>;
	
	function new (game : Game, x : Float, y : Float)
	{
		super();
		this.game = game;
		
		//Create a simple background the represent the menu
		bg = new Image(Root.assets.getTexture("createTowerMenu"));
		bg.x = (Starling.current.stage.stageWidth - bg.width) / 2;
		bg.y = (Starling.current.stage.stageHeight - bg.height) / 2;
		addChild(bg);
		
		//////////////////////////////
		//
		//Currently clicking the tower button creates the tower
		//We could change this so the clicking the tower brings up stats about the tower
		//with a seperate button to purchase the currently selected tower
		//
		//When adding elements to the build menu make sure tha the x and y values are
		//based on the x and y of the menu background and not the game window
		//and that all elements are added as children to this object and not the game object
		//Unless it's something you want to exist outside of this menu
		//
		/////////////////////////////
		
		var towerText = new TextField(75, 100, "Cost:\nSpeed\nRadius\nAttack");
		towerText.x = bg.x + 10;
		towerText.y = bg.y + bg.height - towerText.height;
		addChild(towerText);
		
		
		//Create a button for each type of tower
		var towerButton1 = new Button(Root.assets.getTexture("towerButton1"));
		towerButton1.x = bg.x + 5;
		towerButton1.y = bg.y + 5;
		towerButton1.addEventListener(Event.TRIGGERED, function()
		{
			//[towerNum, cost, x, y, speed, radius, attack, upgradeBaseCost]
			selected = [ 1, 100, x, y, 2, 2, 1, 50 ];
			towerText.text = "Cost: " + selected[1] + "\nSpeed: " + selected[4] + "\nRadius: " + selected[5] + "\nAttack: " + selected[6];
		});
		addChild(towerButton1);
		
		var towerButton2 = new Button(Root.assets.getTexture("towerButton2"));
		towerButton2.x = towerButton1.x + towerButton1.width;
		towerButton2.y = towerButton1.y;
		towerButton2.addEventListener(Event.TRIGGERED, function()
		{
			selected = [ 2, 150, x, y, 1, 2, 2, 100 ];
			towerText.text = "Cost: " + selected[1] + "\nSpeed: " + selected[4] + "\nRadius: " + selected[5] + "\nAttack: " + selected[6];
		});
		addChild(towerButton2);
		
		//Create an exit button to close the create tower menu
		var buy = new Button(Root.assets.getTexture("button"), "Buy");
		buy.x = bg.x + bg.width - buy.width;
		buy.y = bg.y;
		buy.addEventListener(Event.TRIGGERED, function()
		{
			if (selected != null)
				buyTower();
		});
		addChild(buy);
		
		//Create an exit button to close the create tower menu
		var exit = new Button(Root.assets.getTexture("button"), "Exit");
		exit.x = bg.x + bg.width - exit.width;
		exit.y = bg.y + bg.height - exit.height;
		exit.addEventListener(Event.TRIGGERED, function()
		{
			game.removeChild(this);
		});
		addChild(exit);
	}
	
	//Check that everything is in order (ie enough coins) before actually buying the tower
	private function buyTower()
	{
		var towerNum = Std.int(selected[0]);
		var cost = Std.int(selected[1]);
		var x = selected[2];
		var y = selected[3];
		var initialStats  = [Std.int(selected[4]), Std.int(selected[5]), Std.int(selected[6]), Std.int(selected[7])];
		
		if (game.getCoins() >= cost)
		{
			//Create the tower at the specified coordinates of the build spot
			var tower = new Tower(game, towerNum, x, y, initialStats);
			
			//If the tower's height or width are greater than the standard 32x32
			//adjust their postision accordingly
			if (tower.image.height > 32)
			{
				tower.y = tower.y - (tower.height - 32);
			}
			if (tower.width > 32)
			{
				tower.x = tower.x - (tower.width - 32);
			}
				
				
			//Add the new tower to the game
			game.addChild(tower);
			//Remove the coins from the player
			game.setCoins( -cost);
			//Remove the menu as no more towers should be purchased in this location
			game.removeChild(this);
			//Adding tower to the tower array
			game.towerList.push(tower);
			trace("Xpos: "+tower.x + ", Ypos: "+tower.y);
			trace(game.towerList);

		}
		//If not enough coins let the player know
		else
		{
			//Create a textfield informing the player they don't have enough coins
			//Remove it from the screen after some short time
			var text = new TextField(100, 100, "You don't have enough coins");
			text.x = (Starling.current.stage.stageWidth - text.width) / 2;
			text.y = bg.y + 10;
			//Make sure that it is added to the current child and not the overall game child
			addChild(text);
			var timer = new Timer(500, 3);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent)
			{
				removeChild(text);
			});
		}
	}
	
	
	
}