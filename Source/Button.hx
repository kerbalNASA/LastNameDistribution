package;

import openfl.display.*;

class Button
{
	public var x:Int;
	public var endX:Int;
	public var y:Int;
	public var endY:Int;
	public var hoverDisplay:Bitmap;
	public var normalDisplay:Bitmap;
	public var pressDisplay:Bitmap;
	public var displayState:Int = 0;
	public var callFn:Void->Void;
	public function new (ihoverDisplay:Bitmap, inormalDisplay:Bitmap, ipressDisplay:Bitmap, ix:Int, iy:Int, icallFn)
	{
		x = ix;
		y = iy;
		hoverDisplay = ihoverDisplay;
		hoverDisplay.x = x;
		hoverDisplay.y = y;
		normalDisplay = inormalDisplay;
		normalDisplay.x = x;
		normalDisplay.y = y;
		pressDisplay = ipressDisplay;
		pressDisplay.x = x;
		pressDisplay.y = y;
		endX = x + Math.ceil(hoverDisplay.width);
		endY = y + Math.ceil(hoverDisplay.height);
		callFn = icallFn;
		displayState = 1;
		Main.pubStage.addChild(normalDisplay);
		stateUpdate();
	}
	public function update()
	{
		stateUpdate();
	}
	public function stateUpdate()
	{
		if(bConstrain(Main.pubStage.mouseX, x, endX) && bConstrain(Main.pubStage.mouseY, y, endY))
		{
			if(Main.mDown)
			{
				if(displayState == 0)
				{
					displayState = 2;
					Main.pubStage.removeChild(hoverDisplay);
					Main.pubStage.addChild(pressDisplay);
				}
				else if(displayState == 1)
				{
					displayState = 2;
					Main.pubStage.removeChild(normalDisplay);
					Main.pubStage.addChild(pressDisplay);
				}
			}
			else if(displayState == 1)
			{
				displayState = 0;
				Main.pubStage.removeChild(normalDisplay);
				Main.pubStage.addChild(hoverDisplay);
			}
			else if(displayState == 2)
			{
				displayState = 0;
				Main.pubStage.removeChild(pressDisplay);
				Main.pubStage.addChild(hoverDisplay);
			}
		}
		else if(displayState == 0)
		{
			Main.pubStage.removeChild(hoverDisplay);
			Main.pubStage.addChild(normalDisplay);
			displayState = 1;
		}
		else if(displayState == 2)
		{
			Main.pubStage.removeChild(hoverDisplay);
			Main.pubStage.addChild(normalDisplay);
			displayState = 1;
		}
	}
	public function bConstrain(value:Float, min:Float, max:Float) // returns true if the value (first parameter), is within a minimum value (second parameter) and maximum value (third parameter) otherwise returns false
	{
		if(value < min)
		{
			return false;
		}
		else if(value > max)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	public function callFunctionIfClicked()//calls this button's function when clicked
	{
		if(bConstrain(Main.pubStage.mouseX, x, endX) && bConstrain(Main.pubStage.mouseY, y, endY))
		{
			callFn();
		}
	}
}
