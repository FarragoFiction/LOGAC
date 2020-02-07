import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Colours.dart';
import 'package:LoaderLib/Loader.dart';
import 'package:RenderingLib/RendereringLib.dart';

import 'AlchemyResult.dart';
import 'Level.dart';
import 'Rule.dart';
import 'RuleSet.dart';
import 'Team.dart';


class Game {
    static int levelAlg = 5;
    Element container;
    Element parent;
    Element firstItemElement;
    Element secondItemElement;
    Element resultItemElement;

    Element andButton;
    Element orButton;
    Element xorButton;
    int width =1280;
    int height = 800;
    Level currentLevel;
    List<Level> beatenLevels = new List<Level>();
    RuleSet firstItem;
    RuleSet secondItem;
    RuleSet resultItem;

    Future<void> start(Element element) async {
        element.text = "";
        parent = element;
        container = new DivElement()..classes.add("game");
        element.append(container);
        DivElement intro = new DivElement()..classes.add("intro");
        container.append(intro);
        ImageElement wright = new ImageElement(src: "images/wrightoflaw.png")..classes.add('avatar');
        intro.append(wright);
        DivElement text = new DivElement()..setInnerHtml("The Wright of Law begins to actually engage with the Land of Games and Confusion, after a frankly mind boggling amount of time bugging and fussing and meddling with her coplayers. Her Quest is to use the Alchemy methods of And, Or and the ever-so-mysterious Xor on the proffered rules of of the competitions of the 8 Districts, in order to finally bring order to the chaos of the rules laid down by the Denizen Gerrymander.<br><br>While two teams of Owls watch with frankly unsettling focus, The Wright of Law must place items into the Alchemy Slots of the Adventure Bus in order to create new Rules which satisfy both teams.")..classes.add("introtext");
        intro.append(text);
        DivElement loading = new DivElement()..text = "LOADING..."..classes.add("loading")..classes.add("loadingbase");
        text.append(loading);
        await reset();
        loading.text = "Click to Begin";
        loading.classes.remove("loading");
        intro.onClick.listen((Event e) {
            startLevel(element);
        });
    }

    Future<void> startLevel(Element element) async {
        element.text = "";
        if(beatenLevels.length == Level.levels.length) {
            window.alert("You did it!!!");
        }
        parent = element;
        container = new DivElement()..classes.add("game");
        element.append(container);
        await levelSelect();
    }

    static Future<void> reset() async {
        await Team.loadFrames();
        await Rule.slurpRules();
        await RuleSet.slurpItems();
        await Level.initLevels(levelAlg);
    }

    void displayCurrentLevel() {
        container.text = "";

        currentLevel.team1.displayRules(container,0);
        currentLevel.team2.displayRules(container,1);
        currentLevel.team1.displayTeam(container,0);
        currentLevel.team2.displayTeam(container,1);
        displayBack();
        displayAlchemy();
        displayItems();
    }

    void displayBack() {
        final AnchorElement back = new AnchorElement()..text = "<"..classes.add('back');
        container.append(back);
        back.onClick.listen((Event e) {
            levelSelect();
        });
    }

    void displayItems() {
        int i = 0;
        for(RuleSet item in currentLevel.items) {
            item.sprite.classes.add("item");
            container.append(item.sprite);
            item.sprite.style.left = "${365+(i*65)}px";
            item.handleDragging(<Element>[firstItemElement, secondItemElement]);
            i++;
        }
    }

    void displayAlchemy() {
        print("alchemy");
        firstItemElement = new DivElement()..classes.add("firstItem");
        firstItemDrop();
        secondItemElement = new DivElement()..classes.add("secondItem");
        secondItemDrop();
        resultItemElement = new DivElement()..classes.add("resultItem");
        container.append(firstItemElement);
        container.append(secondItemElement);
        container.append(resultItemElement);

        displayAnd();
        displayOr();
        displayXor();


    }

    void displayOr() {
        orButton = new ButtonElement()..text = "OR"..classes.add("orButton");
        container.append(orButton);
        orButton.onClick.listen((Event e) {
            resultItem = new AlchemyResultOR(<RuleSet>[firstItem,secondItem]).result;
            resultItem.baseName = currentLevel.name;
            resultItem.alchemyDisplay(resultItemElement);
            alchemyAttention();
            judge(currentLevel.suggestRuleset(resultItem));
            //TODO decide how to animate teams, pop up describing reaction
        });
    }

    void clearResult() {
        resultItem = null;
        resultItemElement.text = "";
        currentLevel.clearResult();
    }

