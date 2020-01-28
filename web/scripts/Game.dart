import 'dart:html';

import 'package:CommonLib/Colours.dart';
import 'package:LoaderLib/Loader.dart';
import 'package:RenderingLib/RendereringLib.dart';

import 'Level.dart';


class Game {
    Element container;
    int width =1280;
    int height = 642;
    Level currentLevel;

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
    }

    void displayAlchemy() {
        print("alchemy");
        DivElement firstItemElement = new DivElement()..classes.add("firstItem");
        DivElement secondItemElement = new DivElement()..classes.add("secondItem");
        DivElement resultItemElement = new DivElement()..classes.add("resultItem");
        container.append(firstItemElement);
        container.append(secondItemElement);
        container.append(resultItemElement);
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