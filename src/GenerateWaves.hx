


class GenerateWaves
{
	public static function generate(loadedMap : Array<Array<String>>, game : Game)
	{
		
		var waves : Array<Wave> = new Array();
		
		var cnt = 0;
		for (y in 0...loadedMap.length)
		{
			if (loadedMap[y][0] == '<')
			{
				var string = loadedMap[y][1];
				for (x in 2...loadedMap[y].length)
				{
					string = string + loadedMap[y][x];
				}
				waves[cnt++] = new Wave(string, game);
			}
		}
		return waves;
	}
}