    void displayXor() {
        xorButton = new ButtonElement()..text = "XOR"..classes.add("xorButton");
        container.append(xorButton);
        xorButton.onClick.listen((Event e) {
            resultItem = new AlchemyResultXOR(<RuleSet>[firstItem,secondItem]).result;
            resultItem.baseName = currentLevel.name;
            resultItem.alchemyDisplay(resultItemElement);
            alchemyAttention();
            judge(currentLevel.suggestRuleset(resultItem));
            //TODO decide how to animate teams, pop up describing reaction
        });


    }

    void displayAnd() {
      andButton = new ButtonElement()..text = "AND"..classes.add("andButton");
      andButton.onClick.listen((Event e) {
          resultItem = new AlchemyResultAND(<RuleSet>[firstItem,secondItem]).result;
          resultItem.baseName = currentLevel.name;
          resultItem.alchemyDisplay(resultItemElement);
          alchemyAttention();
          judge(currentLevel.suggestRuleset(resultItem));
          //TODO decide how to animate teams, pop up describing reaction
      });
      container.append(andButton);
    }

    void judge(bool judgement) {
        if(judgement) {
           popup("Congratulations, Wright! Both teams love the new rules!!!!!!!!");
            beatenLevels.add(currentLevel);
            startLevel(parent);
        }else {
            popup("Absolutely not, these rules are complete bullshit!!!!!!!! You need to convince BOTH teams to accept at least half the rules.");
        }
    }

    void popup(String text) {
        final DivElement div = new DivElement()..text = text..classes.add("popup");
        container.append(div);
        StreamSubscription listener;
        listener= div.onClick.listen((Event e) {
            div.remove();
            listener.cancel();
        });
    }

    void secondItemDrop() {
      secondItemElement.onDrop.listen((MouseEvent e) {
          print("detected a drop for second item");
          String text = e.dataTransfer.getData("text");
          if(secondItem != null) {
              secondItem.sprite.style.display = "block";
              secondItemElement.text ="";
          }
          secondItem = RuleSet.items[text];
          secondItem.sprite.style.display = "none";
          secondItem.alchemyDisplay(secondItemElement);
          clearResult();
          alchemyAttention();
      });
      secondItemElement.onDragOver.listen((Event e) {
          e.preventDefault();
      });
    }

    void alchemyAttention() {
        if(firstItem != null && secondItem != null && resultItem == null) {
            andButton.classes.add("attention");
            orButton.classes.add("attention");
            xorButton.classes.add("attention");
        }else {
            andButton.classes.remove("attention");
            orButton.classes.remove("attention");
            xorButton.classes.remove("attention");
        }
    }

    void firstItemDrop() {
      firstItemElement.onDrop.listen((MouseEvent e) {
          print("detected a drop for first item");
          String text = e.dataTransfer.getData("text");
          if(firstItem != null) {
              firstItem.sprite.style.display= "block";
              firstItemElement.text ="";
          }
          firstItem = RuleSet.items[text];
          firstItem.sprite.style.display = "none";
          firstItem.alchemyDisplay(firstItemElement);
          clearResult();
          alchemyAttention();
      });
      firstItemElement.onDragOver.listen((Event e) {
          e.preventDefault();
      });

    }




    Future<void> levelSelect() async {
        currentLevel = null;
        container.text = "";
        CanvasElement canvas = new CanvasElement(width: width, height: height);
        ImageElement levelSelect =  await Loader.getResource("images/levelSelect.png");
        canvas.context2D.drawImage(levelSelect,0,0);
        container.append(canvas);

        for(final Level level in beatenLevels) {
            final Colour color = new Colour.fromStyleString("#ffd800");
            final Palette mapColor = new Palette()..add("selected", level.color);
            final Palette selected = new Palette()..add("selected", color);
            Renderer.swapPalette(canvas, mapColor, selected);
        }

        canvas.onClick.listen((MouseEvent e) {
          final Rectangle rect = canvas.getBoundingClientRect();
          final Point point = new Point(e.client.x-rect.left, e.client.y-rect.top);
          final double x = point.x;
          final double y = point.y;
          final ImageData imgData = canvas.context2D.getImageData(x.toInt(), y.toInt(), 1,1);
          Colour color = new Colour(imgData.data[0], imgData.data[1], imgData.data[2]);
          for(final Level level in Level.levels) {
              print("checking ${level.team1.ruleSet.baseName} for color. Color clicked is ${color.toStyleString()} and team color is ${level.color.toStyleString()} at position $x, $y");
            if(color.toStyleString() == level.color.toStyleString()) {
                //we found it boys
                currentLevel = level;
                Palette mapColor = new Palette()..add("map", color);
                Palette selected = new Palette()..add("selected", new Colour());
                Renderer.swapPalette(canvas, mapColor, selected);
                break;
            }
          }

          if(currentLevel != null) {
              displayCurrentLevel();
          }

        });
    }



}