int goodPairs(List<int> list) {
  int score = 0;

  for (int i = 0; i < list.length; i++) {
    for (int j = i + 1; j < list.length; j++) {
      if (list[i] == list[j] && i != j) {
        score ++;
      }
    }
  }
  
  return score;
}

void main(List<String> arguments) {
  List<int> list = [2, 5, 6, 2, 1, 9, 2, 6, 5, 0];
  int score = goodPairs(list);
  print('Numarul de perechi bune este: $score');
}
