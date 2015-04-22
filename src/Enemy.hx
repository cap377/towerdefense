import starling.display.Sprite;
import starling.display.Image;
import starling.core.Starling;


///////////////////////
//
//All other enemies should extend this class
//
///////////////////////

class Enemy extends Sprite
{
	private var game : Game;
	private var image : Image;
	private var animation : MovieClipPlus;
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
		//If health is to low give the create a coin and kill the enemy
		if (health <= 0)
		{
			var coin = new Coin(game, value, this.x, this.y);
			alive = false;
			game.removeChild(this);
		}
	}

	public function playAnimation(direction: Int) {
		//This code will handle animations for enemies
		//Until the assets are completed, it will not work
		//Assets for animation must also be texture packed
		/*
		removeChild(image);
		removeChild(animation);
		var atlas = Root.assets.getTextureAtlas("assets");
		animation = new MovieClipPlus(atlas.getTextures(name + "_" + direction), 8);
		animation.loop = true;
		addChild(animation);
		animation.play();
		Starling.juggler.add(animation);
		*/
	}
}