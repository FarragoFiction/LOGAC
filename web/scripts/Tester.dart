import 'dart:html';

import 'AlchemyResult.dart';
import 'Level.dart';
import 'RuleSet.dart';

abstract class Tester {

    static void testDropDown(){
        DivElement output = querySelector("#output");

        Level level = Level.makeLevelAroundObject(RuleSet.items.first,0);
        //display the two teams, display a drop down of items, display three buttons for alchemy, then display result
        level.team1.debugInDOM(output);
        level.team2.debugInDOM(output);

        DivElement firstItem = new DivElement()..text = "First Item";
        output.append(firstItem);
        SelectElement firstChoice = new SelectElement();
        DivElement preview = new DivElement();
        level.items.first.debugInDOM(preview);

        print("level items is ${level.items}");
        for(RuleSet item in level.items) {
            print(item);
            OptionElement option = new OptionElement(value: RuleSet.items.indexOf(item).toString())..text="${item.baseName}";
            firstChoice.append(option);
        }
        firstItem.append(firstChoice);
        firstItem.append(preview);

        firstChoice.onChange.listen((Event e) {
            RuleSet first = RuleSet.items[int.parse(firstChoice.selectedOptions.first.value)];
            preview.text = "";
            first.debugInDOM(preview);

        });
        DivElement secondItem = new DivElement()..text = "Second Item";
        output.append(secondItem);
        SelectElement secondChoice = new SelectElement();
        DivElement preview2 = new DivElement();
        level.items.first.debugInDOM(preview2);

        for(RuleSet item in level.items) {
            OptionElement option = new OptionElement(value: RuleSet.items.indexOf(item).toString())..text="${item.baseName}";
            secondChoice.append(option);
        }
        secondItem.append(secondChoice);
        secondItem.append(preview2);
        secondChoice.onChange.listen((Event e) {
            RuleSet first = RuleSet.items[int.parse(secondChoice.selectedOptions.first.value)];
            preview2.text = "";
            first.debugInDOM(preview2);

        });

        ButtonElement and = new ButtonElement()..text = "AND";
        ButtonElement or = new ButtonElement()..text = "OR";
        ButtonElement xor = new ButtonElement()..text = "XOR";
        output.append(and);
        output.append(or);
        output.append(xor);
        DivElement results = new DivElement()..text = "Proposed Ruleset:";
        output.append(results);

        and.onClick.listen((Event e) {
            results.text = "Proposed Ruleset:";
            RuleSet first = RuleSet.items[int.parse(firstChoice.selectedOptions.first.value)];
            RuleSet second = RuleSet.items[int.parse(secondChoice.selectedOptions.first.value)];

            AlchemyResult result = new AlchemyResultAND(<RuleSet>[first,second]);
            level.suggestRuleset(result.result);
            result.result.debugInDOM(results);
            teamsJudgement(results,level, result.result);
        });

        or.onClick.listen((Event e) {
            results.text = "Proposed Ruleset:";
            RuleSet first = RuleSet.items[int.parse(firstChoice.selectedOptions.first.value)];
            RuleSet second = RuleSet.items[int.parse(secondChoice.selectedOptions.first.value)];

            AlchemyResult result = new AlchemyResultOR(<RuleSet>[first,second]);
            level.suggestRuleset(result.result);
            result.result.debugInDOM(results);
            teamsJudgement(results,level, result.result);
        });

        xor.onClick.listen((Event e) {
            results.text = "Proposed Ruleset:";
            RuleSet first = RuleSet.items[int.parse(firstChoice.selectedOptions.first.value)];
            RuleSet second = RuleSet.items[int.parse(secondChoice.selectedOptions.first.value)];

            AlchemyResult result = new AlchemyResultAND(<RuleSet>[first,second]);
            level.suggestRuleset(result.result);
            result.result.debugInDOM(results);
            teamsJudgement(results,level, result.result);
        });


    }

    static void teamsJudgement(Element element, Level level, RuleSet proposedRuleset) {
        bool firstTeamApproves = level.team1.approveOfOtherRuleSet(proposedRuleset);
        bool secondTeamApproves = level.team2.approveOfOtherRuleSet(proposedRuleset);
        DivElement judgement = new DivElement()..text = "Team1: ${firstTeamApproves?'Approves':'Riots'}, Team2: ${secondTeamApproves?'Approves':'Riots'}.  ${(level.suggestRuleset(proposedRuleset))?'Victory!!!':'Try Again'}";
        element.append(judgement);
    }
}