class Queue<T> {
  List<T> list = [];

  void push(T element) {
    list.add(element);
  }

  T pop() {
    if (isEmpty()) {
      throw Exception('Cannot pop from empty queue');
    }
    return list.removeAt(0);
  }

  T back() {
    if (isEmpty()) {
      throw Exception('Queue is empty');
    }
    return list.last;
  }

  T front() {
    if (isEmpty()) {
      throw Exception('Queue is empty');
    }
    return list.first;
  }

  bool isEmpty() {
    if(list.isEmpty)
      return true;
    return false;
  }

  @override
  String toString() {
    return list.toString();
  }
}

void main() {
  final queue = Queue<int>();

  queue.push(1);
  queue.push(2);
  queue.push(3);

  print('\nQueue after pushes: ${queue.toString()}'); // [1, 2, 3]

  print('Front element: ${queue.front()}'); // 1
  print('Back element: ${queue.back()}'); // 3

  print('Pop element: ${queue.pop()}'); // 1
  print('Queue after pop: ${queue.toString()}'); // [2, 3]

  print('Queue is empty: ${queue.isEmpty()}'); // False
}
