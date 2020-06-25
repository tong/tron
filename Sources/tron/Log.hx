package tron;

#if (kha_krom || macro)

private enum abstract BackgroundColor(Int) to Int {
    var black = 40;
    var red = 41;
    var green = 42;
    var yellow = 43;
    var blue = 44;
    var magenta = 45;
    var cyan = 46;
    var white = 47;
    var default_ = 49;
    var bright_black = 100;
    var bright_red = 101;
    var bright_green = 102;
    var bright_yellow = 103;
    var bright_blue = 104;
    var bright_magenta = 105;
    var bright_cyan = 106;
    var bright_white = 107;
}

private enum abstract Color(Int) to Int {
    var black = 30;
    var red = 31;
    var green = 32;
    var yellow = 33;
    var blue = 34;
    var magenta = 35;
    var cyan = 36;
    var white = 37;
    var default_ = 39;
    var bright_black = 90;
    var bright_red = 91;
    var bright_green = 92;
    var bright_yellow = 93;
    var bright_blue = 94;
    var bright_magenta = 95;
    var bright_cyan = 96;
    var bright_white = 97;
}

#end

class Log {

	public static inline function clear() {
		#if macro
		Sys.print( '\033c' );
		#elseif kha_krom
		Krom.log( '\033c' );
		#elseif kha_html5
		js.Browser.console.clear();
		#end
	}

	public static inline function debug( v : Dynamic ) {
		#if macro
		Sys.println( v );
		#elseif kha_krom
		Krom.log( v );
		#elseif kha_html5
		js.Browser.console.debug( v );
		#end
	}

	public static inline function log( v : Dynamic ) {
		#if macro
		Sys.println( v );
		#elseif kha_krom
		Krom.log( v );
		#elseif kha_html5
		js.Browser.console.log( v );
		#end
	}
	
	public static inline function info( v : Dynamic ) {
		#if macro
		Sys.println( format( v, [Color.blue] ) );
		#elseif kha_krom
		Krom.log( format( v, [Color.blue] ) );
		#elseif kha_html5
		js.Browser.console.info( v );
		#end
	}

	public static inline function warn( v : Dynamic ) {
		#if macro
		Sys.println( format( v, [Color.magenta] ) );
		#elseif kha_krom
		Krom.log( format( v, [Color.magenta] ) );
		#elseif kha_html5
		js.Browser.console.warn( v );
		#end
	}

	public static inline function error( v : Dynamic ) {
		#if macro
		Sys.println( format( v, [BackgroundColor.red,Color.white] ) );
		#elseif kha_krom
		Krom.log( format( v, [BackgroundColor.red,Color.white] ) );
		#elseif kha_html5
		js.Browser.console.error( v );
		#end
	}

	#if (kha_krom || macro)

	public static var noColors = false;

	static inline var CSI = '\x1B[';

	static function format( v : String, ?ansi : Array<Int> ) : String {
		//var time = '['+Time.realDelta+']';
		//v = time + v;
		if( noColors || ansi == null || ansi.length == 0 )
			return v;
		return '${CSI}${ansi.join(";")}m$v${CSI}0m';
	}

	#end

}
