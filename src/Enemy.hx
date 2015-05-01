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
	public var maxHealth : Float;
	public var healthBar : Image;
	public var value : Int;
	public var currentDirection : Int;
	public var alive : Bool;

	
	public function new(game : Game, name : String, speed : Float, health : Float, value : Int)
	{
		super();
		this.game = game;
		//image = new Image(Root.assets[game.era].getTexture(name));
		this.name = name;
		this.speed = speed;
		this.health = health;
		this.maxHealth = health;
		this.value = value;
		currentDirection = 2;
		alive = true;
		//addChild(image);
		
		healthBar = new Image(Root.assets[0].getTexture("enemyHealth"));
		healthBar.y = -12;
		addChild(healthBar);
		
	}
	
	//Apply hit damage
	public function hit(damage : Float)
	{
		health = health - damage;
		

		healthBar.scaleX = health / maxHealth;
		

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
		
		var directionString = "";
		if(direction == 0) {
			directionString = "back";
		} else if(direction == 1) {
			directionString = "right";
		} else if(direction == 2) {
			directionString = "";
		} else if(direction == 3) {
			directionString = "left";
		}

		//Look up the sprite name for the enemy
		var spriteName = "";
		if(this.name == "S") {
			spriteName = game.enemyArray.data[game.era - 1][0];
		}
		if(this.name == "W") {
			spriteName = game.enemyArray.data[game.era - 1][1];
		}
		if(this.name == "E") {
			spriteName = game.enemyArray.data[game.era - 1][2];
		}
		if(this.name == "B") {
			spriteName = game.enemyArray.data[game.era - 1][3];
		}

		//removeChild(image);
		removeChild(animation);
		var atlas = Root.assets[game.era].getTextureAtlas("assets");
		animation = new MovieClipPlus(atlas.getTextures(spriteName + directionString + "_page_0"), 4);
		animation.width = 32;
		animation.height = 32;
		animation.x = -8;
		animation.y = -8;
		animation.loop = true;
		addChild(animation);
		animation.play();
		Starling.juggler.add(animation);
		
	}
}