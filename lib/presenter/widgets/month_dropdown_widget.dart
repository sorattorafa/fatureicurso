import 'package:fatureicurso/data/features/month_balance/controllers/month_balance.dart';
import 'package:fatureicurso/data/storage/expenses.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MonthsSelectWidget extends StatefulWidget {
  const MonthsSelectWidget({super.key});

  @override
  State<MonthsSelectWidget> createState() => _MonthsSelectWidgetState();
}

class _MonthsSelectWidgetState extends State<MonthsSelectWidget> {
  final List<String> months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  late String selectedMonth;

  @override
  void initState() {
    super.initState();

    selectedMonth = months[0];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        String currentMonth = DateFormat.MMMM('pt_BR').format(DateTime.now());
        selectedMonth =
            months.map((e) => e.toLowerCase()).contains(currentMonth)
                ? months.firstWhere((e) => e.toLowerCase() == currentMonth)
                : months[0];
      });

      Get.find<MonthBalanceController>().setCurrentMonth(selectedMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double fontSize = constraints.maxWidth *
                0.05; // Ajuste o fator conforme necessário
            return Builder(builder: (context) {
              return Obx(() => RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      children: [
                        const TextSpan(text: 'Saldo de '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: DropdownButton<String>(
                            value: selectedMonth,
                            onChanged: (String? newValue) async {
                              setState(() {
                                selectedMonth = newValue!;
                              });
                              Get.find<MonthBalanceController>()
                                  .setCurrentMonth(selectedMonth);
                             updateCurrentBalance();
                            },
                            items: months
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              );
                            }).toList(),
                            underline:
                                const SizedBox(), // Remove a linha sublinhada
                          ),
                        ),
                        const TextSpan(text: ': '),
                        TextSpan(
                          text:
                              'R\$ ${Get.find<MonthBalanceController>().getCurrentBalance}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ));
            });
          },
        ),
      ),
    );
  }
}
