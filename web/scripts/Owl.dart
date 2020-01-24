import 'dart:html';

class Owl {
    //owls have an element and know how to animate themselves (palette gives the paletted sprite sheet to the element)
    Element sprite = new DivElement()..classes.add("owl");
    CanvasElement flap;
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
    }

    void celebrateTime() {
        if(sprite.classes.contains("happy-owl")) {
            sprite.classes.remove("happy-owl");
        }else {
            sprite.classes.add("happy-owl");
        }
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




}