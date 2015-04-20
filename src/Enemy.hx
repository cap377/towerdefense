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
		//image = new Image(Root.assets.getTexture(name));

		/*
		Replaced the image with an animation
		Curently only uses one image, but when more assets are done they can be added to the animation
		*/
		//var atlas = Root.assets.getTextureAtlas("assets);  //This line will work once assets have been texture packed
		var vector = new flash.Vector<starling.textures.Texture>();
		vector.push(Root.assets.getTexture(name));
		this.animation = new MovieClipPlus(vector, 8);
		animation.loop = true;
		addChild(animation);
		animation.play();
		

		this.name = name;
		this.speed = speed;
		this.health = health;
		this.value = value;
		currentDirection = 2;
		alive = true;
		//addChild(image);
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
}