package tron;

import armory.system.Assert.*;
import aura.Aura;
import aura.channels.MixChannel;
import aura.dsp.Filter;
import aura.Types.Balance.*;
import kha.Sound;

class Audio {

    public static var music(default,null) : MixChannel;

    public static function init() {
        
        #if !aura_disabled

        trace('Initializing aura audio');

        var numchannels = 8;
        Aura.init( numchannels );
        
        //TODO
        //music = new MixerChannel();
        //Aura.masterChannel.addInputChannel( music );
        /*
        var loadConfig: AuraLoadConfig = {
            uncompressed: [
                //"belldrone_c",
                //"prelife",
                "stapletapewormsonmypenis"
            ],
            compressed: [
            ]
        };
       Aura.loadSounds(loadConfig, () -> {
            var sound: kha.Sound = Aura.getSound("stapletapewormsonmypenis");
            //Aura.play(sound, true, Aura.mixChannels["fx"]);
            //Aura.play(sound, true, Aura.mixChannels["music"]);
            //var musicChannel = Aura.mixChannels["music"];
            //var musicChannel = Aura.mixChannels["asd"];
            //TODO krom sound cracks if extra channel is used
            var h = Aura.play(sound, true);
            //var h = Aura.play(sound, true, music);
            // trace(h);
            //h.setBalance(0.5);

            // var lowPass = new Filter(LowPass);
            // lowPass.setCutoffFreq(400);
            // h.addInsert(lowPass);
            //@:privateAccess Aura.masterChannel.inserts.push(lowPass);

            sound.addInsert(new aura.dsp.WhiteNoise());
				//sound.addInsert(new aura.dsp.PinkNoise());
        }); */

        #end
    }

    public static function load( sounds : Array<String>, done : Array<Sound>->Void ) {
        Aura.loadSounds(
            { uncompressed: sounds },
            () -> {
                done([for(s in sounds) Aura.getSound(s) ]);
            },
            () -> {
                assert(Error,true,'Sound load error');
            }
        );
    }

    public static function loadSound( sound : String, done : kha.Sound->Void ) {
        Aura.loadSounds(
            { uncompressed: [sound] },
            () -> done(Aura.getSound(sound)),
            () -> {
                assert(Error,true,'Sound load error');
                //armory.system.Assert.assert(Error,true,'Sound load error');
            }
        );
    }
}
