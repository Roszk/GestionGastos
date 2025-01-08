import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'theme_manager.dart';
import 'session_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar el tema y cargar preferencias
  final themeManager = ThemeManager();
  await themeManager.loadTheme();

  // Cargar los gastos almacenados
  await SessionManager().loadExpensesFromStorage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeManager),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Control de Gastos',
      theme: themeManager.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: LoginScreen(),
    );
  }
}
