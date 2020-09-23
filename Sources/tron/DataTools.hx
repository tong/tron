package tron;

import iron.data.Data;
import iron.data.MaterialData;

class DataTools {

	public static function loadImages( names : Array<String>, ?prefix : String, ?extension : String, done : Array<kha.Image>->Void ) {
		var loaded = new Array<kha.Image>();
		function loadNext() {
			var name = names[loaded.length];
			if( prefix != null ) name = prefix + name;
			if( extension != null ) name += '.'+extension;
			Data.getImage( name, img -> {
				loaded.push( img );
				if( loaded.length == names.length ) done( loaded ) else loadNext();
			} );
		}
		loadNext();
	}

	public static function loadMaterial( scene : String, name : String, done : haxe.ds.Vector<MaterialData>->Void ) {
		Data.getMaterial( scene, name, (md:MaterialData) -> {
			done( haxe.ds.Vector.fromData([md]) );
		});
	}

}
