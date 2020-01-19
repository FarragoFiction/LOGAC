import 'dart:html';

class Game {
    Element container;

    void display(Element element) {
        container = new DivElement()..classes.add("game");
        element.append(container);
    }

}