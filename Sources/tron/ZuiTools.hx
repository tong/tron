package tron;

import zui.Id;
import zui.Themes;
import zui.Zui;

@:access(zui.Zui)
class ZuiTools {

	public static var fontSize = 13;
	public static var fontSizeH1 = 96;
	public static var fontSizeH2 = 60;
	public static var fontSizeH3 = 48;
	public static var fontSizeH4 = 34;
	public static var fontSizeH5 = 24;
	public static var fontSizeH6 = 20;

	public static inline function h1( ui : Zui, text : String )
		ZuiTools.text( ui, text, fontSizeH1 );

	public static inline function h2( ui : Zui, text : String )
		ZuiTools.text( ui, text, fontSizeH2 );
	
	public static inline function h3( ui : Zui, text : String )
		ZuiTools.text( ui, text, fontSizeH3 );
	
	public static inline function h4( ui : Zui, text : String )
		ZuiTools.text( ui, text, fontSizeH4 );
	
	public static inline function h5( ui : Zui, text : String )
		ZuiTools.text( ui, text, fontSizeH5 );
	
	public static inline function h6( ui : Zui, text : String )
		ZuiTools.text( ui, text, fontSizeH6 );

	static function text( ui : Zui, str : String, size : Int ) {
		ui.fontSize = size;
		ui.text( str );
		ui.fontSize = fontSize;
	}

}