import 'dart:html';

import 'package:CommonLib/Colours.dart';
import 'package:LoaderLib/Loader.dart';
import 'package:RenderingLib/RendereringLib.dart';

import 'AlchemyResult.dart';
import 'Level.dart';
import 'RuleSet.dart';


class Game {
    Element container;
    Element firstItemElement;
    Element secondItemElement;
    Element resultItemElement;

    Element andButton;
    Element orButton;
    Element xorButton;
    int width =1280;
    int height = 800;
    Level currentLevel;
    RuleSet firstItem;
    RuleSet secondItem;
    RuleSet resultItem;

    Future<void> start(Element element) async {
        element.text = "";
        container = new DivElement()..classes.add("game");
        element.append(container);
        await levelSelect();
    }

    void displayCurrentLevel() {
        container.text = "";

        currentLevel.team1.displayRules(container,0);
        currentLevel.team2.displayRules(container,1);
        currentLevel.team1.displayTeam(container,0);
        currentLevel.team2.displayTeam(container,1);
        displayAlchemy();
        displayItems();
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
            window.alert("!!!");
        }else {
            window.alert("NOPE!");
        }
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