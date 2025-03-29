class Tx {
  String txId;
  double amount;
  String to;
  String from;
  DateTime timestamp;

  Tx(
      {required this.txId,
      required this.amount,
      required this.to,
      required this.from,
      required this.timestamp});
}
