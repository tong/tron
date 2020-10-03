package tron;

#if arm_bullet
import armory.trait.physics.bullet.PhysicsWorld;
import armory.trait.physics.bullet.PhysicsWorld.Hit;
import iron.math.RayCaster;
#end

class PhysicsTools {
	
	#if arm_bullet

	/**
	 */
	public static function raycast( camera : CameraObject, x : Float, y : Float, ?group : Int ) : Hit {
		var start = new Vec4();
		var end = new Vec4();
		RayCaster.getDirection( start, end, x, y, camera );
		return PhysicsWorld.active.rayCast( camera.transform.world.getLoc(), end, group );
	}

	/**
	 * Pick closest point from the rigidbody of given object.
	*/
	public static function pickLocation( object : Object, coords : Vec4 ) : Vec4 {
		#if arm_physics
		if( object == null || coords == null )
			return null;
		var rb = object.getTrait( armory.trait.physics.RigidBody );
		if( rb == null )
			return null;
		var b = PhysicsWorld.active.pickClosest( coords.x, coords.y );
		if( b == rb ) {
			return PhysicsWorld.active.hitPointWorld.clone();
		}
		#else
		trace( 'pickLocation requires arm_physics' );
		#end
		return null;
	}

	#end
	
}
