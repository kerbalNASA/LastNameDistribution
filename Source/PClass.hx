package;

class PClass
{
	public var nameGiver:Bool;
	public var lastName:Int;
	public function new (iNameGiver:Int, iLastName:Int)
	{
		nameGiver = false;
		if (iNameGiver == 1)
		nameGiver = true;
		lastName = iLastName;
	}
}
