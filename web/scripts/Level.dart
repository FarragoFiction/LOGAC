import 'dart:html';

import 'Rule.dart';
import 'RuleSet.dart';
import 'package:CommonLib/Random.dart';
import 'AlchemyResult.dart';
import 'Level.dart';
import 'RuleSet.dart';
import 'Team.dart';
class Level {
    static List<Level> levels = new List<Level>();
    Team team1;
    Team team2;
    RuleSet currentSuggestion;
    List<RuleSet> items = new List<RuleSet>();

    Level(String itemName, this.team1, this.team2, this.items) {
        levels.add(this);
        team1.ruleSet.baseName = itemName;
        team2.ruleSet.baseName = itemName;
        //they at least need to believe they are playing the same game
        team2.ruleSet.imageLocation = team1.ruleSet.imageLocation;
    }

    bool suggestRuleset(RuleSet suggestion) {
        currentSuggestion = suggestion;
        currentSuggestion.baseName = team1.ruleSet.baseName;
        bool firstTeamApproves = team1.approveOfOtherRuleSet(currentSuggestion);
        bool secondTeamApproves = team2.approveOfOtherRuleSet(currentSuggestion);
        return firstTeamApproves && secondTeamApproves;
    }

    //TODO possibly make this data instead
    static initLevels() {
        print("initializing levels");
        levels.clear();
        List<String> levelNames = <String>["Basketball","Baseball","Soccer","Skateboard","Tennis","Pool"];
        int i = 0;
        for(String name in levelNames) {
            i++;
            RuleSet set = RuleSet.items[name];
            makeLevelAroundObject(set,i);
        }
    }

    static Level makeLevelAroundObject(RuleSet item, int seed) {
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

        AlchemyResult result = new AlchemyResultAND(<RuleSet>[item,secondItem])..result;
        AlchemyResult result2 = new AlchemyResultAND(<RuleSet>[secondItem,item])..result;

        AlchemyResult final1 = new AlchemyResultAND(<RuleSet>[result.result,thirdItem]);
        AlchemyResult final2 = new AlchemyResultAND(<RuleSet>[result2.result, fourthItem]);

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
        Team team1 = new Team("Team1",final1.result, Team.randomPalette);
        Team team2 = new Team("Team2", final2.result,Team.randomPalette);
        return new Level(item.baseName,team1, team2, items);

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
       if(final1.result.rules.length < 8) {
           throw "WTF? I thought we fixed this, rules are ${final1.result.rules.length}";
       }
    }

    static void debugAllInDom(Element output) {
        output.text = "";
        for(final Level level in Level.levels) {
            level.team1.debugInDom(output);
            level.team2.debugInDom(output);
        }
    }
}