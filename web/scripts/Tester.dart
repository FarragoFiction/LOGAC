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
        SelectElement ret = new SelectElement();
        print("level items is ${level.items}");
        for(RuleSet item in level.items) {
            print(item);
            OptionElement option = new OptionElement(value: RuleSet.items.indexOf(item).toString())..text="${item.baseName}";
            ret.append(option);
        }
        firstItem.append(ret);
        DivElement secondItem = new DivElement()..text = "Second Item";
        output.append(secondItem);
        SelectElement ret2 = new SelectElement();
        for(RuleSet item in level.items) {
            OptionElement option = new OptionElement(value: RuleSet.items.indexOf(item).toString())..text="${item.baseName}";
            ret2.append(option);
        }
        secondItem.append(ret2);



        /*DivElement judge12 = new DivElement()..text = "Does Team1 approve of ${resultOR2.result.baseName}? ${final1.result.approveOfOtherRuleSet(resultOR2.result)}";
  DivElement judge22 = new DivElement()..text = "Does Team2 approve of the ${resultOR2.result.baseName}? ${final2.result.approveOfOtherRuleSet(resultOR2.result)}";
  output.append(judge12);
  output.append(judge22);
  */

    }
}