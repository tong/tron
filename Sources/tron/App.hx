package tron;

@:build(tron.Build.app_base())
@:autoBuild(tron.Build.app())
abstract class App {

    // public final name : String;

    public var state(default,null) : String;

    function new() {}

    public function setState( state : String, ?done : Object->Void ) {
        if( state != this.state ) {
            Log.debug('State ${this.state} → $state');
            this.state = null;
            Scene.setActive( 'app.$state', obj -> {
                this.state = state;
                if( done != null ) done( obj );
            });
        }
    }

    public function quit( ?info : String, state = 'quit', ?done : Object->Void ) {
        if( info != null ) Log.info(info);
        setState( state, done );
    }

    static inline function main() {
        Main.main();
        iron.App.notifyOnInit(() -> {
            Log.info('T   R   ⚫  Ͷ');
            // tron.Audio.init();
            tron.Input.init();
        });
        // var cl = Type.resolveClass( '${info.pack}.App' );
         //Type.createInstance( cl, [] );
    }
}
