package tron;

import iron.data.SceneFormat;

class SpawnTools {
	
	/*
	public static inline function spawnObjectsFromScene( sceneName : String, objectNames: Array<String>, parent: Object, done: Object->Void, ?spawnChildren : Bool ) {
	}
	*/

	/**
	 * Spawn object tree from another scene
	 */
	public static inline function spawnObjectFromScene( sceneName : String, name : String, ?parent : Object, done : Object->Void, ?spawnChildren : Bool ) {
		Data.getSceneRaw( sceneName, raw -> spawnObject( raw, name, parent, done, spawnChildren ) );
	}
	
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
			if( discardNoSpawn && o.spawn != null && o.spawn == false )
				continue; // Do not count children of non-spawned objects
			if( o.children != null)
				result += getObjectsCount( o.children );
		}
		return result;
	}
	
}
