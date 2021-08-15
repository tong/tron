package tron;

class Build {

	#if macro

	static function app() : Array<Field> {
        //trace("Building tron app");
        var fields = Context.getBuildFields();
        return fields;
    }

	public static function resolveProjectPath() : String {
		var cwd = Sys.getCwd().removeTrailingSlashes().split("/");
        if( cwd[cwd.length-1] == 'debug' ) {
            return cwd.slice( 0, cwd.length-2 ).join('/');
        } else {
            return cwd.slice( 0, cwd.length-1 ).join('/');
        }
		return null;
	}

	#end

    macro public static function infos() {
        var projectPath = resolveProjectPath();
        var projectName = projectPath.withoutDirectory();
        trace(projectName);
        final infoFile = "app.json";
        final infoFilePath = '$projectPath/$infoFile';
        if( FileSystem.exists( infoFilePath ) ) {
            var infos : Array<String> = Json.parse( File.getContent( infoFilePath ) );
            var exprs = [for(v in infos) macro { name: $v{v} }];
            return macro $a{exprs};
        } else {
            trace("app.json not found");
            //blender -noaudio -b gamma.blend --python tron/Scripts/export_level_info.py

        }
        return macro null;
    }

}
