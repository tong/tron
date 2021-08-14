package tron;

class Timer {

    public static inline function delay( f : Void->Void, sec : Float ) {
        kha.Scheduler.addTimeTask( f, sec );
    }
}
