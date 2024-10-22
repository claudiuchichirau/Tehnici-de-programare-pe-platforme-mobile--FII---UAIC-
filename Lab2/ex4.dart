import 'dart:math';

int sumOfDigits(int num) {
  int sum = 0;
  while (num > 0) {
    sum += num % 10;
    num = num ~/ 10;
  }
  return sum;
}

int countGroups(int n) {
  Map<int, int> groups = {};
  for (int i = 1; i <= n; i++) {
    int sum = sumOfDigits(i);
    groups[sum] = (groups[sum] ?? 0) + 1;
  }

  int maxCount = groups.values.reduce(max);

  // Numără câte grupuri au numărul maxim de elemente
  int numMaxGroups = 0;
  for (int count in groups.values) {
    if (count == maxCount) {
      numMaxGroups++;
    }
  }
  return numMaxGroups;
}

void main() {
  int n = 30;
  print(countGroups(n));
}