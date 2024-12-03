
import 'package:fatureicurso/data/features/month_balance/controllers/month_balance.dart';
import 'package:get/instance_manager.dart';

class MonthBalance extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MonthBalanceController>(() => MonthBalanceController());
  }
}
