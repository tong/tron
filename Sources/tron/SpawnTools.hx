package tron;

import iron.data.SceneFormat;

using haxe.io.Path;

class SpawnTools {
	
	/*
	public static function spawnObjectsFromScene( sceneName : String, objectNames : Array<String>, ?parent: Object, done: Array<Object>->Void, ?spawnChildren : Bool ) {
		var spawned = new Array<Object>();
		function spawnNext() {
			var name = objectNames.shift();
			spawnObjectFromScene( sceneName, name, parent, obj -> {
				spawned.push( obj );
				if( objectNames.length == 0 ) {
					done( spawned );
				} else {
					spawnNext();
				}
			} );
		}
		spawnNext();
	}
	*/

	/**
	 * Spawn object tree from scene.
	 */
	public static inline function spawnObjectFromScene( sceneName : String, name : String, ?parent : Object, done : Object->Void, ?spawnChildren : Bool ) {
		Data.getSceneRaw( sceneName, raw -> spawnObject( raw, name, parent, done, spawnChildren ) );
	}

	/**
	 * Spawn object tree from linked proxy scene.
	 */
	public static inline function spawnObjectFromProxyScene( blendFile : String, sceneName : String, objectName : String, ?parent : Object, done : Object->Void, ?spawnChildren : Bool ) {
		// blendFile = blendFile.withoutExtension();
		Data.getSceneRaw( sceneName, raw -> spawnObject( raw, '${objectName}_$blendFile.blend', parent, done, spawnChildren ) );
	}
	
	/**
		Spawn object.
	 */
	public static function spawnObject( ?raw : TSceneFormat, name : String, ?parent : Object, done : Object->Void, spawnChildren = true ) {
		if( raw == null ) raw = Scene.active.raw;
		var objectsTraversed = 0;
		var obj = Scene.getRawObjectByName( raw, name );
		var objectsCount = spawnChildren ? getObjectsCount([obj], false) : 1;
		function spawnObjectTree(obj: TObj, parent: Object, parentObject: TObj, done: Object->Void) {
			Scene.active.createObject( obj, raw, parent, parentObject, function(object: Object) {
				if( spawnChildren && obj.children != null ) {
					for( c in obj.children ) spawnObjectTree( c, object, obj, done );
				}
				if( ++objectsTraversed == objectsCount && done != null ) {
					// Retrieve the originally spawned object from the current child object to ensure done() is called with the right object
					while( object.name != name ) object = object.parent;
					done( object );
				}
			});
		}
		spawnObjectTree( obj, parent, null, done );
	}

	public static function getObjectsCount( objects : Array<TObj>, discardNoSpawn = true ) : Int {
		if( objects == null ) return 0;
		var result = objects.length;
		for( o in objects ) {
			if( discardNoSpawn && o.spawn != null && !o.spawn )
				continue; // Do not count children of non-spawned objects
			if( o.children != null)
				result += getObjectsCount( o.children );
		}
		return result;
	}

	/*
	public static function loadObject( ?raw : TSceneFormat, name : String, done : Object->Void, loadChildren = true ) {
		if( raw == null ) raw = Scene.active.raw;
		var objectsTraversed = 0;
		var obj = Scene.getRawObjectByName( raw, name );
		var objectsCount = spawnChildren ? getObjectsCount([obj], false) : 1;
		function loadObjectTree(obj: TObj, parent: Object, parentObject: TObj, done: Object->Void) {
			Scene.active.createObject( obj, raw, parent, parentObject, function(object: Object) {
				if( spawnChildren && obj.children != null ) {
					for( c in obj.children ) loadObjectTree( c, object, obj, done );
				}
				if( ++objectsTraversed == objectsCount && done != null ) {
					// Retrieve the originally spawned object from the current child object to ensure done() is called with the right object
					while( object.name != name ) object = object.parent;
					done( object );
				}
			});
		}
		spawnObjectTree( obj, parent, null, done );
	}
	*/
	
}
