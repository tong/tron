package tron;

class MathTools {

	public static inline var PI = 3.141592653589793;
	public static inline var HALF_PI = 1.570796326794896619;
	public static inline var PI2 = 6.283185307179586;
	//public static inline var hPI = 1.5707963267948966;

	/**
		The golden ratio.
		Defined as (1 + sqrt(5)) / 2
		Two quantities are in the golden ratio if their ratio is the same as the ratio of their sum to the larger of the two quantities.
	*/
	public static inline var PHI = 1.618033988749895;

	public static inline function degToRad( deg : Float ) : Float {
		return deg * 0.0174532924;
	}

	public static inline function radToDeg( rad : Float ) : Float {
		return rad * 57.29578;
	}

	/**
		Linear interpolation between two values. When k is 0 a is returned, when it's 1, b is returned.
	**/
	public inline static function lerp( a : Float, b : Float, k : Float ) : Float {
		return a + k * (b - a);
	}

	/*
	public static function fmt( v : Float ) {
		var neg;
		if( v < 0 ) {
			neg = -1.0;
			v = -v;
		} else
			neg = 1.0;
		if( std.Math.isNaN(v) || !std.Math.isFinite(v) )
			return v;
		var digits = Std.int(4 - std.Math.log(v) / std.Math.log(10));
		if( digits < 1 )
			digits = 1;
		else if( digits >= 10 )
			return 0.;
		var exp = Math.pow(10,digits);
		return std.Math.ffloor(v * exp + .49999) * neg / exp;
	}
	*/



}
