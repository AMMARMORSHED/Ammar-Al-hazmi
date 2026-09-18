class BalanceEntry {
  final String type;
  final double amount;

  const BalanceEntry({required this.type, required this.amount});
}

class BalanceService {
  static double calculateNetBalance(List<BalanceEntry> entries) {
    double receivable = 0;
    double payable = 0;

    for (final entry in entries) {
      if (entry.type == 'receivable' || entry.type == 'received') {
        receivable += entry.amount;
      } else if (entry.type == 'payable' || entry.type == 'paid') {
        payable += entry.amount;
      }
    }

    return receivable - payable;
  }
}
