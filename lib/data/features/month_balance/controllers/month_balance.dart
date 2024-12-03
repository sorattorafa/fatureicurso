import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MonthBalanceController extends GetxController {
  Rx<String> currentMonth = ''.obs;
  Rx<String> currentYear = ''.obs;
  Rx<String> currentBalance = '0.00'.obs;

  RxList weekBalance = [].obs;


  setWeekBalance(List value) {
    weekBalance.value = value;
  }

  get getWeekBalance => weekBalance;

  void setCurrentMonth(String value) {
    currentMonth.value = value;
  }

  void setCurrentYear(String value) {
    currentYear.value = value;
  }

  void setCurrentBalance(String value) {
    currentBalance.value = value;
  }

  get getCurrentMonth => currentMonth.value;
  get getCurrentYear => currentYear.value;
  get getCurrentBalance {
    return currentBalance.value.replaceAll('.', ',');
  }
}