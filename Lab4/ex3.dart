class MathOps<T, G> {
  int sub(T obj1, G obj2) {
    final double obiect_1 = convertToDouble(obj1);
    final double obiect_2 = convertToDouble(obj2);
    return (obiect_1 - obiect_2).toInt();
  }

  int prod(T obj1, G obj2) {
    final double obiect_1 = convertToDouble(obj1);
    final double obiect_2 = convertToDouble(obj2);
    return (obiect_1 * obiect_2).toInt();
  }

  int mod(T obj1, G obj2) {
    final double obiect_1 = convertToDouble(obj1);
    final double obiect_2 = convertToDouble(obj2);
    return (obiect_1 % obiect_2).toInt();
  }

  double convertToDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is int) {
      return value.toDouble();
    } else {
      return value as double;
    }
  }
}

void main() {
  final mathOps = MathOps();

  // Example usage
  final int subResult = mathOps.sub(10.5, 3.2);
  final int prodResult = mathOps.prod(5.2, "7.5");
  final int modResult = mathOps.mod("15.5", 4.0);

  print("Diferenta: $subResult");
  print("Inmultire: $prodResult");
  print("Modulo: $modResult");
}
