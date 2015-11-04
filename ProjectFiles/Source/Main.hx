package;

import openfl.display.*;
import openfl.events.*;
import openfl.Lib;

class Main extends Sprite
{
	public var currentGen:Array<PClass> = [];
	public var nextGen:Array<PClass> = [];
	public var givers:Array<Int> = [];
	public var takers:Array<Int> = [];
	public var popTotal:Int = 100000;//total population; 
	public var numLastName:Int = 100;//number of last names
	public var lastNameOccurence:Array<Int> = [];//amount of people with each last name
	public var popDiff:Int;//variable for tracking intial difference in givers/takers in generation
	
	var histogramWidth:Int = 600;//histrogram width in pixels
	var histogramHeight:Int = 300;//histrogram height in pixels
	var histogramX:Int = 10;//histrogram leftmost X in pixels
	var histogramY:Int = 10;//histrogram uppermost Y in pixels
	var gramSprt:Sprite = new Sprite();//sprite for the histrogram
	var progSprt:Sprite = new Sprite();//sprite for progress bar
	
	var barColour:Array<Int> = [];
	
	public function new ()
	{
		super ();
		init();
		stage.addEventListener(Event.ENTER_FRAME, drawFrame);
	}
	public function init()//initializes the first generation
	{
		for(i in 0...popTotal)
		{
			currentGen.push(new PClass(Math.floor(2*Math.random()), Math.floor(numLastName*Math.random())));
		}
		for(i in 0...numLastName)
		{
			lastNameOccurence.push(0);
		}
		for(i in 0...currentGen.length)
		{
			lastNameOccurence[currentGen[i].lastName]++;
		}
		initNewGeneration();
		var stepAmount = Math.ceil(Math.pow(numLastName, 1/3));
		var stepVal = 200/stepAmount;
		for(i in 0...numLastName)
		{
			barColour.push(createColour(Math.floor(i/(stepAmount*stepAmount))*stepVal, (Math.floor(i/stepAmount)*stepVal)%200,(i*stepVal)%200,255));
		}
		drawGraph();
	}
	public function drawFrame(e:Event)
	{
		drawProgress();
		if(createNewGeneration(Lib.getTimer()))
		{
			drawGraph();
			initNewGeneration();
		}
	}
	public function drawProgress()
	{
		stage.removeChild(progSprt);
		progSprt = new Sprite();
		progSprt.graphics.beginFill(0);
		var ratio:Float = 1-Math.min(givers.length/(popTotal>>1),takers.length/(popTotal>>1));
		progSprt.graphics.drawRect(histogramX, histogramY+histogramHeight, histogramWidth*ratio, 10);
		stage.addChild(progSprt);
	}
	public function drawGraph()
	{
		var sortedA:Array<Int> = lastNameCommonness();
		var prevV:Int = -1;
		var prevP:Int = -1;
		stage.removeChild(gramSprt);
		gramSprt = new Sprite();
		for(i in 0...sortedA.length)
		{
			if(prevV == sortedA[i])
			{
				prevP = lastNameOccurence.indexOf(sortedA[i], prevP+1);
			}
			else
			{
				prevP = lastNameOccurence.indexOf(sortedA[i]);
				prevV = sortedA[i];
			}
			var ratio:Float = sortedA[i]/sortedA[0];
			gramSprt.graphics.beginFill(barColour[prevP]);
			gramSprt.graphics.drawRect(histogramX+i*6, histogramY+histogramHeight*(1-ratio), 6, histogramHeight*(ratio));
		}
		stage.addChild(gramSprt);
	}
	public function initNewGeneration()
	{
		nextGen = [];
		givers = [];
		takers = [];
		for(i in 0...currentGen.length)
		{
			if(currentGen[i].nameGiver)
			{
				givers.push(i);
			}
			else
			{
				takers.push(i);
			}
		}
		popDiff = Math.round(Math.abs(givers.length-takers.length));
	}
	public function createNewGeneration(beginTime:Int):Bool
	{
		while(givers.length > 0 && takers.length > 0)
		{
			var gPos = Math.floor(givers.length*Math.random());
			var gCPos = givers[gPos];
			givers[gPos] = givers[givers.length-1];
			givers.pop();
			var tPos = Math.floor(takers.length*Math.random());
			var tCPos = takers[tPos];
			takers[tPos] = takers[takers.length-1];
			takers.pop();
			for(i in 0 ... 2)
			{
				nextGen.push(new PClass(Math.floor(2*Math.random()), currentGen[gCPos].lastName));
			}
			if(popDiff > 0)
			{
				nextGen.push(new PClass(Math.floor(2*Math.random()), currentGen[gCPos].lastName));
				popDiff--;
			}
			if(Lib.getTimer()-beginTime>16)
			return false;
		}
		currentGen = nextGen.copy();
		return true;
	}
	public function lastNameCommonness():Array<Int>
	{
		lastNameOccurence = [];
		for(i in 0...numLastName)
		{
			lastNameOccurence.push(0);
		}
		for(i in 0...currentGen.length)
		{
			lastNameOccurence[currentGen[i].lastName]++;
		}
		var sortedOccurence:Array<Int> = lastNameOccurence.copy();
		sortedOccurence.sort( function(a:Int, b:Int):Int
		{
			if (a > b) return -1;
			if (a < b) return 1;
			return 0;
		} );
		return sortedOccurence;
	}
	public function createColour(red:Float, green:Float, blue:Float, alpha:Float):Int//same as crtClr expect uses floats
	{
		return constrain(Math.round(alpha), 0, 255)<<24 | constrain(Math.round(red), 0, 255) << 16 | constrain(Math.round(green), 0, 255) << 8 | constrain(Math.round(blue), 0, 255);
	}
	public function constrain(value:Int, min:Int, max:Int):Int // sees if the value (first parameter), is within a minimum value (second parameter) and maximum value (third parameter) and returns the constrained value.
	{
		if(value < min)
		{
			return min;
		}
		else if(value > max)
		{
			return max;
		}
		else
		{
			return value;
		}
	}
}
