import starling.display.Sprite;
import starling.display.Image;


///////////////////////
//
//All other enemies should extend this class
//
///////////////////////

class Enemy extends Sprite
{
	private var game : Game;
	private var image : Image;
	public var speed : Float;
	public var health : Float;
	public var value : Int;
	public var currentDirection : Int;
	public var alive : Bool;
	
	public function new(game : Game, name : String, speed : Float, health : Float, value : Int)
	{
		super();
		this.game = game;
		image = new Image(Root.assets.getTexture(name));
		this.speed = speed;
		this.health = health;
		this.value = value;
		currentDirection = 2;
		alive = true;
		addChild(image);
	}
	
	//Apply hit damage
	public function hit(damage : Float)
	{
		health = health - damage;
		//If health is to low give the player coins and kill the enemy
		if (health < 0.1)
		{
			game.setCoins(value);
			alive = false;
		}
	}
}