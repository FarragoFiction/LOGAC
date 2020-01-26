import 'dart:html';

import 'AlchemyResult.dart';
import 'Level.dart';
import 'RuleSet.dart';

abstract class Tester {

    static void testDropDown(Element output){
        output.text = "";
        DivElement levelShit = new DivElement();
        final SelectElement selectLevel = new SelectElement();
        output.append(selectLevel);
        output.append(levelShit);
        for(int i = 0; i< Level.levels.length; i++) {
            Level level = Level.levels[i];
            OptionElement option = new OptionElement(value: i.toString())..text="${level.team1.ruleSet.baseName}";
            selectLevel.append(option);
        }

        selectLevel.onChange.listen((Event e) {
            Level first = Level.levels[int.parse(selectLevel.selectedOptions.first.value)];
            testLevel(first,levelShit);
        });
        testLevel(Level.levels.first, levelShit);

    }

    static void testLevel(Level level, Element output) {
        output.text = "";
        //display the two teams, display a drop down of items, display three buttons for alchemy, then display result
        DivElement team1 = new DivElement()..style.display= "inline-block"..style.border="1px solid black";
        output.append(team1);
        team1.append(level.team1.owls.first.sprite);
        level.team1.ruleSet.debugInDOM(team1);
        DivElement team2 = new DivElement()..style.display= "inline-block"..style.border="1px solid black";
        output.append(team2);
        team2.append(level.team2.owls.first.sprite);
        level.team2.ruleSet.debugInDOM(team2);

        DivElement firstItem = new DivElement()..text = "First Item"..style.display="inline-block";;
        output.append(firstItem);
        SelectElement firstChoice = new SelectElement();
        DivElement preview = new DivElement();
        level.items.first.debugInDOM(preview);

        for(RuleSet item in level.items) {
            OptionElement option = new OptionElement(value: item.baseName)..text="${item.baseName}";
            firstChoice.append(option);
        }
        firstItem.append(firstChoice);
        firstItem.append(preview);

        firstChoice.onChange.listen((Event e) {
            RuleSet first = RuleSet.items[firstChoice.selectedOptions.first.value];
            preview.text = "";
            first.debugInDOM(preview);

        });
        DivElement secondItem = new DivElement()..text = "Second Item"..style.display="inline-block";
        output.append(secondItem);
        SelectElement secondChoice = new SelectElement();
        DivElement preview2 = new DivElement();
        level.items.first.debugInDOM(preview2);

        for(RuleSet item in level.items) {
            OptionElement option = new OptionElement(value: item.baseName)..text="${item.baseName}";
            secondChoice.append(option);
        }
        secondItem.append(secondChoice);
        secondItem.append(preview2);
        secondChoice.onChange.listen((Event e) {
            RuleSet first = RuleSet.items[secondChoice.selectedOptions.first.value];
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
            RuleSet first = RuleSet.items[(firstChoice.selectedOptions.first.value)];
            RuleSet second = RuleSet.items[secondChoice.selectedOptions.first.value];

            AlchemyResult result = new AlchemyResultAND(<RuleSet>[first,second]);
            level.suggestRuleset(result.result);
            result.result.debugInDOM(results);
            teamsJudgement(results,level, result.result);
        });

        or.onClick.listen((Event e) {
            results.text = "Proposed Ruleset:";
            RuleSet first = RuleSet.items[firstChoice.selectedOptions.first.value];
            RuleSet second = RuleSet.items[secondChoice.selectedOptions.first.value];

            AlchemyResult result = new AlchemyResultOR(<RuleSet>[first,second]);
            level.suggestRuleset(result.result);
            result.result.debugInDOM(results);
            teamsJudgement(results,level, result.result);
        });

        xor.onClick.listen((Event e) {
            results.text = "Proposed Ruleset:";
            RuleSet first = RuleSet.items[firstChoice.selectedOptions.first.value];
            RuleSet second = RuleSet.items[secondChoice.selectedOptions.first.value];

            AlchemyResult result = new AlchemyResultXOR(<RuleSet>[first,second]);
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