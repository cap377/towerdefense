import starling.display.Sprite;
import starling.display.Image;
import starling.display.Button;
import starling.events.*;


class Coin extends Sprite
{
	
	public function new(game : Game, value : Int, x : Float, y : Float)
	{
		super();
		
		var collect = new Button(Root.assets.getTexture("coin"));
		collect.x = x;
		collect.y = y;
		collect.addEventListener(Event.TRIGGERED, function()
		{
			game.setCoins(value);
			game.removeChild(this);
		});
		game.addChild(this);
	}

}