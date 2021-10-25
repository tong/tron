package tron.render;

#if rp_pp

import iron.data.MaterialData;
import iron.math.Vec4;
import iron.object.Object;
import iron.object.Uniforms;

typedef TPostprocess = {
    var global : TPPColorgrading & {
        weight: Array<FastFloat>,
        tint: Array<FastFloat>,
        lut: Array<FastFloat>,
    };
    var shadow : TPPColorgrading;
    var midtone : TPPColorgrading;
    var highlight : TPPColorgrading;
    var camera : TPPCamera;
    var tonemapper: {
        slope: FastFloat,
        toe: FastFloat,
        shoulder: FastFloat,
        black_clip: FastFloat,
        white_clip: FastFloat,
    };
    var ssr: {
        step: FastFloat,
        step_min: FastFloat,
        search: FastFloat,
        falloff: FastFloat,
        jitter: FastFloat
    };
    var bloom: {
        threshold: FastFloat,
        strength: FastFloat,
        radius: FastFloat
    };
    var ssao: {
        strength: FastFloat,
        radius: FastFloat,
        max_steps: Int
    };
    var lenstexture: {
        center_min_clip: FastFloat,
        center_max_clip: FastFloat,
        luminance_min: FastFloat,
        luminance_max: FastFloat,			
        brightness_exponent: FastFloat,			
    };
    var chromatic_aberration: {
        strength: FastFloat,
        samples: Int
    }
}

typedef TPPColorgrading = {
    saturation: Array<FastFloat>,
    contrast: Array<FastFloat>,
    gamma: Array<FastFloat>,
    gain: Array<FastFloat>,
    offset: Array<FastFloat>
}

typedef TPPCamera = {
    fnumber: FastFloat,
    shutter: FastFloat,
    iso: FastFloat,
    exposure_compensation: FastFloat,
    fisheye: FastFloat,
    dof_autofocus: FastFloat,
    dof_distance: FastFloat,
    dof_focallength: FastFloat,
    dof_fstop: Int,
    tonemapping: Int,
    filmgrain: FastFloat
}

class Postprocess {

    public static var defaultConfig = {
        global: {
            weight: [6500.0, 1.0, 0.0],
            tint: [1.0, 1.0, 1.0],
            saturation: [1.0, 1.0, 1.0],
            contrast: [1.0, 1.0, 1.0],
            gamma: [1.0, 1.0, 1.0],
            gain: [1.0, 1.0, 1.0],
            offset: [1.0, 1.0, 1.0],
            lut: [1.0, 1.0, 1.0], 
        },
        shadow: {
            saturation: [1.0, 1.0, 1.0],
            contrast: [1.0, 1.0, 1.0],
            gamma: [1.0, 1.0, 1.0],
            gain: [1.0, 1.0, 1.0],
            offset: [1.0, 1.0, 1.0],
        },
        midtone: {
            saturation: [1.0, 1.0, 1.0],
            contrast: [1.0, 1.0, 1.0],
            gamma: [1.0, 1.0, 1.0],
            gain: [1.0, 1.0, 1.0],
            offset: [1.0, 1.0, 1.0],
        },
        highlight: {
            saturation: [1.0, 1.0, 1.0],
            contrast: [1.0, 1.0, 1.0],
            gamma: [1.0, 1.0, 1.0],
            gain: [1.0, 1.0, 1.0],
            offset: [1.0, 1.0, 1.0],
        },
        camera: {
            fnumber: 1.0,
            shutter: 2.8333,
            iso: 100.0,
            exposure_compensation: 0.0,
            fisheye: 0.01,
            dof_autofocus: 0.0,
            dof_distance: 10.0,
            dof_focallength: 160.0,
            dof_fstop: 128,
            tonemapping: 0,
            filmgrain: 0.5
        },
        tonemapper: {
            slope: 1.0,
            toe: 1.0,
            shoulder: 1.0,
            black_clip: 1.0,
            white_clip: 1.0
        },
        ssr: {
            step: 0.04,
            step_min: 0.05,
            search: 5.0,
            falloff: 5.0,
            jitter: 5.0
        },
        bloom: {
            threshold: 1.0,
            strength: 3.5,
            radius: 3.0
        },
        ssao: {
            strength: 1.0,
            radius: 1.0,
            max_steps: 8
        },
        lenstexture: {
            center_min_clip: 0.1,
            center_max_clip: 0.5,
            luminance_min: 0.1,
            luminance_max: 2.5,				
            brightness_exponent: 2.0,				
        },
        chromatic_aberration: {
            strength: 0.05,
            samples: 32
        }
    };

