import 'dart:html';
import 'dart:math' as Math;
import 'package:CommonLib/Colours.dart';
import 'package:CommonLib/Random.dart';
import 'package:LoaderLib/Loader.dart';
import 'package:RenderingLib/RendereringLib.dart';

import 'Owl.dart';
import 'Rule.dart';
import 'RuleSet.dart';


class Team {
    //a team has three owls, and an item (that has the rulesets they believe in).
    //a team knows if they approve of a new ruleset.
    //TODO shove into level instead of the item directly
    //team generates a sprite sheet with palette
    static ImageElement flapSource;
    static ImageElement idleSource;

    //TODO make it use the text engine
    String name;
    CanvasElement flap;
    CanvasElement idle;
    bool left;

    RuleSet ruleSet;
    List<Owl> owls = new List<Owl>();
    static Palette sourcePalette = new Palette()
    ..add("lightaccent",new Colour.fromStyleString("#44244d"))
    ..add("darkaccent",new Colour.fromStyleString("#271128"))
    ..add("darkjersey",new Colour.fromStyleString("#eba900"))
    ..add("lightjersey",new Colour.fromStyleString("#ffd800"));

    Palette palette = new Palette()
        ..add("lightaccent",new Colour.fromStyleString("#44244d"))
        ..add("darkaccent",new Colour.fromStyleString("#271128"))
        ..add("darkjersey",new Colour.fromStyleString("#eba900"))
        ..add("lightjersey",new Colour.fromStyleString("#ffd800"));

    Team(String this.name, RuleSet this.ruleSet, Palette this.palette, bool this.left) {
        setupPaletteFrames();
        setupOwls();
    }

    bool approveOfOtherRuleSet(RuleSet other) {
        int approvalRating = 0;
        for(Rule rule in ruleSet.rules) {
            if(other.rules.contains(rule)) {
                approvalRating ++;
                print("the background is ${rule.element.parent.style.background}" );
                if(rule.element != null && rule.element.parent.style.background != "rgb(156, 30, 140)") {
                    rule.element.parent.style.background =
                    "${palette["lightjersey"].toStyleString()}";
                    rule.element.parent.style.color =
                    "${palette["darkjersey"].toStyleString()}";
                }else if (rule.element != null ) {
                    print("trying to change border color");
                    rule.element.parent.style.borderColor =
                    "${palette["lightjersey"].toStyleString()}";
                }
            }
        }
        bool ret= approvalRating>=4;
        if(ret) {
            owls.forEach((Owl owl)=> owl.celebrateTime());
        }else {
            owls.forEach((Owl owl)=> owl.flapTime());
        }
        return ret;
    }

    void setupOwls() {
        //TODO are we on left or right?
        owls.add(new Owl(flap, idle,0,0));
        owls.add(new Owl(flap, idle,0,0));
        owls.add(new Owl(flap, idle,0,0));
        if(!left) {
            owls.forEach((Owl owl) => owl.turnways());
        }
    }

    void clearResult() {
        owls.forEach((Owl owl) => owl.idleTime());
    }

    void setupPaletteFrames() {
        flap = new CanvasElement(width: flapSource.width, height: flapSource.height);
        flap.context2D.drawImage(flapSource,0,0);

        idle = new CanvasElement(width: idleSource.width, height: idleSource.height);
        idle.context2D.drawImage(idleSource,0,0);

        Renderer.swapPalette(idle, sourcePalette, palette);
        Renderer.swapPalette(flap, sourcePalette, palette);

    }

    void displayRules(Element parent, int teamNumber) {
        DivElement ruleElement = new DivElement()
            ..classes.add("rules$teamNumber");
        parent.append(ruleElement);
        for (final Rule rule in ruleSet.rules) {
            final Random rand = new Random(Rule.rules.indexOf(rule));
            final Colour bgColor = new Colour.hsv(rand.nextDouble(), rand.nextDouble(), rand.nextDouble());
            final Colour foregroundColor = new Colour.hsv(bgColor.hue, bgColor.saturation, bgColor.value-.5<.2?1.0:1.0-bgColor.value);

            DivElement div = new DivElement();
            div.classes.add("rule");
            div.style.backgroundColor =
            "${palette["lightjersey"].toStyleString()}";
            div.style.color =
            "${palette["darkjersey"].toStyleString()}";
            SpanElement plzwork = new SpanElement()..text = "${rule.applyObjectToPhrase(ruleSet.baseName)}";
            div.append(plzwork);
            ruleElement.append(div);
        }
    }

    void displayTeam(Element parent, int teamNumber) {
        for(int i=0; i<owls.length; i++) {
            Owl owl = owls[i];
            owl.sprite.classes.add("owl${i+(owls.length*teamNumber)}");
            parent.append(owl.sprite);
    }

    }

