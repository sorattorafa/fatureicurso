
import 'package:fatureicurso/data/features/auth/controllers/user.dart';
import 'package:get/instance_manager.dart';

class UserBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}
