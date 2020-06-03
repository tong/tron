package tron.sys;

class Path {

	#if kha_krom

	#if krom_windows // no inline for plugin access
	public static inline var sep = "\\";
	#else
	public static inline var sep = "/";
	#end

	public static inline function data() : String {
		return Krom.getFilesLocation() + Path.sep + Data.dataPath;
	}

	public static inline function isProtected() : Bool {
		#if krom_windows
		return Krom.getFilesLocation().indexOf( "Program Files" ) >= 0;
		#else
		return false;
		#end
	}

	#end
}
