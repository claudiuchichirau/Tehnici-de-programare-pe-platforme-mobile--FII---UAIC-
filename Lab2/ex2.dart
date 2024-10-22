int calculateScore(Map<String, int> letterNumbers, String word) {
  int score = 0;

  for (int i = 0; i < word.length; i++) {
    score += letterNumbers[word[i]] as int;
  }

  return score;
}

void main(List<String> arguments) {
  Map<String, int> letterNumbers = {};
  String word = '';

  for (int i = 0; i < arguments.length; i += 2) {
    if (i + 1 < arguments.length) {
      letterNumbers[arguments[i]] = int.parse(arguments[i + 1]);
    } else {
      word = arguments[i];
    }
  }

  int score = calculateScore(letterNumbers, word);

  print('Score: $score');
}