import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'Rule.dart';

class Item {
    static List<Item> items =new List<Item>();
    String baseName;
    bool isCopy;
    //a set is like a list but each thing in it happens exactly one or zero times
    Set<Rule>  rules = new Set<Rule>();
    Iterable<Rule> get permissiveRules => rules.where((Rule a) => (a is PermissiveRule));
    Iterable<Rule> get restrictiveRules => rules.where((Rule a) => (a is RestrictiveRule));

  Item(String this.baseName, Set<Rule> this.rules, {bool this.isCopy}) {
        items.add(this);
  }

    Item copy() {
        return new Item(baseName, new Set<Rule>.from(rules),isCopy:true);
    }

    String  toString() => baseName;

  Map<String, dynamic> toJSON() {
      Map<String, dynamic> json = new Map<String, dynamic>();
      json["baseName"] = baseName;
      json["rules"] = rules.map((Rule rule) =>Rule.rules.indexOf(rule)).toList();
      return json;
  }

  static String allJSON() {
        List<Map<String, dynamic>> list = new List<Map<String, dynamic>>();
        for(Item item in items) {
            list.add(item.toJSON());
        }
        return jsonEncode(list);
  }

    static void slurpItems() async {
        String data = await http.read('/Data/items.json');
        print("data for items is $data");
        var jsonData = jsonDecode(data);
        for(dynamic json in jsonData) {
            String baseName = json["baseName"];
            List<Rule> rules = new List<Rule>();
            for(int id in json["rules"]) {
                rules.add(Rule.rules[id]);
            }
            new Item(baseName, new Set.from(rules));

        }
    }

    int approveOfOtherRuleSet(Item other) {
        int approvalRating = 0;
        for(Rule rule in rules) {
            if(other.rules.contains(rule)) {
                approvalRating ++;
            }
        }
        return approvalRating;
    }

    static void debugAllInDom(Element element) {
        for(Item item in items) {
            item.debugInDOM(element);
        }
    }

    void debugInDOM(Element element) {
        DivElement div = new DivElement()
            ..text = baseName
            ..style.border="1px solid black";

        int i = 0;
        for(Rule rule in rules) {
            i++;
            div.append(new DivElement()..text = "$i: ${rule.applyObjectToPhraseDebug(baseName)}");
        }

        element.append(div);
    }
}