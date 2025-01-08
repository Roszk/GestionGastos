import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../session_manager.dart';

class CardScreen extends StatefulWidget {
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expirationDateController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  String cardType = 'Débito';
  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  // Método para cargar las tarjetas almacenadas
  void _loadCards() async {
    await SessionManager().loadCardsFromStorage();
    setState(() {});
  }

  // Método para agregar una tarjeta
  void _addCard() {
    final card = {
      'cardNumber': cardNumberController.text,
      'expirationDate': expirationDateController.text,
      'cardType': cardType,
      'bank': bankController.text,
    };

    SessionManager().addCard(card); // Guardar la tarjeta
    Fluttertoast.showToast(msg: "Tarjeta agregada");
    setState(() {});
  }

  // Método para eliminar una tarjeta
  void _deleteCard(int index) {
    setState(() {
      SessionManager().cards.removeAt(index); // Eliminar la tarjeta de la lista
      SessionManager().saveCardsToStorage(); // Guardar los cambios
    });
    Fluttertoast.showToast(msg: "Tarjeta eliminada");
  }

  @override
  Widget build(BuildContext context) {
    final cards = SessionManager().cards;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Tarjetas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tarjetas Registradas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return ListTile(
                    title: Text('Número: ${card['cardNumber']}'),
                    subtitle: Text(
                      'Banco: ${card['bank']} | Tipo: ${card['cardType']}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCard(index), // Llamar al método de eliminación
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: cardNumberController,
              decoration: InputDecoration(labelText: 'Número de Tarjeta'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: expirationDateController,
              decoration: InputDecoration(labelText: 'Fecha de Expiración'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: bankController,
              decoration: InputDecoration(labelText: 'Banco'),
            ),
            DropdownButton<String>(
              value: cardType,
              onChanged: (String? newValue) {
                setState(() {
                  cardType = newValue!;
                });
              },
              items: <String>['Débito', 'Crédito']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _addCard,
              child: Text('Agregar Nueva Tarjeta'),
            ),
          ],
        ),
      ),
    );
  }
}
