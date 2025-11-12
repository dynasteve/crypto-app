import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/balance_provider.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Withdraw Funds', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'e.g. 50.00',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Confirm Withdraw'),
                onPressed: () {
                  final amount = double.tryParse(_controller.text) ?? 0;
                  if (amount > 0) {
                    if (amount <= balanceProvider.balance) {
                      balanceProvider.withdraw(amount);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Withdrew \$${amount.toStringAsFixed(2)}')),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Insufficient balance')),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
