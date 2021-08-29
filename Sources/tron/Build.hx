package tron;

#if macro
using haxe.macro.TypeTools;
#end

typedef Info = {
    name: String,
    version: String,
    ?pack: String,
    ?root: String,
    ?bundle: String,
    runtime : String,
    scenes : Array<String>,
    armory: { commit : String },
};

class Build {

    public static var info(default,null) : Info #if !macro = getBuildInfo() #end;

    #if macro
    
    public static var projectPath(default,null) : String;
    public static var projectName(default,null) : String;
    
    static function __init__() {
        Sys.println('T   R   ⚫  Ͷ');
        projectPath = resolveProjectPath();
        projectName = projectPath.withoutDirectory();
        var file = Context.definedValue("tron-info");
        if( file == null ) file = 'tron.json';
        info = cast Json.parse( File.getContent( '$projectPath/$file' ) );
        // trace(info);
    }
    
    static function resolveProjectPath() : String {
		var cwd = Sys.getCwd().removeTrailingSlashes().split("/");
        return cwd.slice( 0, cwd.length-((cwd[cwd.length-1] == 'debug') ? 2 : 1) ).join('/');
	}
    
    static function app_base() : Array<Field> {
        var fields = Context.getBuildFields();
        var pos = Context.currentPos();
        for( f in fields ) {
            switch f.name {
            case 'main':
                switch f.kind {
                case FFun(f):
                    // var exprs = [f.expr];
                    // var typePath = { name: 'App', pack: info.pack };
                    // exprs.push( macro new $typePath());
                    // f.expr = { pos: pos, expr: EBlock(exprs) };
                    //f.expr = { pos: pos, expr: EBlock(exprs) };
                    //trace(f.expr.push( macro new gamma.App()));
                case _:
                }
                /* switch f.kind {
                case FFun(f):
                    trace(f);
                    switch f.expr.expr {
                    }
                case _:
                } */
                // trace(f.expr.expr);
            }
        }
        return fields;
    }

    static function app() : Array<Field> {
        var fields = Context.getBuildFields();
        var pos = Context.currentPos();
        /* fields.push({
            access: [AStatic,AInline],
            name: 'main',
            kind: FFun({
                args:  [],
                expr: macro Main.main()
            }),
            pos: pos
        }); */
        /* for( f in fields ) {
            switch f.name {
            case 'main':
            }
        } */
        fields.push({
            access: [APublic,AFinal],
            name: 'name',
            kind: FVar(macro:String, macro $v{info.name} ),
            pos: pos
        });
        var type = Context.getLocalType();
        var clType = type.getClass();
        var typePath = { name: clType.name, pack: clType.pack };
        fields.push({
            access: [APublic,AStatic,AFinal],
            name: 'active',
            kind: FVar(type.toComplexType(), macro new $typePath()),
            pos: pos
        });
        return fields;
    }
    
    #end
    
    macro static function getBuildInfo() : ExprOf<tron.Build.Info> {
        return macro $v{tron.Build.info};
    }
}
