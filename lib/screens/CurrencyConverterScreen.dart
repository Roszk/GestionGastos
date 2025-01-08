import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController amountController = TextEditingController();
  String fromCurrency = 'USD'; // Moneda origen
  String toCurrency = 'MXN'; // Moneda destino
  double result = 0.0;

  // Tasas de conversión
  final Map<String, Map<String, double>> exchangeRates = {
    'USD': {
      'MXN': 17.5,
      'EUR': 0.92,
    },
    'MXN': {
      'USD': 0.057,
      'EUR': 0.053,
    },
    'EUR': {
      'USD': 1.09,
      'MXN': 19.0,
    },
  };

  void convertCurrency() {
    final double? amount = double.tryParse(amountController.text);
    if (amount != null) {
      setState(() {
        result = amount * (exchangeRates[fromCurrency]?[toCurrency] ?? 1.0);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa un monto válido.')),
      );
    }
  }

  // Función para abrir XE.com
  Future<void> _launchCurrencyConverter() async {
    const url = 'https://www.xe.com/es/currencyconverter/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir el conversor de divisas en XE';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencies = exchangeRates.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Conversión de Monedas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: fromCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  fromCurrency = newValue!;
                });
              },
              items: currencies.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: toCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  toCurrency = newValue!;
                });
              },
              items: currencies.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: convertCurrency,
              child: Text('Convertir'),
            ),
            SizedBox(height: 16),
            Text(
              'Resultado: $result $toCurrency',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Botón para abrir XE.com
            ElevatedButton(
              onPressed: _launchCurrencyConverter,
              child: Text('Más monedas actualizadas'),
            ),
          ],
        ),
      ),
    );
  }
}
