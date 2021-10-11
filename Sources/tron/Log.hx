package tron;

// import tron.log.Level;

/*
enum abstract LogLevel(Int) to Int {
	var All = 0;
	var Debug = 1;
	var Info = 2;
	var Warn = 3;
	var Error = 4;
	public static inline function gt(a:Int,b:Int) return a > b;
	public static inline function lt(a:Int,b:Int) return a < b;
}
*/

class Log {

	//public static var level : LogLevel = LogLevel.All;
	public static var time = true;
	public static var timePrecision = 4;

	#if (kha_hl || kha_krom || macro)
	
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
			str += ansify( '[$nowStr]', [40,37] )+' ';
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
		#if (kha_hl || macro)
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
		// if( LogLevel.lt( level, LogLevel.Debug ) ) {
		// 	return;
		// }
		// if( tron.Log.level > LogLevel.Debug ) return;
		#if kha_html5
		js.Browser.console.debug( v );
		#else
		print( format( v, [40,37] ) );
		#end
	}

	public static function log( v : Dynamic ) {
		// if( level >= LogLevel.All ) return;
		#if macro
		Sys.println( format( v, [37] ) );
		#elseif kha_krom
		Krom.log( format( v, [37] ) );
		#elseif kha_html5
		js.Browser.console.log( v );
		#end
	}
	
	public static function info( v : Dynamic ) {
		// if( tron.Log.level > LogLevel.Info ) return;
		#if kha_html5
		js.Browser.console.info( v );
		#else
		print( format( v, [44] ) );
		#end
	}

	public static function warn( v : Dynamic ) {
		// if( level > LogLevel.Warn ) return;
		#if kha_html5
		js.Browser.console.warn( v );
		#else
		print( format( v, [40,35] ) );
		#end
	}
	
	public static function error( v : Dynamic ) {
		// if( level > LogLevel.Error ) return;
		#if kha_html5
		js.Browser.console.error( v );
		#else
		print( format( v, [41,107] ) );
		#end
	}

}
