import 'RuleSet.dart';
import 'package:CommonLib/Random.dart';
import 'AlchemyResult.dart';
import 'Level.dart';
import 'RuleSet.dart';
class Level {
    RuleSet team1;
    RuleSet team2;
    List<RuleSet> items = new List<RuleSet>();

    Level(String itemName, this.team1, this.team2, this.items) {
        team1.baseName = itemName;
        team2.baseName = itemName;
    }

    static Level makeLevelAroundObject(RuleSet item, int seed) {
        Random rand = new Random(seed);
        List<RuleSet> possibleItems = new List.from(RuleSet.items);
        possibleItems.remove(item);
        RuleSet secondItem = rand.pickFrom(possibleItems);
        possibleItems.remove(secondItem);
        RuleSet thirdItem = rand.pickFrom(possibleItems);
        possibleItems.remove(thirdItem);
        RuleSet fourthItem = rand.pickFrom(possibleItems);
        possibleItems.remove(fourthItem);

        AlchemyResult resultOR = new AlchemyResultAND(<RuleSet>[item,secondItem])..result;
        AlchemyResult resultOR2 = new AlchemyResultAND(<RuleSet>[secondItem,item])..result;

        AlchemyResult final1 = new AlchemyResultAND(<RuleSet>[resultOR.result,thirdItem]);
        AlchemyResult final2 = new AlchemyResultAND(<RuleSet>[resultOR2.result, fourthItem]);
        List<RuleSet> items = <RuleSet>[item, secondItem, thirdItem, fourthItem];

        for(int i = 0; i<4; i++) {
            if(possibleItems.isNotEmpty) {
                RuleSet pick = rand.pickFrom(possibleItems);
                possibleItems.remove(pick);
                items.add(pick);
            }
        }
        return new Level(item.baseName,final1.result, final2.result, items);

    }
}