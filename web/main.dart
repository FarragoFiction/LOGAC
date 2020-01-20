import 'dart:html';
import 'scripts/AlchemyResult.dart';
import 'scripts/Game.dart';
import 'scripts/Item.dart';
import 'scripts/ItemBuilder.dart';
import 'scripts/Rule.dart';

void main() async {
  Game game = new Game();
  //game.display(querySelector("#output"));
  await Rule.slurpRules();
  await Item.slurpItems();
  //Item.debugAllInDom(querySelector("#output"));
  ItemBuilder.go(querySelector("#output"));
  test();
}

void test() {
  DivElement output = querySelector("#output");

  Item first = Item.items[0];
  Item second = Item.items[1];
  Item third = Item.items[2];
  Item fourth = Item.items[3];
  first.debugInDOM(output);
  second.debugInDOM(output);
  AlchemyResult resultOR = new AlchemyResultAND(<Item>[first,second])..result;
  AlchemyResult resultOR2 = new AlchemyResultAND(<Item>[second,first])..result;
  AlchemyResult final1 = new AlchemyResultAND(<Item>[resultOR.result, third]);
  AlchemyResult final2 = new AlchemyResultAND(<Item>[resultOR2.result, fourth]);

  final1.result.baseName = "Team1 Basketball";
  final2.result.baseName = "Team2 Basketball";
  final1.result.debugInDOM(output);
  final2.result.debugInDOM(output);

  resultOR.result.baseName = "Fix1";
  resultOR2.result.baseName = "Fix2";

  resultOR.result.debugInDOM(output);
  DivElement judge1 = new DivElement()..text = "Does Team1 approve of ${resultOR.result.baseName}? ${final1.result.approveOfOtherRuleSet(resultOR.result)}";
  DivElement judge2 = new DivElement()..text = "Does Team2 approve of the ${resultOR.result.baseName}? ${final2.result.approveOfOtherRuleSet(resultOR.result)}";
  output.append(judge1);
  output.append(judge2);


  resultOR2.result.debugInDOM(output);
  DivElement judge12 = new DivElement()..text = "Does Team1 approve of ${resultOR2.result.baseName}? ${final1.result.approveOfOtherRuleSet(resultOR2.result)}";
  DivElement judge22 = new DivElement()..text = "Does Team2 approve of the ${resultOR2.result.baseName}? ${final2.result.approveOfOtherRuleSet(resultOR2.result)}";
  output.append(judge12);
  output.append(judge22);


  /*AlchemyResult resultAND = new AlchemyResultAND(<Item>[first,second])..result.debugInDOM(output);
  AlchemyResult resultAND2 = new AlchemyResultAND(<Item>[second,first])..result.debugInDOM(output);

  AlchemyResult resultXOR = new AlchemyResultXOR(<Item>[first,second])..result.debugInDOM(output);
  AlchemyResult resultXOR2 = new AlchemyResultXOR(<Item>[second,first])..result.debugInDOM(output);
  */


}


