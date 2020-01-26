import 'dart:html';
import 'scripts/AlchemyResult.dart';
import 'scripts/Game.dart';
import 'scripts/Level.dart';
import 'scripts/RuleSet.dart';
import 'scripts/ItemBuilder.dart';
import 'scripts/Rule.dart';
import 'scripts/Team.dart';
import 'scripts/Tester.dart';

int levelAlg = 5;
dynamic lastChoice;

void main() async {
  if(Uri.base.queryParameters['levelAlg'] !=null) {
    levelAlg = int.parse(Uri.base.queryParameters['levelAlg']);
  }

  wireUpTestControls();
  realGame();

}

void wireUpTestControls() {
  Element controls = querySelector("#controls");
  setLevelGenAlg();
  ButtonElement build = new ButtonElement()..text = "Build Items"..onClick.listen((Event e)=> buildItems());
  ButtonElement view = new ButtonElement()..text = "View Items"..onClick.listen((Event e)=> debugAll());
  ButtonElement game = new ButtonElement()..text = "Play GameTest"..onClick.listen((Event e)=> gameTest());
  ButtonElement owl = new ButtonElement()..text = "Owl Test"..onClick.listen((Event e)=> owlTest());
  ButtonElement level = new ButtonElement()..text = "Level Test"..onClick.listen((Event e)=> levelTest());
  ButtonElement real = new ButtonElement()..text = "Real GAme"..onClick.listen((Event e)=> realGame());

  controls.append(build);
  controls.append(view);
  controls.append(game);
  controls.append(owl);
  controls.append(level);

  controls.append(real);



}

void reset() async {
  await Team.loadFrames();
  await Rule.slurpRules();
  await RuleSet.slurpItems();
  await Level.initLevels(levelAlg);
}


void buildItems() async{
  lastChoice = buildItems;
  await reset();
  ItemBuilder.go(querySelector("#output"));
}

void owlTest() async{
  lastChoice = owlTest;
  await reset();
  Level.debugAllInDomOwl(querySelector("#output"));
}

void levelTest() async{
  lastChoice = levelTest;
  await reset();
  Level.debugAllInDom(querySelector("#output"));


}

void setLevelGenAlg() {
  DivElement algSelector = new DivElement()..text = "Level Algorithm:";
  SelectElement select = new SelectElement();
  algSelector.append(select);
  querySelector("#controls").append(algSelector);
  for(int i = 0; i<6; i++) {
    OptionElement option = new OptionElement(value: i.toString(), selected: i==levelAlg)..text =i.toString();
    select.append(option);
  }
  select.onChange.listen((Event e) {
    //reset the levels based on the new alg, rerender your last choice
    levelAlg = int.parse(select.selectedOptions.first.value);
    reset();
    lastChoice();
  });
}


void debugAll() async{
  lastChoice = debugAll;
  await reset();
  RuleSet.debugAllInDom(querySelector("#output"));
}

void gameTest() async {
  lastChoice = gameTest;
  await reset();
  Tester.testDropDown(querySelector("#output"));
}

void realGame() async {
  lastChoice = realGame;
  await reset();
  Game game = new Game();
  game.start(querySelector("#output"));
}



