import starling.display.Sprite;
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
		getImages();
	}
	
	private function interpret(string : String)
	{
		var index = 0;
		while (string.charAt(index) != '>' && index < string.length)
		{
			var count = 0;
			while (string.charAt(index + count) != ',' && string.charAt(index + count) != '>')
			{
				count++;
			}
			if (Std.parseInt(string.charAt(index)) == null && string.charAt(index) != ',' && count > 0)
			{
				var stringAmount = "";
				for (i in 1...count)
				{
					stringAmount = stringAmount + string.charAt(index + i);
				}
				buildWave(string.charAt(index), Std.parseInt(stringAmount));
			}
			if (count > 0)
				index = index + count;
			else
				index++;
		}
	}
	
	private function buildWave(char : String, amount : Int)
	{
		for (i in 0...amount)
		{
			stringWave.push(char);
		}
	}
	
	private function getImages()
	{
		for (i in 0...stringWave.length)
		{
			switch (stringWave[i])
			{
				case 'W':
					wave.push(new Wolf(game, stringWave[i], .7, 15, 5));
				case 'E':
					wave.push(new Elephant(game, stringWave[i], .3, 50, 30));
				case 'S':
					wave.push(new Sabretooth(game, stringWave[i], 1.1, 15, 10));
					
			}
		}
	}
	
	public function getEnemy(index : Int)
	{
		return wave[index];
	}
	
	public function getLength()
	{
		return wave.length;
	}
}