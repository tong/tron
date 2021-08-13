package tron;

import tron.log.Level;

#if !kha_html5

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

	public static var level : Int = tron.log.Level.Log;
	public static var time = true;
	public static var timePrecision = 4;

	#if (kha_krom || macro)
	
	public static var noColors = false;

	static inline var CSI = '\x1B[';

	static function format( v : String, ?ansi : Array<Int> ) : String {
		var str = ''; 
		if( v == null ) str = '';
		if( time ) {
			final precision = timePrecision;
			final precisionMult = Math.pow( 10, precision );
			final now = Std.int( #if macro Sys.time() #else Time.realTime() #end * precisionMult ) / precisionMult;
			var nowStr = Std.string( now );
			var parts = nowStr.split('.');
			var len = parts[1].length;
			if( len < precision ) {
				for( i in 0...(precision-len) ) nowStr += '0';
			}
			str += ansify( '[$nowStr]', [BackgroundColor.black,Color.white] )+' ';
		}
		if( !noColors && ansi != null && ansi.length > 0 ) {
			str += ansify( v, ansi );
		} else {
			str += Std.string(v);
		}
		return str;
	}

	static function ansify( s : String, ?ansi : Array<Int> ) : String {
		if( s == null )
			return '';
		if( !noColors && ansi != null && ansi.length > 0 )
			return '${CSI}${ansi.join(";")}m$s${CSI}0m';
		return s;
	}

	#end

	public static inline function print( s : String ) {
		#if macro
		Sys.print( s );
		#elseif kha_krom
		Krom.log( s );
		#elseif kha_html5
		js.Browser.console.log(s);
		#end
	}

	public static inline function clear() {
		#if kha_html5
		js.Browser.console.clear();
		#else
		print( '\033c' );
		#end
	}

	public static function debug( v : Dynamic ) {
		if( level > cast tron.log.Level.Debug ) return;
		#if kha_html5
		js.Browser.console.debug( v );
		#else
		print( format( v, [BackgroundColor.black,Color.white] ) );
		#end
	}

	public static function log( v : Dynamic ) {
		if( level > cast tron.log.Level.Log ) return;
		#if macro
		Sys.println( format( v, [Color.white] ) );
		#elseif kha_krom
		Krom.log( format( v, [Color.white] ) );
		#elseif kha_html5
		js.Browser.console.log( v );
		#end
	}
	
	public static function info( v : Dynamic ) {
		if( level > cast tron.log.Level.Info ) return;
		#if kha_html5
		js.Browser.console.info( v );
		#else
		print( format( v, [Color.blue] ) );
		#end
	}

	public static function warn( v : Dynamic ) {
		if( level > cast tron.log.Level.Warn ) return;
		#if kha_html5
		js.Browser.console.warn( v );
		#else
		print( format( v, [BackgroundColor.magenta,Color.white] ) );
		#end
	}
	
	public static function error( v : Dynamic ) {
		if( level > cast tron.log.Level.Error ) return;
		#if kha_html5
		js.Browser.console.error( v );
		#else
		print( format( v, [BackgroundColor.red,Color.bright_white] ) );
		#end
	}

}
