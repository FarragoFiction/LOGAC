import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Colours.dart';

import 'Rule.dart';
import 'RuleSet.dart';
import 'package:CommonLib/Random.dart';
import 'AlchemyResult.dart';
import 'Level.dart';
import 'RuleSet.dart';
import 'Team.dart';
class Level {
    static List<Level> levels = new List<Level>();

    Colour color;


    Team team1;
    Team team2;
    String get name => team1.ruleSet.baseName;
    int alg;
    RuleSet currentSuggestion;
    List<RuleSet> items = new List<RuleSet>();

    Level(String itemName, this.team1, this.team2, this.items, int this.alg, this.color) {
        levels.add(this);
        team1.ruleSet.baseName = itemName;
        team2.ruleSet.baseName = itemName;
        //they at least need to believe they are playing the same game
        team2.ruleSet.imageLocation = team1.ruleSet.imageLocation;
    }

    void clearResult() {
        team1.clearResult();
        team2.clearResult();
    }

    bool suggestRuleset(RuleSet suggestion) {
        currentSuggestion = suggestion;
        currentSuggestion.baseName = team1.ruleSet.baseName;
        bool firstTeamApproves = team1.approveOfOtherRuleSet(currentSuggestion);
        bool secondTeamApproves = team2.approveOfOtherRuleSet(currentSuggestion);
        return firstTeamApproves && secondTeamApproves;
    }

    //TODO possibly make this data instead
    static initLevels(int algorithm) {
        print("initializing levels");
        levels.clear();
        final List<String> levelNames = <String>["Basketball","Baseball","Soccer","Skateboard","Tennis","Pool","Poker Hand", "Horse"];
        final List<String> colors = <String>["#61c1b3","#5571ff","#54aad2","#87b358","#cdbb68","#743b89","#e6914c", "#a63f31"];

        int i = 0;
        for(String name in levelNames) {
            i++;
            RuleSet set = RuleSet.items[name];
            makeLevelAroundObject(set,i, algorithm, new Colour.fromStyleString(colors[i-1]));
        }
    }

    //AND AND AND AND is fully solvable, so is OR OR AND AND, AND OR AND AND, AND XOR AND AND
    static List<dynamic> getFinalRulesets(int seed, RuleSet item, RuleSet secondItem, RuleSet thirdItem, RuleSet fourthItem, int algNumber) {
        if(algNumber > 4) {
            algNumber = seed%4; //makes it fair, not random
        }

        if(algNumber == 0) {
            return alg1(item, secondItem, thirdItem, fourthItem, algNumber);
        }else if(algNumber == 1) {
            return alg2(item, secondItem, thirdItem, fourthItem, algNumber);
        }else if(algNumber == 2) {
            return alg3(item, secondItem, thirdItem, fourthItem, algNumber);
        }else if(algNumber == 3){
            return alg4(item, secondItem, thirdItem, fourthItem, algNumber);
        }else if(algNumber == 4){
            return algFail(item, secondItem, thirdItem, fourthItem, algNumber);
        }
    }

    static List<dynamic> alg1(RuleSet item, RuleSet secondItem, RuleSet thirdItem, RuleSet fourthItem, int algNumber) {
        AlchemyResult result = new AlchemyResultAND(<RuleSet>[item,secondItem])..result;
        AlchemyResult result2 = new AlchemyResultAND(<RuleSet>[secondItem,item])..result;

        AlchemyResult final1 = new AlchemyResultAND(<RuleSet>[result.result,thirdItem]);
        AlchemyResult final2 = new AlchemyResultAND(<RuleSet>[result2.result, fourthItem]);
        return[final1, final2, algNumber];
    }

    static List<dynamic> alg2(RuleSet item, RuleSet secondItem, RuleSet thirdItem, RuleSet fourthItem, int algNumber) {
        AlchemyResult result = new AlchemyResultOR(<RuleSet>[item,secondItem])..result;
        AlchemyResult result2 = new AlchemyResultOR(<RuleSet>[secondItem,item])..result;

        AlchemyResult final1 = new AlchemyResultAND(<RuleSet>[result.result,thirdItem]);
        AlchemyResult final2 = new AlchemyResultAND(<RuleSet>[result2.result, fourthItem]);
        return[final1, final2, algNumber];
    }

    static List<dynamic> alg3(RuleSet item, RuleSet secondItem, RuleSet thirdItem, RuleSet fourthItem, int algNumber) {
        AlchemyResult result = new AlchemyResultAND(<RuleSet>[item,secondItem])..result;
        AlchemyResult result2 = new AlchemyResultOR(<RuleSet>[secondItem,item])..result;

        AlchemyResult final1 = new AlchemyResultAND(<RuleSet>[result.result,thirdItem]);
        AlchemyResult final2 = new AlchemyResultAND(<RuleSet>[result2.result, fourthItem]);
        return[final1, final2, algNumber];
    }

    static List<dynamic> alg4(RuleSet item, RuleSet secondItem, RuleSet thirdItem, RuleSet fourthItem, int algNumber) {
        AlchemyResult result = new AlchemyResultAND(<RuleSet>[item,secondItem])..result;
        AlchemyResult result2 = new AlchemyResultXOR(<RuleSet>[secondItem,item])..result;

        AlchemyResult final1 = new AlchemyResultAND(<RuleSet>[result.result,thirdItem]);
        AlchemyResult final2 = new AlchemyResultAND(<RuleSet>[result2.result, fourthItem]);
        return[final1, final2, algNumber];
    }

