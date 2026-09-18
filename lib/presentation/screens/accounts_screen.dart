import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      body: state.persons.isEmpty
          ? const Center(child: Text('No accounts yet'))
          : ListView.builder(
              itemCount: state.persons.length,
              itemBuilder: (context, index) {
                final person = state.persons[index];
                final balance = state.personBalance(person);
                final net = balance['net'] as double;

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(person.name.isNotEmpty ? person.name[0] : '?')),
                    title: Text(person.name),
                    subtitle: Text(person.phone.isEmpty ? 'No phone' : person.phone),
                    trailing: Text(
                      '${net.toStringAsFixed(0)} ${state.selectedLedger?.currencyCode ?? 'YER'}',
                      style: TextStyle(
                        color: net >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
