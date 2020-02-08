import 'dart:convert';
import 'dart:html';
import 'package:CommonLib/Random.dart';
import 'package:http/http.dart' as http;
import 'Game.dart';
import 'ItemBuilder.dart';
import 'Rule.dart';

class RuleSet {
    static Map<String,RuleSet> items =new Map<String,RuleSet>();
    String baseName;
    String imageLocation;
    //baes items go into the item pile
    bool baseItem;
    ImageElement sprite;
    bool isCopy;
    //a set is like a list but each thing in it happens exactly one or zero times
    Set<Rule>  rules = new Set<Rule>();
    Iterable<Rule> get permissiveRules => rules.where((Rule a) => (a is PermissiveRule));
    Iterable<Rule> get restrictiveRules => rules.where((Rule a) => (a is RestrictiveRule));

  RuleSet(String this.baseName, String this.imageLocation,Set<Rule> this.rules, {bool this.isCopy, bool this.baseItem=false}) {
      sprite = new ImageElement(src: this.imageLocation);
      if(this.rules == null) {
          randomRules();
      }
        if(baseItem) items[baseName] =this;
  }

  void alchemyDisplay(Element parent) {
      parent.text = "";
      for (final Rule rule in rules) {
          DivElement div = new DivElement();
          div.classes.add("alchemyRule");
          rule.element= new SpanElement()..text = "${rule.applyObjectToPhrase(baseName)}";
          div.append(rule.element);
          parent.append(div);
      }
  }

  //game will call this
  void handleDragging(List<Element> elements) {
      sprite.draggable = true;

      sprite.onMouseDown.listen((MouseEvent e) {
          Game.playSoundEffect("254286__jagadamba__mechanical-switch");
          elements.forEach((Element e) =>e.classes.add("attention"));
      });

      sprite.onMouseUp.listen((MouseEvent e) {
          elements.forEach((Element e) =>e.classes.remove("attention"));
      });

      sprite.onDragStart.listen((MouseEvent e) {
        elements.forEach((Element e) =>e.classes.add("attention"));
        e.dataTransfer.setData("text","$baseName");
        Game.playSoundEffect("scrape",true);
      });

      sprite.onDragEnd.listen((MouseEvent e) {
          elements.forEach((Element e) =>e.classes.remove("attention"));
          Game.playSoundEffect("254286__jagadamba__mechanical-switch");
          e.dataTransfer.setData("text","$baseName");
      });
  }

  void randomRules() {
      rules = new Set<Rule>();
      List<Rule> possibleRules = new List<Rule>.from(Rule.rules);
      Random rand = new Random();
      for(int i = 0; i<8; i++) {
          if(possibleRules.isNotEmpty) {
              Rule pick = rand.pickFrom(possibleRules);
              possibleRules.remove(pick);
              rules.add(pick);
          }
      }
  }


    String  toString() => baseName;

  Map<String, dynamic> toJSON() {
      Map<String, dynamic> json = new Map<String, dynamic>();
      json["baseName"] = baseName;
      json["imageLocation"] = imageLocation;
      json["rules"] = rules.map((Rule rule) =>Rule.rules.indexOf(rule)).toList();
      return json;
  }

  static String allJSON() {
        List<Map<String, dynamic>> list = new List<Map<String, dynamic>>();
        for(RuleSet item in items.values) {
            list.add(item.toJSON());
        }
        return jsonEncode(list);
  }

    static void slurpItems() async {
      print("slurping items");
      items.clear();
        String data = await http.read('Data/items.json');
        var jsonData = jsonDecode(data);
        for(dynamic json in jsonData) {
            String baseName = json["baseName"];
            String imageLocation = json["imageLocation"];
            List<Rule> rules = new List<Rule>();
            for(int id in json["rules"]) {
                rules.add(Rule.rules[id]);
            }
            new RuleSet(baseName, imageLocation,new Set.from(rules), baseItem: true);

        }
    }



    static void debugAllInDom(Element element) {
        element.text = "";
        for(RuleSet item in items.values) {
            item.debugInDOM(element);
        }
    }

    void debugInDOM(Element element) {
        ItemBuilder.debugItemInDOM(this, element);
    }
}