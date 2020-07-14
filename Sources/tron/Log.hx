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

private enum abstract Level(Int) to Int {
	var Debug = 0;
	var Log = 1;
	var Info = 2;
	var Warn = 3;
	var Error = 4;
	var None = 5;
}

class Log {

	public static var level = Level.Info;
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
			//str += '${CSI}${ansi.join(";")}m$v${CSI}0m';
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

	//static function print() {

	#end

	public static function clear() {
		#if macro
		Sys.print( '\033c' );
		#elseif kha_krom
		Krom.log( '\033c' );
		#elseif kha_html5
		js.Browser.console.clear();
		#end
	}

	public static function debug( v : Dynamic ) {
		if( cast(level,Int) > cast(Level.Debug,Int) ) return;
		#if macro
		Sys.println( v );
		#elseif kha_krom
		Krom.log( v );
		#elseif kha_html5
		js.Browser.console.debug( v );
		#end
	}

	public static function log( v : Dynamic ) {
		if( cast(level,Int) > cast(Level.Log,Int) ) return;
		#if macro
		Sys.println( v );
		#elseif kha_krom
		Krom.log( v );
		#elseif kha_html5
		js.Browser.console.log( v );
		#end
	}
	
	public static function info( v : Dynamic ) {
		if( cast(level,Int) > cast(Level.Info,Int) ) return;
		#if macro
		Sys.println( format( v, [Color.blue] ) );
		#elseif kha_krom
		Krom.log( format( v, [Color.blue] ) );
		#elseif kha_html5
		js.Browser.console.info( v );
		#end
	}

	public static function warn( v : Dynamic ) {
		if( cast(level,Int) > cast(Level.Warn,Int) ) return;
		#if macro
		Sys.println( format( v, [Color.magenta] ) );
		#elseif kha_krom
		Krom.log( format( v, [Color.magenta] ) );
		#elseif kha_html5
		js.Browser.console.warn( v );
		#end
	}
	
	public static function error( v : Dynamic ) {
		if( cast(level,Int) > cast(Level.Error,Int) ) return;
		#if macro
		Sys.println( format( v, [BackgroundColor.red,Color.white] ) );
		#elseif kha_krom
		Krom.log( format( v, [BackgroundColor.red,Color.white] ) );
		#elseif kha_html5
		js.Browser.console.error( v );
		#end
	}

}
