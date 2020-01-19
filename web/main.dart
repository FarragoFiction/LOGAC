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
  //test();
}

void test() {
  DivElement output = querySelector("#output");
  List<Rule> ruleSet1 = new List<Rule>();
  ruleSet1.add(new PermissiveRule("you can jump"));
  ruleSet1.add(new PermissiveRule("you can throw the object"));
  ruleSet1.add(new PermissiveRule("you can bounce the object"));
  ruleSet1.add(new PermissiveRule("you can take the object from others"));
  ruleSet1.add(new RestrictiveRule("you can't move while you have the object"));
  ruleSet1.add(new RestrictiveRule("you can't fight"));
  ruleSet1.add(new RestrictiveRule("you can't throw the object at your own side "));
  ruleSet1.add(new RestrictiveRule("you can't leave the field"));


  List<Rule> ruleSet2 = new List<Rule>();
  ruleSet2.add(new PermissiveRule("you can eat the object"));
  ruleSet2.add(new PermissiveRule("you can throw the object"));
  ruleSet2.add(new PermissiveRule("you can cut the object"));
  ruleSet2.add(new PermissiveRule("you can light fires on the object"));
  ruleSet2.add(new RestrictiveRule("you can't steal the object"));
  ruleSet2.add(new RestrictiveRule("you cannot have 40 of the object"));
  ruleSet2.add(new RestrictiveRule("you cannot bounce the object"));
  ruleSet2.add(new RestrictiveRule("you cannot wash the object"));

  List<Rule> ruleSet3 = new List<Rule>();
  ruleSet3.add(new PermissiveRule("you can draw up to 7 of the object"));
  ruleSet3.add(new PermissiveRule("you win when your opponent's object is dead"));
  ruleSet3.add(new PermissiveRule("you can have up to three objects in play"));
  ruleSet3.add(new PermissiveRule("you must tap the object to play it"));
  ruleSet3.add(new RestrictiveRule("you can't interact with your opponents object directly"));
  ruleSet3.add(new RestrictiveRule("you can't break an egg before its ready"));
  ruleSet3.add(new RestrictiveRule("you lose points if you don't care for your object"));
  ruleSet3.add(new RestrictiveRule("you cannot ignore the object"));

  List<Rule> ruleSet4 = new List<Rule>();
  ruleSet4.add(new PermissiveRule("you can water the object three times a week"));
  ruleSet4.add(new PermissiveRule("you can harvest the object at the end of the season"));
  ruleSet4.add(new PermissiveRule("you can eat the object"));
  ruleSet4.add(new PermissiveRule("you can cut the object"));
  ruleSet4.add(new RestrictiveRule("you can't steal the object"));
  ruleSet4.add(new RestrictiveRule("you cannot ignore the object"));
  ruleSet4.add(new RestrictiveRule("you cannot bounce the object"));
  ruleSet4.add(new RestrictiveRule("you cannot burn the object"));


  Item first = new Item("Basketball", new Set.from(ruleSet1));
  Item second = new Item("Cake", new Set.from(ruleSet2));
  Item third = new Item("Fiduspawn Cards", new Set.from(ruleSet3));
  Item fourth = new Item("Carrot", new Set.from(ruleSet4));
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


