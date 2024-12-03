import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  Rx<String> userToken = ''.obs;

  set setUserToken(String? value) {
    if (value != null) {
      userToken.value = value;
      saveLocalUser(value);
    }
  }

  Future<String?> get getUser async {
    if (userToken.value == '') {
      String? token = await loadLocalUserToken();
      if (token != null) {
        userToken.value = token;
      }
    }
    return userToken.value;
  }
}

Future<void> saveLocalUser(String value) async {
  GetStorage box = GetStorage();
  box.write('userToken', value);
  await box.save();
}

Future<String?> loadLocalUserToken() async {
  GetStorage box = GetStorage();
  final String? value = box.read('userToken');
  if (value != null) {
    return value;
  }
  return null;
}
