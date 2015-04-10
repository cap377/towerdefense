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
		
		bg = new Image(Root.assets.getTexture("createTowerMenu"));
		bg.x = (Starling.current.stage.stageWidth - bg.width) / 2;
		bg.y = (Starling.current.stage.stageHeight - bg.height) / 2;
		addChild(bg);
		
		
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
		
		
		var exit = new Button(Root.assets.getTexture("button"), "Exit");
		exit.x = bg.x + bg.width - exit.width;
		exit.y = bg.y + bg.height - exit.height;
		exit.addEventListener(Event.TRIGGERED, function()
		{
			game.removeChild(this);
		});
		addChild(exit);
	}
	
	
	private function buyTower(towerNum : Int, cost : Int, x : Float, y : Float)
	{
			if (game.getCoins() >= cost)
			{
				if (towerNum == 2)
					y = y - 32;
				var tower = new Tower(game);
				var temp = tower.createTower(towerNum, x, y);
				game.addChild(temp);
				game.setCoins( -cost);
				game.removeChild(this);
			}
			else
			{
				var text = new TextField(100, 100, "You don't have enough coins");
				text.x = (Starling.current.stage.stageWidth - text.width) / 2;
				text.y = bg.y + 10;
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