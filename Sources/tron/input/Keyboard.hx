package tron.input;

/*
private class KeyboardButton {
	public var down = false;
	public var started = false;
	public var released = false;
}
*/

//TODO keyboard repeat

class Keyboard {
	
	var keysStarted = new Map<Int,Bool>();
	var keysDown = new Map<Int,Bool>();
	var keysReleased = new Map<Int,Bool>();
	var keysFrame : Array<KeyCode> = [];

	public function new() {
		reset();
		kha.input.Keyboard.get().notify( downListener, upListener, pressListener );
	}

	public inline function started( key : KeyCode ) return keysStarted.get( key );
	public inline function down( key : KeyCode ) return keysDown.get( key );
	public inline function released( key : KeyCode ) return keysReleased.get( key );
	
	public function reset() {
		for( c in 0...256 ) { //TODO
			keysStarted.set( c, false );
			keysDown.set( c, false );
			keysReleased.set( c, false );
		}
		endFrame();
	}

	public function endFrame() {
		if( keysFrame.length > 0 ) {
			for( c in keysFrame ) {
				keysStarted.set( c, false );
				keysReleased.set( c, false );
			}
			keysFrame.splice( 0, keysFrame.length );
		}
	}

	function downListener( code : KeyCode ) {
		keysFrame.push( code );
		keysStarted.set( code, true );
		keysDown.set( code, true );
	}

	function upListener( code : KeyCode ) {
		keysFrame.push( code );
		keysReleased.set( code, true );
		keysDown.set( code, false );
	}

	function pressListener( char : String ) {
		//trace(char);
	}
}
