import 'package:flutter/material.dart';

class MedioPago extends StatelessWidget {
  const MedioPago({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medio de Pago'),
        backgroundColor: Colors.red[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.red[50],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.blue[50],
            child: ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.blue),
              title: const Text('Tarjeta de Crédito o Débito'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Seleccionaste Tarjeta de Crédito o Débito')),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.deepPurple),
              title: const Text('PayPal'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Seleccionaste PayPal')),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance, color: Colors.red),
              title: const Text('Transferencia Bancaria'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Seleccionaste Transferencia Bancaria')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}