    static List<dynamic> algFail(RuleSet item, RuleSet secondItem, RuleSet thirdItem, RuleSet fourthItem, int algNumber) {
        AlchemyResult result = new AlchemyResultXOR(<RuleSet>[item,item])..result;
        AlchemyResult result2 = new AlchemyResultXOR(<RuleSet>[secondItem,secondItem])..result;

        AlchemyResult final1 = new AlchemyResultXOR(<RuleSet>[result.result,result.result]);
        AlchemyResult final2 = new AlchemyResultXOR(<RuleSet>[result2.result, result2.result]);
        final1.result.rules.add(new RestrictiveRule("You lose."));
        final2.result.rules.add(new RestrictiveRule("You lose."));

        return[final1, final2, algNumber];
    }


    static Level makeLevelAroundObject(RuleSet item, int seed, int algorithm, Colour color) {
        print("making level around item $item");
        Random rand = new Random(seed);
        List<RuleSet> possibleItems = new List<RuleSet>.from(RuleSet.items.values);
        possibleItems.remove(item);
        RuleSet secondItem = rand.pickFrom(possibleItems);
        possibleItems.remove(secondItem);
        RuleSet thirdItem = rand.pickFrom(possibleItems);
        possibleItems.remove(thirdItem);
        RuleSet fourthItem = rand.pickFrom(possibleItems);
        possibleItems.remove(fourthItem);
        //lets it be mix and match as needed
        List<dynamic> finals =  getFinalRulesets(seed,item, secondItem, thirdItem, fourthItem, algorithm);
        AlchemyResult final1 = finals[0];
        AlchemyResult final2 = finals[1];
        algorithm = finals[2];

        if(final1.result.rules.length <8) {
            augmentRules(final1, final2);
        }

        if(final2.result.rules.length<8) {
            augmentRules(final2, final1);
        }

        List<RuleSet> items = <RuleSet>[item, secondItem, thirdItem, fourthItem];

        for(int i = 0; i<4; i++) {
            if(possibleItems.isNotEmpty) {
                RuleSet pick = rand.pickFrom(possibleItems);
                possibleItems.remove(pick);
                items.add(pick);
            }
        }
        Team team1 = new Team("Team1",final1.result, Team.randomPalette(rand.nextInt()), true);
        Team team2 = new Team("Team2", final2.result,Team.randomPalette(rand.nextInt()),false);
        return new Level(item.baseName,team1, team2, items, algorithm,color);

    }

    static void augmentRules(AlchemyResult final1, AlchemyResult final2) {
       Random rand = new Random(13); //its less important that its literally random, just consistent and i don't wanna always pick the first one
       //don't just add a rule that you already have
      Set<Rule> diff = final2.result.rules.difference(final1.result.rules);
      final int rulesNeeded = 8-final1.result.rules.length;
      for(int i = 0; i< rulesNeeded; i++) {
          Rule choice = rand.pickFrom(diff);
          final1.result.rules.add(choice);
      }
    }

    void debugInDom(Element output){
        DivElement me = new DivElement()..style.border="1px solid black";
        output.append(me);
        DivElement label = new DivElement()..text = "Sport: ${team1.ruleSet.baseName}";
        me.append(label);
        DivElement itemList = new DivElement()..text = "Items: ${items.join(",")}";
        me.append(itemList);
        DivElement beatableValue = new DivElement()..text = "Beatable: ???";
        me.append(beatableValue);
        checkBeatableDebug(beatableValue);
    }

    Future<void> checkBeatableDebug(Element element) async {
        //bool result = await beatable();
        new Timer(new Duration(milliseconds: 1000), () async {
            bool result =  await beatable();
            element.text = "Beatable: $result";
            element.style.backgroundColor = result ? "green":"red";
        });


    }

    static void debugAllInDom(Element output) {
        output.text = "";
        for(final Level level in Level.levels) {
            level.debugInDom(output);
        }
    }

    static void debugAllInDomOwl(Element output) {
        output.text = "";
        for(final Level level in Level.levels) {
            level.team1.debugInDom(output);
            level.team2.debugInDom(output);
        }
    }

    //might take a chunk of time
    Future<bool> beatable() async {
        print("Is level ${team1.ruleSet.baseName} beatable?");
        bool beaten = false;
        for(RuleSet item1 in items) {
            for(RuleSet item2 in items) {
                if(item1 != item2) {
                    List<AlchemyResult> results = <AlchemyResult>[];
                    results.add(new AlchemyResultAND(<RuleSet>[item1, item2]));
                    results.add(new AlchemyResultOR(<RuleSet>[item1, item2]));
                    results.add(new AlchemyResultXOR(<RuleSet>[item1, item2]));
                    results.add(new AlchemyResultAND(<RuleSet>[item2, item1]));
                    results.add(new AlchemyResultOR(<RuleSet>[item2, item1]));
                    results.add(new AlchemyResultXOR(<RuleSet>[item2, item1]));
                    for(AlchemyResult result in results) {
                        if(suggestRuleset(result.result)) {
                            beaten = true;
                            break;
                        }else {
                            print("$item1 and $item2 can not be combined to win");
                        }
                    }
                }
            }
            if(beaten) break;
        }
        return beaten;
    }
}