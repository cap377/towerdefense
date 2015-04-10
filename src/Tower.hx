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
		var button = new Button(Root.assets.getTexture("tower" + towerNum));
		button.x = x;
		button.y = y;
		
		button.addEventListener(Event.TRIGGERED, function()
		{
			game.addChild(new TowerMenu(game, this));
		});
		
		return button;
	}
	
	public function upgrade()
	{
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
		var bg = new Image(Root.assets.getTexture("towerMenu"));
		var exit = new Button(Root.assets.getTexture("button"), "Exit");
		var upgrade = new Button(Root.assets.getTexture("button"), "Upgrade");
		var text = new TextField(150, 100, "Attack Radius: " + tower.radius + "\nAttack Speed: " + tower.speed + "\nAttack Power: " + tower.attack);
		
		bg.x = (Starling.current.stage.stageWidth - bg.width) / 2;
		bg.y = (Starling.current.stage.stageHeight - bg.height) / 2;
		
		text.x = bg.x + 5;
		text.y = bg.y + (bg.width - text.width) / 2;
		
		
		upgrade.x = text.x + text.width + upgrade.width;
		upgrade.y = text.y + (text.height - upgrade.height) / 2;
		upgrade.addEventListener(Event.TRIGGERED, function()
		{
			if (game.getCoins() >= tower.upgradeCost)
			{
				game.setCoins( -tower.upgradeCost);
				tower.upgrade();
				text.text = "Attack Radius: " + tower.radius + "\nAttack Speed: " + tower.speed + "\nAttack Power: " + tower.attack;
			}
			else
			{
				var poor = new TextField(100, 100, "You don't have enough coins");
				poor.x = (Starling.current.stage.stageWidth - poor.width) / 2;
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