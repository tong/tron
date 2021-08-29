package tron.input;

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

/**
 * 0: cross
 * 1: circle
 * 2: square
 * 3: triangle
 * 4: l1
 * 5: r1
 * 6: l2
 * 7: r2
 * 8: share
 * 9: options
 * 10: l3
 * 11: r3
 * 12: up
 * 13: down
 * 14: left
 * 0: right
 * 0: home
 * 0: touchpad
 * 
 * 
 */
class Gamepad {

	public static var buttonsPS = ["cross", "circle", "square", "triangle", "l1", "r1", "l2", "r2", "share", "options", "l3", "r3", "up", "down", "left", "right", "home", "touchpad"];
	public static var buttonsXBOX = ["a", "b", "x", "y", "l1", "r1", "l2", "r2", "share", "options", "l3", "r3", "up", "down", "left", "right", "home", "touchpad"];
	public static var buttonsXBOX360 = ["a","b","x","y","l1","r1","back","start","home","leftStick","rightStick","left","right","up","down"];
	
	public final num = 0;

	public var device(default,null) : kha.input.Gamepad;
	public var connected(default,null) = false;
	public var buttons = buttonsPS;

	//public var dpad(default,null) = new GamepadDPad(); // TODO ?
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

    public inline function rumble( l : Float, r : Float ) {
        device.rumble( l, r );
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
		//trace(i,value);
		buttonsFrame.push( i );
		buttonsDown[i] = value;
		if( value > 0 ) buttonsStarted[i] = true else buttonsReleased[i] = true;
	}

	function buttonIndex( button : String ) : Int {
		for( i in 0...buttons.length ) if( buttons[i] == button ) return i;
		return 0;
	}

}
