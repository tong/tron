package tron;

class MathTools {

	public static inline var PI = 3.141592653589793;
	public static inline var PI2 = 1.5707963267948966;

	public static inline function degToRad( deg : Float ) : Float {
		return deg * 0.0174532924;
	}

	public static inline function radToDeg( rad : Float ) : Float {
		return rad * 57.29578;
	}

}
