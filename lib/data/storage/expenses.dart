import 'package:fatureicurso/data/features/month_balance/controllers/month_balance.dart';
import 'package:fatureicurso/domain/models/monthly_expenses.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void updateCurrentBalance() {
  final currentBalance = loadLocalMonthBalance();
  Get.find<MonthBalanceController>()
      .setCurrentBalance(currentBalance.toStringAsFixed(2));

  loadLocalWeekBalance();
}

Future<void> saveLocalExpenses(List<Expense> expenses) async {
  final String value = expenses.map((e) => e.toJsonString()).join('///');

  final yearId = DateTime.now().year.toString();
  final monthId = Get.find<MonthBalanceController>().getCurrentMonth;
  final expensesId = '$monthId-$yearId-expenses';

  GetStorage box = GetStorage();

  box.write(expensesId, value);
  await box.save();

  updateCurrentBalance();
}

Future<void> saveLocalIncomes(List<Income> expenses) async {
  final String value = expenses.map((e) => e.toJsonString()).join('///');

  final yearId = DateTime.now().year.toString();
  final monthId = Get.find<MonthBalanceController>().getCurrentMonth;
  final incomesId = '$monthId-$yearId-incomes';

  GetStorage box = GetStorage();
  box.write(incomesId, value);
  await box.save();
  updateCurrentBalance();
}

Future<List<Income>> loadLocalIncomes() async {
  var returnedValue = <Income>[];
  GetStorage box = GetStorage();

  final yearId = DateTime.now().year.toString();
  final monthId = Get.find<MonthBalanceController>().getCurrentMonth;
  final incomesId = '$monthId-$yearId-incomes';
  final String? value = box.read(incomesId);

  if (value != null && value.isNotEmpty) {
    List<String> expenses = value.split('///');
    returnedValue = expenses.map((e) => Income.fromJsonString(e)).toList();
  }

  updateCurrentBalance();
  return returnedValue;
}

Future<List<Expense>> loadLocalExpenses() async {
  var returnedValue = <Expense>[];
  GetStorage box = GetStorage();
  final yearId = DateTime.now().year.toString();
  final monthId = Get.find<MonthBalanceController>().getCurrentMonth;
  final expensesId = '$monthId-$yearId-expenses';
  final String? value = box.read(expensesId);

  if (value != null && value.isNotEmpty) {
    List<String> expenses = value.split('///');
    returnedValue = expenses.map((e) => Expense.fromJsonString(e)).toList();
  }
  updateCurrentBalance();
  return returnedValue;
}

double loadLocalMonthBalance() {
  double currentBalance = 0.0;

  var expensesValue = <Expense>[];
  GetStorage box = GetStorage();
  final yearId = DateTime.now().year.toString();
  final monthId = Get.find<MonthBalanceController>().getCurrentMonth;
  final expensesId = '$monthId-$yearId-expenses';
  final String? value = box.read(expensesId);

  if (value != null && value.isNotEmpty) {
    List<String> expenses = value.split('///');
    expensesValue = expenses.map((e) => Expense.fromJsonString(e)).toList();

    for (var expense in expensesValue) {
      if (expense.doneDate != null) {
        currentBalance -= expense.amount;
      }
    }
  }

  var incomeValue = <Income>[];

  final incomesId = '$monthId-$yearId-incomes';

  final String? storageValue = box.read(incomesId);

  if (storageValue != null && storageValue.isNotEmpty) {
    List<String> expenses = storageValue.split('///');
    incomeValue = expenses.map((e) => Income.fromJsonString(e)).toList();

    for (var inc in incomeValue) {
      if (inc.doneDate != null) {
        currentBalance += inc.amount;
      }
    }
  }

  return currentBalance;
}

List<double> loadLocalWeekBalance() {
  List<double> weekBalance = [];

  // Obter a data atual
  DateTime now = DateTime.now();

  // Calcular o início da semana (segunda-feira)
  DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

  // Iterar sobre os 7 dias da semana
  for (int i = 0; i < 7; i++) {
    DateTime currentDay = startOfWeek.add(Duration(days: i));
    double dailyBalance = loadLocalDayBalance(currentDay);
    weekBalance.add(dailyBalance);
  }

  Get.find<MonthBalanceController>().setWeekBalance(weekBalance);
  return weekBalance;
}

// Função fictícia para carregar o balanço de um dia específico
double loadLocalDayBalance(DateTime date) {
  double currentBalance = 0.0;

  var expensesValue = <Expense>[];
  GetStorage box = GetStorage();

  final yearId = DateTime.now().year.toString();
  final monthId = Get.find<MonthBalanceController>().getCurrentMonth;
  final expensesId = '$monthId-$yearId-expenses';

  final String? value = box.read(expensesId);

  if (value != null && value.isNotEmpty) {
    List<String> expenses = value.split('///');
    expensesValue = expenses.map((e) => Expense.fromJsonString(e)).toList();

    for (var expense in expensesValue) {
      if (expense.doneDate != null &&
          int.parse(expense.doneDate!.substring(0, 2)) == date.day) {
        currentBalance -= expense.amount;
      }
    }
  }

  var incomeValue = <Income>[];

  final incomesId = '$monthId-$yearId-incomes';

  final String? storageValue = box.read(incomesId);

  if (storageValue != null && storageValue.isNotEmpty) {
    List<String> expenses = storageValue.split('///');
    incomeValue = expenses.map((e) => Income.fromJsonString(e)).toList();

    for (var inc in incomeValue) {
      if (inc.doneDate != null &&
          int.parse(inc.doneDate!.substring(0, 2)) == date.day) {
        currentBalance += inc.amount;
      }
    }
  }

  return currentBalance;
}
