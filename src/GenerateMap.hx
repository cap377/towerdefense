


class GenerateMap
{
	public static function getMap(loadedMap:Array<Array<String>>)
	{
		
		var map : Array<Array<String>> = new Array();
		
		for (y in 0...loadedMap.length)
		{
			if (loadedMap[y][0] == '<')
			{
				break;
			}
			map[y] = new Array();
			for (x in 0...loadedMap[y].length)
			{
				map[y].push(loadedMap[y][x]);
			}
		}
		return map;
	}
}