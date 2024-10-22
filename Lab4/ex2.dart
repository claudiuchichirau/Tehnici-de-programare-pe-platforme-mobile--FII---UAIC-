import 'dart:io';

class Stack {
  final String storageFilePath;
  List<String> stackItems = [];

  Stack(this.storageFilePath);

  void push(String item) {
    stackItems.add(item);
    saveToFile();
  }

  // scot elementul din vf stivei
  String pop() {
    if (stackItems.isEmpty) {
      throw Exception("Stiva este goală!");
    }
    final poppedItem = stackItems.removeLast();
    saveToFile();
    return poppedItem;
  }

  void saveToFile() {
    final file = File(storageFilePath);
    file.writeAsStringSync(stackItems.join('\n'));
  }

  // incarc stiva din fisier
  void loadFromFile() {
    final file = File(storageFilePath);
    if (file.existsSync()) {
      stackItems = file.readAsStringSync().split('\n');
    }
  }

  @override
  String toString() {
    return stackItems.reversed.join('\n');
  }
}

void main() {
  final stack = Stack('stack.txt');
  stack.loadFromFile();

  stack.push('Element 1');
  stack.push('Element 2');
  stack.push('Element 3');

  print('Stiva curentă:');
  print(stack);

  final poppedItem = stack.pop();
  print('Elementul scos din stiva: $poppedItem');

  print('Stiva dupa pop:');
  print(stack);
}
