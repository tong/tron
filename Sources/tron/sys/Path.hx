package tron.sys;

class Path {

	#if kha_krom

	#if krom_windows
	public static inline var SEP = "\\";
	#else
	public static inline var SEP = "/";
	#end

	public static inline function data() : String {
		return Krom.getFilesLocation() + Path.SEP + Data.dataPath;
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
