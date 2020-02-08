import 'dart:html';

class Owl {
    //owls have an element and know how to animate themselves (palette gives the paletted sprite sheet to the element)
    Element sprite = new DivElement()..classes.add("owl");
    CanvasElement flap;
    static AudioElement soundEffects = new AudioElement();
    CanvasElement idle;
    int x=0;
    int y = 0;
    Owl(CanvasElement this.flap, CanvasElement this.idle, this.x, this.y) {
        idleTime();
    }

    void flapTime() {
        sprite.style.backgroundImage="url(${flap.toDataUrl()})";
        if(sprite.classes.contains("angryowl")) {
            sprite.classes.remove("angryowl");
        }else {
            sprite.classes.add("angryowl");
        }
        playSoundEffect("who");
    }

    void celebrateTime() {
        if(sprite.classes.contains("happy-owl")) {
            sprite.classes.remove("happy-owl");
        }else {
            sprite.classes.add("happy-owl");
        }
        playSoundEffect("cheer");
    }

    void idleTime() {
        sprite.style.backgroundImage="url(${idle.toDataUrl()})";
    }

    void turnways() {
        if(sprite.classes.contains("turnways")) {
            sprite.classes.remove("turnways");
        }else {
            sprite.classes.add("turnways");
        }
    }


    static void playSoundEffect(String locationWithoutExtension, [loop = false]) {
        if(soundEffects.canPlayType("audio/mpeg").isNotEmpty) soundEffects.src = "SoundFX/${locationWithoutExtension}.mp3";
        if(soundEffects.canPlayType("audio/ogg").isNotEmpty) soundEffects.src = "SoundFX/${locationWithoutExtension}.ogg";
        soundEffects.loop = loop;
        soundEffects.play();


    }

}