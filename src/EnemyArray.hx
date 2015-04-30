
class EnemyArray
{
	//This class contains a list of all sprite names for enemies in a 2d array.
	//Each row of the array represents an era and each row contains the enemies' sprite names for that era

	public var data : Array<Array<String>>;

	public function new() {
		data = new Array<Array<String>>();
		data.push(["enemy-tank"]);
	}
}