
class EnemyArray
{
	//This class contains a list of all sprite names for enemies in a 2d array.
	//Each row of the array represents an era and each row contains the enemies' sprite names for that era

	public var data : Array<Array<String>>;

	public function new() {
		data = new Array<Array<String>>();

		//Era 1 enemies
		data.push(["sabertooth", "wolves", "mammoth"]);

		//Era 2 enemies
		data.push(["chariot", "centurion", "trojan"]);

		//Era 3 enemies
		data.push(["rats", "knight", "demon"]);

		//Era 4 enemies
		data.push(["jeep", "zombies", "enemy-tank", "deathtank"]);

		//Era 5 enemies
		data.push(["robot1", "robot2", "robot3", "deathbot"]);
	}
}