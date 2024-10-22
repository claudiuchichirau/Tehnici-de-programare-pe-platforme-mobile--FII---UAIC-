List<int> unuPlusUnu(numbers) {
    int number = 0;
    int power = 1;
    for (int i = numbers.length-1; i >= 0; i--) {
        number += numbers[i] * power as int;
        power *= 10;
    }

    number += 1;

    List<int> digits_list = [];

    while (number > 0) {
        digits_list.add(number % 10);
        number = (number / 10).floor();
    }

    digits_list = digits_list.reversed.toList();

    return digits_list;
}


void main(List<String> arguments) {
  List<int> numbers = arguments.map(int.parse).toList();
  List<int> digits_list = unuPlusUnu(numbers);
  print('Lista de numere + 1: $digits_list');
}
