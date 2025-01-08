import 'package:flutter/material.dart';
import '../session_manager.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  String description = '';
  double amount = 0.0;
  String type = 'expense';
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Transacción')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Descripción'),
                onSaved: (value) => description = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un monto';
                  }
                  final parsedValue = double.tryParse(value);
                  if (parsedValue == null) {
                    return 'Por favor, ingresa un número válido';
                  }
                  if (parsedValue <= 0) {
                    return 'El monto debe ser mayor que 0';
                  }
                  return null;
                },
                onSaved: (value) {
                  amount = double.parse(value!);
                },
              ),
              DropdownButtonFormField<String>(
                value: type,
                items: [
                  DropdownMenuItem(value: 'expense', child: Text('Gasto')),
                  DropdownMenuItem(value: 'income', child: Text('Ingreso')),
                ],
                onChanged: (value) => setState(() => type = value!),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() => selectedDate = pickedDate);
                  }
                },
                child: Text('Seleccionar Fecha: ${selectedDate.toLocal()}'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final transaction = {
                      'description': description,
                      'amount': amount,
                      'date': selectedDate.toIso8601String(),
                    };
                    if (type == 'expense') {
                      SessionManager().addExpense(transaction);
                    } else {
                      SessionManager().addIncome(transaction);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
