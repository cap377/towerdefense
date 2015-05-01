
class EnemyArray
{
	//This class contains a list of all sprite names for enemies in a 2d array.
	//Each row of the array represents an era and each row contains the enemies' sprite names for that era

	public var data : Array<Array<String>>;

	public function new() {
		data = new Array<Array<String>>();

		//Era 1 enemies
		data.push(["enemy-tank"]);

		//Era 2 enemies
		data.push(["enemy-tank"]);

		//Era 3 enemies
		data.push(["enemy-tank"]);

		//Era 4 enemies
		data.push(["enemy-tank"]);

		//Era 5 enemies
		data.push(["enemy-tank"]);
	}
}