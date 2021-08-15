#if macro
import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;
using haxe.io.Path;
using haxe.macro.ExprTools;
#else

import armory.system.Event;
import armory.trait.internal.CanvasScript;
import armory.trait.physics.PhysicsWorld;
import armory.trait.physics.RigidBody;

import haxe.Json;
import haxe.io.Bytes;

import iron.Scene;
import iron.Trait;
import iron.data.Data;
import iron.math.Mat4;
import iron.math.Quat;
import iron.math.Vec2;
import iron.math.Vec3;
import iron.math.Vec4;
import iron.object.Animation;
import iron.object.BoneAnimation;
import iron.object.CameraObject;
import iron.object.LightObject;
import iron.object.MeshObject;
import iron.object.Object;
import iron.object.SpeakerObject;
import iron.object.Transform;
import iron.object.Uniforms;
import iron.system.Audio;
import iron.system.Time;
import iron.system.Tween;

import kha.Assets;
import kha.Blob;
import kha.FastFloat;
import kha.Image;
import kha.input.KeyCode;

#if html5
import js.lib.Promise;
#end

#end //!macro
