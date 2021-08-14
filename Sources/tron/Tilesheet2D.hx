package tron;

import iron.data.SceneFormat;
import iron.system.Time;
import kha.math.FastMatrix3;

class Tilesheet2D {

	public var image : kha.Image;
	public var raw :  TTilesheetData;

	public var tileX = 0.0;
	public var tileY = 0.0;

	public var action : TTilesheetAction;
	public var onAction : Void->Void = null;
	public var paused(default,null) = false;
	public var time = 0.0;
	public var frame = 0;

	public function new( image : kha.Image, raw : TTilesheetData ) {
		this.image = image;
		this.raw = raw;
	}

	public function play( action : String, ?onAction : Void->Void ) {
		this.onAction = onAction;
		for( a in raw.actions ) {
			if( a.name == action ) {
				this.action = a;
				break;
			}
		}
		setFrame( this.action.start );
		paused = false;
	}

	public function pause() {
		paused = true;
	}

	public function resume() {
		paused = false;
	}

	public function update() {
		if( paused || action.start >= action.end ) return;
		time += Time.delta;
		if( time >= 1 / raw.framerate ) {
			setFrame( frame + 1 );
		}
	}

	function setFrame( f : Int ) {
		frame = f;
		time = 0;
		final ix = frame % raw.tilesx;
		final iy = Std.int(frame / raw.tilesx);
		tileX = ix * (1 / raw.tilesx);
		tileY = iy * (1 / raw.tilesy);
		if( frame >= action.end && action.start < action.end ) {
			if( onAction != null ) onAction();
			if( action.loop ) setFrame( action.start ) else paused = true;
		}
	}

	public function render( g : kha.graphics2.Graphics ) {
		//final t = FastMatrix3.scale( raw.tilesx, raw.tilesy );
		//g.pushTransformation( t );
		var sx = tileX * image.width;
		var sy = tileY * image.height;
		var sw = image.width / raw.tilesx;
		var sh = image.height / raw.tilesy;
		g.drawSubImage( image, 0, 0, sx, sy, sw, sh );
		//g.popTransformation();
	}

}
