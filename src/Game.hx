import starling.display.Sprite;
import starling.display.Image;
import starling.display.Button;
import starling.events.*;
import starling.events.EnterFrameEvent;
import flash.utils.Timer;
import flash.events.TimerEvent;
import starling.text.TextField;
import starling.core.Starling;


class Game extends Sprite
{
	private var villagers : Int;
	private var villagerText : TextField;
	
	private var coins : Int;
	private var coinText : TextField;
	
	private var map : Array<Array<String>>;
	private var waves : Array<Wave>;
	private var spawnedEnemies : Array<Enemy>;
	private var waveX : Float;
	private var waveY : Float;
	private var waveNum : Int;
	
	public function new()
	{
		super();
		spawnedEnemies = new Array();
		run();
	}
	public function run()
	{
		waveNum = 0;
		var loadedMap = LoadMap.load("level1");
		map = GenerateMap.getMap(loadedMap);
		waves = GenerateWaves.generate(loadedMap, this);
		
		drawMap();
		startWave(waveNum);
		
		villagers = 10;
		villagerText = new TextField(75, 50, "Villagers: " + villagers);
		villagerText.x = Starling.current.stage.stageWidth - villagerText.width * 2;
		villagerText.y = 5;
		addChild(villagerText);
		
		coins = 250;
		coinText = new TextField(50, 50, "Coins: " + coins);
		coinText.x = Starling.current.stage.stageWidth - coinText.width - 15;
		coinText.y = 5;
		addChild(coinText);
		
		this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
	}
	
	public function onEnterFrame(event:EnterFrameEvent)
	{
		villagerText.text = "Villagers: " + villagers;
		coinText.text = "Coins: " + coins;
		
		for (i in 0...spawnedEnemies.length)
		{
			if (spawnedEnemies[i].alive)
			{
				moveEnemy(i);
				checkPosition(i);
			}
		}
	}
	
	public function drawMap()
	{
		for (y in 0...map.length)
		{
			for (x in 0...map[y].length)
			{
				switch (map[y][x])
				{
					case "g":
						var grass = new Image(Root.assets.getTexture("grass"));
						grass.x = x * 32;
						grass.y = y * 32;
						addChild(grass);
					case "p":
						var path = new Image(Root.assets.getTexture("path"));
						path.x = x * 32;
						path.y = y * 32;
						addChild(path);
					case "e":
						var entry = new Image(Root.assets.getTexture("entry"));
						entry.x = x * 32;
						entry.y = y * 32;
						waveX = entry.x;
						waveY = entry.y;
						addChild(entry);
					case "f":
						var finish = new Image(Root.assets.getTexture("finish"));
						finish.x = x * 32;
						finish.y = y * 32;
						addChild(finish);
					case "t":
						var tree = new Image(Root.assets.getTexture("tree"));
						tree.x = x * 32;
						tree.y = y * 32;
						addChild(tree);
					case "b":
						var build = new Button(Root.assets.getTexture("build"));
						build.x = x * 32;
						build.y = y * 32;
						build.addEventListener(Event.TRIGGERED, function()
						{
							var createTower = new CreateTower(this, build.x, build.y);
							addChild(createTower);
							
						});
						addChild(build);
				}
			}
		}
	}
	
