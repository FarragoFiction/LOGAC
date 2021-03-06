

import 'package:CommonLib/Random.dart';

import 'RuleSet.dart';
import 'Rule.dart';

abstract class AlchemyResult {
    //no matter what, it's the first item that gets shit shoved into it and all other items that are removed
    //in sim, assume only two items at a time. but can support anding 3 or more things at a time
    List<RuleSet> items;
    RuleSet result;

    AlchemyResult(List<RuleSet> this.items) {
        combine();
        capAt8();
    }

    void capAt8() {
        //8 is the arc number here
        if(result.rules.length > 8) {
            List<Rule> listRules = result.rules.toList();
            //shuffle it, but the same item will be shuffled the same way each time
            listRules.shuffle(new Random(result.baseName.codeUnitAt(0)));
            listRules.removeRange(8, result.rules.length);
            result.rules = new Set.from(listRules);
        }
    }




    void combine();

}

class AlchemyResultAND extends AlchemyResult {
    AlchemyResultAND(List<RuleSet> items) : super(items);
    @override
    String toString() {
        return "${items[0]} AND ${items[1]}";
    }
    ///AND takes both functionality and appearance from both things.
    @override
    void combine() {
        result = new RuleSet("${items[0]}-${items[1]}",items[0].imageLocation, new Set());
        for(RuleSet item in items) {
            //every other rule
            List<Rule> listRules = item.rules.toList();
            for(int j = 0; j<listRules.length-1; j+=2) {
                result.rules.add(listRules[j]); //will handle not allowing duplicates.
            }
        }

    }

}

class AlchemyResultOR extends AlchemyResult {
    AlchemyResultOR(List<RuleSet> items) : super(items);

    @override
    String toString() {
        return "${items[0]} OR ${items[1]}";
    }

    ///OR takes  functionality from first and appearance from second. ignores all other items.
    @override
    void combine() {
        result = new RuleSet("${items[0]}-${items[1]}",items[0].imageLocation, new Set());
        result.baseName = "${items[0]}-${items[1]}";
        result.rules.clear();

        for(Rule t in items[0].permissiveRules) {
            result.rules.add(t); //will handle not allowing duplicates.
        }

        for(Rule t in items[1].restrictiveRules) {
            result.rules.add(t); //will handle not allowing duplicates.
        }

    }
}


//spoken only of in legend, but totally fucking theoretically possible
class AlchemyResultXOR extends AlchemyResult {
    AlchemyResultXOR(List<RuleSet> items) : super(items);
    @override
    String toString() {
        return "${items[0]} XOR ${items[1]}";
    }
    //XOR is where you have traits ONLY if they only show up in one place, not two.
    @override
    void combine() {
        result = new RuleSet("${items[0]}-${items[1]}",items[0].imageLocation, new Set());
        result.baseName = "${items[0]}-${items[1]}";
        //all the things first item has that second doesn't
        result.rules = items[0].rules.difference(items[1].rules);
        //and vice versa
        result.rules.addAll( items[1].rules.difference(items[0].rules));
    }
}
