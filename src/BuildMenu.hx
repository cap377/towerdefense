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
	private var numOfTowers = 2;
	
	function new (game : Game, x : Float, y : Float)
	{
		super();
		this.game = game;
		selected = new Array();
		
		//Create a simple background the represent the menu
		bg = new Image(Root.assets[0].getTexture("createTowerMenu"));
		bg.x = (Starling.current.stage.stageWidth - bg.width) / 2;
		bg.y = (Starling.current.stage.stageHeight - bg.height) / 2;
		addChild(bg);
		
		//////////////////////////////
		//
		//When adding elements to the build menu make sure tha the x and y values are
		//based on the x and y of the menu background and not the game window
		//and that all elements are added as children to this object and not the game object
		//Unless it's something you want to exist outside of this menu
		//
		/////////////////////////////
		
		var towerText = new TextField(125, 100, "COST:\nSPEED\nRANGE\nATTACK", "font", 24, 0xFFFFFF);
		towerText.x = bg.x + 10;
		towerText.y = bg.y + bg.height - towerText.height;
		addChild(towerText);
		
		
		var h = 0;
		var w = 0;
		for (i in 1...numOfTowers+1)
		{
			var towerButton = new Button(Root.assets[game.era].getTexture("towerButton" + i));
			towerButton.fontName = "font";
			towerButton.fontSize = 24;
			towerButton.fontColor = 0xFFFFFF;
			towerButton.x = bg.x + 5 + w * (towerButton.width + 5);
			towerButton.y = bg.y + 5 + h * (towerButton.height + 5);
			towerButton.addEventListener(Event.TRIGGERED, function()
			{
				selected = new Array();
				selected.push(x);
				selected.push(y);
				selected.push(i);
				getTower();
				towerText.text = "COST: " + selected[3] + "\nSPEED: " + selected[4] + "\nRANGE: " + selected[5] + "\nATTACK: " + selected[6];
			});
			addChild(towerButton);
			if (w == 2)
			{
				w = 0;
				h++;
			}
			w++;
		}
		
		//Create an exit button to close the create tower menu
		var buy = new Button(Root.assets[0].getTexture("button"), "BUY");
		buy.fontName = "font";
		buy.fontSize = 24;
		buy.fontColor = 0xFFFFFF;
		buy.x = bg.x + bg.width - buy.width;
		buy.y = bg.y;
		buy.addEventListener(Event.TRIGGERED, function()
		{
			if (!Math.isNaN(selected[0]))
				buyTower();
		});
		addChild(buy);
		
		//Create an exit button to close the create tower menu
		var exit = new Button(Root.assets[0].getTexture("button"), "EXIT");
		exit.fontName = "font";
		exit.fontSize = 24;
		exit.fontColor = 0xFFFFFF;
		exit.x = bg.x + bg.width - exit.width;
		exit.y = bg.y + bg.height - exit.height;
		exit.addEventListener(Event.TRIGGERED, function()
		{
			game.removeChild(this);
			
			//Unpause the game
			game.unpause();
		});
		addChild(exit);
	}
	
	//Check that everything is in order (ie enough coins) before actually buying the tower
	private function buyTower()
	{
		var x = selected[0];
		var y = selected[1];
		var towerNum = Std.int(selected[2]);
		var cost = Std.int(selected[3]);
		var initialStats  = [Std.int(selected[4]), Std.int(selected[5]), Std.int(selected[6]), Std.int(selected[7])];
		
		if (game.getCoins() >= cost)
		{
			//Create the tower at the specified coordinates of the build spot
			var tower = new Tower(game, towerNum, x, y, cost, initialStats, getTowerProjectile());
			
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
			//trace("Xpos: "+tower.x + ", Ypos: "+tower.y);
			//trace(game.towerList);
			
			//Unpause the game
			game.unpause();

		}
		//If not enough coins let the player know
		else
		{
			//Create a textfield informing the player they don't have enough coins
			//Remove it from the screen after some short time
			var text = new TextField(100, 100, "YOU DON'T HAVE ENOUGH COINS", "font", 24, 0xFFFFFF);
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
	
	
	private function getTower()
	{
		var str: String = new String(Root.assets[game.era].getByteArray("towerValues" + selected[2]).toString());
		var info = str.split("\n");
		for (i in 0...info.length-1)
		{
			var count = 0;
			var numString = "";
			while (info[i].charAt(count) != ';')
			{
				numString = numString + info[i].charAt(count);
				count++;
			}
			selected.push(getTowerHelper(numString));
		}
	}
	private function getTowerHelper(str : String)
	{
		var total = 0.0;
		total = total + Std.parseInt(str);
		return total;
	}
	private function getTowerProjectile()
	{
		var str: String = new String(Root.assets[game.era].getByteArray("towerValues" + selected[2]).toString());
		var info = str.split("\n");
		var pos = 0;
		var projectile = "";
		while (info[info.length - 1].charAt(pos) != ';')
		{
			projectile = projectile + info[info.length - 1].charAt(pos);
			pos++;
		}
		return projectile;
	}
}