    void debugInDom(Element output) {
        print("output is $output and idle is $idle");
         output.append(idle);
         output.append(flap);
         DivElement spacer =new DivElement();
         output.append(spacer);
         for(Owl owl in owls) {
             DivElement container = new DivElement()..style.display="inline-block";
             output.append(container);
             container.append(owl.sprite);
             ButtonElement button = new ButtonElement()..text = "Flap???";
             container.append(button);
             bool flap = false;
             button.onClick.listen((Event e) {
                 flap = !flap;
                 if(flap) {
                    button.text = "NO FLAP!!!";
                    owl.flapTime();
                 }else {
                    button.text = "Flap???";
                    owl.idleTime();
                 }
             });

             ButtonElement turn = new ButtonElement()..text = "Turnways???";
             container.append(turn);
             turn.onClick.listen((Event e) {
                 owl.turnways();
             });

             bool celebrate = false;
             ButtonElement button2 = new ButtonElement()..text = "Celebrate???";
             container.append(button2);
             button2.onClick.listen((Event e) {
                 celebrate = !celebrate;
                 if(celebrate) {
                     button2.text = "Default";
                     owl.celebrateTime();
                 }else {
                     button2.text = "Celebrate???";
                     owl.celebrateTime();
                 }
             });
         }
        DivElement space2r =new DivElement();
        output.append(space2r);
    }

    static void loadFrames() async {
        //https://draeton.github.io/stitches/
        flapSource = await Loader.getResource("images/owls/flap.png");
        idleSource = await Loader.getResource("images/owls/idle.png");
    }

    static  Palette  inversePalette(Palette otherPalette,seed) {
        Random rand = new Random(seed);

        Palette ret = new Palette()
            ..add("lightaccent",new Colour.fromStyleString("#44244d"))
            ..add("darkaccent",new Colour.fromStyleString("#271128"))
            ..add("darkjersey",new Colour.fromStyleString("#eba900"))
            ..add("lightjersey",new Colour.fromStyleString("#ffd800"));

        Colour lightaccent = new Colour(255-otherPalette["lightaccent"].red,255-otherPalette["lightaccent"].green,255-otherPalette["lightaccent"].blue );
        //lightaccent = new Colour.hsv(lightaccent.hue, rand.nextDoubleRange(0.0,0.95), rand.nextDoubleRange(0.5,0.95));
        ret.add("lightaccent", lightaccent,true);
        makeOtherColorsDarker(ret, "lightaccent", <String>["darkaccent"]);

        Colour lightjersey = new Colour(255-otherPalette["lightjersey"].red,255-otherPalette["lightjersey"].green,255-otherPalette["lightjersey"].blue );
        //lightjersey = new Colour.hsv(lightjersey.hue, rand.nextDoubleRange(0.0,0.85), rand.nextDoubleRange(0.5,0.85));

        ret.add("lightjersey", lightjersey,true);
        makeOtherColorsDarker(ret, "lightjersey", <String>["darkjersey"]);
        return ret;
    }

    static  Palette  randomPalette(int seed) {
        Random rand = new Random(seed);
        Palette ret = new Palette()
            ..add("lightaccent",new Colour.fromStyleString("#44244d"))
            ..add("darkaccent",new Colour.fromStyleString("#271128"))
            ..add("darkjersey",new Colour.fromStyleString("#eba900"))
            ..add("lightjersey",new Colour.fromStyleString("#ffd800"));

        Colour lightaccent = new Colour(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
        lightaccent = new Colour.hsv(lightaccent.hue, rand.nextDoubleRange(0.0,0.95), rand.nextDoubleRange(0.5,0.95));
        ret.add("lightaccent", lightaccent,true);
        makeOtherColorsDarker(ret, "lightaccent", <String>["darkaccent"]);

        Colour lightjersey = new Colour(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
        lightjersey = new Colour.hsv(lightjersey.hue, rand.nextDoubleRange(0.0,0.85), rand.nextDoubleRange(0.5,0.85));

        ret.add("lightjersey", lightjersey,true);
        makeOtherColorsDarker(ret, "lightjersey", <String>["darkjersey"]);
        return ret;
    }

    static void makeOtherColorsDarker(Palette p, String sourceKey, List<String> otherColorKeys) {
        String referenceKey = sourceKey;
        //print("$name, is going to make other colors darker than $sourceKey, which is ${p[referenceKey]}");
        for(String key in otherColorKeys) {
            //print("$name is going to make $key darker than $sourceKey");
            p.add(key, new Colour(p[referenceKey].red, p[referenceKey].green, p[referenceKey].blue)..setHSV(p[referenceKey].hue, p[referenceKey].saturation, 1*p[referenceKey].value / 2), true);
            //print("$name made  $key darker than $referenceKey, its ${p[key]}");

            referenceKey = key; //each one is progressively darker
        }
    }
}