    public var enabled = true;
    public var config : TPostprocess;
    public var gamma : FastFloat = 1.0; // Global gamma offset
    // public var channels : Map<String,EffectChannel>;

    // var transition : TAnim;

    public function new( ?config : TPostprocess ) {
        this.config = (config == null) ? defaultConfig : config;
        Uniforms.externalVec3Links.push( vec3Link );
    }

    public function reset() {
        config = defaultConfig;
    }

    //TODO remove
    public function tween( target : Dynamic, props : Dynamic, ?duration : Float, ?delay : Float, ease = Ease.Linear, ?done : Void->Void ) : TAnim {
        // if( transition != null ) Tween.stop( transition );
        //transition = Tween.to({
        return Tween.to({
            target: target,
            props: props,
            duration: duration,
            delay: delay,
            ease: ease,
            done: () -> if(done != null) done()
        });
    }
    
    public function dispose() {
        Uniforms.externalVec3Links.remove( vec3Link );
    }

    function vec3Link( obj : Object, mat : MaterialData, link : String ) : Vec4 {
        if( !enabled ) return null;
        var v : Vec4 = null;
        var c = config;
        switch link {

        // --- global
        case '_globalWeight':
			v = Uniforms.helpVec;
			v.x = c.global.weight[0];
			v.y = c.global.weight[1];
			v.z = c.global.weight[2];
        case "_globalTint":
            v = Uniforms.helpVec;
            v.x = c.global.tint[0];
            v.y = c.global.tint[1];
            v.z = c.global.tint[2];
        case "_globalSaturation":
            v = Uniforms.helpVec;
            v.x = c.global.saturation[0];
            v.y = c.global.saturation[1];
            v.z = c.global.saturation[2];
        case "_globalContrast":
            v = Uniforms.helpVec;
            v.x = c.global.contrast[0];
            v.y = c.global.contrast[1];
            v.z = c.global.contrast[2];
        case "_globalGamma":
            v = Uniforms.helpVec;
            v.x = c.global.gamma[0] * gamma;
            v.y = c.global.gamma[1] * gamma;
            v.z = c.global.gamma[2] * gamma;
        case "_globalGain":
            v = Uniforms.helpVec;
            v.x = c.global.gain[0];
            v.y = c.global.gain[1];
            v.z = c.global.gain[2];
        case "_globalOffset":
            v = Uniforms.helpVec;
            v.x = c.global.offset[0];
            v.y = c.global.offset[1];
            v.z = c.global.offset[2];

        // --- shadow
        case "_shadowSaturation":
            v = Uniforms.helpVec;
            v.x = c.shadow.saturation[0];
            v.y = c.shadow.saturation[1];
            v.z = c.shadow.saturation[2];
        case "_shadowContrast":
            v = Uniforms.helpVec;
            v.x = c.shadow.contrast[0];
            v.y = c.shadow.contrast[1];
            v.z = c.shadow.contrast[2];
        case "_shadowGamma":
            v = Uniforms.helpVec;
            v.x = c.shadow.gamma[0];
            v.y = c.shadow.gamma[1];
            v.z = c.shadow.gamma[2];
        case "_shadowGain":
            v = Uniforms.helpVec;
            v.x = c.shadow.gain[0];
            v.y = c.shadow.gain[1];
            v.z = c.shadow.gain[2];
        case "_shadowOffset":
            v = Uniforms.helpVec;
            v.x = c.shadow.offset[0];
            v.y = c.shadow.offset[1];
            v.z = c.shadow.offset[2];
        
        // --- midtone
        case "_midtoneSaturation":
            v = Uniforms.helpVec;
            v.x = c.midtone.saturation[0];
            v.y = c.midtone.saturation[1];
            v.z = c.midtone.saturation[2];
        case "_midtoneContrast":
            v = Uniforms.helpVec;
            v.x = c.midtone.contrast[0];
            v.y = c.midtone.contrast[1];
            v.z = c.midtone.contrast[2];
        case "_midtoneGamma":
            v = Uniforms.helpVec;
            v.x = c.midtone.gamma[0];
            v.y = c.midtone.gamma[1];
            v.z = c.midtone.gamma[2];
        case "_midtoneGain":
            v = Uniforms.helpVec;
            v.x = c.midtone.gain[0];
            v.y = c.midtone.gain[1];
            v.z = c.midtone.gain[2];
        case "_midtoneOffset":
            v = Uniforms.helpVec;
            v.x = c.midtone.offset[0];
            v.y = c.midtone.offset[1];
            v.z = c.midtone.offset[2];

        // --- highlight
		case "_highlightSaturation":
			v = Uniforms.helpVec;
			v.x = c.highlight.saturation[0];
			v.y = c.highlight.saturation[1];
			v.z = c.highlight.saturation[2];
		case "_highlightContrast":
			v = Uniforms.helpVec;
			v.x = c.highlight.contrast[0];
			v.y = c.highlight.contrast[1];
			v.z = c.highlight.contrast[2];
		case "_highlightGamma":
			v = Uniforms.helpVec;
			v.x = c.highlight.gamma[0];
			v.y = c.highlight.gamma[1];
			v.z = c.highlight.gamma[2];
		case "_highlightGain":
			v = Uniforms.helpVec;
			v.x = c.highlight.gain[0];
			v.y = c.highlight.gain[1];
			v.z = c.highlight.gain[2];
		case "_highlightOffset":
			v = Uniforms.helpVec;
			v.x = c.highlight.offset[0];
			v.y = c.highlight.offset[1];
			v.z = c.highlight.offset[2];

		// --- postprocess
		case "_PPComp1":
			v = Uniforms.helpVec;
			v.x = c.camera.fnumber;
			v.y = c.camera.shutter;
			v.z = c.camera.iso;
		case "_PPComp2":
			v = Uniforms.helpVec;
			v.x = c.camera.exposure_compensation;
			v.y = c.camera.fisheye;
			v.z = c.camera.dof_autofocus;
		case "_PPComp3":
			v = Uniforms.helpVec;
			v.x = c.camera.dof_distance;
			v.y = c.camera.dof_focallength;
			v.z = c.camera.dof_fstop;
		case "_PPComp4":
			v = Uniforms.helpVec;
			v.x = c.camera.tonemapping;
			v.y = c.camera.filmgrain;
			v.z = c.tonemapper.slope;
		case "_PPComp5":
			v = Uniforms.helpVec;
			v.x = c.tonemapper.toe;
			v.y = c.tonemapper.shoulder;
			v.z = c.tonemapper.black_clip;
		case "_PPComp6":
			v = Uniforms.helpVec;
			v.x = c.tonemapper.white_clip;
			v.y = c.lenstexture.center_min_clip;
			v.z = c.lenstexture.center_max_clip;
		case "_PPComp7":
			v = Uniforms.helpVec;
			v.x = c.lenstexture.luminance_min;
			v.y = c.lenstexture.luminance_max;
			v.z = c.lenstexture.brightness_exponent;
		case "_PPComp8":
			v = Uniforms.helpVec;
			v.x = c.global.lut[0];
			v.y = c.global.lut[1];
			v.z = c.global.lut[2];
		case "_PPComp9":
			v = Uniforms.helpVec;
			v.x = c.ssr.step;
			v.y = c.ssr.step_min;
			v.z = c.ssr.search;
		case "_PPComp10":
			v = Uniforms.helpVec;
			v.x = c.ssr.falloff;
			v.y = c.ssr.jitter;
			v.z = c.bloom.threshold;
		case "_PPComp11":
			v = Uniforms.helpVec;
			v.x = c.bloom.strength;
			v.y = c.bloom.radius;
			v.z = c.ssao.strength;
		case "_PPComp12":
			v = Uniforms.helpVec;
			v.x = c.ssao.radius;
			v.y = c.ssao.max_steps; 
			v.z = 0;
		case "_PPComp13":
			v = Uniforms.helpVec;
			v.x = c.chromatic_aberration.strength;
			v.y = c.chromatic_aberration.samples;
			v.z = 0;

		default:
			// trace(link);
        }
        return v;
    }
}

#end
