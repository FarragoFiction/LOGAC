import 'dart:html';

import 'package:LoaderLib/Loader.dart';


class Game {
    Element container;

    Future<void> start(Element element) async {
        container = new DivElement()..classes.add("game");
        element.append(container);
        CanvasElement canvas = new CanvasElement(width: 720, height: 720);
        ImageElement levelSelect =  await Loader.getResource("images/levelSelect.png");
        canvas.context2D.drawImage(levelSelect,0,0);
        container.append(canvas);
        //TODO do an on click (check ant sim) where it checks the color of the pixel clicked and loads the corresponding level
    }



}