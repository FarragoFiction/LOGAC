abstract class Rule {
    static const String  OBJECTKEY = "object";
    //index position is id
    static List<Rule> rules = new List<Rule>();
    //i.e. "you may eat the object"
    String _phrase;

    Rule(this._phrase) {
        rules.add(this);
    }

    String toString() {
        return _phrase;
    }

    String applyObjectToPhrase(String item) {
        return _phrase.replaceAll("object", item);
    }

    String applyObjectToPhraseDebug(String item);
}

class PermissiveRule extends Rule {
  PermissiveRule(String phrase) : super(phrase);
    String toString() {
        return "PermissiveRule: $_phrase";
    }

  String applyObjectToPhraseDebug(String item) {
      print("applying $item");
      return "$PermissiveRule: ${_phrase.replaceAll('${Rule.OBJECTKEY}','$item')}";
  }
}

class RestrictiveRule extends Rule{
  RestrictiveRule(String phrase) : super(phrase);
    String toString() {
        return "RestrictiveRule: $_phrase";
    }

  String applyObjectToPhraseDebug(String item) {
        print("applying $item");
      return "$RestrictiveRule: ${_phrase.replaceAll('${Rule.OBJECTKEY}','$item')}";
  }
}