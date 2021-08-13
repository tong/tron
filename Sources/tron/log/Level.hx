package tron.log;

enum abstract Level(Int) from Int to Int {
	var Log = 0;
	var Debug = 1;
	var Info = 2;
	var Warn = 3;
	var Error = 4;
}
