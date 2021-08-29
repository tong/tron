package tron;

import kha.input.KeyCode;
import tron.input.Gamepad;
import tron.input.Keyboard;
import tron.input.Mouse;

class Input {
	
	public static var initialized(default,null) = false;
	public static var gamepads(default,null) : Array<Gamepad> = [];
	public static var keyboard(default,null) : Keyboard;
	public static var mouse(default,null) : Mouse;

	public static function init() {
		if( initialized ) 
			return;
		for( i in 0...4 ) gamepads[i] = new Gamepad(i);
		keyboard = new Keyboard();
		mouse = new Mouse();
		//kha.input.Gamepad.notifyOnConnect( i-> trace(i), i-> trace(i) );
		iron.App.notifyOnEndFrame( endFrame );
		iron.App.notifyOnReset( reset );
		//kha.input.Keyboard.get().notify( downListener, upListener, pressListener );
		kha.System.notifyOnApplicationState( mouse.reset, null, null, null, null );
		initialized = true;
	}

	public static function dispose() {
		if( !initialized ) 
			return;
		iron.App.removeEndFrame( endFrame );
		iron.App.removeEndFrame( endFrame );
		kha.System.removeApplicationStateListeners(mouse.reset, null, null, null, null);
		keyboard = null;
		mouse = null;
		gamepads = null;
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
