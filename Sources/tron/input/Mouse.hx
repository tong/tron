package tron.input;

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
