package;

import openfl.display.*;
import openfl.events.*;

class Main extends Sprite
{
	public var currentGen:Array<PClass> = [];
	public var nextGen:Array<PClass> = [];
	public var givers:Array<Int> = [];
	public var takers:Array<Int> = [];
	public var popTotal:Int = 100000;//total population; 
	public var numLastName:Int = 100;//number of last names
	public var lastNameOccurence:Array<Int> = [];//amount of people with each last name
	
	var histogramWidth:Int = 600;//histrogram width in pixels
	var histogramHeight:Int = 300;//histrogram height in pixels
	var histogramX:Int = 10;//histrogram leftmost X in pixels
	var histogramY:Int = 10;//histrogram uppermost Y in pixels
	var graphSprt:Sprite = new Sprite();
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
	}
	public function drawFrame(e:Event)
	{
		var sortedA:Array<Int> = lastNameCommonness();
		var prevV:Int = -1;
		var prevP:Int = -1;
		stage.removeChild(graphSprt);
		graphSprt = new Sprite();
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
			var ratio = sortedA[i]/sortedA[0];
			graphSprt.graphics.beginFill(prevP*2);
			graphSprt.graphics.drawRect(histogramX+i*6, histogramY+histogramHeight*(1-ratio), 6, histogramHeight*(ratio));
		}
		stage.addChild(graphSprt);
		createNewGeneration();
	}
	public function createNewGeneration()
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
		var popDiff = Math.abs(givers.length-takers.length);
		while(givers.length > 0 && takers.length > 0)
		{
			var gPos = Math.floor(givers.length*Math.random());
			var gCPos = givers[gPos];
			givers.splice(gPos, 1);
			var tPos = Math.floor(takers.length*Math.random());
			var tCPos = takers[tPos];
			takers.splice(tPos, 1);
			for(i in 0 ... 2)
			{
				nextGen.push(new PClass(Math.floor(2*Math.random()), currentGen[gCPos].lastName));
			}
			if(popDiff > 0)
			{
				nextGen.push(new PClass(Math.floor(2*Math.random()), currentGen[gCPos].lastName));
				popDiff--;
			}
		}
		currentGen = nextGen.copy();
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
}
