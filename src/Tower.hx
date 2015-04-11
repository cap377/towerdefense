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
	
	public var level : Int;
	public var maxLevel : Int;
	public var upgradeCost : Int;
	public var radius : Int;
	public var speed : Int;
	public var attack : Int;
	
	public function new (game : Game)
	{
		super();
		level = 1;
		upgradeCost = 50;
		maxLevel = 3;
		radius = 2;
		speed = 1;
		attack = 1;
		this.game = game;
	}
	
	public function createTower(towerNum : Int, x : Float, y : Float)
	{
		///////////////////////
		//
		//The Image is currently created as a button, but a better option would
		//be to create movie clip (or whatever for animation) and then draw
		//a transparent button over it so that it is still clickable
		//
		///////////////////////
		
		//Create a new tower based on the tower clicked and set it to the correct position
		var button = new Button(Root.assets.getTexture("tower" + towerNum));
		button.x = x;
		button.y = y;
		button.addEventListener(Event.TRIGGERED, function()
		{
			//When clicked create a new tower menu
			game.addChild(new TowerMenu(game, this));
		});
		
		return button;
	}
	
	public function upgrade()
	{
		////////////////////////
		//
		//Currently all towers have the same stats and upgrades
		//The stats could be passed in as parameters when the tower is initially created
		//
		////////////////////////
		switch (level)
		{
			case 1:
				upgradeCost = 100;
				attack += 2;
			case 2:
				upgradeCost = 150;
				radius += 1;
				speed += 1;
			case 3:
				radius += 1;
				speed += 1;
				attack += 1;
		}
	}
}


class TowerMenu extends Sprite
{
	public function new(game : Game, tower : Tower)
	{
		super();
		//Create a simple background to hold the tower menu together
		var bg = new Image(Root.assets.getTexture("towerMenu"));
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
		
		//Create a textfield taht lists the stats of the tower
		var text = new TextField(150, 100, "Attack Radius: " + tower.radius + "\nAttack Speed: " + tower.speed + "\nAttack Power: " + tower.attack);
		text.x = bg.x + 5;
		text.y = bg.y + (bg.width - text.width) / 2;
		
		//Allow the player to upgrade the tower
		var upgrade = new Button(Root.assets.getTexture("button"), "Upgrade");
		upgrade.x = text.x + text.width + upgrade.width;
		upgrade.y = text.y + (text.height - upgrade.height) / 2;
		upgrade.addEventListener(Event.TRIGGERED, function()
		{
			//Check to make sure the player has enough coins
			if (game.getCoins() >= tower.upgradeCost)
			{
				game.setCoins( -tower.upgradeCost);
				tower.upgrade();
				text.text = "Attack Radius: " + tower.radius + "\nAttack Speed: " + tower.speed + "\nAttack Power: " + tower.attack;
			}
			//Otherwise inform the player they don't have enough coins
			else
			{
				var poor = new TextField(100, 100, "You don't have enough coins");
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
		
		//Create an exit button to close the tower menu
		var exit = new Button(Root.assets.getTexture("button"), "Exit");
		exit.x = bg.x + bg.width - exit.width;
		exit.y = bg.y + bg.height - exit.height;
		exit.addEventListener(Event.TRIGGERED, function()
		{
			game.removeChild(this);
		});
		
		addChild(bg);
		addChild(upgrade);
		addChild(exit);
		addChild(text);
	}
}