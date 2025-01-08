import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../session_manager.dart';
import 'login_screen.dart';
import 'add_transaction_screen.dart';
import 'graph_screen.dart';
import 'card_screen.dart';
import 'CurrencyConverterScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Método para cargar el nombre del usuario
  void _loadUserName() async {
    userName = await SessionManager().getUserName(); // Obtener el nombre del usuario
    setState(() {}); // Actualizar la UI
  }

  // Método para eliminar un gasto
  void _deleteExpense(int index) {
    setState(() {
      SessionManager().expenses.removeAt(index);
      SessionManager().saveExpensesToStorage(); // Guardar los cambios en el almacenamiento
    });
    Fluttertoast.showToast(msg: "Gasto eliminado");
  }

  // Método para eliminar un ingreso
  void _deleteIncome(int index) {
    setState(() {
      SessionManager().incomes.removeAt(index);
      SessionManager().saveIncomesToStorage(); // Guardar los cambios en el almacenamiento
    });
    Fluttertoast.showToast(msg: "Ingreso eliminado");
  }

  // Método para eliminar una tarjeta
  void _deleteCard(int index) {
    setState(() {
      SessionManager().cards.removeAt(index);
      SessionManager().saveCardsToStorage(); // Guardar los cambios en el almacenamiento
    });
    Fluttertoast.showToast(msg: "Tarjeta eliminada");
  }

  @override
  Widget build(BuildContext context) {
    final expenses = SessionManager().expenses;
    final incomes = SessionManager().incomes;
    final cards = SessionManager().cards; // Obtener las tarjetas

    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Gastos'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await SessionManager().clearUserToken();
              Fluttertoast.showToast(msg: "Sesión cerrada");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '¡Hola ${userName ?? "Usuario"}!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                // Mostrar la lista de gastos
                ...expenses.asMap().entries.map((entry) {
                  final index = entry.key;
                  final expense = entry.value;
                  return ListTile(
                    title: Text(expense['description']),
                    subtitle: Text(expense['date']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '- \$${expense['amount']}',
                          style: TextStyle(color: Colors.red),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteExpense(index),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                // Mostrar la lista de ingresos con botón de eliminar
                ...incomes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final income = entry.value;
                  return ListTile(
                    title: Text(income['description']),
                    subtitle: Text(income['date']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '+ \$${income['amount']}',
                          style: TextStyle(color: Colors.green),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteIncome(index),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                // Mostrar la lista de tarjetas con botón de eliminar
                ...cards.asMap().entries.map((entry) {
                  final index = entry.key;
                  final card = entry.value;
                  return ListTile(
                    title: Text(card['name']), // Nombre de la tarjeta
                    subtitle: Text('**** **** **** ${card['last4Digits']}'), // Últimos 4 dígitos
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCard(index),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          // Botón para agregar gastos o ingresos
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTransactionScreen()),
              );
            },
            child: Text('Agregar Gasto/Ingreso'),
          ),

          // Botón para ver la gráfica
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GraphScreen()),
              );
            },
            child: Text('Ver Gráfica Comparativa'),
          ),

          // Botón para gestionar tarjetas
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CardScreen()),
              );
            },
            child: Text('Gestionar Tarjetas'),
          ),

          // Botón para actualizar la pantalla
          ElevatedButton(
            onPressed: () {
              setState(() {}); // Refrescar la UI
              Fluttertoast.showToast(msg: "Pantalla actualizada");
            },
            child: Text('Actualizar'),
          ),

          // Botón para borrar todos los datos
          ElevatedButton(
            onPressed: () async {
              await SessionManager().clearAllData(); // Llamar al método directamente
              setState(() {});
              Fluttertoast.showToast(msg: "Datos borrados");
            },
            child: Text('Borrar Todo'),
          ),


          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrencyConverterScreen()),
              );
            },
            child: Text('Calculadora de Conversión de Monedas'),
          ),
        ],
      ),
    );
  }
}
