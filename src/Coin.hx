import starling.display.Sprite;
import starling.display.Image;
import starling.display.Button;
import starling.events.*;


class Coin extends Sprite
{
	
	public function new(game : Game, value : Int, x : Float, y : Float)
	{
		super();
		this.x = x;
		this.y = y;
		
		var collect = new Button(Root.assets.getTexture("coin"));
		collect.addEventListener(Event.TRIGGERED, function()
		{
			game.setCoins(value);
			game.removeChild(this);
		});
		addChild(collect);
		game.addChild(this);
	}

}