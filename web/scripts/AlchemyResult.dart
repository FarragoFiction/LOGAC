

import 'Item.dart';
import 'Rule.dart';

abstract class AlchemyResult {
    //no matter what, it's the first item that gets shit shoved into it and all other items that are removed
    //in sim, assume only two items at a time. but can support anding 3 or more things at a time
    List<Item> items;
    Item result;

    AlchemyResult(List<Item> this.items) {
        combine();
    }




    void combine();

}

class AlchemyResultAND extends AlchemyResult {
    AlchemyResultAND(List<Item> items) : super(items);

    ///AND takes both functionality and appearance from both things.
    ///TODO if this is OP (i.e. OR is never selected) then take every other trait from both.
    @override
    void combine() {
        result = items[0].copy();
        //
        //skip first item
        for(int i = 1; i<items.length; i++) {
            Item item = items[i];
            //
            for(Rule t in item.rules) {
                //
                result.rules.add(t); //will handle not allowing duplicates.
            }
        }
    }

}

class AlchemyResultOR extends AlchemyResult {
    AlchemyResultOR(List<Item> items) : super(items);

    ///OR takes  functionality from first and appearance from second. ignores all other items.
    @override
    void combine() {
        result = items[0].copy();
        result.rules.clear();

        for(Rule t in items[0].permissiveRules) {
            result.traits.add(t); //will handle not allowing duplicates.
        }

        for(Rule t in items[1].restrictiveRules) {
            result.rules.add(t); //will handle not allowing duplicates.
        }

    }
}


//spoken only of in legend, but totally fucking theoretically possible
class AlchemyResultXOR extends AlchemyResult {
    AlchemyResultXOR(List<Item> items) : super(items);

    //XOR is where you have traits ONLY if they only show up in one place, not two.
    @override
    void combine() {
        result = items[0].copy();
        //all the things first item has that second doesn't
        result.traits = items[0].traits.difference(items[1].traits);
        //and vice versa
        result.traits.addAll( items[1].traits.difference(items[0].traits));
    }
}
