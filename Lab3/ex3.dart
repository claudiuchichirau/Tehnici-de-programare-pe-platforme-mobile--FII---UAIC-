class Client {
  final String name;
  double _purchasesAmount;

  Client(this.name) : _purchasesAmount = 0;

  double get purchasesAmount => _purchasesAmount;

  void add(double amount) {
    _purchasesAmount += amount;
  }
}

class LoyalClient extends Client {
  LoyalClient(String name) : super(name);

  double get totalPurchases => super.purchasesAmount;

  void discount() {
    super._purchasesAmount *= 0.9;
  }
}

void main() {
  var client = LoyalClient('John Doe');
  client.add(100.0);
  print('Total purchases before discount: ${client.totalPurchases}');
  client.discount();
  print('Total purchases after 10% discount: ${client.totalPurchases}');
}
