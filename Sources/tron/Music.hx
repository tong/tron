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