	public function startWave(waveNum : Int)
	{
		for (j in 0...waves[waveNum].getLength())
		{
			var timer = new Timer(j * 400 + 1000, 3);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent)
			{
				waves[waveNum].getEnemy(j).x = waveX + Std.random(16);
				waves[waveNum].getEnemy(j).y = waveY;
				spawnedEnemies.push(waves[waveNum].getEnemy(j));
				trace(spawnedEnemies.length);
				addChild(spawnedEnemies[j]);
			});
		}
	}
	
	private function checkPosition(waveEnemy : Int)
	{
		if (map[Std.int(spawnedEnemies[waveEnemy].y / 32)][Std.int(spawnedEnemies[waveEnemy].x / 32)] == 'f')
		{
			villagers -= 1;
			spawnedEnemies[waveEnemy].alive = false;
			removeChild(spawnedEnemies[waveEnemy]);
		}
	}
	
	private function moveEnemy(waveEnemy : Int)
	{
		switch (getDirection(waveEnemy))
		{
			case 0:
				spawnedEnemies[waveEnemy].y -= spawnedEnemies[waveEnemy].speed;
			case 1:
				spawnedEnemies[waveEnemy].x += spawnedEnemies[waveEnemy].speed;
			case 2:
				spawnedEnemies[waveEnemy].y += spawnedEnemies[waveEnemy].speed;
			case 3:
				spawnedEnemies[waveEnemy].x -= spawnedEnemies[waveEnemy].speed;
		}
	}
	
	private function getDirection(waveEnemy : Int) : Int
	{
		switch (spawnedEnemies[waveEnemy].currentDirection)
		{
			case 0:
				if (map[Std.int((spawnedEnemies[waveEnemy].y - 8) / 32)][Std.int((spawnedEnemies[waveEnemy].x) / 32)] != 'p' && map[Std.int((spawnedEnemies[waveEnemy].y - 8) / 32)][Std.int((spawnedEnemies[waveEnemy].x) / 32)] != 'f')
				{
					if (map[Std.int((waves[waveNum].getEnemy(waveEnemy).y) / 32)][Std.int((spawnedEnemies[waveEnemy].x - 24) / 32)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 3;
					}
					else if (map[Std.int((spawnedEnemies[waveEnemy].y) / 32)][Std.int((spawnedEnemies[waveEnemy].x + 24) / 32)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 1;
					}
				}
				return spawnedEnemies[waveEnemy].currentDirection;
			case 1:
				if (map[Std.int((spawnedEnemies[waveEnemy].y) / 32)][Std.int((spawnedEnemies[waveEnemy].x + 24) / 32)] != 'p' && map[Std.int((spawnedEnemies[waveEnemy].y) / 32)][Std.int((spawnedEnemies[waveEnemy].x + 24) / 32)] != 'f')
				{
					if (map[Std.int((spawnedEnemies[waveEnemy].y - 24) / 32)][Std.int((spawnedEnemies[waveEnemy].x) / 32)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 0;
					}
					else if (map[Std.int((spawnedEnemies[waveEnemy].y + 24) / 32)][Std.int((spawnedEnemies[waveEnemy].x) / 32)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 2;
					}
				}
				return spawnedEnemies[waveEnemy].currentDirection;
			case 2:
				if (map[Std.int((spawnedEnemies[waveEnemy].y + 24) / 32)][Std.int((spawnedEnemies[waveEnemy].x) / 32)] != 'p' && map[Std.int((spawnedEnemies[waveEnemy].y + 24) / 32)][Std.int((spawnedEnemies[waveEnemy].x) / 32)] != 'f')
				{
					if (map[Std.int((spawnedEnemies[waveEnemy].y) / 32)][Std.int((spawnedEnemies[waveEnemy].x - 24) / 32)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 3;
					}
					else if (map[Std.int((spawnedEnemies[waveEnemy].y) / 32)][Std.int((spawnedEnemies[waveEnemy].x + 24) / 32)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 1;
					}
				}
				return spawnedEnemies[waveEnemy].currentDirection;
			case 3:
				if (map[Std.int((spawnedEnemies[waveEnemy].y) / 32)][Std.int((spawnedEnemies[waveEnemy].x - 8) / 32)] != 'p' && map[Std.int((spawnedEnemies[waveEnemy].y) / 32)][Std.int((spawnedEnemies[waveEnemy].x - 24) / 32)] != 'f')
				{
					if (map[Std.int((spawnedEnemies[waveEnemy].y - 24) / 32)][Std.int((spawnedEnemies[waveEnemy].x) / 32)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 0;
					}
					else if (map[Std.int((spawnedEnemies[waveEnemy].y + 24) / 32)][Std.int((spawnedEnemies[waveEnemy].x) / 32)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 2;
					}
				}
				return spawnedEnemies[waveEnemy].currentDirection;
		}
		return spawnedEnemies[waveEnemy].currentDirection;
	}
	
	public function getCoins()
	{
		return coins;
	}
	public function setCoins(amount : Int)
	{
		coins = coins + amount;
	}
}