package tron;

import kha.input.KeyCode;

class Input {
	
	public static var registered(default,null) = false;
	
	public static var keyboard(default,null) : Keyboard;
	public static var mouse(default,null) : Mouse;
	public static var gamepads(default,null) : Array<Gamepad> = [];

	public static function init() {
		if( !registered )  {
			keyboard = new Keyboard();
			mouse = new Mouse();
			for( i in 0...4 ) {
				gamepads.push( new Gamepad(i) );
			}
			//kha.input.Gamepad.notifyOnConnect( i-> trace(i), i-> trace(i) );
			iron.App.notifyOnEndFrame( endFrame );
			iron.App.notifyOnReset( reset );
			//kha.input.Keyboard.get().notify( downListener, upListener, pressListener );
			kha.System.notifyOnApplicationState( mouse.reset, null, null, null, null );
			registered = true;
		}
	}

	public static function reset() {
		keyboard.reset();
		mouse.reset();
		for( gp in gamepads ) gp.reset();
	}
	
	public static function endFrame() {
		keyboard.endFrame();
		mouse.endFrame();
		for( gp in gamepads ) gp.endFrame();
	}
}

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

private class MouseButton {
	public var down = false;
	public var started = false;
	public var released = false;
	public function new() {}
}

class Mouse {

	public var x(default,null) = 0.0;
	public var y(default,null) = 0.0;
	public var viewX(get,null) = 0.0;
	public var viewY(get,null) = 0.0;
	public var moved(default,null) = false;
	public var movementX(default,null) = 0.0;
	public var movementY(default,null) = 0.0;
	public var wheelDelta(default,null) = 0;
	public var locked(default,null) = false;
	public var hidden(default,null) = false;
	public var lastX = -1.0;
	public var lastY = -1.0;
	public var left(default,null) = new MouseButton();
	public var right(default,null) = new MouseButton();
	public var middle(default,null) = new MouseButton();

	public function new() {
		var m = kha.input.Mouse.get();
		m.notify( downListener, upListener, moveListener, wheelListener );
		#if kha_html5
		m.notifyOnLockChange(
			() -> locked = m.isLocked(),
			() -> {}
		);
		#elseif (kha_android || kha_ios)
		var s = kha.input.Surface.get();
		if( s != null ) s.notify( onTouchDown, onTouchUp, onTouchMove );
		#end
	}

	public function reset() {
		left.down = right.down = middle.down = false;
		endFrame();
	}

	public function endFrame() {
		left.started = right.started = middle.started = left.released = right.released = middle.released = false;
		moved = false;
		movementX = movementY = wheelDelta = 0;
	}

	public function lock() {
		if( kha.input.Mouse.get().canLock() ) {
			kha.input.Mouse.get().lock();
			locked = hidden = true;
		}
	}
	public function unlock() {
		if( kha.input.Mouse.get().canLock() ) {
			kha.input.Mouse.get().unlock();
			locked = hidden = false;
		}
	}

	public function show() {
		kha.input.Mouse.get().showSystemCursor();
		hidden = false;
	}

	public function hide() {
		kha.input.Mouse.get().hideSystemCursor();
		hidden = true;
	}

	function downListener( i : Int, x : Int, y : Int ) {
		switch i {
		case 0: left.started = left.down = true;
		case 1: right.started = right.down = true;
		case 2: middle.started = middle.down = true;
		}
		this.x = x;
		this.y = y;
		#if (kha_android || kha_ios || kha_webgl) // For movement delta using touch
		if( i == 0 ) { lastX = x; lastY = y; }
		#end
	}

	function upListener( i : Int, x : Int, y : Int ) {
		switch i {
		case 0: left.released = true; left.down = false;
		case 1: right.released = true; right.down = false;
		case 2: middle.released = true; middle.down = false;
		}
		this.x = x;
		this.y = y;
	}

	function moveListener( x : Int, y : Int, movementX : Int, movementY : Int ) {
		if( lastX == -1.0 && lastY == -1.0 ) {
			lastX = x;
			lastY = y;
		} // First frame init
		if( locked ) {
			// Can be called multiple times per frame
			this.movementX += movementX;
			this.movementY += movementY;
		} else {
			this.movementX += x - lastX;
			this.movementY += y - lastY;
		}
		this.x = lastX = x;
		this.y = lastY = y;
		moved = true;
	}

	function wheelListener( delta : Int ) {
		wheelDelta = delta;
	}

	#if (kha_android || kha_ios)
	public function onTouchDown( i : Int, x : Int, y : Int ) {
		// Two fingers down - right mouse button
		if( i == 1 ) { upListener( 0, x, y ); downListener( 1, x, y ); }
	}

