import 'dart:html';
import 'scripts/AlchemyResult.dart';
import 'scripts/Game.dart';
import 'scripts/RuleSet.dart';
import 'scripts/ItemBuilder.dart';
import 'scripts/Rule.dart';
import 'scripts/Tester.dart';

void main() async {
  Game game = new Game();
  //game.display(querySelector("#output"));
  await Rule.slurpRules();
  await RuleSet.slurpItems();
  //Item.debugAllInDom(querySelector("#output"));
  ItemBuilder.go(querySelector("#output"));
  Tester.testDropDown();
}



