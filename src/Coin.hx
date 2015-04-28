import starling.display.Sprite;
import starling.display.Image;
import starling.display.Button;
import starling.core.Starling;
import starling.events.*;


class Coin extends Sprite
{
	
	public function new(game : Game, value : Int, x : Float, y : Float)
	{
		super();
		this.x = x;
		this.y = y;
		
		var collect = new Button(Root.assets[0].getTexture("button"));

		var atlas = Root.assets[0].getTextureAtlas("assets");
		var animation = new MovieClipPlus(atlas.getTextures("spinning_coin"), 8);
		animation.loop = true;
		addChild(animation);
		animation.play();
		Starling.juggler.add(animation);

		collect.addEventListener(Event.TRIGGERED, function()
		{
			Root.assets[0].playSound("Pickup_Coin", 0, 0);
			game.setCoins(value);
			game.removeChild(this);
		});
		addChild(collect);
		game.addChild(this);
	}

}