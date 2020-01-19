import 'dart:html';

import 'Rule.dart';

class Item {
    String baseName;
    bool isCopy;
    //a set is like a list but each thing in it happens exactly one or zero times
    Set<Rule>  rules = new Set<Rule>();
    Iterable<Rule> get permissiveRules => rules.where((Rule a) => (a is PermissiveRule));
    Iterable<Rule> get restrictiveRules => rules.where((Rule a) => (a is RestrictiveRule));

  Item(String this.baseName, Set<Rule> this.rules, {bool this.isCopy});

    Item copy() {
        return new Item(baseName, new Set<Rule>.from(rules),isCopy:true);
    }

    String  toString() => baseName;

    int approveOfOtherRuleSet(Item other) {
        int approvalRating = 0;
        for(Rule rule in rules) {
            if(other.rules.contains(rule)) {
                approvalRating ++;
            }
        }
        return approvalRating;
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