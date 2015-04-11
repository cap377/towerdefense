import starling.display.Sprite;
import starling.display.Image;
import starling.display.Button;
import starling.events.*;
import flash.utils.Timer;
import flash.events.TimerEvent;
import starling.text.TextField;
import starling.core.Starling;


class CreateTower extends Sprite
{
	private var game : Game;
	private var bg : Image;
	
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
		/////////////////////////////
		
		//Create a button for each type of tower
		var towerButton1 = new Button(Root.assets.getTexture("towerButton1"));
		towerButton1.x = Starling.current.stage.stageWidth / 2 - towerButton1.width;
		towerButton1.y = (640 - towerButton1.height) / 2;
		towerButton1.addEventListener(Event.TRIGGERED, function()
		{
			buyTower(1, 100, x, y);
		});
		addChild(towerButton1);
		
		var towerButton2 = new Button(Root.assets.getTexture("towerButton1"));
		towerButton2.x = Starling.current.stage.stageWidth / 2;
		towerButton2.y = (640 - towerButton2.height) / 2;
		towerButton2.addEventListener(Event.TRIGGERED, function()
		{
			buyTower(2, 150, x, y);
		});
		addChild(towerButton2);
		
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
	private function buyTower(towerNum : Int, cost : Int, x : Float, y : Float)
	{
			if (game.getCoins() >= cost)
			{
				//Used currently only for towers that are larger than the standard size of 32x32
				//Have to move the tower up 32 pixels otherwise it appears incorrectly
				if (towerNum == 2)
					y = y - 32;
				//Create the tower at the specified coordinates of the build spot
				var tower = new Tower(game);
				var temp = tower.createTower(towerNum, x, y);
				game.addChild(temp);
				//Remove the coins from the player
				game.setCoins( -cost);
				//Remove the menu as no more towers should be purchased in this location
				game.removeChild(this);
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