import 'dart:html';
import 'scripts/AlchemyResult.dart';
import 'scripts/Game.dart';
import 'scripts/Level.dart';
import 'scripts/RuleSet.dart';
import 'scripts/ItemBuilder.dart';
import 'scripts/Rule.dart';
import 'scripts/Tester.dart';

void main() async {
  Game game = new Game();
  //game.display(querySelector("#output"));
  wireUpTestControls();
  debugAll();

}

void wireUpTestControls() {
  Element controls = querySelector("#controls");
  ButtonElement build = new ButtonElement()..text = "Build Items"..onClick.listen((Event e)=> buildItems());
  ButtonElement view = new ButtonElement()..text = "View Items"..onClick.listen((Event e)=> debugAll());
  ButtonElement game = new ButtonElement()..text = "Play GameTest"..onClick.listen((Event e)=> gameTest());
  ButtonElement owl = new ButtonElement()..text = "Owl Test"..onClick.listen((Event e)=> owlTest());

  controls.append(build);
  controls.append(view);
  controls.append(game);
  controls.append(owl);



}

void reset() async {
  await Rule.slurpRules();
  await RuleSet.slurpItems();
  await Level.initLevels();
}


void buildItems() async{
  await reset();
  ItemBuilder.go(querySelector("#output"));
}

void owlTest() async{
  await reset();
  querySelector("#output")..text="todo";
}


void debugAll() async{
  await reset();
  RuleSet.debugAllInDom(querySelector("#output"));
}

void gameTest() async {
  await reset();
  Tester.testDropDown(querySelector("#output"));
}



