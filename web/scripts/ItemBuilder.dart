//otherwise i'll go insane making items
/*
TODO:
display all items in a big pile, each item has its own builder that lets you change name and then pick up to 8 traits from drop down
text area on top that constantly updates json array */
import 'dart:html';

import 'Item.dart';
import 'Rule.dart';

abstract class ItemBuilder {
    static TextAreaElement textAreaElement;
    static void go(Element element) {
        textAreaElement = new TextAreaElement();
        element.append(textAreaElement);
        syncOutput();
        for(Item item in Item.items) {
            makeBuilder(item, element);
        }
    }

    static void syncOutput() {
        textAreaElement.text = Item.allJSON();
    }

    static void makeBuilder(Item item, Element element) {
        DivElement div = new DivElement()
            ..text = item.baseName
            ..style.border="1px solid black";

        int i = 0;
        for(Rule rule in item.rules) {
            i++;
            div.append(new DivElement()..text = "$i: ${rule.applyObjectToPhraseDebug(item.baseName)}");
        }

        element.append(div);
    }

    static void debugItemInDOM(Item item, Element element) {
        DivElement div = new DivElement()
            ..text = item.baseName
            ..style.border="1px solid black";

        int i = 0;
        for(Rule rule in item.rules) {
            i++;
            div.append(new DivElement()..text = "$i: ${rule.applyObjectToPhraseDebug(item.baseName)}");
        }

        element.append(div);
    }


}