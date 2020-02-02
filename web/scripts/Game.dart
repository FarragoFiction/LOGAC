import 'dart:html';

import 'package:CommonLib/Colours.dart';
import 'package:LoaderLib/Loader.dart';
import 'package:RenderingLib/RendereringLib.dart';

import 'Level.dart';
import 'RuleSet.dart';


class Game {
    Element container;
    int width =1280;
    int height = 642;
    Level currentLevel;
    RuleSet firstItem;
    RuleSet secondItem;

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
        displayItems();
        displayAlchemy();
    }

    void displayItems() {
        int i = 0;
        for(RuleSet item in currentLevel.items) {
            i++;
            item.sprite.classes.add("item");
            container.append(item.sprite);
            item.sprite.style.left = "${300+(i*65)}px";
            item.handleDragging();
        }
    }

    void displayAlchemy() {
        print("alchemy");
        DivElement firstItemElement = new DivElement()..classes.add("firstItem");
        firstItemDrop(firstItemElement);
        DivElement secondItemElement = new DivElement()..classes.add("secondItem");
        secondItemDrop(secondItemElement);
        DivElement resultItemElement = new DivElement()..classes.add("resultItem");
        container.append(firstItemElement);
        container.append(secondItemElement);
        container.append(resultItemElement);

        ButtonElement andButton = new ButtonElement()..text = "AND"..classes.add("andButton");;
        ButtonElement orButton = new ButtonElement()..text = "OR"..classes.add("orButton");;
        ButtonElement xorButton = new ButtonElement()..text = "XOR"..classes.add("xorButton");;
        container.append(andButton);
        container.append(orButton);
        container.append(xorButton);


    }

    void secondItemDrop(DivElement secondItemElement) {
      secondItemElement.onDrop.listen((MouseEvent e) {
          print("detected a drop for second item");
          String text = e.dataTransfer.getData("text");
          if(secondItem != null) {
              secondItem.sprite.style.left = "${300+(currentLevel.items.indexOf(secondItem)*65)}px";
              secondItem.sprite.style.bottom = "0px";
          }
          secondItem = RuleSet.items[text];
          secondItem.sprite.style.right = "${270-(secondItem.sprite.width/2)}px";
          secondItem.sprite.style.top = "${80+(secondItem.sprite.height/2)}px";
      });
      secondItemElement.onDragOver.listen((Event e) {
          e.preventDefault();
      });
    }

    void firstItemDrop(DivElement firstItemElement) {
      firstItemElement.onDrop.listen((MouseEvent e) {
          print("detected a drop for first item");
          String text = e.dataTransfer.getData("text");
          if(firstItem != null) {
              firstItem.sprite.style.left = "${300+(currentLevel.items.indexOf(firstItem)*65)}px";
              firstItem.sprite.style.bottom = "0px";
          }
          firstItem = RuleSet.items[text];
          firstItem.sprite.style.left = "${270+(firstItem.sprite.width/2)}px";
          firstItem.sprite.style.top = "${80+(firstItem.sprite.height/2)}px";
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