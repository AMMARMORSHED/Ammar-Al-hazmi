import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daftar_alhisabat/domain/services/balance_service.dart';

void main() {
  group('Balance service', () {
    test('receivable minus payable equals net balance', () {
      final result = BalanceService.calculateNetBalance([
        const BalanceEntry(type: 'receivable', amount: 100),
        const BalanceEntry(type: 'payable', amount: 50),
      ]);

      expect(result, 50.0);
    });

    test('partial payment is correctly handled', () {
      final result = BalanceService.calculateNetBalance([
        const BalanceEntry(type: 'receivable', amount: 120),
        const BalanceEntry(type: 'paid', amount: 30),
      ]);

      expect(result, 90.0);
    });
  });
}
