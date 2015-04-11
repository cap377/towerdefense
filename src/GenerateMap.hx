


class GenerateMap
{
	public static function getMap(rawData:Array<Array<String>>)
	{
		
		var map : Array<Array<String>> = new Array();
		
		for (y in 0...rawData.length)
		{
			//Break when we get to the start of the wave stuff
			if (rawData[y][0] == '<')
			{
				break;
			}
			map[y] = new Array();
			//Add the information to the map
			for (x in 0...rawData[y].length)
			{
				map[y].push(rawData[y][x]);
			}
		}
		return map;
	}
}