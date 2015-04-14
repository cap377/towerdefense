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
	//The size of each sprite
	private var size : Int = 32;
	
	private var currentLevel : Int;
	
	private var villagers : Int;
	private var villagerText : TextField;
	
	private var coins : Int;
	private var coinText : TextField;
	
	private var numEnemies : TextField;
	
	//Map of the level
	private var map : Array<Array<String>>;
	//All the waves for this level
	private var waves : Array<Wave>;
	//The enemies that have be spawned in
	private var spawnedEnemies : Array<Enemy>;
	//The entry point for the waves
	private var entryX : Array<Float>;
	private var entryY : Array<Float>;
	//What wave we are currently on
	private var waveNum : Int;
	
	private var flag : Bool = false;
	
	public function new()
	{
		super();
		//////////////////////
		//
		//Call to the main menu would go right here
		//
		/////////////////////
		
		spawnedEnemies = new Array();
		run();
	}
	
	//Entry point game to run
	public function run()
	{
		//Hold the entry points
		entryX = new Array();
		entryY = new Array();
		
		/////////////////////////////////
		//
		//Code for starting the next level would go right here
		//Could also have a level select from the main menu
		//nextLevel()
		//
		/////////////////////////////////
		
		currentLevel = 2;
		//Load in the text (map and waves) based on the current level
		var rawData = LoadMap.load("level" + currentLevel);
		//Get the map portion of the raw data
		map = GenerateMap.getMap(rawData);
		//Get the wave portion of the raw data
		waves = GenerateWaves.generate(rawData, this);
		
		drawMap();
		loadEnemies();
		waveNum = 0;
		
		
		numEnemies = new TextField(100, 50, "Enemies Left:\n" + waves[waveNum].getLength() + "/" + waves[waveNum].getLength());
		numEnemies.x = Starling.current.stage.stageWidth - numEnemies.width - 15;
		numEnemies.y = 5;
		addChild(numEnemies);
		
		villagers = 10;
		villagerText = new TextField(75, 50, "Villagers:\n" + villagers);
		villagerText.x = numEnemies.x - villagerText.width ;
		villagerText.y = 5;
		addChild(villagerText);
		
		coins = 250;
		coinText = new TextField(50, 50, "Coins:\n" + coins);
		coinText.x = villagerText.x - coinText.width;
		coinText.y = 5;
		addChild(coinText);
		
		
		startWave();
		
		this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
	}
	
	//Generate the next level
	public function nextLevel()
	{
		
	}
	
	//Creates a button that starts the next wave
	//When all waves are finished it calls the next level function
	public function nextWave()
	{
		if (waveNum != waves.length)
		{
			flag = false;
			
			var nextWave = new Button(Root.assets.getTexture("button"), "Next Wave");
			nextWave.x = Starling.current.stage.stageWidth - nextWave.width;
			nextWave.y = Starling.current.stage.stageHeight - nextWave.height;
			nextWave.addEventListener(Event.TRIGGERED, function()
			{
				spawnedEnemies = new Array();
				waveNum++;
				startWave();
				removeChild(nextWave);
			});
			addChild(nextWave);
		}
		else
			nextLevel();
	}
	
	//Anything that needs to be updated continuously goes here
	public function onEnterFrame(event:EnterFrameEvent)
	{
		////////////////////
		//
		//If we want it to pause when we open one of the menus
		//we could add a boolean that is checked each frame
		//and if its true the game is paused and unpaused otherwise
		//which can then be switched when a menu is created/closed
		//to pause/unpause the game
		//if(!paused)
		//	do the game logic here
		//
		////////////////////
		
		
		//Update the coin and villagers to reflect the new values
		villagerText.text = "Villagers:\n" + villagers;
		coinText.text = "Coins:\n" + coins;
		var numEnemiesLeft = enemiesLeft();
		numEnemies.text = "Enemies Left:\n" + numEnemiesLeft + "/" + waves[waveNum].getLength();
		
		//Move all spawned enemies that are still alive and check their position
		for (i in 0...spawnedEnemies.length)
		{
			if (spawnedEnemies[i].alive)
			{
				moveEnemy(i);
				checkPosition(i);
			}
		}
		
		//Check if all the enemies are dead
		if (numEnemiesLeft == 0 && flag)
		{
			nextWave();
		}
	}
	
	private function enemiesLeft()
	{
		var count = waves[waveNum].getLength();
		for (i in 0...spawnedEnemies.length)
		{
			if (!spawnedEnemies[i].alive)
				count--;
		}
		return count;
	}
	
	//////////////////////
	//
	//Case for each possible map type
	//Each possible type would require a different letter, symbol or number
	//Upper and lower case letters could be used to represent the same type with different attributes (ie g = grass, G = taller grass)
	//
	/////////////////////
	
	//Interpret and draw the map based on the loaded text file
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
						grass.x = x * size;
						grass.y = y * size;
						addChild(grass);
					case "p":
						var path = new Image(Root.assets.getTexture("path"));
						path.x = x * size;
						path.y = y * size;
						addChild(path);
					case "e":
						var entry = new Image(Root.assets.getTexture("entry"));
						entry.x = x * size;
						entry.y = y * size;
						entryX.push(entry.x);
						entryY.push(entry.y);
						addChild(entry);
					case "f":
						var finish = new Image(Root.assets.getTexture("finish"));
						finish.x = x * size;
						finish.y = y * size;
						addChild(finish);
					case "t":
						//Randomly choose a tree from all possible trees
						var tree = new Image(Root.assets.getTexture("tree" + (Std.random(2) + 1)));
						tree.x = x * size;
						tree.y = y * size;
						addChild(tree);
					case "b":
						var build = new Button(Root.assets.getTexture("build"));
						build.x = x * size;
						build.y = y * size;
						build.addEventListener(Event.TRIGGERED, function()
						{
							var buildMenu = new BuildMenu(this, build.x, build.y);
							addChild(buildMenu);
							
						});
						addChild(build);
					case "h":
						var hill = new Image(Root.assets.getTexture("hill"));
						hill.x = x * size;
						hill.y = y * size;
						addChild(hill);
				}
			}
		}
	}
	
	//Load all the enemies for this level right away to prevent any of them from being placed over other game objects
	private function loadEnemies()
	{
		for (i in 0...waves.length)
			for (j in 0...waves[i].getLength())
			{
				//Add the enemies to some point outside of the map
				waves[i].getEnemy(j).x = -100;
				waves[i].getEnemy(j).y = -100;
				addChild(waves[i].getEnemy(j));
			}
	}
	
	//Prime the wave to enter the game world
	public function startWave()
	{
		//Loop through all enemies in the current wave
		for (j in 0...waves[waveNum].getLength())
		{
			//Start each enemy with a slightly higher timer to stagger the inflow of enemies
			var timer = new Timer(j * 400 + 1000, 3);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent)
			{
				///////////////////////////
				//
				//Currently the entry point is randomly decided for each enemy
				//It could maybe switch back and forth depending on the wave
				//
				///////////////////////////
				
				//Start the wave at the entry point
				//Supports multiple entry points just not perfectly
				var entry = Std.random(entryX.length);
				waves[waveNum].getEnemy(j).x = entryX[entry] + 8;
				waves[waveNum].getEnemy(j).y = entryY[entry] + 8;
				spawnedEnemies.push(waves[waveNum].getEnemy(j));
				if (j == 1)
					flag = true;
			});
		}
	}
	
	//Check if the enemy is at the finish/goal
	private function checkPosition(waveEnemy : Int)
	{
		//To check if the enemy position is at the goal, we take the enemy's current x and y position and divide it by the size of tile
		//and round this down to a integer so that we can look it up in the map array
		if (map[Std.int(spawnedEnemies[waveEnemy].y / size)][Std.int(spawnedEnemies[waveEnemy].x / size)] == 'f')
		{
			villagers -= 1;
			spawnedEnemies[waveEnemy].alive = false;
			removeChild(spawnedEnemies[waveEnemy]);
		}
	}
	
	//Move the enemy based on the current/possible direction
	//Direction is based on 0 = -y, 1 = +x, 2 = +y, 3 = -x
	private function moveEnemy(waveEnemy : Int)
	{
		//Get either the current direction or the new direction
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
	
	//Check if the current direction is still good to move and if not figure the next direction to move
	//We don't allow them to move backwards normally, but in certian situations it can happen but never directly
	private function getDirection(waveEnemy : Int) : Int
	{
		//The new direction is based on the current direction
		switch (spawnedEnemies[waveEnemy].currentDirection)
		{
			case 0:
				//Check slightly in front of the enemy's current direction to see if the path changes or if it is still the same
				if (map[Std.int((spawnedEnemies[waveEnemy].y - 8) / size)][Std.int((spawnedEnemies[waveEnemy].x) / size)] != 'p' && map[Std.int((spawnedEnemies[waveEnemy].y - 8) / size)][Std.int((spawnedEnemies[waveEnemy].x) / size)] != 'f')
				{
					//If the path changes check the two orthoganol directions to determine which way to move
					//We don't allow them to move backwards as this should never be an option.
					//Change the enemy's current direction that reflects the direction change
					if (map[Std.int((waves[waveNum].getEnemy(waveEnemy).y) / size)][Std.int((spawnedEnemies[waveEnemy].x - 24) / size)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 3;
					}
					else if (map[Std.int((spawnedEnemies[waveEnemy].y) / size)][Std.int((spawnedEnemies[waveEnemy].x + 24) / size)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 1;
					}
				}
				//Return the enemy's current/new direction
				return spawnedEnemies[waveEnemy].currentDirection;
			case 1:
				if (map[Std.int((spawnedEnemies[waveEnemy].y) / size)][Std.int((spawnedEnemies[waveEnemy].x + 24) / size)] != 'p' && map[Std.int((spawnedEnemies[waveEnemy].y) / size)][Std.int((spawnedEnemies[waveEnemy].x + 24) / size)] != 'f')
				{
					if (map[Std.int((spawnedEnemies[waveEnemy].y + 24) / size)][Std.int((spawnedEnemies[waveEnemy].x) / size)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 2;
					}
					else if (map[Std.int((spawnedEnemies[waveEnemy].y - 24) / size)][Std.int((spawnedEnemies[waveEnemy].x) / size)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 0;
					}
				}
				return spawnedEnemies[waveEnemy].currentDirection;
			case 2:
				if (map[Std.int((spawnedEnemies[waveEnemy].y + 24) / size)][Std.int((spawnedEnemies[waveEnemy].x) / size)] != 'p' && map[Std.int((spawnedEnemies[waveEnemy].y + 24) / size)][Std.int((spawnedEnemies[waveEnemy].x) / size)] != 'f')
				{
					if (map[Std.int((spawnedEnemies[waveEnemy].y) / size)][Std.int((spawnedEnemies[waveEnemy].x - 24) / size)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 3;
					}
					else if (map[Std.int((spawnedEnemies[waveEnemy].y) / size)][Std.int((spawnedEnemies[waveEnemy].x + 24) / size)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 1;
					}
				}
				return spawnedEnemies[waveEnemy].currentDirection;
			case 3:
				if (map[Std.int((spawnedEnemies[waveEnemy].y) / 32)][Std.int((spawnedEnemies[waveEnemy].x - 8) / 32)] != 'p' && map[Std.int((spawnedEnemies[waveEnemy].y) / 32)][Std.int((spawnedEnemies[waveEnemy].x - 24) / 32)] != 'f')
				{
					if (map[Std.int((spawnedEnemies[waveEnemy].y + 24) / 32)][Std.int((spawnedEnemies[waveEnemy].x) / 32)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 2;
					}
					else if (map[Std.int((spawnedEnemies[waveEnemy].y - 24) / 32)][Std.int((spawnedEnemies[waveEnemy].x) / 32)] == 'p')
					{
						spawnedEnemies[waveEnemy].currentDirection = 0;
					}
				}
				return spawnedEnemies[waveEnemy].currentDirection;
		}
		//If for some strange reason the current direction is not one of the above
		//Keep moving in whatever direction it is moving
		return spawnedEnemies[waveEnemy].currentDirection;
	}
	
	//Setter and getter function for the coins
	public function getCoins()
	{
		return coins;
	}
	public function setCoins(amount : Int)
	{
		coins = coins + amount;
	}
}