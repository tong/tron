package tron;

import tron.Input;

class UserInput extends Trait {

	public var keyboard(default,null) : Keyboard;
	public var mouse(default,null) : Mouse;
	public var gamepad(default,null) : Gamepad;

	public function new() {
		super();
		notifyOnInit( () -> {
			Input.init();
			keyboard = Input.keyboard;
			mouse = Input.mouse;
			gamepad = Input.gamepads[0];
			init();
			notifyOnUpdate( update );
		} );
	}

	function init() {
		// Override me
	}
	
	function update() {
		// Override me
	}

}
