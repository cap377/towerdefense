


class GenerateWaves
{
	public static function generate(rawData : Array<Array<String>>, game : Game)
	{
		
		var waves : Array<Wave> = new Array();
		
		var cnt = 0;
		for (y in 0...rawData.length-1)
		{
			//Loop through until we get to the start of the wave data
			if (rawData[y][0] == '<')
			{
				//Create a string from this wave data to be parsed by the Wave class
				var string = rawData[y][1];
				for (x in 2...rawData[y].length)
				{
					string = string + rawData[y][x];
				}
				//Create a new wave with the generated string
				waves[cnt++] = new Wave(string, game);
			}
		}
		
		game.era = Std.parseInt(rawData[rawData.length-1][0]);
		
		return waves;
	}
}