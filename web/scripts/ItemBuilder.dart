//otherwise i'll go insane making items
/*
TODO:
display all items in a big pile, each item has its own builder that lets you change name and then pick up to 8 traits from drop down
text area on top that constantly updates json array */
import 'dart:html';

import 'Item.dart';

abstract class ItemBuilder {
    static TextAreaElement textAreaElement;
    static void go(Element element) {
        textAreaElement = new TextAreaElement();
        element.append(textAreaElement);
        syncOutput();
    }

    static void syncOutput() {
        textAreaElement.text = Item.allJSON();
    }


}