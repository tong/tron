package tron;

import kha.audio1.AudioChannel;

class Music {

	public static var track(default,null) : String;
	public static var paused(default,null) = false;
	
	public static var volume(default,set) = 1.0;
	static inline function set_volume(v:Float) {
		if( channel != null ) channel.volume = v;
		return volume = v;
	}

	public static var finished(get,never) : Bool;
	static inline function get_finished() {
		return (channel == null) ? false : channel.finished;
	}

	public static var length(get,never) : Float;
	static inline function get_length() {
		return (channel == null) ? null : channel.length;
	}

	public static var position(get,never) : Float;
	static inline function get_position() {
		return (channel == null) ? null : channel.position;
	}

	static var channel : AudioChannel;

	public static function play( track : String, stream = true, loop = false ) {
		if( channel != null ) {
			channel.stop();
		}
		Music.track = track;
		Data.getSound( 'music_$track', s -> {
			channel = Audio.play( s, loop, stream );
			channel.volume = volume;
		});
	}

	public static function pause() {
		if( paused ) {
			paused = false;
			if( channel != null ) channel.play();
		} else {
			paused = true;
			if( channel != null ) channel.pause();
		}
	}

	public static function stop() {
		if( channel != null ) {
			channel.stop();
		}
		track = null;
		paused = false;
	}

}
