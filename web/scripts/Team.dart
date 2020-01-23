import 'dart:html';

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
            }
        }
        return approvalRating>=4;
    }

    void setupOwls() {
        //TODO are we on left or right?
        owls.add(new Owl(flap, idle,0,0));
        owls.add(new Owl(flap, idle,0,0));
        owls.add(new Owl(flap, idle,0,0));

    }

    void setupPaletteFrames() {
        flap = new CanvasElement(width: flapSource.width, height: flapSource.height);
        flap.context2D.drawImage(flapSource,0,0);

        idle = new CanvasElement(width: idleSource.width, height: idleSource.height);
        idle.context2D.drawImage(idleSource,0,0);

        Renderer.swapPalette(idle, sourcePalette, palette);
        Renderer.swapPalette(flap, sourcePalette, palette);

    }

    void debugInDom(Element output) {
        print("output is $output and idle is $idle");
         output.append(idle);
         output.append(flap);
         output.append(owls.first.sprite);
    }

    static void loadFrames() async {
        //https://draeton.github.io/stitches/
        flapSource = await Loader.getResource("images/owls/flap.png");
        idleSource = await Loader.getResource("images/owls/idle.png");
    }


    static  Palette  randomPalette(int seed) {
        Random rand = new Random(seed);
        Palette ret = new Palette()
            ..add("lightaccent",new Colour.fromStyleString("#44244d"))
            ..add("darkaccent",new Colour.fromStyleString("#271128"))
            ..add("darkjersey",new Colour.fromStyleString("#eba900"))
            ..add("lightjersey",new Colour.fromStyleString("#ffd800"));

        Colour lightaccent = new Colour(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
        ret.add("lightaccent", lightaccent,true);
        makeOtherColorsDarker(ret, "lightaccent", <String>["darkaccent"]);

        Colour lightjersey = new Colour(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
        ret.add("lightjersey", lightjersey,true);
        makeOtherColorsDarker(ret, "lightjersey", <String>["darkjersey"]);
        return ret;
    }

    static void makeOtherColorsDarker(Palette p, String sourceKey, List<String> otherColorKeys) {
        String referenceKey = sourceKey;
        //print("$name, is going to make other colors darker than $sourceKey, which is ${p[referenceKey]}");
        for(String key in otherColorKeys) {
            //print("$name is going to make $key darker than $sourceKey");
            p.add(key, new Colour(p[referenceKey].red, p[referenceKey].green, p[referenceKey].blue)..setHSV(p[referenceKey].hue, p[referenceKey].saturation, 2*p[referenceKey].value / 3), true);
            //print("$name made  $key darker than $referenceKey, its ${p[key]}");

            referenceKey = key; //each one is progressively darker
        }
    }
}