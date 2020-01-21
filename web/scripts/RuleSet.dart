import 'dart:convert';
import 'dart:html';
import 'package:CommonLib/Random.dart';
import 'package:http/http.dart' as http;
import 'ItemBuilder.dart';
import 'Rule.dart';

class RuleSet {
    static Map<String,RuleSet> items =new Map<String,RuleSet>();
    String baseName;
    String imageLocation;
    //baes items go into the item pile
    bool baseItem;
    bool isCopy;
    //a set is like a list but each thing in it happens exactly one or zero times
    Set<Rule>  rules = new Set<Rule>();
    Iterable<Rule> get permissiveRules => rules.where((Rule a) => (a is PermissiveRule));
    Iterable<Rule> get restrictiveRules => rules.where((Rule a) => (a is RestrictiveRule));

  RuleSet(String this.baseName, String this.imageLocation,Set<Rule> this.rules, {bool this.isCopy, bool this.baseItem=false}) {
      if(this.rules == null) {
          randomRules();
      }
        if(baseItem) items[baseName] =this;
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

    RuleSet copy() {
        return new RuleSet(baseName, imageLocation,new Set<Rule>.from(rules),isCopy:true);
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
        String data = await http.read('/Data/items.json');
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

    bool approveOfOtherRuleSet(RuleSet other) {
        int approvalRating = 0;
        for(Rule rule in rules) {
            if(other.rules.contains(rule)) {
                approvalRating ++;
            }
        }
        print("$baseName's approval rating for this ruleset ${other.baseName} is $approvalRating");
        return approvalRating>=4;
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