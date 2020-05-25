package tron;

/**
	Check if objects overlap each other.

	Haxe version of armory.logicnode.OnVolumeTriggerNode
**/
class Overlap {
	
	public var objectA : Object;
	public var objectB : Object;
	public var lastOverlap(default,null) = false;

	final lA = new Vec4();
	final lB = new Vec4();

	public function new( objectA : Object, objectB : Object ) {
		this.objectA = objectA;
		this.objectB = objectB;
	}

	public function update() {
		final tA = objectA.transform;
		final tB = objectB.transform;
		lA.set( tA.worldx(), tA.worldy(), tA.worldz() );
		lB.set( tB.worldx(), tB.worldy(), tB.worldz() );
		final dA = tA.dim;
		final dB = tB.dim;
		final overlap = lA.x + dA.x / 2 > lB.x - dA.x / 2 && lA.x - dA.x / 2 < lB.x + dA.x / 2 &&
				  	  	lA.y + dA.y / 2 > lB.y - dA.y / 2 && lA.y - dA.y / 2 < lB.y + dA.y / 2 &&
				  	  	lA.z + dA.z / 2 > lB.z - dA.z / 2 && lA.z - dA.z / 2 < lB.z + dA.z / 2;
		final r = {
			overlap: overlap,
			enter: overlap && !lastOverlap,
			leave: !overlap && lastOverlap
		} 
		lastOverlap = overlap;
		return r;
	}

}