	public function onTouchUp( i : Int, x : Int, y : Int ) {
		if( i == 1 ) upListener( 1, x, y );
	}

	public function onTouchMove( i : Int, x : Int, y : Int ) {}
	#end

	inline function get_viewX() : Float { return x - iron.App.x(); }
	inline function get_viewY() : Float { return y - iron.App.y(); }
}

private class GamepadStick {
	public var x = 0.0;
	public var y = 0.0;
	public var lastX = 0.0;
	public var lastY = 0.0;
	public var moved = false;
	public var movementX = 0.0;
	public var movementY = 0.0;
	public function new() {}
}

private class GamepadTrigger {
	public var value = 0.0;
	public var last = 0.0;
	public var moved = false;
	public var movement = 0.0;
	public function new() {}
}

class Gamepad {

	public static var buttonsPS = ["cross", "circle", "square", "triangle", "l1", "r1", "l2", "r2", "share", "options", "l3", "r3", "up", "down", "left", "right", "home", "touchpad"];
	public static var buttonsXBOX = ["a", "b", "x", "y", "l1", "r1", "l2", "r2", "share", "options", "l3", "r3", "up", "down", "left", "right", "home", "touchpad"];
	
	public final num = 0;
	public var buttons = buttonsPS;
	public var connected(default,null) = false;
	public var device(default,null) : kha.input.Gamepad;
	public var stickLeft(default,null) = new GamepadStick();
	public var stickRight(default,null) = new GamepadStick();
	public var triggerL(default,null) = new GamepadTrigger();
	public var triggerR(default,null) = new GamepadTrigger();

	var buttonsDown : Array<Float> = [];
	var buttonsStarted : Array<Bool> = [];
	var buttonsReleased : Array<Bool> = [];
	var buttonsFrame : Array<Int> = [];

	public function new( num : Int ) {
		this.num = num;
		reset();
		connect();
	}
	
	function connect() {
		var gp = kha.input.Gamepad.get( num );
		if( gp != null ) {
			connected = true;
			device = gp;
			gp.notify( axisListener, buttonListener );
		}
	}

	public function reset() {
		for (i in 0...buttonsDown.length) {
			buttonsDown[i] = 0.0;
			buttonsStarted[i] = buttonsReleased[i] = false;
		}
		endFrame();
	}

	public function endFrame() {
		stickLeft.moved = stickRight.moved = false;
		stickLeft.movementX = stickLeft.movementY = stickRight.movementX = stickRight.movementY = 0;
		triggerL.moved = triggerR.moved = false;
		triggerL.movement = triggerR.movement = 0;
		if( buttonsFrame.length > 0 ) {
			for( i in buttonsFrame ) buttonsStarted[i] = buttonsReleased[i] = false;
			buttonsFrame.splice( 0, buttonsFrame.length );
		}
	}

	public inline function down( button : String ) : Float return buttonsDown[buttonIndex( button )];
	public inline function started( button : String ) : Bool return buttonsStarted[buttonIndex( button )];
	public inline function released( button : String ) : Bool return buttonsReleased[buttonIndex( button )];

	function axisListener( axis : Int, value : Float ) {
		switch axis {
		case 2,5: //L2/R2
			var trigger = (axis == 2) ? triggerL : triggerR;
			trigger.moved = true;
			trigger.last = trigger.value;
			trigger.value = value;
			trigger.movement = trigger.value - trigger.last;
		default:
			var stick = (axis == 0 || axis == 1) ? stickLeft : stickRight;
			stick.moved = true;
			switch axis {
			case 0,3:
				stick.lastX = stick.x;
				stick.x = value;
				stick.movementX = stick.x - stick.lastX;
			case 1,4:
				stick.lastY = stick.y;
				stick.y = value;
				stick.movementY = stick.y - stick.lastY;
			}
		}
	}
	
	function buttonListener( i : Int, value : Float ) {
		trace(i,value);
		buttonsFrame.push( i );
		buttonsDown[i] = value;
		if( value > 0 ) buttonsStarted[i] = true;
		else buttonsReleased[i] = true;
	}

	function buttonIndex( button : String ) : Int {
		for( i in 0...buttons.length ) if( buttons[i] == button ) return i;
		return 0;
	}

}

#if (kha_android || kha_ios)
class Accelerometer {

	public var x = 0.0;
	public var y = 0.0;
	public var z = 0.0;

	public function new() {
		kha.input.Sensor.get( kha.input.SensorType.Accelerometer ).notify( listener );
	}

	function listener( x : Float, y : Float, z : Float ) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
}
#end
