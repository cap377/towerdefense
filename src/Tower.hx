import starling.display.Sprite;
import starling.display.Image;
import starling.display.Button;
import starling.events.*;
import starling.text.TextField;
import flash.utils.Timer;
import flash.events.TimerEvent;
import starling.core.Starling;

class Tower extends Sprite
{
	private var game : Game;
	public var image : Image;
	public var button : Button;
	public var level : Int;
	public var maxLevel : Int = 4;
	public var cost : Int;
	public var upgradeBaseCost : Int;
	public var radius : Int;
	public var speed : Int;
	public var attack : Int;
	public var attacking : Bool;
	
	public function new (game : Game, towerNum : Int, x : Float, y : Float, cost : Int, initialStats : Array<Int>)
	{
		super();
		level = 1;
		this.game = game;
		this.x = x;
		this.y = y;
		this.cost = cost;
		this.attacking = false;
		
		//Initial stats: speed, radius, attack, upgradeCost
		speed = initialStats[0];
		radius = initialStats[1];
		attack = initialStats[2];
		upgradeBaseCost = initialStats[3];
		
		
		image = new Image(Root.assets[game.era].getTexture("tower" + towerNum));
		addChild(image);
		
		//Create a new tower based on the tower clicked and set it to the correct position
		button = new Button(Root.assets[0].getTexture("button"));
		button.height = image.height;
		button.width = image.width;
		button.addEventListener(Event.TRIGGERED, function()
		{
			//When clicked create a new tower menu an pause the game
			game.pause();
			game.addChild(new TowerMenu(game, this));
		});
		addChild(button);
	}
	
	public function upgrade()
	{
		////////////////////////
		//
		//Currently all towers have the same upgrades
		//The upgrade costs also need to be adjusted better
		//
		////////////////////////
		switch (level)
		{
			case 1:
				upgradeBaseCost += Std.int(upgradeBaseCost * 1.5);
				attack += 2;
			case 2:
				upgradeBaseCost += Std.int(upgradeBaseCost * 1.5);
				radius += 1;
				speed += 1;
			case 3:
				upgradeBaseCost += Std.int(upgradeBaseCost * 1.5);
				radius += 1;
				speed += 1;
				attack += 1;
		}
		level++;
	}

	public function launchAttack(enemy : Enemy) {
		//Creates a projectile and tweens it to the target
		this.attacking = true;
		
		var projectile = new Image(Root.assets[game.era].getTexture("projectile"));
		projectile.x = projectile.x + this.width / 2;
		
		//Rotate the arrow to face the enemy
		var rx = (enemy.x + enemy.width/2) - this.x;
		var ry = (enemy.y + enemy.height/2) - this.y;
		var radians = Math.atan2(ry,rx);
		projectile.rotation = radians;
		
		addChild(projectile);
		Starling.juggler.tween(projectile, .003 * Math.pow((Math.pow((enemy.x - this.x), 2) + Math.pow(enemy.y - this.y, 2)), .5), {
            delay: 0.0,
            x: (enemy.x + enemy.width/2) - this.x,
            y: (enemy.y + enemy.height/2) - this.y,
            onComplete: function() {
            	removeChild(projectile);
            	enemy.hit(this.attack);
            	Starling.juggler.delayCall(function() { this.attacking = false; }, (1 - .2 * this.speed) - .003 * Math.pow((Math.pow((enemy.x - this.x), 2) + Math.pow(enemy.y - this.y, 2)), .5));
            }
		});
	}
}



class TowerMenu extends Sprite
{
	public function new(game : Game, tower : Tower)
	{
		super();
		//Create a simple background to hold the tower menu together
		var bg = new Image(Root.assets[0].getTexture("towerMenu"));
		bg.x = (Starling.current.stage.stageWidth - bg.width) / 2;
		bg.y = (Starling.current.stage.stageHeight - bg.height) / 2;
		
		/////////////////////////
		//
		//When adding elements to the tower menu make sure tha the x and y values are
		//based on the x and y of the menu background and not the game window
		//and that all elements are added as children to this object and not the game object
		//Unless it's something you want to exist outside of this menu
		//
		/////////////////////////
		
		//Create a textfield that lists the stats of the tower
		var level = new TextField(150, 100, "LEVEL: " + tower.level, "font", 24, 0xFFFFFF);
		level.x = bg.x + (bg.width - level.width) / 2;
		level.y = bg.y + 5;
		
		//Create a textfield that lists the stats of the tower
		var text = new TextField(150, 150, "RANGE: " + tower.radius + "\nSPEED: " + tower.speed + "\nATTACK: " + tower.attack + "\nUpgrade Cost: " + tower.upgradeBaseCost, "font", 24, 0xFFFFFF);
		text.x = bg.x + 5;
		text.y = bg.y + (bg.width - text.width) / 2;
		
		//Allow the player to upgrade the tower
		var upgrade = new Button(Root.assets[0].getTexture("button"), "UPGRADE");
		upgrade.fontName = "font";
		upgrade.fontSize = 24;
		upgrade.fontColor = 0xFFFFFF;
		upgrade.x = text.x + text.width + upgrade.width;
		upgrade.y = text.y + (text.height - upgrade.height) / 2;
		
		
		if (tower.level < tower.maxLevel)
		{
			upgrade.addEventListener(Event.TRIGGERED, function()
			{
				//Check to make sure the player has enough coins
				if (game.getCoins() >= tower.upgradeBaseCost)
				{
					game.setCoins( -tower.upgradeBaseCost);
					tower.upgrade();
					level.text = "LEVEL: " + tower.level;
					text.text = "RANGE: " + tower.radius + "\nSPEED: " + tower.speed + "\nATTACK: " + tower.attack + "\nUpgrade Cost: " + tower.upgradeBaseCost;
				}
				//Otherwise inform the player they don't have enough coins
				else
				{
					var poor = new TextField(100, 100, "YOU DON'T HAVE ENOUGH COINS", "font", 24, 0xFFFFFF);
					poor.x = bg.x + (bg.width - poor.width) / 2;
					poor.y = bg.y + 10;
					addChild(poor);
					var timer = new Timer(500, 3);
					timer.start();
					timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent)
					{
						removeChild(poor);
					});
				}
			});
		}
		
		//Create sell button to sell the tower for the current tower upgrade amount
		var sell = new Button(Root.assets[0].getTexture("button"), "SELL");
		sell.fontName = "font";
		sell.fontSize = 24;
		sell.fontColor = 0xFFFFFF;
		sell.x = upgrade.x;
		sell.y = upgrade.y  + sell.height;
		sell.addEventListener(Event.TRIGGERED, function()
		{
			game.setCoins(tower.upgradeBaseCost);
			game.removeChild(tower);
			game.towerList.remove(tower);
			game.removeChild(this);
			
			//Unpause the game
			game.unpause();
		});
		
		
		
		//Create an exit button to close the tower menu
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
		
		addChild(bg);
		addChild(level);
		addChild(upgrade);
		addChild(sell);
		addChild(exit);
		addChild(text);
	}
}