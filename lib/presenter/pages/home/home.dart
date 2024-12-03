import 'package:fatureicurso/data/features/month_balance/controllers/month_balance.dart';
import 'package:fatureicurso/domain/models/monthly_expenses.dart';
import 'package:fatureicurso/presenter/widgets/grafico_barras_widget.dart';
import 'package:fatureicurso/data/storage/expenses.dart';
import 'package:fatureicurso/presenter/widgets/items/expense_item_widget.dart';
import 'package:fatureicurso/presenter/widgets/items/income_item_widget.dart';
import 'package:fatureicurso/presenter/widgets/month_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Expense> monthlyExpenses = [];
  List<Income> monthlyIncomes = [];

  bool isIncomeSelected = true;

  @override
  void initState() {
    super.initState();
    loadLocalTransations();
  }

  void loadLocalTransations() {
    Future.microtask(() async {
      Future.wait([
        loadLocalExpenses(),
        loadLocalIncomes(),
      ]).then((List<dynamic> values) {
        setState(() {
          monthlyExpenses = values[0];
          monthlyIncomes = values[1];
        });
      });
    });
  }

  void showAddAccountDialog(BuildContext context) {
    final TextEditingController accountNameController = TextEditingController();
    final TextEditingController dueDateController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    bool isExpense = true;
    bool isRecurring = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, internalSetState) {
            return AlertDialog(
              title: const Text('Adicionar Entrada/Saída'),
              content: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: accountNameController,
                        decoration: const InputDecoration(labelText: 'Nome'),
                      ),
                      const SizedBox(height: 15),
                      const Text('Renda ou Despesa'),
                      const SizedBox(height: 10),
                      ToggleButtons(
                        borderRadius: BorderRadius.circular(20),
                        isSelected: [isExpense, !isExpense],
                        onPressed: (int index) {
                          internalSetState(() {
                            isExpense = index == 0;
                          });
                        },
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('Despesa'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('Renda'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text('Recorrente ou Pontual'),
                      const SizedBox(height: 10),
                      ToggleButtons(
                        borderRadius: BorderRadius.circular(20),
                        isSelected: [isRecurring, !isRecurring],
                        onPressed: (int index) {
                          internalSetState(() {
                            isRecurring = index == 0;
                          });
                        },
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('Recorrente'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('Pontual'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (isRecurring)
                        TextField(
                          controller: dueDateController,
                          decoration:
                              const InputDecoration(labelText: 'Dia limite'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                        ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: amountController,
                        decoration:
                            const InputDecoration(labelText: 'Valor Médio'),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Get.back();
                  },
                ),
                TextButton(
                  child: const Text('Salvar'),
                  onPressed: () async {
                    String accountName = accountNameController.text;
                    int? dueDate = isRecurring
                        ? int.tryParse(dueDateController.text)
                        : null;
                    double? amount = double.tryParse(amountController.text);

                    if ((dueDate != null || !isRecurring) &&
                        (dueDate == null || (dueDate >= 1 && dueDate <= 31)) &&
                        amount != null &&
                        accountName.isNotEmpty) {
                      try {
                        if (isExpense == false) {
                          setState(() {
                            monthlyIncomes.add(
                              Income(
                                id: '$accountName-${dueDate ?? 'pontual'}',
                                title: accountName,
                                amount: amount,
                                dueDate: dueDate,
                                isRecurring: isRecurring,
                              ),
                            );
                          });
                          await saveLocalIncomes(monthlyIncomes);
                          loadLocalTransations();
                        } else {
                          setState(() {
                            monthlyExpenses.add(
                              Expense(
                                id: '$accountName-${dueDate ?? 'pontual'}',
                                title: accountName,
                                amount: amount,
                                dueDate: dueDate,
                                isRecurring: isRecurring,
                              ),
                            );
                          });
                          await saveLocalExpenses(monthlyExpenses);
                          loadLocalTransations();
                        }
                      } catch (e) {
                        // print(e);
                      }

                      Get.back();
                    } else {
                      // Mostrar mensagem de erro
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Por favor, insira valores válidos.')),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.account_circle,
              size: 40,
            ),
            onPressed: () {
              Get.toNamed('/profile');
              // Ação ao pressionar o ícone de perfil de usuário
            },
          ),
          title: const Center(
              child: Text(
            "Minha Renda",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          )),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.black,
                size: 40,
              ),
              onPressed: () {
                showAddAccountDialog(context);
              },
            ),
          ],
        ),
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MonthsSelectWidget(),
                Visibility(
                  visible:
                      monthlyExpenses.isNotEmpty || monthlyIncomes.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ToggleButtons(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          isSelected: [isIncomeSelected, !isIncomeSelected],
                          onPressed: (int index) {
                            setState(() {
                              isIncomeSelected = index == 0;
                            });
                          },
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'Rendas',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'Gastos',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isIncomeSelected,
                        child: Container(
                          height: 250,
                          padding: const EdgeInsets.all(18.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: monthlyIncomes.length,
                            itemBuilder: (BuildContext context, int index) {
                              return IncomeItemWidget(
                                  onEdit: () {},
                                  onDelete: (income) async {
                                    setState(() {
                                      monthlyIncomes.remove(income);
                                    });
                                    await saveLocalIncomes(monthlyIncomes);
                                  },
                                  onDone: () async {
                                    if (monthlyIncomes[index].doneDate != null) {
                                      setState(() {
                                        monthlyIncomes[index].doneDate = null;
                                      });
                                    } else {
                                      setState(() {
                                        monthlyIncomes[index].doneDate =
                                            DateFormat('dd/MM/yyyy')
                                                .format(DateTime.now());
                                      });
                                    }
                                    await saveLocalIncomes(monthlyIncomes);
                                  },
                                  income: monthlyIncomes[index]);
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !isIncomeSelected,
                        child: Container(
                          height: 250,
                          padding: const EdgeInsets.all(18.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: monthlyExpenses.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ExpenseItemWidget(
                                  onEdit: () {},
                                  onDelete: (expense) async {
                                    setState(() {
                                      monthlyExpenses.remove(expense);
                                    });
              
                                    await saveLocalExpenses(monthlyExpenses);
                                  },
                                  onDone: () async {
                                    if (monthlyExpenses[index].doneDate != null) {
                                      setState(() {
                                        monthlyExpenses[index].doneDate = null;
                                      });
                                    } else {
                                      setState(() {
                                        monthlyExpenses[index].doneDate =
                                            DateFormat('dd/MM/yyyy')
                                                .format(DateTime.now());
                                      });
                                    }
                                    await saveLocalExpenses(monthlyExpenses);
                                  },
                                  expense: monthlyExpenses[index]);
                            },
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 22),
                        child: Text('Balanço semanal',
                            style: TextStyle(fontSize: 20)),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(
                            () => GraficoDeBarras(
                              dias: [
                                Day(
                                    id: 'Seg',
                                    valor: Get.find<MonthBalanceController>()
                                        .weekBalance[0]),
                                Day(
                                    id: 'Ter',
                                    valor: Get.find<MonthBalanceController>()
                                        .weekBalance[1]),
                                Day(
                                    id: 'Qua',
                                    valor: Get.find<MonthBalanceController>()
                                        .weekBalance[2]),
                                Day(
                                    id: 'Qui',
                                    valor: Get.find<MonthBalanceController>()
                                        .weekBalance[3]),
                                Day(
                                    id: 'Sex',
                                    valor: Get.find<MonthBalanceController>()
                                        .weekBalance[4]),
                                Day(
                                    id: 'Sab',
                                    valor: Get.find<MonthBalanceController>()
                                        .weekBalance[5]),
                                Day(
                                    id: 'Dom',
                                    valor: Get.find<MonthBalanceController>()
                                        .weekBalance[6]),
                              ],
                            ),
                          )),
                    ],
                  ),
                )
              ],
                        ),
                      ),
            )));
  }
}
