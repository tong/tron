package tron;

import iron.data.MeshData;
import iron.data.MaterialData;
import iron.data.SceneFormat;
import kha.arrays.Int16Array;
import kha.arrays.Uint32Array;

class MeshGenerator {

	public static function generateBox( name = 'BoxMesh', scale = 1.0, done : MeshData->Void ) {
		
		final positions = [1.0,1.0,-1.0,1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,1.0,-1.0,1.0,1.0,1.0,-1.0,1.0,1.0,-1.0,-1.0,1.0,1.0,-1.0,1.0,1.0,1.0,-1.0,1.0,1.0,1.0,1.0,-1.0,1.0,1.0,-1.0,-1.0,1.0,-1.0,-1.0,1.0,-1.0,1.0,-1.0,-1.0,1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,-1.0,1.0,-1.0,1.0,1.0,-1.0,1.0,-1.0,1.0,1.0,1.0,1.0,1.0,-1.0,-1.0,1.0,-1.0,-1.0,1.0,1.0];
		final normals = [0.0,0.0,-1.0,0.0,0.0,-1.0,0.0,0.0,-1.0,0.0,0.0,-1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,0.0,-1.0,-0.0,0.0,-1.0,-0.0,0.0,-1.0,-0.0,0.0,-1.0,-0.0,-1.0,0.0,-0.0,-1.0,0.0,-0.0,-1.0,0.0,-0.0,-1.0,0.0,-0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0,0.0,1.0,0.0];
		final indices = [0,1,2,0,2,3,4,5,6,4,6,7,8,9,10,8,10,11,12,13,14,12,14,15,16,17,18,16,18,19,20,21,22,20,22,23];
		final numVertices = Std.int( positions.length / 3 );

		// Armory uses packed 16-bit normalized vertex data to preserve memory
		// To prevent padding and ensure 32-bit align, normal.z component is packed into position.w component
		final posI16 = new Int16Array(numVertices * 4); // pos.xyz, nor.z
		final norI16 = new Int16Array(numVertices * 2); // nor.xy
		toI16( posI16, norI16, positions, normals );
		final indU32 = new Uint32Array( indices.length );
		toU32( indU32, indices );

		final pos : TVertexArray = { attrib: "pos", values: posI16, data: "short4norm" };
		final nor : TVertexArray = { attrib: "nor", values: norI16, data: "short2norm" };
		final ind : TIndexArray  = { material: 0, values: indU32 };

		var rawData : TMeshData = {
			name: name,
			vertex_arrays: [pos, nor],
			index_arrays: [ind],
			scale_pos: scale // Usable to scale positions over the (-1, 1) range
		};

		new MeshData( rawData, data -> {
			done( data );
		});
	}

	static function toI16( toPos : Int16Array, toNor : Int16Array, fromPos : Array<Float>, fromNor : Array<Float> ) {
		final numVertices = Std.int( fromPos.length / 3 );
		for( i in 0...numVertices ) {
			// Values are scaled to the signed short (-32768, 32767) range
			// In the shader, vertex data is normalized into (-1, 1) range
			toPos[i * 4    ] = Std.int(fromPos[i * 3    ] * 32767);
			toPos[i * 4 + 1] = Std.int(fromPos[i * 3 + 1] * 32767);
			toPos[i * 4 + 2] = Std.int(fromPos[i * 3 + 2] * 32767);
			toNor[i * 2    ] = Std.int(fromNor[i * 3    ] * 32767);
			toNor[i * 2 + 1] = Std.int(fromNor[i * 3 + 1] * 32767);
			// normal.z component is packed into position.w component
			toPos[i * 4 + 3] = Std.int(fromNor[i * 3 + 2] * 32767);
		}
	}

	static inline function toU32( to :Uint32Array, from:Array<Int>) {
		for(i in 0...to.length) to[i] = from[i];
	}
}
