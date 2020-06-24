package tron;

@:keep
class CompositionGuides extends Trait {

	@prop
	public var color = new Vec4( 1, 1, 1, 0.5 );

	@prop
	public var strength = 1.0;

	@prop
	public var center = false;
	
	@prop
	public var centerDiagonal = false;

	@prop
	public var thirds = false;
	
	// TODO: public var goldenRatio = false;
	// TODO: public var goldenTriangleA = false;
	// TODO: public var goldenTriangleB = false;
	// TODO: public var harmoniousTriangleA = false;
	// TODO: public var harmoniousTriangleB = false;

	public function new() {
		super();
		notifyOnRender2D( render );
	}

	function render( g : kha.graphics2.Graphics ) {
		if( !object.visible )
			return;
		final w = kha.System.windowWidth();
		final h = kha.System.windowHeight();
		final cx = w/2;
		final cy = h/2;
		g.end();
		g.color = kha.Color.fromFloats( color.x, color.y, color.z, color.w );
		if( center ) {
			g.drawLine( 0, cy, w, cy, strength );
			g.drawLine( cx, 0, cx, h, strength );
		}
		if( centerDiagonal ) {
			g.drawLine( 0, 0, w, h, strength );
			g.drawLine( w, 0, 0, h, strength );
		}
		if( thirds ) {
			var sw = w / 3;
			var sh = h / 3;
			g.drawLine( 0, sh, w, sh, strength );
			g.drawLine( 0, sh*2, w, sh*2, strength );
			g.drawLine( sw, 0, sw, h, strength );
			g.drawLine( sw*2, 0, sw*2, h, strength );
		}
		g.begin( false );
	}

}
