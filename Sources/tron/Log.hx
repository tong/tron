package tron;

#if macro
#end

#if kha_krom

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

#elseif kha_html5
import js.Browser.console;
#end

class Log {

	/* macro public static inline function test( e : ExprOf<Dynamic>, extra : Array<Expr> ) : ExprOf<Void> {
		var v = Std.string( e.getValue() );
		//var a = [e.getValue()];
		trace(Context.currentPos());
		var pos : haxe.macro.Position = Context.currentPos();
		trace(pos);
		for( e in extra ) {
			//v += ', '+Std.string( e.getValue() );
		}
		var info = {
			fileName : "FFF", //pos.file ,
			lineNumber : 0, 
			className : "Test", 
			methodName : "main", 
			customParams : extra.map( e -> return e.getValue() )
		};
		var s = haxe.Log.formatOutput( v, info );
		//return macro haxe.Log.trace( $e );
		return macro haxe.Log.trace( $v{s} );
	} */

	public static inline function clear() {
		#if kha_krom
		trace( '\033c' );
		#elseif kha_html5
		console.clear();
		#end
	}

	public static inline function debug( o : Dynamic ) {
		#if kha_krom
		trace( o );
		#elseif kha_html5
		console.debug( Std.string(o) );
		#end
	}

	public static inline function log( o : Dynamic ) {
		#if kha_krom
		trace( o );
		#elseif kha_html5
		console.log( Std.string(o) );
		#end
	}
	
	public static inline function info( v : Dynamic, posInfos = false ) {
		#if kha_krom
		//TODO optional pos infos
		//var m = posInfos ? haxe.Log.formatOutput( v, infos );
		Krom.log( format( v, [Color.blue] ) );
		//println();
		//trace( format(o,[Color.blue]) );
		#elseif kha_html5
		console.info( v );
		#end
	}

	public static inline function warn( o : Dynamic ) {
		#if kha_krom
		/*
		var hxTrace = haxe.Log.trace;
		haxe.Log.trace = function(v, inf) {
			//var message = haxe.Log.formatOutput(v,infos);
			Krom.log( haxe.Log.formatOutput(v,infos) );
		}
		trace( o);
		*/
		trace( format( o, [Color.magenta] ) );
		//Krom.log( format( o, [Color.magenta] ) );
		#elseif kha_html5
		console.warn( Std.string(o) );
		#end
	}

	public static inline function error( o : Dynamic ) {
		#if kha_krom
		trace( format(o,[BackgroundColor.red,Color.white]) );
		#elseif kha_html5
		console.error( Std.string(o) );
		#end

	}

	#if kha_krom

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
