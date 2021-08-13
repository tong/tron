package tron;

import iron.object.BoneAnimation;
import iron.object.Object;

class AnimationTools {

	public static function findAnimation( obj : Object ) : BoneAnimation {
		if( obj.animation != null )
			return cast obj.animation;
		for( c in obj.children ) {
			var co = findAnimation( c );
			if( co != null ) return co;
		}
		return null;
	}

	public static function getAnimation( obj : Object ) : BoneAnimation {
		var anim = obj.animation;
		if( anim == null ) anim = obj.children[0].animation;
		return anim;
	}

}
