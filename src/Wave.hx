//import starling.display.Sprite;
import starling.display.Image;


class Wave
{
	private var wave : Array<Enemy>;
	private var stringWave : Array<String>;
	private var game : Game;
	
	public function new (string : String, game : Game)
	{
		this.game = game;
		wave = new Array();
		stringWave = new Array();
		interpret(string);
		createEnemies();
	}
	
	//Parse through the string built by generate wave
	private function interpret(string : String)
	{
		//Pointer to the current position
		//Should only point at the characters in the string
		var index = 0;
		//Go through the string until the end symbol is found of the index is the length of the string
		while (string.charAt(index) != '>' && index < string.length)
		{
			var count = 0;
			//Scan from the current position to the next comma or end
			while (string.charAt(index + count) != ',' && string.charAt(index + count) != '>')
			{
				count++;
			}
			//Check that we are pointing at a Letter and not a number or some other character
			if (Std.parseInt(string.charAt(index)) == null && string.charAt(index) != ',' && count > 0)
			{
				//Create a string of the amount of this type of enemies, ie <W99> becomes 99
				var stringAmount = "";
				//Skip the first position which is the letter we want
				for (i in 1...count)
				{
					//Append the next number to the string
					stringAmount = stringAmount + string.charAt(index + i);
				}
				//Build the wave based on the number of character and the amount of that character
				buildWave(string.charAt(index), Std.parseInt(stringAmount));
			}
			//Update index
			if (count > 0)
				index = index + count;
			else
				index++;
		}
	}
	
	private function buildWave(char : String, amount : Int)
	{
		//Add the character to the string array based on the number of times it should show up
		//ie <W3,E2,S4> becomes WWWEESSSS
		for (i in 0...amount)
		{
			stringWave.push(char);
		}
	}
	
	//Creates the enemies and adds them to the wave based on the string array that was generated
	private function createEnemies()
	{
		for (i in 0...stringWave.length)
		{
			switch (stringWave[i])
			{
				case 'W':
					//Set up as the (current game, the enemy name, speed, health, value)
					wave.push(new Enemy(game, stringWave[i], .7, 15, 20));
				case 'E':
					wave.push(new Enemy(game, stringWave[i], .3, 50, 100));
				case 'S':
					wave.push(new Enemy(game, stringWave[i], 1.1, 15, 30));
				//////////////////////////////
				//
				//Case for each possible enemy
				//Each possible enemy would require a different letter, symbol or number
				//Upper and lower case letters could be used to represent the same enemy with different attributes (speed, health, value)
				//
				/////////////////////////////
					
			}
		}
	}
	
	//Getter functions
	//Returns the enemy at index
	public function getEnemy(index : Int)
	{
		return wave[index];
	}
	
	//Returns the length of the wave
	public function getLength()
	{
		return wave.length;
	}
}