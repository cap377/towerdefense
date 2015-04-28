/*
 * Create a map from a loaded text file. Map can be of varying sizes.
*/
class LoadMap
{
	public static function load(name:String) : Array<Array<String>>
	{
		//Load in the level as a bytearray and conver to string
		var str: String = new String(Root.assets.getByteArray(name).toString());
		//Add a character to the end of the string that is needed, is removed later
		str = str + ".";

		//Split the string at each new line and store it in an array
		var array = str.split("\n");

		//Create an integer map that represents the level
		var map : Array<Array<String>> = new Array();
		for (i in 0...array.length) {
			map[i] = new Array();
			for (j in 0...array[i].length-1) {
				//make sure null isn't being pushed into the map
				var val = array[i].charAt(j);
				if (val != null) {
					map[i].push(val);
				}
			}

			//remove the last row if nothing was put into it
			if(map[i].length == 0) map.pop();
		}

		return map;
	}
}