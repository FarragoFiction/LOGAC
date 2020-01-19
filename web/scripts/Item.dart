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
}