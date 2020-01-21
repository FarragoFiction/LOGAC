//otherwise i'll go insane making items
/*
TODO:
display all items in a big pile, each item has its own builder that lets you change name and then pick up to 8 traits from drop down
text area on top that constantly updates json array */
import 'dart:html';
import 'package:CommonLib/Colours.dart';
import 'package:CommonLib/Random.dart';
import 'RuleSet.dart';
import 'Rule.dart';

abstract class ItemBuilder {
    static TextAreaElement textAreaElement;
    static void go(Element element) {
        element.text = "";
        textAreaElement = new TextAreaElement();
        textAreaElement.cols = 100;
        textAreaElement.rows = 30;
        element.append(textAreaElement);
        syncOutput();
        DivElement newItems = new DivElement();
        element.append(newItems);
        ButtonElement button = new ButtonElement()..text = "New Item"..onClick.listen((Event e) {
            RuleSet newItem = new RuleSet("New Item", "", null);
            makeBuilder(newItem, newItems);
            syncOutput();
        });
        element.append(button);
        for(RuleSet item in RuleSet.items.values) {
            makeBuilder(item, element);
        }
    }

    static void syncOutput() {
        textAreaElement.text = RuleSet.allJSON();
    }

    static void makeBuilder(RuleSet item, Element element) {
        DivElement div = new DivElement()
            ..style.padding="10px"
            ..style.border="1px solid black";


        TextInputElement input = new TextInputElement()..value = item.baseName;
        div.append(input);
        input.onChange.listen((Event e) {
            item.baseName = input.value;
            syncOutput();
        });

        TextInputElement input2 = new TextInputElement()..value = item.imageLocation;
        div.append(input2);
        ImageElement image = new ImageElement(src: item.imageLocation);
        div.append(image);
        input2.onChange.listen((Event e) {
            item.imageLocation = input2.value;
            image.src = item.imageLocation;
            syncOutput();
        });

        int i = 0;
        for(Rule rule in item.rules) {
            DivElement ruleDiv = new DivElement()..text = "Rule ${i+1}:";
            div.append(ruleDiv);
            SelectElement select = addRuleDropDown(item,Rule.rules.indexOf(rule));
            div.append(select);
            select.onChange.listen((Event e) {
                Rule newRule =Rule.rules[int.parse(select.selectedOptions.first.value)];
                //sets don't care about order so why should i
                item.rules.remove(rule);
                item.rules.add(newRule);
                syncOutput();
            });
            i++;
        }

        element.append(div);
    }

    static SelectElement addRuleDropDown(RuleSet item, int selectedIndex) {
        SelectElement ret = new SelectElement();
        for(int i = 0; i<Rule.rules.length; i++) {
            Rule rule = Rule.rules[i];
            OptionElement option = new OptionElement(value: i.toString(), selected: selectedIndex==i)..text="$i:${rule.toString()}";
            ret.append(option);
        }
        return ret;
    }

    static void debugItemInDOM(RuleSet item, Element element) {
        DivElement div = new DivElement()
            ..text = item.baseName
            ..style.display="inline-block"
            ..style.width="250px"
            ..style.border="1px solid black";

        int i = 0;
        ImageElement image = new ImageElement(src: item.imageLocation);
        div.append(image);
        for(Rule rule in item.rules) {
            i++;
            Random rand = new Random(Rule.rules.indexOf(rule));
            Colour bgColor = new Colour(rand.nextInt(255), rand.nextInt(255), rand.nextInt(255));
            Colour foregroundColor = new Colour.hsv(bgColor.hue, 255-bgColor.value, bgColor.saturation);

            div.append(new DivElement()..text = "$i: ${rule.applyObjectToPhraseDebug(item.baseName)}"..style.backgroundColor="${bgColor.toStyleString()}"..style.color="${foregroundColor.toStyleString()}");
        }

        element.append(div);
    }


}