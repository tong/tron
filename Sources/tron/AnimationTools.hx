package tron;

import iron.object.BoneAnimation;
import iron.object.Object;

class AnimationTools {

	public static function findBoneAnimation( obj : Object ) : BoneAnimation {
		if( obj.animation != null )
			return cast obj.animation;
		for( c in obj.children ) {
			var a = findBoneAnimation( c );
			if( a != null ) return a;
		}
		return null;
	}

	public static function getAnimation( obj : Object ) : BoneAnimation {
		var a = obj.animation;
		if( a == null ) a = obj.children[0].animation;
		return cast a;
	}

}
