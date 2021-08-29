package tron.input;

#if (kha_android || kha_ios)

class Accelerometer {

	public var x = 0.0;
	public var y = 0.0;
	public var z = 0.0;

	public function new() {
		kha.input.Sensor.get( kha.input.SensorType.Accelerometer ).notify( listener );
	}

	function listener( x : Float, y : Float, z : Float ) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
}

#end
