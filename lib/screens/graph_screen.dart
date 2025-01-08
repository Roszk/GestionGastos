import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../session_manager.dart';

class GraphScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenses = SessionManager().expenses;
    final incomes = SessionManager().incomes;

    final List<ExpenseIncomeData> chartData = [
      ExpenseIncomeData(
        'Gastos',
        expenses.fold(0.0, (sum, item) => sum + (double.tryParse(item['amount'].toString()) ?? 0.0)),
        Colors.red,
      ),
      ExpenseIncomeData(
        'Ingresos',
        incomes.fold(0.0, (sum, item) => sum + (double.tryParse(item['amount'].toString()) ?? 0.0)),
        Colors.green,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfica Comparativa'),
      ),
      body: Center(
        child: SfCircularChart(
          legend: Legend(isVisible: true),
          series: <CircularSeries>[
            PieSeries<ExpenseIncomeData, String>(
              dataSource: chartData,
              xValueMapper: (ExpenseIncomeData data, _) => data.category,
              yValueMapper: (ExpenseIncomeData data, _) => data.value,
              pointColorMapper: (ExpenseIncomeData data, _) => data.color,
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseIncomeData {
  final String category;
  final double value;
  final Color color;

  ExpenseIncomeData(this.category, this.value, this.color);
}
